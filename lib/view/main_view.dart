import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:recipes/theme/app_colors.dart';
import 'package:recipes/utils/app_session_manager.dart';
import 'package:recipes/view/home_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late PersistentTabController _controller;
  int currentIndex = 0;

  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: currentIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineToSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,

      decoration: NavBarDecoration(boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 8.0)
      ]),
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      navBarStyle: NavBarStyle.style9,
      // confineInSafeArea: true,
      // hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
      // popAllScreensOnTapOfSelectedTab: true,
      // popActionScreens: PopActionScreensType.all,
      // itemAnimationProperties: const ItemAnimationProperties(
      //   // Navigation Bar's items animation properties.
      //   duration: Duration(milliseconds: 200),
      //   curve: Curves.ease,
      // ),
    ));
  }

  List<Widget> _buildScreens() {
    return [
      const HomeView(),
      const Center(child: Text('Wishlist')),
      Center(
        child: IconButton(
          onPressed: () {
            SessionManager().clearSession();
            GoRouter.of(context).go('/login');
          },
          icon: const Icon(Icons.logout),
          color: AppColors.color600,
          iconSize: 30,
        ),
      )
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      _bottomWidget(
        icon: Icons.home,
        inactiveIcon: Icons.home_outlined,
        title: 'Home',
      ),
      _bottomWidget(
        icon: Icons.favorite,
        inactiveIcon: Icons.favorite_border,
        title: 'Wishlist',
      ),
      _bottomWidget(
        icon: Icons.person,
        inactiveIcon: Icons.person_outline,
        title: 'Profile',
      ),
    ];
  }

  PersistentBottomNavBarItem _bottomWidget({
    required IconData icon,
    required IconData inactiveIcon,
    required String title,
  }) {
    final theme = Theme.of(context);
    return PersistentBottomNavBarItem(
      icon: Icon(
        icon,
        color: theme.colorScheme.secondary,
      ),
      inactiveIcon: Icon(
        inactiveIcon,
        color: theme.colorScheme.secondary,
      ),
      title: title,
      textStyle: theme.textTheme.bodySmall,
      activeColorPrimary: theme.colorScheme.secondary,
      inactiveColorPrimary: theme.colorScheme.onTertiary,
    );
  }
}
