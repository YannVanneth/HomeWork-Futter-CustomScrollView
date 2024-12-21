import 'package:custom_scroll_view/data/exports.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => ProductDetailsPageState();
}

class ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var itemData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    var product = Product.fromJson(itemData);

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
          productImage(context, product),
          Expanded(child: productDetails(context, product, itemData)),
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
                  "Color: ",
                  style: TextStyle(fontSize: 18),
                ),
                if (product.colors.isNotEmpty)
                  SizedBox(
                    height: 50,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var color = product.colors[index].name
                              .replaceFirst("#", "0xFF")
                              .split(',')
                              .first
                              .replaceFirst("#", "0xFF");
                          return colorBox(color: Color(int.parse(color)));
                        },
                        separatorBuilder: (context, index) => SizedBox(
                              width: 10,
                            ),
                        itemCount: product.colors.length),
                  )
                else
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.3,
                    child: itemTags(tagName: "Unknow Color"),
                  )
              ],
            ),
          ),
          productTags(product),
          Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Description:", style: TextStyle(fontSize: 18)),
              Text(
                product.description.isNotEmpty
                    ? product.description
                    : "Unknown",
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          bottomArea(context),
        ],
      ),
    );
  }

  Widget bottomArea(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.60,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(),
              backgroundColor: Colors.white,
            ),
            child: Text(
              "Add to cart",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.30,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(),
              backgroundColor: Colors.black,
            ),
            child: Text(
              "Add to cart",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  Widget productTags(Product product) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Tags", style: TextStyle(fontSize: 18)),
        SizedBox(
          height: 35,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                var tag = product.tagName;

                return tag.isNotEmpty
                    ? itemTags(tagName: tag[index], backgroundColor: Colors.red)
                    : itemTags(tagName: "Unknown");
              },
              separatorBuilder: (context, index) => SizedBox(
                    width: 8,
                  ),
              itemCount:
                  product.tagName.isNotEmpty ? product.tagName.length : 1),
        )
      ],
    );
  }

  Widget itemTags(
      {String tagName = "Tag",
      Color backgroundColor = Colors.grey,
      Color foregroundColor = Colors.white}) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Center(
        child: Text(
          tagName,
          style: TextStyle(fontWeight: FontWeight.bold, color: foregroundColor),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget colorBox({double size = 50, Color color = Colors.amberAccent}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
        color: color,
      ),
    );
  }

  Widget productImage(BuildContext context, Product product) {
    return Container(
      color: Colors.white,
      height: MediaQuery.sizeOf(context).height * 0.30,
      width: double.infinity,
      child: Image.network(
        product.featureImageUrl,
        errorBuilder: (context, error, stackTrace) => error404(),
      ),
    );
  }

  Widget error404({String errorMessage = "Error Image"}) {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(Icons.error), Text(errorMessage)],
    );
  }
}
