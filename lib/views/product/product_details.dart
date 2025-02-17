import 'package:custom_scroll_view/bloc/detail_screen/detail_screen_bloc.dart';
import 'package:custom_scroll_view/bloc/detail_screen/detail_screen_event.dart';
import 'package:custom_scroll_view/bloc/detail_screen/detail_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:custom_scroll_view/data/exports.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var itemData = ModalRoute.of(context)?.settings.arguments as List;

    var item = itemData[0] as Map<String, dynamic>;
    var product = Product.fromJson(item);

    int numberOfItems = itemData.length == 2 ? itemData[1] as int : 1;

    return BlocProvider(
      create: (context) => DetailScreenBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.shopping_cart),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(child: ProductDetailContent(product, numberOfItems, item)),
          ],
        ),
      ),
    );
  }
}

class ProductDetailContent extends StatelessWidget {
  final Product product;
  final int numberOfItems;
  final Map<String, dynamic> item;
  const ProductDetailContent(this.product, this.numberOfItems, this.item,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailScreenBloc, DetailScreenState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomWidgets.productImage(context, product),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.68,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Price: ${product.currencySign}${product.price}",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Bounceable(
                    onTap: () => context
                        .read<DetailScreenBloc>()
                        .add(ToggleFavorite(!state.isFavorite)),
                    child: Icon(
                      state.isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 28,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Text(
                      "Color: ${state.selectedColor.isEmpty && product.colors.isEmpty ? "Not found" : state.selectedColor.isEmpty ? "Please select color" : state.selectedColor}",
                      style: TextStyle(fontSize: 18),
                    ),
                    if (product.colors.isNotEmpty)
                      SizedBox(
                        height: 50,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var color = product.colors[index].colorCode
                                .replaceFirst("#", "0xFF")
                                .split(',')[0]
                                .replaceFirst("#", "0xFF");
                            return Bounceable(
                              onTap: () {
                                context.read<DetailScreenBloc>().add(
                                    ColorSelected(
                                        product.colors[index].colorName));
                              },
                              child: CustomWidgets.colorBox(
                                  border: state.selectedColor ==
                                      product.colors[index].colorName,
                                  color: Color(int.parse(color))),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 10),
                          itemCount: product.colors.length,
                        ),
                      )
                    else
                      CustomWidgets.itemTags(tagName: "Unknown Color"),
                  ],
                ),
              ),
              CustomWidgets.productTags(product),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text("Description:", style: TextStyle(fontSize: 18)),
                  if (product.description.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (!state.isExpanded)
                          Text(
                            product.description,
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.justify,
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (state.isExpanded)
                          Text(
                            product.description,
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.justify,
                          ),
                        TextButton(
                          onPressed: () => context.read<DetailScreenBloc>().add(
                                ShowDetailScreen(!state.isExpanded),
                              ),
                          child:
                              Text(state.isExpanded ? "See less" : "See more"),
                        ),
                      ],
                    )
                  else
                    CustomWidgets.itemTags(tagName: "Unknown Description"),
                ],
              ),
              CustomWidgets.bottomArea(
                  context, item, state.selectedColor, numberOfItems),
            ],
          ),
        );
      },
    );
  }
}

// import 'package:custom_scroll_view/data/exports.dart';

// class ProductDetailsPage extends StatefulWidget {
//   const ProductDetailsPage({super.key});

//   @override
//   State<ProductDetailsPage> createState() => ProductDetailsPageState();
// }

// class ProductDetailsPageState extends State<ProductDetailsPage> {
//   var isSelectedColor = "";
//   late Map<String, dynamic> item;
//   int numberOfItems = 1;

//   @override
//   Widget build(BuildContext context) {
//     var itemData = ModalRoute.of(context)?.settings.arguments as List;

//     item = itemData[0] as Map<String, dynamic>;
//     var product = Product.fromJson(item);

//     if (itemData.length == 2) {
//       numberOfItems = itemData[1] as int;
//     }

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Icon(Icons.shopping_cart),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           CustomWidgets.productImage(context, product),
//           Expanded(child: productDetails(context, product, item)),
//         ],
//       ),
//     );
//   }

//   Widget productDetails(
//       BuildContext context, Product product, Map<String, dynamic> itemdata) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         spacing: 15,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               SizedBox(
//                 width: MediaQuery.sizeOf(context).width * 0.68,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   spacing: 5,
//                   children: [
//                     Text(
//                       product.name,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style:
//                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       "Price: ${product.currencySign}${product.price}",
//                       style: TextStyle(
//                           color: Colors.red,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16),
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(
//                 Icons.favorite_border,
//                 size: 28,
//                 color: Colors.red,
//               )
//             ],
//           ),
//           SizedBox(
//             width: double.infinity,
//             child: Column(
//               spacing: 5,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Color: ${isSelectedColor.isEmpty && product.colors.isEmpty ? "Not found" : isSelectedColor.isEmpty ? "Please select color" : isSelectedColor ?? ""}",
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 if (product.colors.isNotEmpty)
//                   SizedBox(
//                     height: 50,
//                     child: ListView.separated(
//                         scrollDirection: Axis.horizontal,
//                         itemBuilder: (context, index) {
//                           var color = product.colors[index].colorCode
//                               .replaceFirst("#", "0xFF")
//                               .split(',')
//                               .first
//                               .replaceFirst("#", "0xFF");
//                           return GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 isSelectedColor =
//                                     product.colors[index].colorName;
//                               });
//                             },
//                             child: CustomWidgets.colorBox(
//                                 border: isSelectedColor ==
//                                         product.colors[index].colorName
//                                     ? true
//                                     : false,
//                                 color: Color(int.parse(color))),
//                           );
//                         },
//                         separatorBuilder: (context, index) => SizedBox(
//                               width: 10,
//                             ),
//                         itemCount: product.colors.length),
//                   )
//                 else
//                   SizedBox(
//                     width: MediaQuery.sizeOf(context).width * 0.3,
//                     child: CustomWidgets.itemTags(tagName: "Unknow Color"),
//                   )
//               ],
//             ),
//           ),
//           CustomWidgets.productTags(product),
//           Column(
//             spacing: 5,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Description:",
//                 style: TextStyle(fontSize: 18),
//                 textAlign: TextAlign.start,
//               ),
//               Text(
//                 product.description.isNotEmpty
//                     ? product.description
//                     : "Unknown",
//                 maxLines: 6,
//                 overflow: TextOverflow.ellipsis,
//                 textAlign: TextAlign.start,
//                 style: TextStyle(fontSize: 16),
//               ),
//             ],
//           ),
//           CustomWidgets.bottomArea(
//               context, item, isSelectedColor, numberOfItems)
//         ],
//       ),
//     );
//   }
// }
