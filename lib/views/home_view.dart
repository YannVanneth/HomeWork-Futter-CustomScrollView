import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:custom_scroll_view/data/exports.dart';
import 'package:custom_scroll_view/views/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:custom_scroll_view/views/home_screen/homepages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
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

    var txtController = TextEditingController();

    return BlocProvider(
      create: (context) => MainScreenBloc(),
      child: BlocBuilder<MainScreenBloc, MainScreenState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size(
                  double.infinity, MediaQuery.sizeOf(context).height * 0.35),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.1,
                          child: Text(
                            "NET",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                      AnimationSearchBar(
                          searchBarWidth:
                              MediaQuery.sizeOf(context).width * 0.80,
                          isBackButtonVisible: false,
                          centerTitle: "",
                          onChanged: (p0) {
                            if (state.index != 2) {
                              context
                                  .read<MainScreenBloc>()
                                  .add(ChangeIndexEvent(2));
                              _pageController.jumpToPage(2);
                            }

                            context.read<MainScreenBloc>().add(SearchEvent(p0));
                            context
                                .read<MainScreenBloc>()
                                .add(SearchItemsUpdate());

                            txtController.text = p0;
                          },
                          searchTextEditingController: txtController),
                    ],
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      context
                          .read<MainScreenBloc>()
                          .add(ChangeIndexEvent(index));
                    },
                    children: [
                      HomePageScreen(),
                      WishlistScreen(),
                      SearchScreen(
                        productSelector: state.products,
                      ),
                      Settings(),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              currentIndex: state.index,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
              onTap: (index) {
                context.read<MainScreenBloc>().add(ChangeIndexEvent(index));
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
                  icon: Icon(Icons.search),
                  label: 'Search',
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
