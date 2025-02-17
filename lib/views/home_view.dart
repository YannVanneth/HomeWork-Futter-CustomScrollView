import 'package:flutter/material.dart';
import 'package:custom_scroll_view/views/home_screen/homepages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/main_screen/main_screen_bloc.dart';
import 'settings/settings.dart';
import 'wishlist/wishlist_screen.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainScreenBloc(),
      child: BlocBuilder<MainScreenBloc, int>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: IndexedStack(
                index: state,
                children: [HomePageScreen(), WishlistScreen(), Settings()],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              currentIndex: state,
              onTap: (index) =>
                  context.read<MainScreenBloc>().changeIndex(index),
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
