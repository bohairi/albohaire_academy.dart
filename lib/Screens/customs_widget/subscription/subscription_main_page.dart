import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/card_describe_shop.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/model_card_shop.dart';
import 'package:flutter/material.dart';

class SubscriptionMainPage extends StatelessWidget {
  SubscriptionMainPage({super.key});
  List <ModelCardShop> paidProduct = cards.where((c) => c.quantity > 0).toList();

  
  @override
  Widget build(BuildContext context) {
    productListTile(ModelCardShop model_card_shop){
    return InkWell(
      onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder:(_)=> CardDescribeShop(modelCardShop: model_card_shop))),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(15)
        ),
        child: ListTile(
          leading: Image.asset(model_card_shop.urlImage,width: MediaQuery.of(context).size.width * 0.2,),
          title: Text(model_card_shop.title,style: TextStyle(fontWeight: FontWeight.bold),),
          trailing: Text("${model_card_shop.quantity}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
        ),
      ),
    );
  }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text("JOD ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                Text(getTotalBill().toStringAsFixed(2),style: TextStyle(fontSize: 25,fontFamily:"LoginSignup",fontWeight: FontWeight.bold),)
                ],
              ),
              Icon(Icons.shopping_cart,size: 50,color: Colors.blue,),
              SizedBox(height: 10,),
              paidProduct.isEmpty? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 35,),
              Icon(Icons.hourglass_disabled, size: 150, color: Colors.grey,),
              SizedBox(height: 10,),
              Text("There is no product"),
              SizedBox(height: 10,)
            ],
          ) : ListView.builder(shrinkWrap: true,physics:const NeverScrollableScrollPhysics(),itemCount: paidProduct.length,itemBuilder: (context,index){
            
            return Column(
              children: [
                productListTile(paidProduct[index]),
              ],
            );
          }),
              SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () {
                    },
                    child: Text("Payment Now", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
               SizedBox(height: 10),
                
                Text("Payment is supported via :"),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.credit_card, size: 30, color: Colors.grey),
                    SizedBox(width: 15),
                    Text("Zain Cash / Umniah Coin / Visa", style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
                SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
