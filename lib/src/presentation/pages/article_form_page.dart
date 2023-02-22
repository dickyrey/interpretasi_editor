import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:image_picker/image_picker.dart';
import 'package:interpretasi_editor/src/common/colors.dart';
import 'package:interpretasi_editor/src/common/const.dart';
import 'package:interpretasi_editor/src/common/enums.dart';
import 'package:interpretasi_editor/src/common/routes.dart';
import 'package:interpretasi_editor/src/presentation/bloc/article_form/article_form_bloc.dart';
import 'package:interpretasi_editor/src/presentation/bloc/auth_watcher/auth_watcher_bloc.dart';
import 'package:interpretasi_editor/src/presentation/bloc/category_watcher/category_watcher_bloc.dart';
import 'package:interpretasi_editor/src/presentation/bloc/user_article_drafted_watcher/user_article_drafted_watcher_bloc.dart';
import 'package:interpretasi_editor/src/presentation/widget/elevated_button_widget.dart';
import 'package:interpretasi_editor/src/presentation/widget/responsive_layout.dart';
import 'package:interpretasi_editor/src/presentation/widget/text_field_widget.dart';
import 'package:interpretasi_editor/src/presentation/widget/text_form_field_widget.dart';
import 'package:interpretasi_editor/src/utilities/snackbar.dart';
import 'package:interpretasi_editor/src/utilities/toast.dart';
import 'package:tuple/tuple.dart';

class ArticleFormPage extends StatefulWidget {
  const ArticleFormPage({
    required this.isEdit,
    super.key,
  });
  final bool isEdit;

  @override
  State<ArticleFormPage> createState() => _ArticleFormPageState();
}

class _ArticleFormPageState extends State<ArticleFormPage> {
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollCtrl = ScrollController();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl = TextEditingController();
  late TextEditingController _tagCtrl;
  PageController _pageCtrl = PageController();
  QuillController _quillCtrl = QuillController.basic();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final category = context.read<CategoryWatcherBloc>().state.categoryList;
    final article = context.read<ArticleFormBloc>().state;
    _titleCtrl = TextEditingController(text: article.title);
    Future.microtask(() {
      context
          .read<ArticleFormBloc>()
          .add(ArticleFormEvent.fetchCategories(category));
    });
    _pageCtrl = PageController(initialPage: _selectedIndex);
    _tagCtrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;
    final article = context.read<ArticleFormBloc>().state;
    _quillCtrl = QuillController(
      document: article.document ?? Document()
        ..insert(0, ''),
      selection: const TextSelection.collapsed(offset: 0),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthWatcherBloc, AuthWatcherState>(
          listener: (context, state) {
            state.maybeMap(
              orElse: () {},
              notAuthenticated: (_) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  LOGIN,
                  (Route<dynamic> route) => false,
                );
              },
            );
          },
        ),
        BlocListener<ArticleFormBloc, ArticleFormState>(
          listener: (context, state) {
            if (state.message == ExceptionMessage.thumbnailNull) {
            } else if (state.message == ExceptionMessage.titleNull) {
              final snack = showSnackbar(
                context,
                type: SnackbarType.error,
                labelText: lang.please_write_a_title,
                labelButton: lang.close,
                onTap: () {},
              );
              ScaffoldMessenger.of(context).showSnackBar(snack);
            } else if (state.message == ExceptionMessage.categoryNull) {
              final snack = showSnackbar(
                context,
                type: SnackbarType.error,
                labelText: lang.please_select_a_category,
                labelButton: lang.close,
                onTap: () {},
              );
              ScaffoldMessenger.of(context).showSnackBar(snack);
            } else if (state.message == ExceptionMessage.tagNull) {
              final snack = showSnackbar(
                context,
                type: SnackbarType.error,
                labelText: lang.please_fill_in_some_tags,
                labelButton: lang.close,
                onTap: () {},
              );
              ScaffoldMessenger.of(context).showSnackBar(snack);
            } else if (state.state == RequestState.loaded) {
              context
                  .read<UserArticleDraftedWatcherBloc>()
                  .add(const UserArticleDraftedWatcherEvent.fetch());
              final snack = showSnackbar(
                context,
                type: SnackbarType.success,
                labelText: lang.saved_successfully_in_draft,
                labelButton: lang.close,
                onTap: () {},
              );
              ScaffoldMessenger.of(context).showSnackBar(snack);
              Navigator.pop(context);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: _appBar(context),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ResponsiveLayout(
            mobileBody: _MobileBodyWidget(
              pageCtrl: _pageCtrl,
              onPageChanged: (v) => setState(() => _selectedIndex = v),
              tagCtrl: _tagCtrl,
              titleCtrl: _titleCtrl,
              quillCtrl: _quillCtrl,
              focusNode: _focusNode,
              scrollCtrl: _scrollCtrl,
            ),
            desktopBody: _DesktopBodyWidget(
              pageCtrl: _pageCtrl,
              onPageChanged: (v) => setState(() => _selectedIndex = v),
              tagCtrl: _tagCtrl,
              titleCtrl: _titleCtrl,
              quillCtrl: _quillCtrl,
              focusNode: _focusNode,
              scrollCtrl: _scrollCtrl,
            ),
            webBody: _WebBodyWidget(
              pageCtrl: _pageCtrl,
              onPageChanged: (v) => setState(() => _selectedIndex = v),
              tagCtrl: _tagCtrl,
              titleCtrl: _titleCtrl,
              quillCtrl: _quillCtrl,
              focusNode: _focusNode,
              scrollCtrl: _scrollCtrl,
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    final theme = Theme.of(context);
    final lang = AppLocalizations.of(context)!;

    return AppBar(
      backgroundColor: theme.colorScheme.background,
      elevation: .5,
      leading: IconButton(
        onPressed: () {
          if (_selectedIndex == 1) {
            _pageCtrl.previousPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          } else {
            Navigator.pop(context);
          }
        },
        icon: Icon(
          FeatherIcons.arrowLeft,
          color: theme.iconTheme.color,
        ),
      ),
      title: Row(
        children: [
          const Spacer(),
          BlocBuilder<ArticleFormBloc, ArticleFormState>(
            builder: (context, state) {
              return ElevatedButtonWidget(
                width: 100,
                height: 30,
                isLoading: (state.isSubmit == true) ? true : false,
                label: (_selectedIndex == 0) ? lang.next : lang.save,
                labelSize: 12,
                onTap: () {
                  if (widget.isEdit == true) {
                    if (state.title == '') {
                      final snack = showSnackbar(
                        context,
                        type: SnackbarType.error,
                        labelText: lang.please_write_a_title,
                        labelButton: lang.close,
                        onTap: () {},
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snack);
                    } else if (state.selectedCategory == null) {
                      final snack = showSnackbar(
                        context,
                        type: SnackbarType.error,
                        labelText: lang.please_select_a_category,
                        labelButton: lang.close,
                        onTap: () {},
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snack);
                      // ignore: inference_failure_on_collection_literal
                    } else if (state.tagList.isEmpty || state.tagList == []) {
                      final snack = showSnackbar(
                        context,
                        type: SnackbarType.error,
                        labelText: lang.please_fill_in_some_tags,
                        labelButton: lang.close,
                        onTap: () {},
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snack);
                    } else {
                      if (_selectedIndex == 0) {
                        _pageCtrl.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      } else {
                        final delta = _quillCtrl.document.toDelta();
                        context
                            .read<ArticleFormBloc>()
                            .add(ArticleFormEvent.update(delta));
                      }
                    }
                  } else {
                    if (state.imageFile == null) {
                      final snack = showSnackbar(
                        context,
                        type: SnackbarType.error,
                        labelText: lang.please_insert_a_thumbnail,
                        labelButton: lang.close,
                        onTap: () {},
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snack);
                    } else if (state.title == '') {
                      final snack = showSnackbar(
                        context,
                        type: SnackbarType.error,
                        labelText: lang.please_write_a_title,
                        labelButton: lang.close,
                        onTap: () {},
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snack);
                    } else if (state.selectedCategory == null) {
                      final snack = showSnackbar(
                        context,
                        type: SnackbarType.error,
                        labelText: lang.please_select_a_category,
                        labelButton: lang.close,
                        onTap: () {},
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snack);
                      // ignore: inference_failure_on_collection_literal
                    } else if (state.tagList.isEmpty || state.tagList == []) {
                      final snack = showSnackbar(
                        context,
                        type: SnackbarType.error,
                        labelText: lang.please_fill_in_some_tags,
                        labelButton: lang.close,
                        onTap: () {},
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snack);
                    } else {
                      if (_selectedIndex == 0) {
                        _pageCtrl.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      } else {
                        final delta = _quillCtrl.document.toDelta();
                        context
                            .read<ArticleFormBloc>()
                            .add(ArticleFormEvent.create(delta));
                      }
                    }
                  }
                },
              );
            },
          )
        ],
      ),
      centerTitle: false,
    );
  }
}

class _MobileBodyWidget extends StatelessWidget {
  const _MobileBodyWidget({
    required this.pageCtrl,
    required this.onPageChanged,
    required this.titleCtrl,
    required this.tagCtrl,
    required this.quillCtrl,
    required this.focusNode,
    required this.scrollCtrl,
  });

  final PageController pageCtrl;
  final void Function(int) onPageChanged;
  final TextEditingController titleCtrl;
  final TextEditingController tagCtrl;
  final QuillController quillCtrl;
  final FocusNode focusNode;
  final ScrollController scrollCtrl;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageCtrl,
      onPageChanged: onPageChanged,
      children: [
        _ArticleInformationWidget(
          titleCtrl: titleCtrl,
          tagCtrl: tagCtrl,
          deviceType: DeviceType.mobile,
        ),
        _QuillEditorWidget(
          quillCtrl: quillCtrl,
          focusNode: focusNode,
          scrollCtrl: scrollCtrl,
          deviceType: DeviceType.mobile,
        ),
      ],
    );
  }
}

class _DesktopBodyWidget extends StatelessWidget {
  const _DesktopBodyWidget({
    required this.pageCtrl,
    required this.onPageChanged,
    required this.titleCtrl,
    required this.tagCtrl,
    required this.quillCtrl,
    required this.focusNode,
    required this.scrollCtrl,
  });

  final PageController pageCtrl;
  final void Function(int) onPageChanged;
  final TextEditingController titleCtrl;
  final TextEditingController tagCtrl;
  final QuillController quillCtrl;
  final FocusNode focusNode;
  final ScrollController scrollCtrl;
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageCtrl,
      onPageChanged: onPageChanged,
      children: [
        _ArticleInformationWidget(
          titleCtrl: titleCtrl,
          tagCtrl: tagCtrl,
          deviceType: DeviceType.desktop,
        ),
        _QuillEditorWidget(
          quillCtrl: quillCtrl,
          focusNode: focusNode,
          scrollCtrl: scrollCtrl,
          deviceType: DeviceType.desktop,
        ),
      ],
    );
  }
}

class _WebBodyWidget extends StatelessWidget {
  const _WebBodyWidget({
    required this.pageCtrl,
    required this.onPageChanged,
    required this.titleCtrl,
    required this.tagCtrl,
    required this.quillCtrl,
    required this.focusNode,
    required this.scrollCtrl,
  });

  final PageController pageCtrl;
  final void Function(int) onPageChanged;
  final TextEditingController titleCtrl;
  final TextEditingController tagCtrl;
  final QuillController quillCtrl;
  final FocusNode focusNode;
  final ScrollController scrollCtrl;
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageCtrl,
      onPageChanged: onPageChanged,
      children: [
        _ArticleInformationWidget(
          titleCtrl: titleCtrl,
          tagCtrl: tagCtrl,
          deviceType: DeviceType.web,
        ),
        _QuillEditorWidget(
          quillCtrl: quillCtrl,
          focusNode: focusNode,
          scrollCtrl: scrollCtrl,
          deviceType: DeviceType.web,
        ),
      ],
    );
  }
}

class _ArticleInformationWidget extends StatelessWidget {
  const _ArticleInformationWidget({
    required this.titleCtrl,
    required this.tagCtrl,
    required this.deviceType,
  });

  final TextEditingController titleCtrl;
  final TextEditingController tagCtrl;
  final DeviceType deviceType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = AppLocalizations.of(context)!;

    double maxWidth;
    if (deviceType == DeviceType.mobile) {
      maxWidth = Const.mobileWidth;
    } else if (deviceType == DeviceType.desktop) {
      maxWidth = Const.desktopWidth;
    } else {
      maxWidth = Const.desktopWidth;
    }
    return BlocBuilder<ArticleFormBloc, ArticleFormState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(Const.margin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(Const.radius),
                onTap: () => context.read<ArticleFormBloc>().add(
                      ArticleFormEvent.pickImage(
                        context: context,
                        source: ImageSource.gallery,
                        deviceType: deviceType,
                      ),
                    ),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: Const.mobileWidth,
                      maxHeight: 250,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.disabledColor),
                      borderRadius: BorderRadius.circular(Const.radius),
                      image: (state.imageMemory != null)
                          ? DecorationImage(
                              image: MemoryImage(state.imageMemory!),
                              fit: BoxFit.cover,
                            )
                          : (state.imageUrl != '')
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                    state.imageUrl,
                                  ),
                                )
                              : null,
                    ),
                    child: (state.imageFile != null || state.imageUrl != '')
                        ? const SizedBox()
                        : Text(
                            lang.upload_thumbnail,
                            style: theme.textTheme.bodyLarge,
                          ),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: maxWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Const.space15),
                      Text(
                        lang.your_awesome_title,
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: Const.space8),
                      TextFormFieldWidget(
                        controller: titleCtrl,
                        maxLines: null,
                        hintText: lang.ten_ways_to_explore_this_world,
                        onChanged: (v) {
                          context
                              .read<ArticleFormBloc>()
                              .add(ArticleFormEvent.title(v));
                        },
                      ),
                      const SizedBox(height: Const.space15),
                      Text(
                        lang.choose_a_category,
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: Const.space8),
                      DropdownButtonHideUnderline(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Const.space12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Const.radius),
                            border: Border.all(
                              color: theme.disabledColor,
                            ),
                          ),
                          child: DropdownButton(
                            value: state.selectedCategory,
                            isExpanded: true,
                            dropdownColor: theme.cardColor,
                            borderRadius: BorderRadius.circular(Const.radius),
                            style: theme.textTheme.bodyMedium,
                            hint: Text(
                              lang.select_category,
                              style: theme.textTheme.titleMedium,
                            ),
                            items: state.categoryList.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name,
                                  style: theme.textTheme.titleMedium,
                                ),
                              );
                            }).toList(),
                            onChanged: (v) {
                              context
                                  .read<ArticleFormBloc>()
                                  .add(ArticleFormEvent.changeCategory(v!));
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: Const.space15),
                      Text(
                        lang.related_tags,
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: Const.space8),
                      TextFieldWidget(
                        controller: tagCtrl,
                        showBorder: true,
                        onSubmitted: (v) {
                          context
                              .read<ArticleFormBloc>()
                              .add(ArticleFormEvent.addTags(v));
                          tagCtrl.clear();
                        },
                        hintText: lang.your_tags,
                      ),
                      const SizedBox(height: Const.space8),
                      Wrap(
                        children: state.tagList.map((tag) {
                          return Padding(
                            padding: const EdgeInsets.only(right: Const.space8),
                            child: Chip(
                              labelPadding: const EdgeInsets.symmetric(
                                horizontal: Const.space8,
                              ),
                              label: Text(tag),
                              onDeleted: () {
                                context
                                    .read<ArticleFormBloc>()
                                    .add(ArticleFormEvent.removeTags(tag));
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _QuillEditorWidget extends StatelessWidget {
  const _QuillEditorWidget({
    required this.quillCtrl,
    required this.focusNode,
    required this.scrollCtrl,
    required this.deviceType,
  });

  final QuillController quillCtrl;
  final FocusNode focusNode;
  final ScrollController scrollCtrl;
  final DeviceType deviceType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    double maxWidth;
    if (deviceType == DeviceType.mobile) {
      maxWidth = 400;
    } else if (deviceType == DeviceType.desktop) {
      maxWidth = 600;
    } else {
      maxWidth = 800;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        QuillToolbar.basic(
          controller: quillCtrl,
          toolbarIconSize: 23,
          showFontFamily: false,
          showFontSize: false,
        ),
        const SizedBox(height: Const.space25),
        Expanded(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
            ),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(Const.radius),
            ),
            padding: const EdgeInsets.all(Const.margin),
            child: QuillEditor(
              controller: quillCtrl,
              readOnly: false,
              focusNode: focusNode,
              scrollController: scrollCtrl,
              scrollable: true,
              padding: EdgeInsets.zero,
              autoFocus: false,
              expands: false,
              customStyles: DefaultStyles(
                color: ColorLight.fontTitle,
                h1: DefaultTextBlockStyle(
                  theme.textTheme.headlineLarge!,
                  const Tuple2(2, 0),
                  const Tuple2(0, 0),
                  null,
                ),
                h2: DefaultTextBlockStyle(
                  theme.textTheme.headlineMedium!,
                  const Tuple2(2, 0),
                  const Tuple2(0, 0),
                  null,
                ),
                h3: DefaultTextBlockStyle(
                  theme.textTheme.headlineSmall!,
                  const Tuple2(2, 0),
                  const Tuple2(0, 0),
                  null,
                ),
                paragraph: DefaultTextBlockStyle(
                  theme.textTheme.titleLarge!.copyWith(
                    fontSize: 16,
                  ),
                  const Tuple2(2, 0),
                  const Tuple2(0, 0),
                  null,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
