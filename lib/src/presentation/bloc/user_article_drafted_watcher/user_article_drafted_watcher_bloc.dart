import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:interpretasi_editor/src/domain/entities/article.dart';
import 'package:interpretasi_editor/src/domain/usecases/get_drafted_article.dart';

part 'user_article_drafted_watcher_event.dart';
part 'user_article_drafted_watcher_state.dart';
part 'user_article_drafted_watcher_bloc.freezed.dart';

class UserArticleDraftedWatcherBloc extends Bloc<UserArticleDraftedWatcherEvent,
    UserArticleDraftedWatcherState> {
  UserArticleDraftedWatcherBloc(this._article)
      : super(const UserArticleDraftedWatcherState.initial()) {
    on<UserArticleDraftedWatcherEvent>((event, emit) async {
      await event.map(
        fetch: (_) async {
          emit(const UserArticleDraftedWatcherState.loading());
          final result = await _article.execute();
          result.fold(
            (f) => emit(const UserArticleDraftedWatcherState.error()),
            (data) => emit(UserArticleDraftedWatcherState.loaded(data)),
          );
        },
      );
    });
  }
  final GetDraftedArticle _article;
}
