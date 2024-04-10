import 'package:efood_multivendor_restaurant/data/model/response/report_model.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/screens/reports/widget/title_with_amount_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderTransactionDetailsBottomSheet extends StatelessWidget {
  final Orders orders;
  const OrderTransactionDetailsBottomSheet({Key? key, required this.orders}) : super(key: key);

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

                Text('${'order'.tr} # ${orders.orderId}', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('${'payment_status'.tr} - ' , style: robotoRegular),
                  Text(orders.paymentStatus.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: orders.paymentStatus == 'paid' ? Colors.green : orders.paymentStatus == 'unpaid' ? Colors.red : Colors.blue)),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('${'payment_method'.tr} - ', style: robotoRegular),
                  Text(orders.paymentMethod.toString(), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('${'amount_received_by'.tr} - ', style: robotoRegular),
                  Text(orders.amountReceivedBy.toString(), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
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

                TitleWithAmountWidget(title: 'order_amount'.tr, amount: orders.orderAmount ?? 0),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TitleWithAmountWidget(title: 'food_discount'.tr, amount: orders.itemDiscount ?? 0),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TitleWithAmountWidget(title: 'coupon_discount'.tr, amount: orders.couponDiscount ?? 0),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TitleWithAmountWidget(title: 'total_discount'.tr, amount: orders.discountedAmount ?? 0),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TitleWithAmountWidget(title: 'vat_tax'.tr, amount: orders.tax ?? 0),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TitleWithAmountWidget(title: 'delivery_charge'.tr, amount: orders.deliveryCharge ?? 0),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                TitleWithAmountWidget(title: 'total_order_amount'.tr, amount: orders.totalItemAmount ?? 0),

              ]),
            ),
          ),
        ),

      ]),
    );
  }
}
