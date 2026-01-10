import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/custom_card_shop.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/model_card_shop.dart';
import 'package:flutter/material.dart';

class FavoriteDrawer extends StatelessWidget {
  const FavoriteDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    List <ModelCardShop> favList = cards.where((c) => c.flagFav == true).toList();
    return favList.isEmpty ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_disabled, size: 150, color: Colors.grey,),
          SizedBox(height: 20,),
          Text("There is no favorite")
        ],
      ),
    ) : GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),itemCount: favList.length, itemBuilder: (context,index){
        return CustomCardShop(modelCardShop: favList[index], onTap: (){},);
      });
  }
}