import 'package:efood_multivendor_restaurant/controller/report_controller.dart';
import 'package:efood_multivendor_restaurant/helper/custom_print.dart';
import 'package:efood_multivendor_restaurant/helper/date_converter.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/images.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_restaurant/view/screens/reports/widget/report_details_card.dart';
import 'package:efood_multivendor_restaurant/view/screens/reports/order/widget/order_status_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderReportScreen extends StatefulWidget {
  const OrderReportScreen({Key? key}) : super(key: key);

  @override
  State<OrderReportScreen> createState() => _OrderReportScreenState();
}

class _OrderReportScreenState extends State<OrderReportScreen> {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {

    Get.find<ReportController>().initSetDate();
    Get.find<ReportController>().setOffset(1);
    Get.find<ReportController>().getOrderReportList(
      offset: Get.find<ReportController>().offset.toString(),
      from: Get.find<ReportController>().from, to: Get.find<ReportController>().to,
    );

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<ReportController>().orders != null
          && !Get.find<ReportController>().isLoading) {
        int pageSize = (Get.find<ReportController>().pageSize! / 10).ceil();
        if (Get.find<ReportController>().offset < pageSize) {
          Get.find<ReportController>().setOffset(Get.find<ReportController>().offset+1);
          customPrint('end of the page');
          Get.find<ReportController>().showBottomLoader();
          Get.find<ReportController>().getOrderReportList(
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
        title: 'order_report'.tr,
        menuWidget: IconButton(
          icon: Icon(Icons.filter_list_sharp, color: Theme.of(context).textTheme.bodyLarge!.color),
          onPressed: () => Get.find<ReportController>().showDatePicker(context, order: true),
        ),
      ),
      body: GetBuilder<ReportController>(
        builder: (reportController) {
          return reportController.orders != null ? SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Row(children: [

                      Column(
                        children: [
                          OrderStatusCard(
                            image: Images.scheduled,
                            title: 'scheduled_orders'.tr,
                            totalCount: reportController.otherData!.totalScheduledCount ?? 0,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          OrderStatusCard(
                            image: Images.processing,
                            title: 'processing_orders'.tr,
                            totalCount: reportController.otherData!.totalProgressCount ?? 0,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          OrderStatusCard(
                            image: Images.cancel,
                            title: 'canceled'.tr,
                            totalCount: reportController.otherData!.totalCanceledCount ?? 0,
                          ),
                        ],
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault),

                      Column(
                        children: [
                          OrderStatusCard(
                            image: Images.pending,
                            title: 'pending_orders'.tr,
                            totalCount: reportController.otherData!.totalPendingCount ?? 0,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          OrderStatusCard(
                            image: Images.foodOnTheWay,
                            title: 'food_on_the_way'.tr,
                            totalCount: reportController.otherData!.totalOnTheWayCount ?? 0,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          OrderStatusCard(
                            image: Images.paymentFailed,
                            title: 'payment_failed'.tr,
                            totalCount: reportController.otherData!.totalFailedCount ?? 0,
                          ),
                        ],
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault),

                      Column(
                        children: [
                          OrderStatusCard(
                            image: Images.accept,
                            title: 'accepted_orders'.tr,
                            totalCount: reportController.otherData!.totalAcceptedCount ?? 0,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          OrderStatusCard(
                            image: Images.deliver,
                            title: 'delivered'.tr,
                            totalCount: reportController.otherData!.totalDeliveredCount ?? 0,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          OrderStatusCard(
                            image: Images.refund,
                            title: 'refunded'.tr,
                            totalCount: reportController.otherData!.totalRefundedCount ?? 0,
                          ),
                        ],
                      ),

                    ]),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [

                  Text(
                    "total_orders".tr,
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

              reportController.orders != null ? reportController.orders!.isNotEmpty ? ListView.builder(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reportController.orders!.length,
                itemBuilder: (context, index) {
                  return ReportDetailsCard(orders: reportController.orders![index]);
                },
              ) : Center(child: Padding(padding: const EdgeInsets.only(top : 200), child: Text('no_order_found'.tr, style: robotoMedium)))
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



