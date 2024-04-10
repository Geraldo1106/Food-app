import 'dart:math';

import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_image.dart';
import 'package:flutter/material.dart';
class MapCustomInfoWindow extends StatelessWidget {
  final String image;
  const MapCustomInfoWindow({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, width: 50,
      child: Stack(
        children: [
          const SizedBox(),

          Align(
            alignment: Alignment.bottomCenter,
            child: Transform.rotate(
              angle: pi / 4.0,
              child: Container(
                height: 20, width: 20,
                color: Theme.of(context).cardColor,
              ),
            ),
          ),

          Column(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    child: CustomImage(image: image, fit: BoxFit.fill),
                  ),
                ),
              ),
              const Expanded(flex: 1, child: SizedBox()),
            ],
          ),

        ],
      ),
    );
  }
}
