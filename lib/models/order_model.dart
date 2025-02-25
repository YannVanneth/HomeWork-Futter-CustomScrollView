class OrderModel {
  late int id;
  late int userId;
  late String invoiceId;
  late String orderDate;
  late String status;

  OrderModel.fromJSON(Map<String, dynamic> json) {
    id = json['id'] ?? 1;
    userId = json['user_id'] ?? 1;
    invoiceId = json['invoice_id'] ?? "404";
    orderDate = json['date'] ?? "404";
    status = json['status'] ?? "404";
  }
}

class OrderDetailsModel {
  late int userId;
  late String invoiceId;
  late String productName;
  late String description;
  late double price;
  late String currency;
  late String imageUrl;
  late String priceSign;
  late String selectedColor;
  late int quantity;
  late String address;

  OrderDetailsModel.fromJSON(Map<String, dynamic> json) {
    userId = json['user_id'] ?? 1;
    invoiceId = json['invoice_id'] ?? "404";
    productName = json['product_name'] ?? "404";
    description = json['description'] ?? "404";
    price = json['price'] ?? 1;
    currency = json['currency'] ?? "404";
    imageUrl = json['image_url'] ?? "404";
    priceSign = json['price_sign'] ?? "404";
    selectedColor = json['selected_color'] ?? "404";
    quantity = json['quantity'] ?? 1;
    address = json['address'] ?? "404";
  }
}
