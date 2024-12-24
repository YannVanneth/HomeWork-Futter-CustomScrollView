import 'package:custom_scroll_view/data/exports.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  String typeSelected = productType[0]['title']!;

  List<Map<String, dynamic>> filters = [];

  void filterProduct() {
    filters = products
        .where((find) => find['product_type'] == typeSelected.toLowerCase())
        .toList();
  }

  var indicator = 0;

  @override
  void initState() {
    super.initState();
    filterProduct();
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
                            CustomWidgets().error404(),
                      );
                    },
                    options: CarouselOptions(
                      autoPlay: true,
                      autoPlayCurve: Curves.decelerate,
                      viewportFraction: 1,
                      enableInfiniteScroll: true,
                      height: MediaQuery.of(context).size.height * 0.3,
                      onPageChanged: (index, reason) =>
                          setState(() => indicator = index),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.sizeOf(context).width / 2 - 25,
                    bottom: 5,
                    child: AnimatedSmoothIndicator(
                      effect: ExpandingDotsEffect(
                        dotColor: Colors.grey,
                        activeDotColor: Colors.red,
                      ),
                      activeIndex: indicator,
                      count: slidesCarousel.length,
                    ),
                  )
                ],
              )),
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
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: productType.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () => setState(() {
                              typeSelected = productType[index]['title']!;
                              filterProduct();

                              Navigator.pushNamed(
                                context,
                                Routes.category,
                                arguments: filters,
                              );
                            }),
                            child: CustomWidgets().categoryList(index: index),
                          ),
                          separatorBuilder: (context, index) => SizedBox(
                            width: 10,
                          ),
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
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  var product = Product.fromJson(products[index]);
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, Routes.detailProduct,
                        arguments: products[index]),
                    child: CustomWidgets().productCard(context,
                        cardImage: product.featureImageUrl,
                        title: product.name,
                        description: product.description,
                        price: "${product.currencySign}${product.price}"),
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
