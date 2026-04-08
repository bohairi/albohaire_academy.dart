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
      borderRadius: BorderRadius.circular(24),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CardDescribeShop(modelCardShop: modelCardShop),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// image
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      child: Image.network(
                        modelCardShop.urlImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: Icon(
                                Icons.broken_image_rounded,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  Positioned(
                    top: 10,
                    right: 10,
                    child: StreamBuilder<bool>(
                      stream: ShopFirebaseHelper.isFavoriteStream(
                        modelCardShop.id!,
                      ),
                      builder: (context, snapshot) {
                        final isFav = snapshot.data ?? false;

                        return Material(
                          color: Colors.white.withOpacity(0.92),
                          shape: const CircleBorder(),
                          elevation: 3,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: onFavoriteTap ??
                                () => ShopFirebaseHelper.toggleFavorite(
                                      modelCardShop,
                                    ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                isFav
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: Colors.red,
                                size: 22,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            /// content
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      modelCardShop.title,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1F2937),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),


                    const Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xff1565C0).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                "JOD ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1565C0),
                                  fontSize: 12.5,
                                ),
                              ),
                              Text(
                                "${modelCardShop.price}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1565C0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 34,
                          width: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xff1565C0).withOpacity(0.10),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 12,
                            color: Color(0xff1565C0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}