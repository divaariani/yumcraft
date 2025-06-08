import 'package:go_router/go_router.dart';
import 'package:recipes/view/form_food_view.dart';
import 'package:recipes/view/home_view.dart';
import 'package:recipes/view/login_view.dart';
import 'package:recipes/view/main_view.dart';
import 'package:recipes/view/register_view.dart';
import 'package:recipes/view/splash_view.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: '/main',
        builder: (context, state) => const MainView(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: '/form-food',
        builder: (context, state) => const FormFoodView(),
      ),
    ],
  );
}
