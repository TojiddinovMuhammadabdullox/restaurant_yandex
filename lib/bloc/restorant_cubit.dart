import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_yandex/bloc/restaurant_state.dart';
import 'package:restaurant_yandex/models/restauratn_model.dart';

class RestoranCubit extends Cubit<RestoranState> {
  RestoranCubit() : super(RestoranInitial());

  final List<RestoranModels> restorans = [];

  void addLocation(String title, String point, String locationName) {
    restorans.add(
        RestoranModels(title: title, point: point, locationName: locationName));
    emit(RestoranLoaded(restorans: restorans));
  }
}
