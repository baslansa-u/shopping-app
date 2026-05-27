part of 'product_bloc.dart';

abstract class ProductState {
  // const ProductState();
  // @override
  // List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductLoadedState extends ProductState {
  final List<ProductDataModel> Product;

  ProductState copyWith() {
    return ProductLoadedState(Product: Product);
  }

  ProductLoadedState({required this.Product});
}

class ProductLoadedFailState extends ProductState {
  final String error;

  ProductLoadedFailState({required this.error});
}
