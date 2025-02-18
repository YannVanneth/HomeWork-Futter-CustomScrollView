import 'package:custom_scroll_view/databases/databases_helper.dart';
import 'package:flutter/material.dart';
import 'package:custom_scroll_view/views/home_screen/homepages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/main_screen/main_screen_bloc.dart';
import 'settings/settings.dart';
import 'wishlist/wishlist_screen.dart';

class HomeView extends StatelessWidget {
  final _pageController = PageController();
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // reset data

    // SharedPreferences.getInstance().then(
    //   (value) => value.clear(),
    // );

    // DatabasesHelper.dbHelper.deleteTableData("wishlists");

    return BlocProvider(
      create: (context) => MainScreenBloc(),
      child: BlocBuilder<MainScreenBloc, int>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Text('Custom Scroll View'),
            ),
            body: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                context.read<MainScreenBloc>().changeIndex(index);
              },
              children: [
                HomePageScreen(),
                WishlistScreen(),
                Settings(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              currentIndex: state,
              onTap: (index) {
                context.read<MainScreenBloc>().changeIndex(index);
                _pageController.jumpToPage(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Wishlist',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
