part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class SendOtpEvent extends AuthEvent {
  final String phoneNumber;
  SendOtpEvent(this.phoneNumber);
}

class VerifyOtpEvent extends AuthEvent {
  final String verificationId;
  final String otp;
  VerifyOtpEvent(this.verificationId, this.otp);
}
