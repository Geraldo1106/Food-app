import 'package:efood_multivendor_restaurant/data/model/response/report_model.dart';
import 'package:efood_multivendor_restaurant/helper/extensions.dart';
import 'package:efood_multivendor_restaurant/helper/price_converter.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/screens/reports/widget/order_transaction_details_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportDetailsCard extends StatelessWidget {
  final Orders orders;
  final bool isCampaign;
  const ReportDetailsCard({Key? key, required this.orders, this.isCampaign = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width, height: 145,
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

            Text('${'order'.tr} # ${orders.orderId}', style: robotoBold),

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
                      child: OrderTransactionDetailsBottomSheet(orders: orders),
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
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Row(children: [

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                  Row(children: [
                    Text('${'payment_status'.tr} - ' , style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5))),
                    Text(orders.paymentStatus!.replaceAll('_', ' ').toCapitalized(),
                      style: robotoMedium.copyWith(color: orders.paymentStatus == 'paid' ? Colors.green : orders.paymentStatus == 'unpaid' ? Colors.red : Colors.blue),
                    ),
                  ]),

                  Text('${'payment_method'.tr} -', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5))),
                  Text(orders.paymentMethod.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),

                ]),
              ),

              Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center, children: [

                Text('order_amount'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Text(PriceConverter.convertPrice(orders.orderAmount), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.blue)),

              ]),
            ]),
          ),
        ),

      ]),

    );
  }
}