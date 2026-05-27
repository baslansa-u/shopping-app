import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping/scr/models/brands_model.dart';
import 'package:shopping/scr/services/brands_service.dart';

part 'brands_event.dart';
part 'brands_state.dart';

class BrandsBloc extends Bloc<BrandsEvent, BrandsState> {
  BrandsBloc() : super(BrandsInitial()) {
    on<BrandsInitialFetcth>(_BrandsInitialFetch);
  }

  FutureOr<void> _BrandsInitialFetch(
      BrandsInitialFetcth event, Emitter<BrandsState> emit) async {
    emit(BrandsLoadingState());
    try {
      List<BransDataModel> brands = await BrandServices.fetchData();
      emit(BrnadsLoadingSuccessState(brands: brands));
    } catch (e) {
      emit(BrandsLoadingFailure(error: e.toString()));
    }
  }
}
