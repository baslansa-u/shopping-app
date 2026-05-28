import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/scr/bloc/count/counter_bloc.dart';
import 'package:shopping/scr/models/product_model.dart';

class PaymentPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: BlocBuilder<CounterBloc, CounterState>(
        builder: (context, state) {
          final counts = state.productCounts;

          return Column(
            children: [
              const SizedBox(height: 20),
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 70,
              ),
              const SizedBox(height: 10),
              const Text(
                'ชำระเงินสำเร็จ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: productCounts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = productCounts[index];
                    final qty = counts[item] ?? 0;

                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              'x$qty',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '฿${item.price * qty}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'รวมทั้งหมด',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '฿$calculateTotalPrice',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
