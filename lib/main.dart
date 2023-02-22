import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:interpretasi_editor/injection.dart' as di;
import 'package:interpretasi_editor/l10n/l10n.dart';
import 'package:interpretasi_editor/src/common/routes.dart';
import 'package:interpretasi_editor/src/common/themes.dart';
import 'package:interpretasi_editor/src/presentation/bloc/article_form/article_form_bloc.dart';
import 'package:interpretasi_editor/src/presentation/bloc/auth_watcher/auth_watcher_bloc.dart';
import 'package:interpretasi_editor/src/presentation/bloc/category_watcher/category_watcher_bloc.dart';
import 'package:interpretasi_editor/src/presentation/bloc/delete_article_actor/delete_article_actor_bloc.dart';
import 'package:interpretasi_editor/src/presentation/bloc/localization_watcher/localization_watcher_bloc.dart';
import 'package:interpretasi_editor/src/presentation/bloc/sign_in_with_email_form/sign_in_with_email_form_bloc.dart';
import 'package:interpretasi_editor/src/presentation/bloc/theme_watcher/theme_watcher_bloc.dart';
import 'package:interpretasi_editor/src/presentation/bloc/upload_image_actor/upload_image_actor_bloc.dart';
import 'package:interpretasi_editor/src/presentation/bloc/user_article_drafted_watcher/user_article_drafted_watcher_bloc.dart';
import 'package:interpretasi_editor/src/presentation/bloc/user_article_moderated_watcher/user_article_moderated_watcher_bloc.dart';
import 'package:interpretasi_editor/src/utilities/route_generator.dart';
import 'package:interpretasi_editor/src/utilities/scroll_behavior.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.locator<ArticleFormBloc>()),
        BlocProvider(create: (context) => di.locator<AuthWatcherBloc>()),
        BlocProvider(create: (context) => di.locator<CategoryWatcherBloc>()),
        BlocProvider(create: (context) => di.locator<DeleteArticleActorBloc>()),
        BlocProvider(create: (context) => di.locator<LocalizationWatcherBloc>()),
        BlocProvider(create: (context) => di.locator<SignInWithEmailFormBloc>()),
        BlocProvider(create: (context) => di.locator<ThemeWatcherBloc>()),
        BlocProvider(create: (context) => di.locator<UploadImageActorBloc>()),
        BlocProvider(create: (context) => di.locator<UserArticleDraftedWatcherBloc>()),
        BlocProvider(create: (context) => di.locator<UserArticleModeratedWatcherBloc>()),
      ],
      child: BlocBuilder<ThemeWatcherBloc, ThemeWatcherState>(
        builder: (context, theme) {
          return BlocBuilder<LocalizationWatcherBloc, LocalizationWatcherState>(
            builder: (context, localization) {
              return MaterialApp(
                title: 'Interpretasi',
                debugShowCheckedModeBanner: false,
                theme: themeLight(context),
                darkTheme: themeDark(context),
                scrollBehavior: ScrollBehaviorWidget(),
                themeMode: (theme.isDarkMode == true)
                    ? ThemeMode.dark
                    : ThemeMode.light,
                supportedLocales: L10n.all,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                locale: localization.selectedLocale,
                initialRoute: SPLASH,
                onGenerateRoute: RouteGenerator.generateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
