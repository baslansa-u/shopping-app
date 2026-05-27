import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/scr/bloc/product/product_bloc.dart';
import 'package:shopping/scr/bloc/count/counter_bloc.dart';
import 'package:shopping/scr/models/product_model.dart';
import 'package:shopping/scr/pages/cart_page.dart';

class ProductPage extends StatefulWidget {
  final String brandName;

  const ProductPage({Key? key, required this.brandName}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product : ${widget.brandName}'),
        centerTitle: false,
      ),
      body: BlocBuilder<CounterBloc, CounterState>(
        builder: (context, counterState) {
          return BlocBuilder<ProductBloc, ProductState>(
            builder: (context, productState) {
              if (productState is ProductLoadingState) {
                return const Center(
                  child: LinearProgressIndicator(),
                );
              } else if (productState is ProductLoadedState) {
                return ListView.builder(
                  itemCount: productState.Product.length,
                  itemBuilder: (context, index) {
                    final products = productState.Product[index];
                    final count = counterState.productCounts[products] ?? 0;
                    bool isSelected = count > 0;
                    return Center(
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          height: 90,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 26),
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Visibility(
                                  visible: isSelected,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.teal,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      '$count',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  replacement: const SizedBox(
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                                Image.network(
                                  products.image,
                                  width: 100,
                                  height: 100,
                                ),
                              ],
                            ),
                            title: Text(products.name),
                            subtitle:
                                Text('ราคา : ${products.price.toString()}'),
                            // add buttom
                            trailing: GestureDetector(
                              onTap: () {
                                final counterBloc =
                                    BlocProvider.of<CounterBloc>(context);
                                counterBloc.add(AddProductEvent(products));
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.orange,
                                ),
                                child:
                                    const Icon(Icons.add, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return Container();
            },
          );
        },
      ),
      bottomNavigationBar: SizedBox(
        height: 100,
        child: BottomAppBar(
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Center(child: BlocBuilder<CounterBloc, CounterState>(
                  builder: (context, counterState) {
                    //sum of count number
                    int totalItems = counterState.productCounts.values
                        .fold(0, (sum, count) => sum + (count));
                    return Text(
                      counterState.productCounts.isEmpty
                          ? "ไม่มีสินค้าในตระกร้า"
                          : "มีสินค้าในตระกร้า $totalItems ชิ้น",
                      style: TextStyle(
                        fontSize: 16,
                        color: counterState.productCounts.isEmpty
                            ? Colors.red
                            : Colors.green,
                      ),
                    );
                  },
                )),
              ),
              //cart
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.orange,
                  height: kBottomNavigationBarHeight,
                  child: IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: 35.0,
                    ),
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
