import 'package:efood_multivendor_restaurant/data/model/response/report_model.dart';
import 'package:efood_multivendor_restaurant/helper/price_converter.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/screens/reports/food/widget/food_report_details_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodReportDetailsCard extends StatelessWidget {
  final Foods foods;
  const FoodReportDetailsCard({Key? key, required this.foods}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width, height: 120,
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, spreadRadius: 1, blurRadius: 5)],
      ),
      child: Column(children: [

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            Flexible(child: Text(foods.name.toString(), maxLines: 1, overflow: TextOverflow.ellipsis, style: robotoMedium)),

            InkWell(
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true, useRootNavigator: true, context: context,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radiusExtraLarge),
                      topRight: Radius.circular(Dimensions.radiusExtraLarge),
                    ),
                  ),
                  builder: (context) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                      child: FoodOrderDetailsBottomSheet(foods: foods),
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Text('view_details'.tr, style: robotoRegular.copyWith(color: Colors.blue, fontSize: Dimensions.fontSizeSmall, decoration: TextDecoration.underline)),
              ),
            ),

          ]),
        ),

        const Divider(height: 1, thickness: 0.5),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
            child: Row(children: [

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                  /*Row(children: [
                    Text('${'variation'.tr} - ' , style: robotoRegular),
                    Text('4', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.green)),
                  ]),*/

                  Row(children: [
                    Text('${'total_order'.tr} : ' , style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.6))),
                    Text(foods.totalOrderCount.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  ]),

                ]),
              ),

              Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center, children: [

                Text('price'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Text(PriceConverter.convertPrice(foods.unitPrice), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.blue)),

              ]),
            ]),
          ),
        ),

      ]),

    );
  }
}