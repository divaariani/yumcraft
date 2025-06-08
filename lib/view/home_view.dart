import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
  List<String> categories = [
    "Breakfast",
    "Lunch",
    "Dinner",
    "Snack",
  ];

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).push('/form-food');
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: AppColors.color600,
        child: const Icon(
          Icons.add,
          color: AppColors.color200,
        ),
      ),
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
          height: 32,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 3 / 3,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final item = categories[index];

            return GestureDetector(
              onTap: () {
                GoRouter.of(context).push(
                  '/food',
                  extra: item,
                );
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.color200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/$item.png",
                      width: 80,
                      height: 80,
                      color: AppColors.color600,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.fastfood, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      item,
                      style: const TextStyle(
                        color: AppColors.color600,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
