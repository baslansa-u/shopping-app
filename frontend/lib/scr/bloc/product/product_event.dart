part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchProductApple extends ProductEvent {}

class FetchProductSamsung extends ProductEvent {}
