import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitial()) {
    on<SignInEvent>(onSignInEvent);
  }

  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository();

  void onSignInEvent(
      SignInEvent event, Emitter<SignInState> emit) async {
    if (event is SignInButtonPressed) {
      emit(SignInLoading());

      try {
        try {
          int.parse(event.phoneNumber);
        } catch (e) {
          throw ("Nomor telpon hanya menerima angka");
        }
        if (event.phoneNumber[0] == '0') throw ("Nomor telpon tidak valid");

        await authenticationRepository.authenticate(
          phoneNumber: "62${event.phoneNumber}",
        );
        emit(
            SignInOtpRequested(phoneNumber: event.phoneNumber, otpTimeOut: 50));
      } catch (error) {
        emit(SignInFailure(error: error.toString()));
      }
    }
  }
}
