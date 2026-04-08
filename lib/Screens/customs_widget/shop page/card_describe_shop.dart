import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/model_card_shop.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/shop_firebase_helper.dart';
import 'package:flutter/material.dart';

class CardDescribeShop extends StatefulWidget {
  final ModelCardShop modelCardShop;

  const CardDescribeShop({
    super.key,
    required this.modelCardShop,
  });

  @override
  State<CardDescribeShop> createState() => _CardDescribeShopState();
}

class _CardDescribeShopState extends State<CardDescribeShop> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.modelCardShop.images.isNotEmpty
        ? widget.modelCardShop.images
        : [widget.modelCardShop.urlImage];

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff1565C0),
        title: Text(widget.modelCardShop.title),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 🔥 Image Slider
            Stack(
              children: [
                Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff1565C0),
                        Color(0xff42A5F5),
                      ],
                    ),
                  ),
                  child: PageView.builder(
                    itemCount: images.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            images[index],
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// indicator
                Positioned(
                  bottom: 15,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${currentIndex + 1}/${images.length}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            /// 🔥 Details Card
            Container(
              margin: const EdgeInsets.all(14),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Price
                  Row(
                    children: [
                      const Text(
                        "JOD ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "${widget.modelCardShop.price}",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1565C0),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// Description
                  Text(
                    widget.modelCardShop.describe,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Color(0xff374151),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            backgroundColor: const Color(0xff1565C0),
                            elevation: 4,
                          ),
                          onPressed: () =>
                              ShopFirebaseHelper.addToCart(widget.modelCardShop),
                          child: const Text(
                            "Add to Cart",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () => ShopFirebaseHelper.removeOneFromCart(
                              widget.modelCardShop),
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// Quantity Badge
                  Row(
                    children: [
                      const Icon(Icons.shopping_cart,
                          color: Color(0xff1565C0)),
                      const SizedBox(width: 6),
                      StreamBuilder<int>(
                        stream: ShopFirebaseHelper.getProductQuantity(
                          widget.modelCardShop.id!,
                        ),
                        builder: (context, snapshot) {
                          final quantity = snapshot.data ?? 0;
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xff1565C0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "$quantity in cart",
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// Total
                  Row(
                    children: [
                      const Text(
                        "Total: ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        "JOD ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      StreamBuilder<double>(
                        stream: ShopFirebaseHelper.getTotalBill(),
                        builder: (context, snapshot) {
                          final total = snapshot.data ?? 0.0;
                          return Text(
                            total.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1565C0),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}