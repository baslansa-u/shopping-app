part of 'brands_bloc.dart';

abstract class BrandsState {}

class BrandsInitial extends BrandsState {}

//Successs
class BrnadsLoadingSuccessState extends BrandsState {
  final List<BransDataModel> brands;

  BrnadsLoadingSuccessState({required this.brands});
}

//Loading
class BrandsLoadingState extends BrandsState {}

//Failure
class BrandsLoadingFailure extends BrandsState {
  final String error;
  BrandsLoadingFailure({required this.error});
}
