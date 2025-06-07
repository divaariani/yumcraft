import 'package:go_router/go_router.dart';
import 'package:recipes/view/login_view.dart';
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
    ],
  );
}
