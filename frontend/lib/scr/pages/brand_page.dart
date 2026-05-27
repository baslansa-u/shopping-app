import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/scr/bloc/count/counter_bloc.dart';
import 'package:shopping/scr/bloc/product/product_bloc.dart';
import 'package:shopping/scr/bloc/brands/brands_bloc.dart';
import 'package:shopping/scr/models/product_model.dart';
import 'package:shopping/scr/pages/cart_page.dart';
import 'package:shopping/scr/pages/product_page.dart';

class Brand extends StatefulWidget {
  const Brand({Key? key}) : super(key: key);

  @override
  State<Brand> createState() => _BrandState();
}

class _BrandState extends State<Brand> {
  final BrandsBloc brandsBloc = BrandsBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Brand'),
          ],
        ),
      ),
      body: BlocBuilder<BrandsBloc, BrandsState>(builder: (context, state) {
        if (state is BrandsLoadingState) {
          return const Column(
            children: [
              (LinearProgressIndicator()),
              Text(
                'Loading...',
                style: TextStyle(color: Colors.blue),
              ),
            ],
          );
        } else if (state is BrnadsLoadingSuccessState) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.brands.length,
            itemBuilder: (context, index) {
              final brand = state.brands[index];
              return Center(
                child: Card(
                  color: Colors.blue,
                  margin: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        horizontalTitleGap: 30,
                        minVerticalPadding: 10,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        leading: Container(
                          width: 50,
                          height: 50,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.network(
                            brand.logo,
                            fit: BoxFit.contain,
                          ),
                        ),
                        title: Text(
                          brand.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          if (brand.name == 'Apple') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => ProductBloc()
                                    ..add(
                                      FetchProductApple(),
                                    ),
                                  child: const ProductPage(brandName: 'Apple'),
                                ),
                              ),
                            );
                          } else if (brand.name == 'Samsung') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => ProductBloc()
                                    ..add(
                                      FetchProductSamsung(),
                                    ),
                                  child:
                                      const ProductPage(brandName: 'Samsung'),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Container();
        }
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          final counterBloc = BlocProvider.of<CounterBloc>(context);
          final productCounts = counterBloc.state.productCounts;
          // ignore: unnecessary_null_comparison
          if (productCounts != null) {
            final List<ProductDataModel> brandDataModels =
                productCounts.keys.toList();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartPage(
                  productCounts: brandDataModels,
                  totalPrice: 0,
                ),
              ),
            );
          } else {}
        },
        child: const Icon(Icons.shopping_cart_outlined),
      ),
    );
  }
}
