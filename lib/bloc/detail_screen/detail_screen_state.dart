class DetailScreenState {
  final bool isExpanded;
  final bool isLoading;
  final bool isFavorite;
  final String selectedColor;

  DetailScreenState({
    this.selectedColor = 'unknown',
    this.isExpanded = false,
    this.isLoading = false,
    this.isFavorite = false,
  });

  DetailScreenState copyWith({
    bool? isLoading,
    bool? isFavorite,
    bool? isExpanded,
    String? selectedColor,
  }) {
    return DetailScreenState(
      selectedColor: selectedColor ?? this.selectedColor,
      isExpanded: isExpanded ?? this.isExpanded,
      isLoading: isLoading ?? this.isLoading,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
