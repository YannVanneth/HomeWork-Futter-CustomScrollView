class HomeState {
  final String selectedType;
  final List<Map<String, dynamic>> filteredProducts;
  final int carouselIndicator;

  HomeState({
    required this.selectedType,
    required this.filteredProducts,
    required this.carouselIndicator,
  });

  HomeState copyWith({
    String? selectedType,
    List<Map<String, dynamic>>? filteredProducts,
    int? carouselIndicator,
  }) {
    return HomeState(
      selectedType: selectedType ?? this.selectedType,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      carouselIndicator: carouselIndicator ?? this.carouselIndicator,
    );
  }
}
