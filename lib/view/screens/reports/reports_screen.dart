import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/images.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'reports'.tr),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(children: [

            SubMenuCardWidget(title: 'expense_report'.tr, image: Images.expenseIcon, route: () => Get.toNamed(RouteHelper.getExpenseRoute())),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            SubMenuCardWidget(title: 'transaction_report'.tr, image: Images.transactionIcon, route: () => Get.toNamed(RouteHelper.getTransactionReportRoute())),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            SubMenuCardWidget(title: 'order_report'.tr, image: Images.orderIcon, route: () => Get.toNamed(RouteHelper.getOrderReportRoute())),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            SubMenuCardWidget(title: 'food_report'.tr, image: Images.foodIcon, route: () => Get.toNamed(RouteHelper.getFoodReportRoute())),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            SubMenuCardWidget(title: 'campaign_report'.tr, image: Images.campaignIcon, route: () => Get.toNamed(RouteHelper.getCampaignReportRoute())),

          ]),
        ),
      )
    );
  }
}

class SubMenuCardWidget extends StatelessWidget {
  final String title;
  final String image;
  final void Function() route;
  const SubMenuCardWidget({Key? key, required this.title, required this.image, required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: route,
      child: Container(
        height: 80, width: context.width,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).primaryColor.withOpacity(0.03),
          border: Border.all(width: 1, color: Theme.of(context).primaryColor.withOpacity(0.3)),
        ),
        child: Row(children: [

          Image.asset(image, width: 40, height: 40, color: Theme.of(context).primaryColor),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Text(title, style: robotoMedium),

        ]),
      ),
    );
  }
}
