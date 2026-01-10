import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/card_describe_shop.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/model_card_shop.dart';
import 'package:flutter/material.dart';

class CustomCardShop extends StatefulWidget {
  ModelCardShop modelCardShop;
  VoidCallback onTap;
  CustomCardShop({super.key, required this.modelCardShop,required this.onTap});

  @override
  State<CustomCardShop> createState() => _CustomCardShopState();
}

class _CustomCardShopState extends State<CustomCardShop> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_)=> CardDescribeShop(modelCardShop: widget.modelCardShop))),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        width: MediaQuery.of(context).size.width * 0.45,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Image.asset(widget.modelCardShop.urlImage,
                  width: double.infinity,
                  fit: BoxFit.contain,),
                ),
                SizedBox(height: 5,),
                Text(widget.modelCardShop.title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                         Text("JOD ",style: TextStyle(fontWeight: FontWeight.bold),),
                         Text("${widget.modelCardShop.price}",style: TextStyle(fontSize: 20,fontFamily:"LoginSignup",fontWeight: FontWeight.bold),)
                      ],
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          widget.modelCardShop.flagFav = !widget.modelCardShop.flagFav;
                        });
                      },
                      child: Icon(widget.modelCardShop.flagFav ? Icons.favorite : Icons.favorite_border,color: Colors.red,))
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