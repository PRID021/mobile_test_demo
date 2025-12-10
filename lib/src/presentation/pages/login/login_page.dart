import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_test_demo/src/presentation/bloc/app/app_bloc.dart';
import 'package:mobile_test_demo/src/presentation/bloc/login/login_bloc.dart';
import 'package:mobile_test_demo/src/presentation/bloc/login/login_event.dart';
import 'package:mobile_test_demo/src/presentation/bloc/login/login_state.dart';
import 'package:mobile_test_demo/src/presentation/widgets/app_button.dart';
import 'package:mobile_test_demo/src/presentation/widgets/app_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(authRepository: context.read()),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Login thất bại')),
            );
          }
          if (state.status == LoginStatus.success) {
            context.read<AppBloc>().add(LoggedIn());
          }
        },
        child: Scaffold(
          body: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return Stack(
                children: [
                  Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),

                          // Email
                          BlocBuilder<LoginBloc, LoginState>(
                            buildWhen: (p, c) => p.email != c.email,
                            builder: (context, state) {
                              return AppTextField(
                                label: 'Email',
                                onChanged: (value) {
                                  context
                                      .read<LoginBloc>()
                                      .add(EmailChanged(value));
                                },
                                errorText: (!state.email.isPure)
                                    ? state.email.errorMessage
                                    : null,
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          // Password
                          BlocBuilder<LoginBloc, LoginState>(
                            buildWhen: (p, c) => p.password != c.password,
                            builder: (context, state) {
                              return AppTextField(
                                label: 'Password',
                                obscureText: true,
                                onChanged: (value) {
                                  context
                                      .read<LoginBloc>()
                                      .add(PasswordChanged(value));
                                },
                                errorText: (!state.password.isPure)
                                    ? state.password.errorMessage
                                    : null,
                              );
                            },
                          ),

                          const SizedBox(height: 32),

                          BlocBuilder<LoginBloc, LoginState>(
                            buildWhen: (p, c) => p.status != c.status,
                            builder: (context, state) {
                              if (state.status == LoginStatus.submitting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return AppButton(
                                title: 'Login',
                                enabled: state.isValid,
                                onPressed: () {
                                  context
                                      .read<LoginBloc>()
                                      .add(LoginSubmitted());
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Disable touch when submitting
                  if (state.status == LoginStatus.submitting)
                    const ModalBarrier(
                      dismissible: false,
                      color: Colors.black38, // optional: gives a dimmed effect
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
