import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treadearena/features/auth/domain/auth_bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("✅ Login Successful!")));
        }
      },
      builder: (context, state) {
        final bloc = context.read<AuthBloc>();

        return Scaffold(
          appBar: AppBar(title: const Text("Login")),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 📱 Phone number input
                  if (state is AuthInitial || state is AuthFailure) ...[
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter mobile number",
                        prefixText: "+91 ",
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // 🔑 OTP input
                  if (state is OtpSent) ...[
                    TextField(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter OTP",
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ⏳ Loader or Button
                  if (state is AuthLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: () {
                        if (state is AuthInitial || state is AuthFailure) {
                          bloc.add(SendOtpEvent(phoneController.text));
                        } else if (state is OtpSent) {
                          bloc.add(
                            VerifyOtpEvent(
                              state.verificationId,
                              otpController.text,
                            ),
                          );
                        }
                      },
                      child: Text(state is OtpSent ? "Verify OTP" : "Send OTP"),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
