import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/model_card_shop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowProducts extends StatefulWidget {
  const ShowProducts({super.key});

  @override
  State<ShowProducts> createState() => _ShowProductsState();
}

class _ShowProductsState extends State<ShowProducts> {
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController describe = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Show Products",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("products").snapshots(),
          builder: (context, productSnapshot) {
            if (productSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!productSnapshot.hasData || productSnapshot.data!.docs.isEmpty) {
              return const Center(child: Text("There is no Products"));
            }

            final products = productSnapshot.data!.docs
                .map((doc) => ModelCardShop.fromMap(doc.data(), doc.id))
                .toList();

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return productCard(
                  products[index],
                  IconButton(
                    onPressed: () {
                      name.text = products[index].title;
                      price.text = products[index].price.toString();
                      describe.text = products[index].describe;

                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Edit Product"),
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  TextField(
                                    controller: name,
                                    decoration: InputDecoration(
                                      labelText: "Name",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  TextField(
                                    controller: price,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "Price",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  TextField(
                                    controller: describe,
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      labelText: "Description",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  name.clear();
                                  price.clear();
                                  describe.clear();
                                },
                                child: const Text("CANCEL"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection("products")
                                      .doc(products[index].id)
                                      .update({
                                    "name": name.text.trim(),
                                    "price": double.parse(price.text.trim()),
                                    "describe": describe.text.trim(),
                                  });

                                  Navigator.pop(context);
                                  name.clear();
                                  price.clear();
                                  describe.clear();
                                },
                                child: const Text("EDIT"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Delete Product"),
                            content: const Text("Are you sure?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("CANCEL"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection("products")
                                      .doc(products[index].id)
                                      .delete();
                                  Navigator.pop(context);
                                },
                                child: const Text("YES"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.delete),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget productCard(ModelCardShop card, Widget edit, Widget delete) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(width: 15),
                Image.network(card.urlImage, width: 60, height: 60, fit: BoxFit.cover),
                const SizedBox(width: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(card.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("JOD ${card.price}"),
                    Text("${card.images.length} images"),
                  ],
                ),
              ],
            ),
            Row(children: [edit, delete]),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    name.dispose();
    price.dispose();
    describe.dispose();
    super.dispose();
  }
}