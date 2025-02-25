import 'package:flutter_level_01/data/exports.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

import '../../models/product_model.dart';

class ViewCategoryPage extends StatefulWidget {
  const ViewCategoryPage({super.key});

  @override
  State<ViewCategoryPage> createState() => _ViewCategoryPageState();
}

class _ViewCategoryPageState extends State<ViewCategoryPage> {
  @override
  Widget build(BuildContext context) {
    var filters =
        ModalRoute.of(context)?.settings.arguments as List<ProductModel>;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: filters.isNotEmpty
            ? Text(filters[0].productType)
            : Text("This Product Not found"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.shopping_bag),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: filters.isNotEmpty
            ? CustomScrollView(
                slivers: [
                  SliverGrid.builder(
                    itemCount: filters.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.7,
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      var product = filters[index];
                      return Bounceable(
                        onTap: () => Navigator.pushNamed(
                            context, Routes.detailProduct,
                            arguments: filters[index]),
                        child: CustomWidgets.productCard(context,
                            cardImage: product.image,
                            title: product.title,
                            description: product.description,
                            price: "${product.priceSign}${product.price}"),
                      );
                    },
                  )
                ],
              )
            : Center(
                child: CustomWidgets.error404(errorMessage: "Data not found"),
              ),
      ),
    );
  }
}
