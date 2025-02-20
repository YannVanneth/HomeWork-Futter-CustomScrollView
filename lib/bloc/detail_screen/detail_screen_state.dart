import '../../models/products.dart';

class DetailScreenState {
  final bool isExpanded;
  final bool isLoading;
  final bool isFavorite;
  final String selectedColor;
  final Product product;
  final int qty;

  DetailScreenState({
    Product? product,
    this.selectedColor = 'unknown',
    this.isExpanded = false,
    this.isLoading = false,
    this.isFavorite = false,
    this.qty = 1,
  }) : product = product ?? Product();

  DetailScreenState copyWith({
    int? qty,
    Product? product,
    bool? isLoading,
    bool? isFavorite,
    bool? isExpanded,
    String? selectedColor,
  }) {
    return DetailScreenState(
      qty: qty ?? this.qty,
      product: product ?? this.product,
      selectedColor: selectedColor ?? this.selectedColor,
      isExpanded: isExpanded ?? this.isExpanded,
      isLoading: isLoading ?? this.isLoading,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
