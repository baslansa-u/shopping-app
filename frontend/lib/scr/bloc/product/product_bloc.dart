import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping/scr/models/product_model.dart';
import 'package:shopping/scr/services/brands_service.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<FetchProductApple>((event, emit) async {
      emit(ProductLoadingState());
      try {
        final apple = await BrandAppleServices.fetchData();
        emit(ProductLoadedState(Product: apple));
      } catch (e) {
        emit(ProductLoadedFailState(error: 'Failed to fetch Apple products'));
      }
    });
    on<FetchProductSamsung>((event, emit) async {
      emit(ProductLoadingState());
      try {
        final samsung = await BrandSamsungServices.fetchData();
        emit(ProductLoadedState(Product: samsung));
      } catch (e) {
        emit(ProductLoadedFailState(error: 'Failed to fetch samsung products'));
      }
    });
    on<FetchProductsByBrand>((event, emit) async {
      emit(ProductLoadingState());
      try {
        List<ProductDataModel> products = [];
        if (event.brandName.toLowerCase() == 'apple') {
          products = await BrandAppleServices.fetchData();
        } else if (event.brandName.toLowerCase() == 'samsung') {
          products = await BrandSamsungServices.fetchData();
        }
        emit(ProductLoadedState(Product: products));
      } catch (e) {
        emit(ProductLoadedFailState(
            error: 'Failed to fetch products for ${event.brandName}'));
      }
    });
  }
}
