import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:interpretasi_editor/src/common/const.dart';
import 'package:interpretasi_editor/src/common/enums.dart';
import 'package:interpretasi_editor/src/common/routes.dart';
import 'package:interpretasi_editor/src/common/screens.dart';
import 'package:interpretasi_editor/src/presentation/bloc/article_form/article_form_bloc.dart';
import 'package:interpretasi_editor/src/presentation/bloc/delete_article_actor/delete_article_actor_bloc.dart';
import 'package:interpretasi_editor/src/presentation/bloc/user_article_drafted_watcher/user_article_drafted_watcher_bloc.dart';
import 'package:interpretasi_editor/src/presentation/widget/article_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context
          .read<UserArticleDraftedWatcherBloc>()
          .add(const UserArticleDraftedWatcherEvent.fetch()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<DeleteArticleActorBloc, DeleteArticleActorState>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () {},
          success: (_) {
            context
                .read<UserArticleDraftedWatcherBloc>()
                .add(const UserArticleDraftedWatcherEvent.fetch());
            context
                .read<DeleteArticleActorBloc>()
                .add(const DeleteArticleActorEvent.init());
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.background,
          title: Text(
            'Interpretasi Editor',
            style: theme.textTheme.headlineMedium,
          ),
          actions: [
            IconButton(
              onPressed: () {
                context
                    .read<ArticleFormBloc>()
                    .add(const ArticleFormEvent.init());
                Navigator.pushNamed(
                  context,
                  ARTICLE_FORM,
                  arguments: false,
                );
              },
              icon: Icon(
                FeatherIcons.plus,
                color: theme.iconTheme.color,
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: Const.margin),
              child: Text('Drafted', style: theme.textTheme.headlineMedium),
            ),
            const SizedBox(height: Const.space12),
            BlocBuilder<UserArticleDraftedWatcherBloc,
                UserArticleDraftedWatcherState>(
              builder: (context, state) {
                return state.maybeMap(
                  orElse: () {
                    return SizedBox(
                      width: Screens.width(context),
                      height: 300,
                      child: ListView.builder(
                        itemCount: 3,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(left: Const.margin),
                        itemBuilder: (context, index) {
                          return const ArticleCardLoadingWidget(
                            align: CardAlignment.horizontal,
                          );
                        },
                      ),
                    );
                  },
                  loaded: (state) {
                    return (state.articleList.isEmpty)
                        ? const Text('buat artikel')
                        : SizedBox(
                            width: double.infinity,
                            height: 300,
                            child: ListView.builder(
                              itemCount: state.articleList.length,
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              padding:
                                  const EdgeInsets.only(left: Const.margin),
                              itemBuilder: (context, index) {
                                final article = state.articleList[index];

                                return ArticleCardWidget(
                                  article: article,
                                  index: index,
                                  align: CardAlignment.horizontal,
                                  showDeleteButton: true,
                                  showEditButton: true,
                                  showPreviewButton: true,
                                  showPublishButton: true,
                                  onTap: () {
                                    // Navigator.pushNamed(
                                    //   context,
                                    //   ARTICLE_DETAIL,
                                    //   arguments: article,
                                    // );
                                  },
                                );
                              },
                            ),
                          );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
