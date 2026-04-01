import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/model_card_shop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowProducts extends StatefulWidget {
  const ShowProducts({super.key});

  @override
  State<ShowProducts> createState() => _ShowProductsState();
}
// assets/images/belts.jpeg
class _ShowProductsState extends State<ShowProducts> {
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Show Products",style: TextStyle(color: Colors.white),),backgroundColor: Colors.blue,
      centerTitle: true,iconTheme: IconThemeData(color: Colors.white),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(stream: FirebaseFirestore.instance.collection("products").snapshots(), builder: (context,productSnapshot){
          if(productSnapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          else if(!productSnapshot.hasData || productSnapshot.data!.docs.isEmpty){
            return Center(child: Text("There is no Products"),);
          }
          final products = productSnapshot.data!.docs.map((doc) => ModelCardShop.fromMap(doc.data(), doc.id)).toList();
          return ListView.builder(itemCount: products.length,itemBuilder: (context,index){
            return productCard(products[index], IconButton(onPressed: (){
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: Text("Edit Product"),
                  content: SizedBox(
                    height: MediaQuery.of(context).size.height *0.2,
                    child: Column(
                      children: [
                        TextField(
                          controller: name,
                          decoration: InputDecoration(
                            label: Text("Name: "),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)
                            )
                          ),
                        ),
                        SizedBox(height: 15,),
                        TextField(
                          controller: price,
                          decoration: InputDecoration(
                            label: Text("Price: "),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)
                            )
                          ),
                        )
                      ],
                    ),
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                          name.clear();
                          price.clear();
                        }, child: Text("CANCEL")),
                        TextButton(onPressed: (){
                          FirebaseFirestore.instance.collection("products").doc(products[index].id).update({"name": name.text,"price" : double.parse(price.text)});
                          Navigator.pop(context);
                          name.clear();
                          price.clear();
                        }, child: Text("EDIT")),
                      ],
                    )
                  ],
                );
              });
              
            }, icon: Icon(Icons.edit)), 
            IconButton(onPressed: (){
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: Text("Delete Product"),
                  content: Text("Are you Sure ?"),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                        }, child: Text("CANCEL")),
                        TextButton(onPressed: (){
                          FirebaseFirestore.instance.collection("products").doc(products[index].id).delete();
                          Navigator.pop(context);
                        }, child: Text("YES")),
                      ],
                    )
                  ],
                );
              });
            }, icon: Icon(Icons.delete)));
          });
        }),
      ),
    );
  }
  Widget productCard(ModelCardShop card,Widget edit, Widget delete){
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      width: double.infinity,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(width: 15,),
                Image.network(card.urlImage,width: 60,height: 60,fit: BoxFit.fill,),
                SizedBox(width: 15,),
                Text(card.title),
                SizedBox(width: 15,),
                Text("${card.price}")
              ],
            ),
            Row(
              children: [
                edit,delete
              ],
            )
          ],
        ),
      ),
    );
  }
}