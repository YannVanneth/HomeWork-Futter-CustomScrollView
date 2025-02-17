abstract class HomeEvent {}

class SelectedProductType extends HomeEvent {
  final String type;
  SelectedProductType(this.type);
}

class UpdateCarouselIndicator extends HomeEvent {
  final int index;
  UpdateCarouselIndicator(this.index);
}

class HomeScreenTabIndex extends HomeEvent {
  final int index;
  HomeScreenTabIndex(this.index);
}
