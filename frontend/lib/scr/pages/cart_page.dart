import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/scr/bloc/count/counter_bloc.dart';
import 'package:shopping/scr/models/product_model.dart';
import 'package:shopping/scr/pages/payment_page.dart';

class CartPage extends StatelessWidget {
  final List<ProductDataModel> productCounts;
  final int totalPrice;

  const CartPage(
      {Key? key, required this.productCounts, required this.totalPrice})
      : super(key: key);

  num calculateTotalPrice(Map<ProductDataModel, int> counts) {
    num total = 0;

    for (var item in productCounts) {
      final qty = counts[item] ?? 0;
      if (qty == 0) continue;

      total += item.price * qty;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterBloc, CounterState>(
      builder: (context, state) {
        final counts = state.productCounts;

        final items = productCounts.where((e) => (counts[e] ?? 0) > 0).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Cart'),
          ),
          body: items.isEmpty
              ? const Center(
                  child: Text(
                    'ไม่มีสินค้าในตระกร้า',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final qty = counts[item] ?? 0;

                    return _CartItem(
                      item: item,
                      qty: qty,
                    );
                  },
                ),
          bottomNavigationBar: _BottomBar(
            total: calculateTotalPrice(counts),
            isEmpty: items.isEmpty,
            onPay: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PaymentPage(
                    productCounts: productCounts,
                    prices: {},
                    calculateTotalPrice: calculateTotalPrice(counts),
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

class _CartItem extends StatelessWidget {
  final ProductDataModel item;
  final int qty;

  const _CartItem({
    required this.item,
    required this.qty,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(
                    '฿${item.price}',
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
            _QtyControl(item: item, qty: qty),
          ],
        ),
      ),
    );
  }
}

class _QtyControl extends StatelessWidget {
  final ProductDataModel item;
  final int qty;

  const _QtyControl({
    required this.item,
    required this.qty,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            context.read<CounterBloc>().add(RemoveProductEvent(item));
          },
          icon: const Icon(Icons.remove),
        ),
        Text(qty.toString()),
        IconButton(
          onPressed: () {
            context.read<CounterBloc>().add(AddProductEvent(item));
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  final num total;
  final bool isEmpty;
  final VoidCallback onPay;

  const _BottomBar({
    required this.total,
    required this.isEmpty,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black12,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'รวม: ฿$total',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: isEmpty ? null : onPay,
              child: const Text('ชำระเงิน'),
            ),
          ],
        ),
      ),
    );
  }
}
