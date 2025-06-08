import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recipes/bloc/user/user_bloc.dart';
import 'package:recipes/model/user_model.dart';
import 'package:recipes/theme/app_colors.dart';
import 'package:recipes/utils/app_session_manager.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  UserBloc userBloc = UserBloc();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isLoading = false;

  List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
  }

  void _showSnackbar(String value, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      content: Text(value),
    ));
  }

  void _navigateTo(String route) {
    GoRouter.of(context).push(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'YumCraft',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.color600),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Image.asset(
                    'assets/logo.png',
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  const Text(
                    'Log In to your account !',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.color600,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.color600),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.color400, width: 2),
                      ),
                      filled: true,
                      fillColor: AppColors.color100,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: isPasswordVisible ? false : true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.color600),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.color400, width: 2),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.color600,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: AppColors.color100,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  BlocConsumer(
                    bloc: userBloc,
                    listener: (context, state) async {
                      if (state is GetUsersSuccess) {
                        users = userBloc.listUsers ?? [];
                      }

                      if (state is GetUsersError) {
                        setState(() {
                          isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content:
                                Text(state.errorMessage ?? "User not found"),
                          ),
                        );
                      }

                      if (state is GetLoginSuccess) {
                        final user = userBloc.userData;

                        debugPrint("Cek user data: ${user?.toJson()}, userid : ${user?.id} , email: ${user?.email}");

                        await SessionManager().saveUserSession(
                          user?.id ?? '',
                          user?.email ?? '',
                          true,
                        );

                        _showSnackbar("Login successful", Colors.green);
                        _navigateTo('/home');
                      }

                      if (state is GetLoginError) {
                        setState(() {
                          isLoading = false;
                        });
                        _showSnackbar(
                            state.errorMessage ?? "Login failed", Colors.red);
                      }
                    },
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (emailController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill all fields !'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            setState(() {
                              isLoading = true;
                            });

                            userBloc.add(GetUsersRequest());

                            await Future.delayed(const Duration(seconds: 1));

                            final userWithEmail = users.firstWhere(
                              (user) => user.email == emailController.text,
                              orElse: () => UserModel(),
                            );

                            if (users.isEmpty || userWithEmail.id == null) {
                              setState(() {
                                isLoading = false;
                              });
                              _showSnackbar("No users found", Colors.red);
                            } else if (userWithEmail.password !=
                                passwordController.text) {
                              _showSnackbar(
                                  "Password is incorrect", Colors.red);
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              try {
                                final matchedUser = users.firstWhere(
                                  (user) =>
                                      user.email ==
                                          emailController.text.trim() &&
                                      user.password ==
                                          passwordController.text.trim(),
                                );

                                userBloc.add(
                                    GetLoginRequest(matchedUser.id ?? "0"));
                              } catch (e) {
                                _showSnackbar("Email or password is incorrect",
                                    Colors.red);
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.color600,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Log In',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Don\'t have an account?',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.color600,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context).push('/register');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(
                            color: AppColors.color600,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.color600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
