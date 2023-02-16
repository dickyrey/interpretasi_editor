import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:interpretasi_editor/src/common/enums.dart';
import 'package:interpretasi_editor/src/domain/usecases/sign_in_with_email.dart';

part 'sign_in_with_email_form_event.dart';
part 'sign_in_with_email_form_state.dart';
part 'sign_in_with_email_form_bloc.freezed.dart';

class SignInWithEmailFormBloc
    extends Bloc<SignInWithEmailFormEvent, SignInWithEmailFormState> {
  SignInWithEmailFormBloc(this._signIn)
      : super(SignInWithEmailFormState.initial()) {
    on<SignInWithEmailFormEvent>((event, emit) async {
      await event.map(
        init: (_) {
          emit(SignInWithEmailFormState.initial());
        },
        obscureText: (_) {
          if (state.obscureText == true) {
            emit(state.copyWith(obscureText: false));
          } else {
            emit(state.copyWith(obscureText: true));
          }
        },
        email: (event) {
          emit(
            state.copyWith(
              email: event.email,
              state: RequestState.empty,
              message: '',
            ),
          );
        },
        password: (event) {
          emit(
            state.copyWith(
              password: event.password,
              state: RequestState.empty,
              message: '',
            ),
          );
        },
        signIn: (_) async {
          emit(
            state.copyWith(
              state: RequestState.loading,
              isSubmitting: true,
            ),
          );
          final result = await _signIn.execute(
            email: state.email,
            password: state.password,
          );
          result.fold(
            (f) => emit(
              state.copyWith(
                state: RequestState.error,
                isSubmitting: false,
                message: f.message,
              ),
            ),
            (_) => emit(
              state.copyWith(
                state: RequestState.loaded,
                isSubmitting: false,
              ),
            ),
          );
        },
      );
    });
  }
  final SignInWithEmail _signIn;
}
