import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:treadearena/features/auth/domain/login_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginRepository _loginRepository;

  AuthBloc(this._loginRepository) : super(AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _loginRepository.sendOtp(
        phoneNumber: event.phoneNumber,
        onVerificationCompleted: (user) {
          emit(AuthSuccess());
        },
        onError: (error) {
          emit(AuthFailure(error));
        },
        codeSent: (verificationId) {
          emit(OtpSent(verificationId));
        },
      );
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onVerifyOtp(
      VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userCred = await _loginRepository.verifyOtp(
        verificationId: event.verificationId,
        smsCode: event.otp,
      );
      if (userCred?.user != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure("User is null"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
