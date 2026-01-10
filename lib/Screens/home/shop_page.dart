import 'package:buhairi_academy_application/Customs/Colors.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/custom_card_shop.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/model_card_shop.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List <ModelCardShop> FilterdList = cards;

  searchInEditText(String title){
    setState(() {
      if(title.isEmpty){
        FilterdList = cards;
      }
      else{
        FilterdList = cards.where((c) => c.title.toLowerCase().contains(title.toLowerCase())).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Splash_Color.login_reg,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Material(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  child: TextField(
                    onChanged: (value) {      
                        searchInEditText(value);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, size: 30),
                      hintText: "Search",
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
                SizedBox(height: 10),
            Expanded(
              child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),itemCount: FilterdList.length, itemBuilder: (context,index){
                return CustomCardShop(modelCardShop: FilterdList[index], onTap: (){},);
              }),
            ),
          ],
        ),
      ),
    );
    
  }
}