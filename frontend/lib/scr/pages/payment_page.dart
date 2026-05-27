import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/scr/bloc/count/counter_bloc.dart';
import 'package:shopping/scr/models/product_model.dart';

class PaymentPage extends StatefulWidget {
  final List<ProductDataModel> productCounts;
  final num calculateTotalPrice;
  final Map<ProductDataModel, double> prices;
  const PaymentPage({
    Key? key,
    required this.prices,
    required this.productCounts,
    required this.calculateTotalPrice,
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: false,
      ),
      body: BlocBuilder<CounterBloc, CounterState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 30, bottom: 10),
                child: Center(
                  child: Text(
                    'ชำระเงินสำเร็จ',
                    style: TextStyle(fontSize: 30, color: Colors.green),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.productCounts.length,
                itemBuilder: (context, index) {
                  final item = widget.productCounts[index];
                  return Container(
                    height: 50,
                    // color: Colors.amberAccent,
                    child: ListTile(
                      //contentPadding: EdgeInsets.all(0),
                      //ชื่อสินค้า
                      leading: SizedBox(
                        height: 50,
                        width: 210,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 90, top: 16),
                          child: Text(
                            item.name,
                          ),
                        ),
                      ),
                      //ราคาสินค้า
                      trailing: SizedBox(
                          height: 20,
                          width: 70,
                          child: Text(
                              '${((item.price) * (state.productCounts[item] ?? 0))}')),
                      //จำนวนสินค้า
                      title: Text(
                        '   X ${(state.productCounts[item] ?? 0).toString()}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
              //ราคารวมสินค้า
              Container(
                // color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 280,
                  ),
                  child: Text('รวม        ${widget.calculateTotalPrice}'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
