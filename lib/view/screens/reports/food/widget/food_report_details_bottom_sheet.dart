import 'package:efood_multivendor_restaurant/data/model/response/report_model.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/screens/reports/widget/title_with_amount_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodOrderDetailsBottomSheet extends StatelessWidget {
  final Foods foods;
  const FoodOrderDetailsBottomSheet({Key? key, required this.foods}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusExtraLarge),
          topRight: Radius.circular(Dimensions.radiusExtraLarge),
        ),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Container(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Column(
            children: [
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Container(
                height: 5, width: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Column(children: [
                Text('transaction_details'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color?.withOpacity(0.6))),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                SizedBox(width: context.width * 0.8, child: Text(foods.name.toString(), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge))),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('${'average_ratings'.tr} - ', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),

                  const Icon(Icons.star, color: Colors.blue, size: 15),

                  Text('${foods.averageRatings!.toStringAsFixed(1)}' ' ', style: robotoRegular.copyWith(color: Colors.blue)),

                  Text('(${foods.totalRatingsGiven})', style: robotoRegular),

                ]),

              ]),
              const SizedBox(height: Dimensions.paddingSizeDefault),
            ],
          ),
        ),

        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(mainAxisSize: MainAxisSize.min, children: [

                /*Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('variation'.tr, style: robotoRegular),

                  const Text('4', style: robotoRegular),
                ]),
                const SizedBox(height: Dimensions.paddingSizeDefault),*/

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('total_order'.tr, style: robotoRegular),

                  Text(foods.totalOrderCount.toString(), style: robotoRegular),
                ]),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TitleWithAmountWidget(title: 'order_amount'.tr, amount: foods.unitPrice ?? 0),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TitleWithAmountWidget(title: 'total_discount'.tr, amount: foods.totalDiscountGiven ?? 0),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TitleWithAmountWidget(title: 'average_sales_value'.tr, amount: foods.averageSaleValue ?? 0),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TitleWithAmountWidget(title: 'total_amount'.tr, amount: foods.totalAmountSold ?? 0),

              ]),
            ),
          ),
        ),

      ]),
    );
  }
}
