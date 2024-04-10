import 'package:efood_multivendor_restaurant/controller/report_controller.dart';
import 'package:efood_multivendor_restaurant/helper/custom_print.dart';
import 'package:efood_multivendor_restaurant/helper/date_converter.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_restaurant/view/screens/reports/transaction/widget/transaction_report_details_card.dart';
import 'package:efood_multivendor_restaurant/view/screens/reports/transaction/widget/transaction_status_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class TransactionReportScreen extends StatefulWidget {
  const TransactionReportScreen({Key? key}) : super(key: key);

  @override
  State<TransactionReportScreen> createState() => _TransactionReportScreenState();
}

class _TransactionReportScreenState extends State<TransactionReportScreen> {

  final ScrollController scrollController = ScrollController();
  final completedToolTip = JustTheController();
  final onHoldToolTip = JustTheController();
  final canceledToolTip = JustTheController();

  @override
  void initState() {

    Get.find<ReportController>().initSetDate();
    Get.find<ReportController>().setOffset(1);
    Get.find<ReportController>().getTransactionReportList(
      offset: Get.find<ReportController>().offset.toString(),
      from: Get.find<ReportController>().from, to: Get.find<ReportController>().to,
    );

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<ReportController>().orderTransactions != null
          && !Get.find<ReportController>().isLoading) {
        int pageSize = (Get.find<ReportController>().pageSize! / 10).ceil();
        if (Get.find<ReportController>().offset < pageSize) {
          Get.find<ReportController>().setOffset(Get.find<ReportController>().offset+1);
          customPrint('end of the page');
          Get.find<ReportController>().showBottomLoader();
          Get.find<ReportController>().getTransactionReportList(
            offset: Get.find<ReportController>().offset.toString(),
            from: Get.find<ReportController>().from, to: Get.find<ReportController>().to,
          );
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'transaction_report'.tr,
        menuWidget: IconButton(
          icon: Icon(Icons.filter_list_sharp, color: Theme.of(context).textTheme.bodyLarge!.color),
          onPressed: () => Get.find<ReportController>().showDatePicker(context, transaction: true),
        ),
      ),

      body: GetBuilder<ReportController>(
        builder: (reportController) {
          return reportController.orderTransactions != null ? SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 240,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Row(children: [

                      TransactionStatusCard(
                        isCompleted: true,
                        amount: reportController.completedTransactions ?? 0,
                        completedToolTip: completedToolTip,
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault),

                      TransactionStatusCard(
                        isOnHold: true,
                        amount: reportController.onHold ?? 0,
                        onHoldToolTip: onHoldToolTip,
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault),

                      TransactionStatusCard(
                        amount: reportController.canceled ?? 0,
                        canceledToolTip: canceledToolTip,
                      ),
                    ]),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [

                  Text(
                    "total_transactions".tr,
                    style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      color: Theme.of(context).primaryColor.withOpacity(0.05),
                    ),
                    child: Text(DateConverter.convertDateToDate(reportController.from!), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  ),
                  const SizedBox(width: 5),

                  Text('to'.tr, style: robotoMedium.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),
                  const SizedBox(width: 5),

                  Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      color: Theme.of(context).primaryColor.withOpacity(0.05),
                    ),
                    child: Text(DateConverter.convertDateToDate(reportController.to!), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  ),
                ]),
              ),

              reportController.orderTransactions != null ? reportController.orderTransactions!.isNotEmpty ? ListView.builder(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reportController.orderTransactions!.length,
                itemBuilder: (context, index) {
                  return TransactionReportDetailsCard(orderTransactions: reportController.orderTransactions![index]);
                },
              ) : Center(child: Padding(padding: const EdgeInsets.only(top : 200), child: Text('no_transaction_found'.tr, style: robotoMedium)))
                  : const Center(child: CircularProgressIndicator()),

              reportController.isLoading ? Center(child: Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
              )) : const SizedBox(),

            ]),
          ) : const Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
}




