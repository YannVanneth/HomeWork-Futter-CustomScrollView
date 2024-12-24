import 'package:custom_scroll_view/data/exports.dart';

class CustomWidgets {
  const CustomWidgets();

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

  Widget bottomArea(BuildContext context, Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.60,
          child: OutlinedButton(
            onPressed: () => Navigator.pushNamed(context, Routes.buyNowPage,
                arguments: product),
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
            onPressed: () => Navigator.pushNamed(context, Routes.buyNowPage,
                arguments: product),
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
}
