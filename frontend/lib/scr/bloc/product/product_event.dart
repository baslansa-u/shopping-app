part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchProductApple extends ProductEvent {}

class FetchProductSamsung extends ProductEvent {}

class FetchProductsByBrand extends ProductEvent {
  final String brandName;

  const FetchProductsByBrand(this.brandName);

  @override
  List<Object> get props => [brandName];
}
