import 'package:custom_scroll_view/bloc/detail_screen/detail_screen_event.dart';
import 'package:custom_scroll_view/bloc/detail_screen/detail_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailScreenBloc extends Bloc<DetailScreenEvent, DetailScreenState> {
  DetailScreenBloc()
      : super(DetailScreenState(
          isExpanded: false,
          isLoading: false,
          isFavorite: false,
          selectedColor: 'unknown',
        )) {
    on<ToggleFavorite>(
      (event, emit) {
        emit(state.copyWith(isFavorite: event.isFavorite));
      },
    );

    on<ColorSelected>(
      (event, emit) {
        emit(state.copyWith(selectedColor: event.colorName));
      },
    );

    on<ShowDetailScreen>(
      (event, emit) {
        emit(state.copyWith(isExpanded: event.isExpanded));
      },
    );

    on<LoadDetailScreen>(
      (event, emit) {
        emit(state.copyWith(product: event.product));
      },
    );
  }
}
