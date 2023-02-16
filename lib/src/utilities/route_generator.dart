import 'package:flutter/material.dart';
import 'package:interpretasi_editor/src/common/routes.dart';
import 'package:interpretasi_editor/src/presentation/pages/article_form_page.dart';
import 'package:interpretasi_editor/src/presentation/pages/error_page.dart';
import 'package:interpretasi_editor/src/presentation/pages/home_page.dart';
import 'package:interpretasi_editor/src/presentation/pages/login_page.dart';
import 'package:interpretasi_editor/src/presentation/pages/splash_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case SPLASH:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
        );
      case LOGIN:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
      case HOME:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
      case ARTICLE_FORM:
        if (args is bool) {
          return MaterialPageRoute(
            builder: (_) => ArticleFormPage(isEdit: args),
          );
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return const ErrorPage();
      },
    );
  }
}
