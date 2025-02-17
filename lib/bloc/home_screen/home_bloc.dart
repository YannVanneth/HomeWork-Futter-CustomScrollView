import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../../data/exports.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  static List<Map<String, dynamic>> _filterProducts(String type) {
    return products
        .where((product) => product['product_type'] == type.toLowerCase())
        .toList();
  }

  HomeBloc()
      : super(HomeState(
          selectedType: productType[0]['title']!,
          filteredProducts: _filterProducts(productType[0]['title']!),
          carouselIndicator: 0,
        )) {
    on<SelectedProductType>(
      (event, emit) {
        emit(state.copyWith(
            selectedType: event.type,
            filteredProducts: _filterProducts(event.type)));
      },
    );

    on<UpdateCarouselIndicator>(
      (event, emit) {
        emit(state.copyWith(carouselIndicator: event.index));
      },
    );
  }
}
