import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:interpretasi_editor/src/common/const.dart';
import 'package:interpretasi_editor/src/common/enums.dart';
import 'package:interpretasi_editor/src/common/routes.dart';
import 'package:interpretasi_editor/src/presentation/bloc/sign_in_with_email_form/sign_in_with_email_form_bloc.dart';
import 'package:interpretasi_editor/src/presentation/widget/elevated_button_widget.dart';
import 'package:interpretasi_editor/src/presentation/widget/responsive_layout.dart';
import 'package:interpretasi_editor/src/presentation/widget/text_form_field_widget.dart';
import 'package:interpretasi_editor/src/utilities/snackbar.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;
    return BlocListener<SignInWithEmailFormBloc, SignInWithEmailFormState>(
      listener: (context, state) {
        if (state.state == RequestState.loaded) {
          context
              .read<SignInWithEmailFormBloc>()
              .add(const SignInWithEmailFormEvent.init());
          Navigator.pushNamedAndRemoveUntil(
            context,
            SPLASH,
            (route) => false,
          );
        } else if (state.state == RequestState.error &&
            state.message == ExceptionMessage.wrongPassword) {
          final snack = showSnackbar(
            context,
            type: SnackbarType.error,
            labelText: lang
                .incorrect_password_try_again_or_click_forgot_password_to_reset,
            labelButton: lang.close,
            onTap: () {},
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
        } else if (state.message == ExceptionMessage.userNotFound) {
          final snack = showSnackbar(
            context,
            type: SnackbarType.error,
            labelText: lang.couldnt_find_the_account_with_that_email,
            labelButton: lang.close,
            onTap: () {},
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
        }
      },
      child: const Scaffold(
        body: ResponsiveLayout(
          mobileBody: _LoginMobileBody(),
          desktopBody: _LoginDesktopBody(),
        ),
      ),
    );
  }
}

class _LoginMobileBody extends StatelessWidget {
  const _LoginMobileBody();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final theme = Theme.of(context);
    final lang = AppLocalizations.of(context)!;

    return BlocBuilder<SignInWithEmailFormBloc, SignInWithEmailFormState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Const.margin),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Const.space25 * 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.logo,
                      width: 20,
                    ),
                    const SizedBox(width: Const.space12),
                    Text(
                      lang.interpretasi,
                      style: theme.textTheme.headlineSmall,
                    ),
                  ],
                ),
                const SizedBox(height: Const.space12),
                Center(
                  child: Text(
                    lang.explore_information_without_limits,
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: Const.space50),
                Text(
                  lang.your_email_address,
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: Const.space8),
                TextFormFieldWidget(
                  hintText: lang.captize_gmail_com,
                  textFieldType: TextFieldType.email,
                  onChanged: (v) {
                    context
                        .read<SignInWithEmailFormBloc>()
                        .add(SignInWithEmailFormEvent.email(v));
                  },
                ),
                const SizedBox(height: Const.space25),
                Text(
                  lang.choose_a_password,
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: Const.space8),
                TextFormFieldWidget(
                  obscureText: state.obscureText,
                  hintText: lang.min_6_characters,
                  suffixIcon: IconButton(
                    onPressed: () {
                      context.read<SignInWithEmailFormBloc>().add(
                            const SignInWithEmailFormEvent.obscureText(),
                          );
                    },
                    icon: Icon(
                      state.obscureText == true
                          ? FeatherIcons.eyeOff
                          : FeatherIcons.eye,
                    ),
                  ),
                  onChanged: (v) {
                    context
                        .read<SignInWithEmailFormBloc>()
                        .add(SignInWithEmailFormEvent.password(v));
                  },
                ),
                const SizedBox(height: Const.space25),
                ElevatedButtonWidget(
                  label: lang.login,
                  labelLoading: lang.signing,
                  isLoading: (state.isSubmitting == true) ? true : false,
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      context.read<SignInWithEmailFormBloc>().add(
                            const SignInWithEmailFormEvent.signIn(),
                          );
                    }
                  },
                ),
                const SizedBox(height: Const.space25),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LoginDesktopBody extends StatelessWidget {
  const _LoginDesktopBody();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final theme = Theme.of(context);
    final lang = AppLocalizations.of(context)!;

    return BlocBuilder<SignInWithEmailFormBloc, SignInWithEmailFormState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Const.margin),
          child: Center(
            child: SizedBox(
              width: 300,
              height: 800,
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.logo,
                          width: 20,
                        ),
                        const SizedBox(width: Const.space12),
                        Text(
                          lang.interpretasi,
                          style: theme.textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: Const.space12),
                    Center(
                      child: Text(
                        lang.explore_information_without_limits,
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: Const.space50),
                    Text(
                      lang.your_email_address,
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: Const.space8),
                    TextFormFieldWidget(
                      hintText: lang.captize_gmail_com,
                      textFieldType: TextFieldType.email,
                      onChanged: (v) {
                        context
                            .read<SignInWithEmailFormBloc>()
                            .add(SignInWithEmailFormEvent.email(v));
                      },
                    ),
                    const SizedBox(height: Const.space25),
                    Text(
                      lang.choose_a_password,
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: Const.space8),
                    TextFormFieldWidget(
                      obscureText: state.obscureText,
                      hintText: lang.min_6_characters,
                      suffixIcon: IconButton(
                        onPressed: () {
                          context.read<SignInWithEmailFormBloc>().add(
                                const SignInWithEmailFormEvent.obscureText(),
                              );
                        },
                        icon: Icon(
                          state.obscureText == true
                              ? FeatherIcons.eyeOff
                              : FeatherIcons.eye,
                        ),
                      ),
                      onChanged: (v) {
                        context
                            .read<SignInWithEmailFormBloc>()
                            .add(SignInWithEmailFormEvent.password(v));
                      },
                    ),
                    const SizedBox(height: Const.space25),
                    ElevatedButtonWidget(
                      label: lang.login,
                      labelLoading: lang.signing,
                      isLoading: (state.isSubmitting == true) ? true : false,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          context.read<SignInWithEmailFormBloc>().add(
                                const SignInWithEmailFormEvent.signIn(),
                              );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
