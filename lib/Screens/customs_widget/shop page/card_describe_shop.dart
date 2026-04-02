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
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(widget.modelCardShop.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: PageView.builder(
                        itemCount: images.length,
                        onPageChanged: (index) {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Image.network(
                            images[index],
                            fit: BoxFit.contain,
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          "${currentIndex + 1} / ${images.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "JOD ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${widget.modelCardShop.price}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: "LoginSignup",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(
                  widget.modelCardShop.describe,
                  style: const TextStyle(fontSize: 15),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: () =>
                                ShopFirebaseHelper.addToCart(widget.modelCardShop),
                            child: const Text(
                              "Add to cart",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          left: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: StreamBuilder<int>(
                              stream: ShopFirebaseHelper.getProductQuantity(
                                widget.modelCardShop.id!,
                              ),
                              builder: (context, snapshot) {
                                final quantity = snapshot.data ?? 0;
                                return Text(
                                  "$quantity",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: () =>
                          ShopFirebaseHelper.removeOneFromCart(widget.modelCardShop),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.grey,
                        size: 35,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.shopping_cart, color: Colors.blue),
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
                            fontFamily: "LoginSignup",
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}