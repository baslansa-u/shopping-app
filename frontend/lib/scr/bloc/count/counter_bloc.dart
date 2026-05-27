import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:shopping/scr/models/product_model.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc()
      : super(const CounterState(productCounts: {}, productCounts2: {})) {
    on<AddProductEvent>(_onAddProductEvent);
    on<RemoveProductEvent>(_onRemoveProductEvent);
  }

  FutureOr<void> _onAddProductEvent(
      AddProductEvent event, Emitter<CounterState> emit) {
    final productCounts = Map<ProductDataModel, int>.from(state.productCounts);
    productCounts[event.product] = (productCounts[event.product] ?? 0) + 1;

    emit(state.copyWith(productCounts: productCounts));
  }

  FutureOr<void> _onRemoveProductEvent(
      RemoveProductEvent event, Emitter<CounterState> emit) {
    final productCounts = Map<ProductDataModel, int>.from(state.productCounts);
    if ((productCounts[event.product] ?? 0) > 1) {
      productCounts[event.product] = (productCounts[event.product] ?? 0) - 1;
    } else {
      productCounts.remove(event.product);
    }
    emit(state.copyWith(productCounts: productCounts));
  }
}
