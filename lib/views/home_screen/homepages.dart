import 'package:flutter_bounceable/flutter_bounceable.dart';

import '../../data/exports.dart';
import '../../models/product_model.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int carouselIndicator = 0;
  List<Map<String, dynamic>> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    filteredProducts = products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    CarouselSlider.builder(
                      itemCount: slidesCarousel.length,
                      itemBuilder: (context, index, realIndex) {
                        return Image.network(
                          slidesCarousel[index],
                          errorBuilder: (context, error, stackTrace) =>
                              CustomWidgets.error404(),
                        );
                      },
                      options: CarouselOptions(
                        autoPlay: true,
                        autoPlayCurve: Curves.decelerate,
                        viewportFraction: 1,
                        enableInfiniteScroll: true,
                        height: MediaQuery.of(context).size.height * 0.3,
                        onPageChanged: (index, reason) {
                          setState(() {
                            carouselIndicator = index;
                          });
                        },
                      ),
                    ),
                    Positioned(
                      left: MediaQuery.sizeOf(context).width / 2 -
                          (slidesCarousel.length * 10),
                      bottom: 5,
                      child: AnimatedSmoothIndicator(
                        effect: ExpandingDotsEffect(
                          dotColor: Colors.grey,
                          activeDotColor: Colors.red,
                        ),
                        activeIndex: carouselIndicator,
                        count: slidesCarousel.length,
                      ),
                    )
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Product Type",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: productType.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                String selectedType =
                                    productType[index]['title']!;

                                filteredProducts = products.where((product) {
                                  return product['product_type'] ==
                                      selectedType;
                                }).toList();

                                Navigator.pushNamed(
                                  context,
                                  Routes.category,
                                  arguments: filteredProducts
                                      .map((e) => ProductModel.fromJSON(e))
                                      .toList(),
                                );

                                setState(() {});
                              },
                              child: CustomWidgets.categoryList(index: index),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverGrid.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.7,
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  var product = ProductModel.fromJSON(products[index]);
                  return Bounceable(
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.detailProduct,
                      arguments: product,
                    ),
                    child: Hero(
                      tag: product.image,
                      child: CustomWidgets.productCard(
                        context,
                        cardImage: product.image,
                        title: product.title,
                        description: product.description,
                        price: "${product.priceSign}${product.price}",
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
