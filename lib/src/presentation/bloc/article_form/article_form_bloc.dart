// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interpretasi_editor/src/common/enums.dart';
import 'package:interpretasi_editor/src/domain/entities/article.dart';
import 'package:interpretasi_editor/src/domain/entities/category.dart';
import 'package:interpretasi_editor/src/domain/usecases/create_article.dart';
import 'package:interpretasi_editor/src/domain/usecases/get_article_detail.dart';
import 'package:interpretasi_editor/src/domain/usecases/update_article.dart';
import 'package:interpretasi_editor/src/utilities/image_cropper_utils.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

part 'article_form_event.dart';
part 'article_form_state.dart';
part 'article_form_bloc.freezed.dart';

class ArticleFormBloc extends Bloc<ArticleFormEvent, ArticleFormState> {
  ArticleFormBloc({
    required this.create,
    required this.update,
    required this.articleDetail,
  }) : super(ArticleFormState.initial()) {
    on<ArticleFormEvent>((event, emit) async {
      await event.map(
        init: (_) {
          emit(ArticleFormState.initial());
        },
        initialize: (event) async {
          final category = event.categoryList
              .firstWhere((e) => e.id == event.article.categoryId);
          emit(
            state.copyWith(
              state: RequestState.loading,
              id: event.article.url,
              title: event.article.title,
              imageUrl: event.article.image,
              selectedCategory: category,
              categoryList: event.categoryList,
            ),
          );
          final detail = await articleDetail.execute(event.article.url);
          detail.fold(
            (f) {
              emit(
                state.copyWith(
                  message: 'error-fetch-article-detail',
                  state: RequestState.error,
                ),
              );
            },
            (data) {
              final decoded = jsonDecode(data.originalContent) as List<dynamic>;
              // print(decoded);
              final doc = Document.fromJson(decoded);
              emit(
                state.copyWith(
                  state: RequestState.empty,
                  tagList: data.tags,
                  document: doc,
                ),
              );
            },
          );
        },
        title: (event) {
          emit(
            state.copyWith(
              title: event.val,
              message: '',
            ),
          );
        },
        pickImage: (event) async {
          final pickedImage = await ImagePicker().pickImage(
            source: event.source,
          );
          // if (pickedImage != null) {
          //   final byte = await pickedImage.readAsBytes();
          //   emit(
          //     state.copyWith(imageFile: byte, message: ''),
          //   );
          // }
          if (pickedImage != null) {
            final croppedImage = await ImageCropperUtils.cropImage(
              event.context,
              filePath: pickedImage.path,
              type: event.deviceType,
            );
            if (croppedImage != null) {
              final byte = await croppedImage.readAsBytes();

              emit(
                state.copyWith(
                  imageMemory: byte,
                  imageFile: XFile(croppedImage.path),
                  message: '',
                ),
              );
            }
          }
        },
        changeCategory: (event) {
          emit(
            state.copyWith(
              state: RequestState.empty,
              selectedCategory: event.category,
              message: '',
            ),
          );
        },
        fetchCategories: (event) {
          emit(
            state.copyWith(
              state: RequestState.empty,
              categoryList: event.categories,
            ),
          );
        },
        addTags: (event) {
          if (state.tagList.length < 15) {
            final tagList = List<String>.from(state.tagList)..add(event.tag);
            emit(
              state.copyWith(
                state: RequestState.empty,
                tagList: tagList,
                message: '',
              ),
            );
          }
        },
        removeTags: (event) {
          final tagList = List<String>.from(state.tagList)..remove(event.tag);
          emit(
            state.copyWith(
              state: RequestState.empty,
              tagList: tagList,
              message: '',
            ),
          );
        },
        create: (event) async {
          emit(
            state.copyWith(
              state: RequestState.loading,
              isSubmit: true,
            ),
          );

          final decoded = List<Map<String, dynamic>>.from(event.delta.toJson());
          final html = QuillDeltaToHtmlConverter(decoded);

          if (state.imageFile != null &&
              state.title != '' &&
              state.selectedCategory?.id != null &&
              state.tagList.isNotEmpty) {
            final result = await create.execute(
              categoryId: state.selectedCategory!.id,
              image: state.imageFile!,
              title: state.title,
              content: html.convert(),
              deltaJson: jsonEncode(event.delta.toJson()),
              tags: state.tagList,
            );
            result.fold(
              (f) => emit(
                state.copyWith(
                  state: RequestState.error,
                  isSubmit: false,
                  message: f.message,
                ),
              ),
              (_) => emit(
                state.copyWith(
                  state: RequestState.loaded,
                  isSubmit: false,
                ),
              ),
            );
          }
        },
        update: (event) async {
          emit(
            state.copyWith(
              state: RequestState.loading,
              isSubmit: true,
            ),
          );
          final decoded = List<Map<String, dynamic>>.from(event.delta.toJson());
          final html = QuillDeltaToHtmlConverter(decoded);
          if (state.title != '' &&
              state.selectedCategory?.id != null &&
              state.tagList.isNotEmpty) {
            final result = await update.execute(
              id: state.id,
              categoryId: state.selectedCategory!.id,
              image: state.imageFile,
              title: state.title,
              content: html.convert(),
              deltaJson: jsonEncode(event.delta.toJson()),
              tags: state.tagList,
            );
            result.fold(
              (f) => emit(
                state.copyWith(
                  state: RequestState.error,
                  isSubmit: false,
                  message: f.message,
                ),
              ),
              (_) => emit(
                state.copyWith(
                  state: RequestState.loaded,
                  isSubmit: false,
                ),
              ),
            );
          }
        },
      );
    });
  }
  final CreateArticle create;
  final UpdateArticle update;
  final GetArticleDetail articleDetail;
}
