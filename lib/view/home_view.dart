import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/bloc/user/user_bloc.dart';
import 'package:recipes/theme/app_colors.dart';
import 'package:recipes/utils/app_session_manager.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  UserBloc userBloc = UserBloc();
  String? userId;
  String? userName;
  String? userPhoto;

  @override
  void initState() {
    super.initState();
    SessionManager().getUserId().then((value) {
      setState(() {
        userId = value;
      });
      _loadData();
    });
  }

  void _loadData() {
    userBloc.add(GetLoginRequest(userId ?? ''));
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocConsumer(
                    bloc: userBloc,
                    listener: listener,
                    builder: builder,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void listener(BuildContext context, Object? state) {
    if (state is GetLoginSuccess) {
      userName = userBloc.userData?.name;
      userPhoto = userBloc.userData?.imageUrl;
      debugPrint("cek foto user: $userPhoto");
    }

    if (state is GetLoginError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(state.errorMessage ?? "Terjadi kesalahan"),
      ));
    }
  }

  Widget builder(BuildContext context, Object? state) {
    if (state is GetLoginLoading) {
      return const CircularProgressIndicator(
        color: AppColors.color600,
      );
    }

    if (state is GetLoginError) {
      return Container();
    }

    return buildContext(context);
  }

  Widget buildContext(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: AppColors.color600,
              child: ClipOval(
                child: Image.network(
                  userPhoto ?? '',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.white,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Welcome, ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextSpan(
                    text: "$userName !",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          decoration: BoxDecoration(
            color: AppColors.color100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'card',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
