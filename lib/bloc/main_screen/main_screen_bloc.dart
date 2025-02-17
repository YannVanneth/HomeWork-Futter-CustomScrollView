import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreenBloc extends Cubit<int> {
  MainScreenBloc() : super(0);

  void changeIndex(int index) => emit(index);
}
