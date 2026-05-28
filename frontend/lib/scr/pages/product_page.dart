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
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.brandName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const Text(
              'เลือกสินค้า',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<CounterBloc, CounterState>(
        builder: (context, counterState) {
          return BlocBuilder<ProductBloc, ProductState>(
            builder: (context, productState) {
              if (productState is ProductLoadingState) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.orange,
                        strokeWidth: 2.5,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'กำลังโหลดสินค้า...',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                );
              } else if (productState is ProductLoadedState) {
                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  itemCount: productState.Product.length,
                  itemBuilder: (context, index) {
                    final products = productState.Product[index];
                    final count = counterState.productCounts[products] ?? 0;
                    final bool isSelected = count > 0;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected
                            ? Border.all(
                                color: Colors.orange.withOpacity(0.5),
                                width: 1.5)
                            : Border.all(color: Colors.transparent, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? Colors.orange.withOpacity(0.08)
                                : Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            // Badge + Image
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    products.image,
                                    width: 72,
                                    height: 72,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 72,
                                        height: 72,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          Icons.image_not_supported_outlined,
                                          color: Colors.grey,
                                          size: 28,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                if (isSelected)
                                  Positioned(
                                    top: -6,
                                    right: -6,
                                    child: AnimatedScale(
                                      scale: isSelected ? 1.0 : 0.0,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      child: Container(
                                        width: 22,
                                        height: 22,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                        ),
                                        child: Text(
                                          '$count',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(width: 14),

                            // Name + Price
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    products.name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Text(
                                        '฿',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        products.price.toString(),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Add Button
                            GestureDetector(
                              onTap: () {
                                BlocProvider.of<CounterBloc>(context)
                                    .add(AddProductEvent(products));
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.orange
                                      : Colors.orange.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.add_rounded,
                                  color:
                                      isSelected ? Colors.white : Colors.orange,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
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

      // Bottom Bar
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: BlocBuilder<CounterBloc, CounterState>(
              builder: (context, counterState) {
                final int totalItems = counterState.productCounts.values
                    .fold(0, (sum, count) => sum + count);
                final bool hasItems = totalItems > 0;

                return Row(
                  children: [
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: hasItems
                            ? Row(
                                key: const ValueKey('has_items'),
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '$totalItems ชิ้น',
                                      style: const TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'อยู่ในตะกร้าแล้ว',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              )
                            : const Row(
                                key: ValueKey('empty'),
                                children: [
                                  Icon(Icons.shopping_bag_outlined,
                                      color: Colors.grey, size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    'ตะกร้าว่างเปล่า',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 13),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        final counterBloc =
                            BlocProvider.of<CounterBloc>(context);
                        final productCounts = counterBloc.state.productCounts;
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
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.shopping_cart_outlined,
                                color: Colors.white, size: 20),
                            SizedBox(width: 6),
                            Text(
                              'ตะกร้า',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
