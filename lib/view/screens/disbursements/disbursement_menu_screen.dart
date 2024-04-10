import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/images.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_restaurant/view/screens/reports/reports_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisbursementMenuScreen extends StatelessWidget {
  const DisbursementMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'disbursement'.tr),

        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(children: [

              SubMenuCardWidget(title: 'view_disbursement_history'.tr, image: Images.disbursementIcon, route: () => Get.toNamed(RouteHelper.getDisbursementRoute())),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              SubMenuCardWidget(title: 'disbursement_method_setup'.tr, image: Images.transactionIcon, route: () => Get.toNamed(RouteHelper.getWithdrawMethodRoute())),

            ]),
          ),
        )
    );
  }
}

