import 'package:custom_scroll_view/data/exports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// event
abstract class MainScreenEvent {}

class ChangeIndexEvent extends MainScreenEvent {
  final int index;
  ChangeIndexEvent(this.index);
}

class SearchEvent extends MainScreenEvent {
  final String search;
  SearchEvent(this.search);
}

class SearchItemsUpdate extends MainScreenEvent {
  final List<Product> product = const [];
  // SearchItemsUpdate();
}

class OnloadedScreen extends MainScreenEvent {
  final List<Product> product = const [];
}
// state

class MainScreenState {
  final int index;
  final String query;
  final List<Product> products;
  MainScreenState(this.index, this.query, this.products);

  MainScreenState copyWith({
    int? index,
    String? query,
    List<Product>? products,
  }) {
    return MainScreenState(
      index ?? this.index,
      query ?? this.query,
      products ?? this.products,
    );
  }
}

// bloc
class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  MainScreenBloc() : super(MainScreenState(0, "", const [])) {
    on<ChangeIndexEvent>(
      (event, emit) {
        emit(state.copyWith(index: event.index));
      },
    );
    on<SearchEvent>(
      (event, emit) {
        emit(state.copyWith(query: event.search));
      },
    );

    on<OnloadedScreen>(
      (event, emit) {
        emit(state.copyWith(
            products: products
                .map(
                  (e) => Product.fromJson(e),
                )
                .toList()));
      },
    );

    on<SearchItemsUpdate>(
      (event, emit) {
        var items = state.query.isEmpty
            ? products
                .map(
                  (e) => Product.fromJson(e),
                )
                .toList()
            : products
                .where((element) => element['name']
                    .toString()
                    .startsWith(state.query.characters.first.toUpperCase()))
                .map(
                  (e) => Product.fromJson(e),
                )
                .toList();

        emit(state.copyWith(products: items));
      },
    );
  }
}
