import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/home_screen/home_bloc.dart';
import '../../bloc/home_screen/home_event.dart';
import '../../bloc/home_screen/home_state.dart';
import '../../data/exports.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return CustomScrollView(
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
                                context
                                    .read<HomeBloc>()
                                    .add(UpdateCarouselIndicator(index));
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
                              activeIndex: state.carouselIndicator,
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
                                      context.read<HomeBloc>().add(
                                            SelectedProductType(
                                                productType[index]['title']!),
                                          );

                                      Navigator.pushNamed(
                                        context,
                                        Routes.category,
                                        arguments: state.filteredProducts,
                                      );
                                    },
                                    child: CustomWidgets.categoryList(
                                        index: index),
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
                        var product = Product.fromJson(products[index]);
                        return GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            Routes.detailProduct,
                            arguments: [state.filteredProducts[index]],
                          ),
                          child: CustomWidgets.productCard(
                            context,
                            cardImage: product.featureImageUrl,
                            title: product.name,
                            description: product.description,
                            price: "${product.currencySign}${product.price}",
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
