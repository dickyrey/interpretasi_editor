import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:interpretasi_editor/src/common/const.dart';
import 'package:interpretasi_editor/src/common/routes.dart';
import 'package:interpretasi_editor/src/presentation/bloc/auth_watcher/auth_watcher_bloc.dart';
import 'package:interpretasi_editor/src/presentation/bloc/category_watcher/category_watcher_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AuthWatcherBloc>().add(const AuthWatcherEvent.check());
      context
          .read<CategoryWatcherBloc>()
          .add(const CategoryWatcherEvent.fetch());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthWatcherBloc, AuthWatcherState>(
        listener: (context, state) {
          state.maybeMap(
            orElse: () {},
            authenticated: (_) {
              return goNextRoute(HOME);
            },
            authInFailure: (_) {
              return goNextRoute(LOGIN);
            },
            notAuthenticated: (value) {
              return goNextRoute(LOGIN);
            },
          );
        },
        child: Center(
          child: SvgPicture.asset(
            Assets.logo,
            height: 100,
          ),
        ),
      ),
    );
  }

  Future<void> goNextRoute(String path) async {
    Future.delayed(
      const Duration(seconds: 1),
      () => Navigator.pushNamedAndRemoveUntil(
        context,
        path,
        (Route<dynamic> route) => false,
      ),
    );
  }
}
