import 'package:custom_scroll_view/data/exports.dart';

class CustomWidgets {
  CustomWidgets._();

  static Widget productCard(BuildContext context,
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

  static Widget categoryList({int index = 0, double size = 60}) {
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

  static Widget loadShimmer() {
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

  static Widget productTags(Product product) {
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

  static Widget itemTags(
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

  static Widget colorBox(
      {double size = 50,
      Color color = Colors.amberAccent,
      bool border = false}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: border
            ? Border.all(
                width: 3,
              )
            : null,
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
        color: color,
      ),
    );
  }

  static Widget productImage(BuildContext context, Product product) {
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

  static Widget error404({String errorMessage = "Error Image"}) {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(Icons.error), Text(errorMessage)],
    );
  }

  static Widget bottomArea(BuildContext context, Map<String, dynamic> item,
      String isSelectedColor, int numberOfItems) {
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
            onPressed: () {
              if (isSelectedColor.isNotEmpty ||
                  Product.fromJson(item).colors.isEmpty) {
                Navigator.pushNamed(context, Routes.buyNowPage,
                    arguments: [item, isSelectedColor, numberOfItems]);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Row(
                    spacing: 10,
                    children: [
                      Icon(
                        Icons.error,
                        color: Colors.white,
                      ),
                      Text("Please select color",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ],
                  ),
                  shape: RoundedRectangleBorder(),
                ));
              }
            },
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(),
              backgroundColor: Colors.black,
            ),
            child: Text(
              "Buy Now",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  static Future inputField(BuildContext context,
      {String title = "Contact Number",
      String hintText = "Enter your contact number",
      Icon prefixIcon = const Icon(Icons.phone),
      TextInputType typeInput = TextInputType.text}) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      context: context,
      builder: (context) => Container(
        height: MediaQuery.sizeOf(context).height * 0.25,
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 10,
              children: [
                prefixIcon,
                Text(title.toUpperCase(),
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            TextField(
              keyboardType: typeInput,
              decoration: InputDecoration(
                hintText: hintText,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2)),
                    backgroundColor: Colors.black),
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static Widget bottomNavigationBar(int index, Function(int) value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: BottomNavigationBar(
        currentIndex: index,
        onTap: value,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Wishlist"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
