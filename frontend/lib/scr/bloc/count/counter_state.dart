part of 'counter_bloc.dart';

class CounterState {
  final Map<ProductDataModel, int> productCounts;

  //netx solution
  final Map<int, int> productCounts2;

  const CounterState(
      {required this.productCounts, required this.productCounts2});

  @override
  List<Object?> get props => [productCounts, productCounts2];

  CounterState copyWith(
      {Map<ProductDataModel, int>? productCounts,
      Map<int, int>? productCounts2}) {
    return CounterState(
      productCounts: productCounts ?? this.productCounts,
      productCounts2: productCounts2 ?? this.productCounts2,
    );
  }
}
