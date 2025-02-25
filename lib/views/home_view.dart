import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter_level_01/data/exports.dart';
import 'package:flutter_level_01/views/home_screen/homepages.dart';
import 'package:flutter_level_01/views/search/search_screen.dart';

import '../models/product_model.dart';
import 'settings/settings.dart';
import 'wishlist/wishlist_screen.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _pageController = PageController();
  int currentIndex = 0;
  List<ProductModel> filteredProducts = [];
  final txtController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    txtController.dispose();
    super.dispose();
  }

  void _updateSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = List.from(products
            .map(
              (e) => ProductModel.fromJSON(e),
            )
            .toList());
      } else {
        filteredProducts = products
            .map(
              (e) => ProductModel.fromJSON(e),
            )
            .toList()
            .where((product) {
          return product.title.toLowerCase().startsWith(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize:
            Size(double.infinity, MediaQuery.sizeOf(context).height * 0.35),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.1,
                    child: Text(
                      "NET",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                AnimationSearchBar(
                    searchBarWidth: MediaQuery.sizeOf(context).width * 0.80,
                    isBackButtonVisible: false,
                    centerTitle: "",
                    onChanged: (query) {
                      if (currentIndex != 2) {
                        currentIndex = 2;

                        _pageController.jumpToPage(2);
                      }
                      _updateSearchResults(query);
                      txtController.text = query;

                      setState(() {});
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
                setState(() {
                  currentIndex = index;
                });
              },
              children: [
                HomePageScreen(),
                WishlistScreen(),
                SearchScreen(listProducts: filteredProducts),
                Settings(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 2) {
            _updateSearchResults(txtController.text);
          }
          setState(() {
            currentIndex = index;
          });
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
  }
}
