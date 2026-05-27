import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/scr/bloc/count/counter_bloc.dart';
import 'package:shopping/scr/models/product_model.dart';
import 'package:shopping/scr/pages/payment_page.dart';

class CartPage extends StatefulWidget {
  final List<ProductDataModel> productCounts;
  final int totalPrice;

  const CartPage(
      {Key? key, required this.productCounts, required this.totalPrice})
      : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Map<ProductDataModel, double> prices = {};

//คำนวณ
  num calculateTotalPrice() {
    num total = 0;
    for (var item in widget.productCounts) {
      total += (prices[item] ?? item.price) *
          (BlocProvider.of<CounterBloc>(context).state.productCounts[item] ??
              0);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterBloc, CounterState>(
      builder: (context, state) {
        // ตรวจสอบสถานะ isEmpty เพื่ออัพเดต UI
        if (widget.productCounts.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Cart'),
              centerTitle: false,
            ),
            body: const Center(
              child: Text(
                'ไม่มีสินค้าในตระกร้า',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
            bottomNavigationBar: BlocBuilder<CounterBloc, CounterState>(
              builder: (context, index) {
                return BottomAppBar(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            color: Colors.white,
                            child: Text(
                              '    ชำระเงินทั้งหมด ${calculateTotalPrice()} บาท',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.green),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            color: widget.productCounts.isEmpty
                                ? Colors.grey
                                : Colors.blue,
                            height: kBottomNavigationBarHeight,
                            child: widget.productCounts.isEmpty
                                ? const IconButton(
                                    onPressed: null, // คลิกไม่ได้ = null
                                    icon: Icon(
                                      Icons.monetization_on,
                                      color: Colors.white,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PaymentPage(
                                            productCounts: widget.productCounts,
                                            prices: prices,
                                            calculateTotalPrice:
                                                calculateTotalPrice(),
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.monetization_on,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        // ลบสินค้าจากรายการเมื่อ productCount เป็น 0
        widget.productCounts
            .removeWhere((item) => (state.productCounts[item] ?? 0) == 0);
        print('${state.productCounts}');
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cart'),
            centerTitle: false,
          ),
          body: widget.productCounts.isEmpty
              ? const Center(
                  child: Text(
                    'ไม่มีสินค้าในตระกร้า',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                )
              : ListView.builder(
                  itemCount: widget.productCounts.length,
                  itemBuilder: (context, index) {
                    final item = widget.productCounts[index];
                    return Center(
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 26),
                            leading: Image.network(item.image),
                            title: Text(item.name),
                            subtitle: Text(
                              'ราคา: ${((prices[item] ?? item.price) * 1)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      //remove
                                      Container(
                                        height: 35,
                                        width: 35,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            BlocProvider.of<CounterBloc>(
                                                    context)
                                                .add(RemoveProductEvent(item));
                                          },
                                          icon: const Icon(
                                            Icons.remove,
                                            color: Colors.black,
                                          ),
                                        ),
                                        color: Colors.grey,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: BlocBuilder<CounterBloc,
                                            CounterState>(
                                          builder: (context, state) {
                                            return Text(
                                                (state.productCounts[item] ?? 0)
                                                    .toString());
                                          },
                                        ),
                                      ),
                                      //add
                                      Container(
                                        height: 35,
                                        width: 35,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            BlocProvider.of<CounterBloc>(
                                                    context)
                                                .add(AddProductEvent(item));
                                          },
                                          icon: const Icon(
                                            Icons.add,
                                            color: Colors.black,
                                          ),
                                        ),
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
          bottomNavigationBar: BlocBuilder<CounterBloc, CounterState>(
            builder: (context, index) {
              return BottomAppBar(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          color: Colors.white,
                          child: Text(
                            '    ชำระเงินทั้งหมด ${calculateTotalPrice()} บาท',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.green),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          color: widget.productCounts.isEmpty
                              ? Colors.grey
                              : Colors.blue,
                          height: kBottomNavigationBarHeight,
                          child: widget.productCounts.isEmpty
                              ? const IconButton(
                                  onPressed: null, // คลิกไม่ได้ = null
                                  icon: Icon(
                                    Icons.monetization_on,
                                    color: Colors.white,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PaymentPage(
                                          productCounts: widget.productCounts,
                                          prices: prices,
                                          calculateTotalPrice:
                                              calculateTotalPrice(),
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.monetization_on,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
