import '../../models/products.dart';

abstract class DetailScreenEvent {}

class ToggleFavorite extends DetailScreenEvent {
  final bool isFavorite;

  ToggleFavorite(this.isFavorite);
}

class ColorSelected extends DetailScreenEvent {
  final String colorName;

  ColorSelected(this.colorName);
}

class LoadDetailScreen extends DetailScreenEvent {
  final Product product;

  LoadDetailScreen(this.product);
}

class ShowDetailScreen extends DetailScreenEvent {
  final bool isExpanded;
  ShowDetailScreen(this.isExpanded);
}
