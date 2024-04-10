import 'package:efood_multivendor_restaurant/controller/order_controller.dart';
import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_image.dart';
import 'package:efood_multivendor_restaurant/view/screens/order/map_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvailableDeliveryManBottomSheet extends StatefulWidget {
  final int orderId;
  final int? assignedDeliveryManId;
  const AvailableDeliveryManBottomSheet({Key? key, required this.orderId, required this.assignedDeliveryManId}) : super(key: key);

  @override
  State<AvailableDeliveryManBottomSheet> createState() => _AvailableDeliveryManBottomSheetState();
}

class _AvailableDeliveryManBottomSheetState extends State<AvailableDeliveryManBottomSheet> {

  int _selectedIndex = 0;

  @override
  void initState() {
    Get.find<OrderController>().getDeliveryManList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      return orderController.deliveryManList != null ? Container(
        padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radiusExtraLarge),
            topRight: Radius.circular(Dimensions.radiusExtraLarge),
          ),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Container(
            height: 5, width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "available_delivery_man".tr,
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)
              ),

              Text(
                "${orderController.deliveryManList!.length} ${"delivery_man_available".tr}",
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
              ),

            ]),

            orderController.deliveryManList != null && orderController.deliveryManList!.isNotEmpty ? InkWell(
              onTap: () => Get.to(()=> MapViewScreen(deliveryManList: orderController.deliveryManList)),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  border: Border.all(color: const Color(0xFF006FBD)),
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Text(
                  "view_on_map".tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: const Color(0xFF006FBD),
                  ),
                ),
              ),
            ) : const SizedBox(),

          ]),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          orderController.deliveryManList!.isNotEmpty ? Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ListView.builder(
                itemCount: orderController.deliveryManList!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  bool isAssigned = orderController.deliveryManList![index].id == widget.assignedDeliveryManId;
                  return Column(children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: Dimensions.paddingSizeDefault,
                      leading: Container(
                        height: 50, width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).disabledColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                        child: CustomImage(
                          image: '${Get.find<SplashController>().configModel!.baseUrls!.deliveryManImageUrl}/${orderController.deliveryManList![index].image}',
                        ),
                      ),

                      title: Text(
                        orderController.deliveryManList![index].name ?? '',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),

                      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          "${"active_order".tr} : ${orderController.deliveryManList![index].currentOrders}",
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ),

                        Text(
                          "${orderController.deliveryManList![index].distance} ${"away_from_restaurant".tr}",
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ),
                      ]),

                      trailing: InkWell(
                        onTap: () {
                          _selectedIndex = index;
                          orderController.assignDeliveryMan(orderController.deliveryManList![index].id!, widget.orderId);
                        },
                        child: Container(
                          height: 35, width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            color: isAssigned ? Colors.green : const Color(0xFF006FBD),
                          ),
                          child: (orderController.isLoading && _selectedIndex == index)
                              ? Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Theme.of(context).cardColor)))
                              : Text(
                            isAssigned ? 'assigned'.tr : "assign".tr,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor,
                            ),
                          ),
                        ),
                      ),

                    ),

                    const Divider(height: 0, thickness: 0.5),
                  ]);
                },
              ),
            ),
          ) : Padding(
            padding: const EdgeInsets.only(top: 35),
            child: Text('no_deliveryman_available'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
          ),

        ]),
      ) : const Center(child: CircularProgressIndicator());
    });
  }
}
