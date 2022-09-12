import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository = UserRepository();

  SignUpBloc() : super(SignUpInitial()){
    on<SignUpEvent>(onSignUpEvent);
  }

  onSignUpEvent(SignUpEvent event, Emitter<SignUpState> emit)async{
    if (event is SignUpButtonPressed) {
      emit(SignUpLoading());

      try {
        try {
          int.parse(event.phoneNumber);
        } catch (e) {
          throw ("Nomor telpon hanya menerima angka");
        }
        if (event.phoneNumber[0] == '0') throw ("Nomor telpon tidak valid");

        await _userRepository.signUp(
            name: event.name, phoneNumber: "62${event.phoneNumber}");

        emit(SignUpSuccess(phoneNumber: event.phoneNumber, otpTimeOut: 50));
      } catch (error) {
        emit(SignUpFailure(error: error.toString()));
      }
    }
  }


}
