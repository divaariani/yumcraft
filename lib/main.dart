import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipes/bloc/register/register_bloc.dart';
import 'package:recipes/bloc/user/user_bloc.dart';
import 'package:recipes/theme/app_colors.dart';
import 'package:recipes/utils/app_router.dart';
import 'package:recipes/utils/app_firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RegisterBloc()),
        BlocProvider(create: (context) => UserBloc()),
      ],
      child: MaterialApp.router(
        title: 'YumCraft',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.color600),
          primaryColor: AppColors.color600,
          textTheme: GoogleFonts.poppinsTextTheme(),
          useMaterial3: true,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
