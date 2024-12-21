import 'package:custom_scroll_view/data/exports.dart';

class ViewCategoryPage extends StatefulWidget {
  const ViewCategoryPage({super.key});

  @override
  State<ViewCategoryPage> createState() => ViewCategoryPageState();
}

class ViewCategoryPageState extends State<ViewCategoryPage> {
  @override
  Widget build(BuildContext context) {
    var filters = ModalRoute.of(context)?.settings.arguments
        as List<Map<String, dynamic>>;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: filters.isNotEmpty
            ? Text(filters[0]['product_type'].toString())
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
                      var product = Product.fromJson(filters[index]);
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, Routes.detailProduct,
                            arguments: filters[index]),
                        child: productCard(context,
                            cardImage: product.featureImageUrl,
                            title: product.name,
                            description: product.description,
                            price: "${product.currencySign}${product.price}"),
                      );
                    },
                  )
                ],
              )
            : Center(
                child: ProductDetailsPageState()
                    .error404(errorMessage: "Data not found"),
              ),
      ),
    );
  }

  Widget loadShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
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
            placeholderBuilder: (context) => loadShimmer(),
            (productType[index]['image'] ?? ""),
            fit: BoxFit.contain,
          ),
        ),
        Text(
          productType[index]['title'] ?? "",
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
              color: Colors.white,
              child: Image.network(
                cardImage!,
                errorBuilder: (context, error, stackTrace) => Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.error), Text("Error Image")],
                ),
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress != null ? loadShimmer() : child,
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
