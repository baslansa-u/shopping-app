part of 'counter_bloc.dart';

class CounterEvent {}

class AddProductEvent extends CounterEvent {
  final ProductDataModel product;

  AddProductEvent(this.product);

  @override
  List<Object> get props => [product];
}

class RemoveProductEvent extends CounterEvent {
  final ProductDataModel product;

  RemoveProductEvent(this.product);
}

class UpdateProductCountsEvent extends CounterEvent {
  final Map<ProductDataModel, int> productCounts;

  UpdateProductCountsEvent(this.productCounts);
}
