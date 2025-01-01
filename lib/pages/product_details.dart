import 'package:custom_scroll_view/data/exports.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => ProductDetailsPageState();
}

class ProductDetailsPageState extends State<ProductDetailsPage> {
  var isSelectedColor = "";
  late Map<String, dynamic> item;
  int numberOfItems = 1;

  @override
  Widget build(BuildContext context) {
    var itemData = ModalRoute.of(context)?.settings.arguments as List;

    item = itemData[0] as Map<String, dynamic>;
    var product = Product.fromJson(item);

    if (itemData.length == 2) {
      numberOfItems = itemData[1] as int;
    }

    return Scaffold(
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
          CustomWidgets.productImage(context, product),
          Expanded(child: productDetails(context, product, item)),
        ],
      ),
    );
  }

  Widget productDetails(
      BuildContext context, Product product, Map<String, dynamic> itemdata) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        spacing: 15,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.68,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              Icon(
                Icons.favorite_border,
                size: 28,
                color: Colors.red,
              )
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Color: ${isSelectedColor.isEmpty && product.colors.isEmpty ? "Not found" : isSelectedColor.isEmpty ? "Please select color" : isSelectedColor ?? ""}",
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
                              .split(',')
                              .first
                              .replaceFirst("#", "0xFF");
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                isSelectedColor =
                                    product.colors[index].colorName;
                              });
                            },
                            child: CustomWidgets.colorBox(
                                border: isSelectedColor ==
                                        product.colors[index].colorName
                                    ? true
                                    : false,
                                color: Color(int.parse(color))),
                          );
                        },
                        separatorBuilder: (context, index) => SizedBox(
                              width: 10,
                            ),
                        itemCount: product.colors.length),
                  )
                else
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.3,
                    child: CustomWidgets.itemTags(tagName: "Unknow Color"),
                  )
              ],
            ),
          ),
          CustomWidgets.productTags(product),
          Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Description:",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.start,
              ),
              Text(
                product.description.isNotEmpty
                    ? product.description
                    : "Unknown",
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          CustomWidgets.bottomArea(
              context, item, isSelectedColor, numberOfItems)
        ],
      ),
    );
  }
}
