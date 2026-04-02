import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/card_describe_shop.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/model_card_shop.dart';
import 'package:buhairi_academy_application/Screens/customs_widget/shop%20page/shop_firebase_helper.dart';
import 'package:flutter/material.dart';

class CustomCardShop extends StatelessWidget {
  final ModelCardShop modelCardShop;
  final VoidCallback? onFavoriteTap;

  const CustomCardShop({
    super.key,
    required this.modelCardShop,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CardDescribeShop(modelCardShop: modelCardShop),
        ),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        width: MediaQuery.of(context).size.width * 0.45,
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Image.network(
                    modelCardShop.urlImage,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  modelCardShop.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "JOD ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${modelCardShop.price}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: "LoginSignup",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    StreamBuilder<bool>(
                      stream: ShopFirebaseHelper.isFavoriteStream(modelCardShop.id!),
                      builder: (context, snapshot) {
                        final isFav = snapshot.data ?? false;

                        return InkWell(
                          onTap: onFavoriteTap ??
                              () => ShopFirebaseHelper.toggleFavorite(modelCardShop),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
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