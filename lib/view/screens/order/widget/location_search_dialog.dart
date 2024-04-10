import 'package:custom_info_window/custom_info_window.dart';
import 'package:efood_multivendor_restaurant/controller/order_controller.dart';
import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/response/delivery_man_list_model.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/view/screens/order/widget/map_custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryManSearchDialog extends StatelessWidget {
  final GoogleMapController? mapController;
  final CustomInfoWindowController customInfoWindowController;
  final PageController pageController;
  final List<DeliveryManListModel> deliveryManList;
  const DeliveryManSearchDialog({Key? key, required this.mapController, required this.deliveryManList, required this.customInfoWindowController, required this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Scrollable(viewportBuilder: (context, position) => Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      alignment: Alignment.topCenter,
      child: GetBuilder<OrderController>(
        builder: (orderController) {
          if(orderController.selectedDeliveryMan != null) {
            controller.text = orderController.selectedDeliveryMan!.name!;
          } else {
            controller.text = '';
          }
          return Material(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
            child: SizedBox(width: Dimensions.webMaxWidth, child: Stack(children: [
                TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: controller,
                    textInputAction: TextInputAction.search,
                    autofocus: false,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.streetAddress,
                    decoration: InputDecoration(
                      hintText: 'search_here'.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        borderSide: BorderSide(style: BorderStyle.none, width: 0.3, color: Theme.of(context).disabledColor),
                      ),
                      hintStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor,
                      ),
                      filled: true, fillColor: Theme.of(context).cardColor,
                    ),
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
                    ),
                  ),
                  suggestionsCallback: (pattern) {
                    return orderController.searchDeliveryMan(pattern);
                  },
                  itemBuilder: (context, DeliveryManListModel suggestion) {
                    return Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Row(children: [
                        const Icon(Icons.location_on),
                        Expanded(
                          child: Text(suggestion.name!, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
                          )),
                        ),
                      ]),
                    );
                  },
                  onSuggestionSelected: (DeliveryManListModel suggestion) async {
                    orderController.selectDeliveryManInMap(suggestion);
                    LatLng latLng = LatLng(double.parse(suggestion.lat!), double.parse(suggestion.lng!));
                    if(mapController != null) {
                      mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 16)));
                      customInfoWindowController.addInfoWindow!(MapCustomInfoWindow(image: '${Get.find<SplashController>().configModel!.baseUrls!.deliveryManImageUrl}/${suggestion.image}'), latLng);
                    }
                    int selectedIndex = 0;
                    for (var deliveryMan in deliveryManList) {
                      if(deliveryMan.id == suggestion.id) {
                        selectedIndex = deliveryManList.indexOf(deliveryMan);
                        print('======selected delivery man index : $selectedIndex');
                        pageController.animateToPage(selectedIndex, duration: const Duration(milliseconds: 1000), curve: Curves.bounceInOut);
                      }
                    }
                  },
                ),

              orderController.selectedDeliveryMan != null ? Positioned(
                right: 10, top: 0, bottom: 0,
                child: IconButton(
                  onPressed: () {
                    controller.clear();
                    orderController.selectDeliveryManInMap(null);
                  },
                  icon: const Icon(Icons.clear),
                ),
              ) : const SizedBox(),
            ])),
          );
        }
      ),
    ));
  }
}
