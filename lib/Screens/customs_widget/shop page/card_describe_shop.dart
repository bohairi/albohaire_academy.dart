import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/model_card_shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CardDescribeShop extends StatefulWidget {
  ModelCardShop modelCardShop;
  CardDescribeShop({super.key, required this.modelCardShop});

  @override
  State<CardDescribeShop> createState() => _CardDescribeShopState();
}
int _currentIndex = 0;
class _CardDescribeShopState extends State<CardDescribeShop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(),
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
              itemCount: widget.modelCardShop.images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index; 
                });
              },
              itemBuilder: (context, index) {
                return Image.asset(
                  widget.modelCardShop.images[index],
                  fit: BoxFit.contain,
                );
              },
            ),
                ),
                
                Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "${_currentIndex + 1} / ${widget.modelCardShop.images.length}",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                               Text("JOD ",style: TextStyle(fontWeight: FontWeight.bold),),
                               Text("${widget.modelCardShop.price}",style: TextStyle(fontSize: 20,fontFamily:"LoginSignup",fontWeight: FontWeight.bold),)
                            ],
                          ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
            Text(widget.modelCardShop.describe,style: TextStyle(fontSize: 15),),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Stack(
                children:[ SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)
                    )
                  ),
                  
                  onPressed: (){
                    setState(() {
                      myCart.add(widget.modelCardShop);
                      widget.modelCardShop.quantity += 1;
                    });
                  },
                  onLongPress: () => setState(() {
                    myCart.add(widget.modelCardShop);
                      widget.modelCardShop.quantity += 1;
                  }),
                   child: Text("Add to cart", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),)),
                  ),
                  Positioned(
                    top: 1.5,
                    left: 2,
                    child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Text("${widget.modelCardShop.quantity}",style: TextStyle(color: Colors.white, fontSize: 12),),
                    ),
                  )
                            
                ]
              ),
            SizedBox(width: 20,),
            InkWell(
              onTap: () => setState(() {
                if (myCart.isNotEmpty) {
                myCart.remove(widget.modelCardShop);   
              } 
              if(widget.modelCardShop.quantity>0){
                widget.modelCardShop.quantity -= 1;
              }
              }),
              onLongPress: () => setState(() {
                if (myCart.isNotEmpty) {
                myCart.remove(widget.modelCardShop);   
              } 
              if(widget.modelCardShop.quantity>0){
                widget.modelCardShop.quantity -= 1;
              }
              }),
              child: Icon(Icons.delete,color: Colors.grey,size: 35,)),
            ]),
            SizedBox(height: 10,),
            Row(
              children: [
                Icon(Icons.shopping_cart,color: Colors.blue,),
                Text("JOD ",style: TextStyle(fontWeight: FontWeight.bold),),
                Text(getTotalBill().toStringAsFixed(2),style: TextStyle(fontSize: 20,fontFamily:"LoginSignup",fontWeight: FontWeight.bold),)
              ],
            )
              ],
            ),
          ),
        ),
      ),
    );
  }
}