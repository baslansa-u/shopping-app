import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/scr/bloc/brands/brands_bloc.dart';
import 'package:shopping/scr/bloc/product/product_bloc.dart';
import 'package:shopping/scr/pages/product_page.dart';
import 'package:shopping/scr/bloc/count/counter_bloc.dart';
import 'package:shopping/scr/pages/cart_page.dart';

class Brand extends StatefulWidget {
  const Brand({Key? key}) : super(key: key);

  @override
  State<Brand> createState() => _BrandState();
}

class _BrandState extends State<Brand> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brand'),
      ),
      body: BlocBuilder<BrandsBloc, BrandsState>(
        builder: (context, state) {
          if (state is BrandsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is BrnadsLoadingSuccessState) {
            final brands = state.brands;

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: brands.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final brand = brands[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    context
                        .read<ProductBloc>()
                        .add(FetchProductsByBrand(brand.name));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductPage(
                          brandName: brand.name,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.network(
                            brand.logo,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            brand.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: BlocBuilder<CounterBloc, CounterState>(
        builder: (context, state) {
          final productCounts = state.productCounts;

          return FloatingActionButton(
            backgroundColor: Colors.orange,
            onPressed: () {
              if (productCounts.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("ไม่มีสินค้าในตะกร้า"),
                  ),
                );
                return;
              }

              final products = productCounts.keys.toList();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CartPage(
                    productCounts: products,
                    totalPrice: 0,
                  ),
                ),
              );
            },
            child: const Icon(Icons.shopping_cart_outlined),
          );
        },
      ),
    );
  }
}
