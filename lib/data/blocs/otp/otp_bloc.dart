import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final UserDataCubit userDataCubit;

  OtpBloc({@required this.userDataCubit}) : super(OtpInitial()) {
    on<OtpEvent>(onOtpEvent);
  }

  final UserRepository _userRepository = UserRepository();
  final CartRepository _cartRepository = CartRepository();
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();

  onOtpEvent(OtpEvent event, Emitter<OtpState> emit) async {
    if (event is OtpSubmited) {
      emit(OtpLoading());
      try {
        final SignInResponse signInResponse =
            await _authenticationRepository.otpVerification(
                phoneNumber: "62${event.phoneNumber}", token: "${event.otp}");

        await _authenticationRepository.persistToken(signInResponse.token);
        await userDataCubit.appStarted();
        emit(OtpSuccess());
      } catch (error) {
        emit(OtpFailure(error.toString()));
      }
    } else if (event is OtpRetry) {
      emit(OtpRetryLoading());

      await _authenticationRepository.authenticate(
          phoneNumber: "62${event.phoneNumber}");
      emit(OtpRetrySuccess());
    }
  }
}
