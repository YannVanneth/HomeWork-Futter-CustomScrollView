import 'package:custom_scroll_view/data/product.dart';
import 'package:custom_scroll_view/data/product_type.dart';
import 'package:custom_scroll_view/data/slide.dart';
import 'package:custom_scroll_view/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_svg/svg.dart';

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
              SliverAppBar(
                expandedHeight: 40,
                title: Text("Type : $typeSelected"),
                actions: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Total items: ${filters.length}"),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: FlutterCarousel(
                  options: FlutterCarouselOptions(
                    enableInfiniteScroll: true,
                    height: MediaQuery.sizeOf(context).height * 0.3,
                    viewportFraction: 1,
                    showIndicator: true,
                    autoPlay: true,
                    slideIndicator: CircularSlideIndicator(),
                  ),
                  items: slidesCarousel.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(i),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
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
                                  }),
                              child: categoryList(index: index)),
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
                itemCount: filters.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.7, crossAxisCount: 2),
                itemBuilder: (context, index) {
                  var product = Product.fromJson(filters[index]);
                  return productCard(context,
                      cardImage: product.featureImageUrl,
                      title: product.name,
                      description: product.description,
                      price: "${product.currencySign}${product.price}");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget categoryList({int index = 0, double size = 60}) {
    return Column(
      children: [
        SizedBox(
          height: size,
          width: size,
          child: SvgPicture.network(
            (productType[index]['image'] ?? ""),
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
                productType[index]['title'] == typeSelected
                    ? Colors.blue
                    : Colors.black,
                BlendMode.srcIn),
          ),
        ),
        Text(
          productType[index]['title'] ?? "",
          style: TextStyle(
              color: productType[index]['title'] == typeSelected
                  ? Colors.blue
                  : Colors.black),
        )
      ],
    );
  }

  Widget productCard(BuildContext context,
      {String? cardImage, String? title, String? description, String? price}) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: NetworkImage(
                      cardImage ?? "",
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? "Header",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  description == ""
                      ? "Doesn't have desciption"
                      : description ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Price $price",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
