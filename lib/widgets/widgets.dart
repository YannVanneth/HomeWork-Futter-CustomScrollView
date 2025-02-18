import 'package:custom_scroll_view/data/exports.dart';
import 'package:custom_scroll_view/models/detail_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static Widget bottomArea(
      BuildContext context, Product item, String isSelectedColor) {
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
              if (isSelectedColor.isNotEmpty || item.colors.isEmpty) {
                Navigator.pushNamed(context, Routes.buyNowPage,
                    arguments: DetailProduct(
                        name: item.name,
                        image: item.featureImageUrl,
                        price: double.parse(item.price),
                        currency: item.currencySign,
                        quantity: 0));
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
      TextInputType typeInput = TextInputType.text,
      Key? key,
      Function(String)? function,
      TextEditingController? controller}) {
    var ctr = TextEditingController();
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
            left: 10,
            right: 10,
            top: 20),
        child: Form(
          key: key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Row
              Row(
                children: [
                  prefixIcon,
                  const SizedBox(width: 10),
                  Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Input Field
              TextFormField(
                validator: (value) {
                  if (function != null) {
                    function;
                  }
                },
                autofocus: true,
                controller: controller ?? ctr,
                keyboardType: typeInput,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, ctr.text);
                  }, // Close the bottom sheet
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
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

  static dynamic showMessageSnakeBar(
      {required String message,
      required BuildContext context,
      Color? backgroundColor}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: backgroundColor ?? Colors.blue,
    ));
  }

  static Future<void> favoriteToggle(List<String> isWish) async {
    var pref = await SharedPreferences.getInstance();

    pref.setStringList('isWish', isWish);
  }

  static Future<List<String>> getfavoriteToggle() async {
    var pref = await SharedPreferences.getInstance();
    return pref.getStringList('isWish') ?? [];
  }
}
