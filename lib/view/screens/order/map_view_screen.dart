import 'dart:collection';
import 'dart:ui' as ui;

import 'package:custom_info_window/custom_info_window.dart';
import 'package:efood_multivendor_restaurant/controller/order_controller.dart';
import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/response/delivery_man_list_model.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/images.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_image.dart';
import 'package:efood_multivendor_restaurant/view/screens/order/widget/map_custom_info_window.dart';
import 'package:efood_multivendor_restaurant/view/screens/order/widget/location_search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MapViewScreen extends StatefulWidget {
  final List<DeliveryManListModel>? deliveryManList;
  const MapViewScreen({Key? key, this.deliveryManList, }) : super(key: key);

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  GoogleMapController? _controller;
  bool _isLoading = true;
  Set<Marker> _markers = HashSet<Marker>();
  final CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  PageController pageController = PageController(viewportFraction: 0.85, initialPage: 1);

  @override
  void initState() {
    Get.find<OrderController>().selectDeliveryManInMap(null, canUpdate: false);
    super.initState();
  }
  @override
  void dispose() {
    // _controller?.dispose();
    _customInfoWindowController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'available_delivery_man'.tr),
      body: widget.deliveryManList != null ? Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: LatLng(
              double.parse(widget.deliveryManList!.first.lat!), double.parse(widget.deliveryManList!.first.lng!),
            ), zoom: 16),
            minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
            zoomControlsEnabled: false,
            markers: _markers,
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              _customInfoWindowController.googleMapController = controller;
              _isLoading = false;
              setMarker(widget.deliveryManList!);
            },
          ),

          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 50,
            width: 50,
            offset: 20,
          ),

          Positioned(
            top: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
            child: DeliveryManSearchDialog(
              mapController: _controller, deliveryManList: widget.deliveryManList!,
              customInfoWindowController: _customInfoWindowController, pageController: pageController,
            ),
          ),

          Positioned(
            bottom: Dimensions.paddingSizeLarge, left: 0, right: 0,
            child: SizedBox(
              height: 100,
              child: PageView.builder(
                onPageChanged: (int index) {
                  LatLng latLng = LatLng(double.parse(widget.deliveryManList![index].lat!), double.parse(widget.deliveryManList![index].lng!));
                  if(_controller != null) {
                    _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 16)));
                  }
                  _customInfoWindowController.addInfoWindow!(MapCustomInfoWindow(image: '${Get.find<SplashController>().configModel!.baseUrls!.deliveryManImageUrl}/${widget.deliveryManList![index].image!}'), latLng);

                },
                  scrollDirection: Axis.horizontal,
                  controller: pageController,
                  itemCount: widget.deliveryManList!.length,
                  itemBuilder: (context, index) {
                    return deliveryManCard(widget.deliveryManList![index]);
                  },
              ),
            ),
          ),

        ],
      ) : const CircularProgressIndicator(),
    );
  }

  Future<void> setMarker(List<DeliveryManListModel> deliveryManList) async {
    try{
      final Uint8List carMarkerIcon = await convertAssetToUnit8List(Images.deliveryManMarker, width: 100);

      // Animate to coordinate
      LatLngBounds? bounds;
      double rotation = 0;
      if(_controller != null) {
        if (double.parse(deliveryManList.first.lat!) < double.parse(deliveryManList.last.lat!)) {
          bounds = LatLngBounds(
            southwest: LatLng(double.parse(deliveryManList.first.lat!), double.parse(deliveryManList.first.lng!)),
            northeast: LatLng(double.parse(deliveryManList.last.lat!), double.parse(deliveryManList.last.lng!)),
          );
          rotation = 0;
        }else {
          bounds = LatLngBounds(
            southwest: LatLng(double.parse(deliveryManList.last.lat!), double.parse(deliveryManList.last.lng!)),
            northeast: LatLng(double.parse(deliveryManList.first.lat!), double.parse(deliveryManList.first.lng!)),
          );
          rotation = 180;
        }
      }
      LatLng centerBounds = LatLng(
        (bounds!.northeast.latitude + bounds.southwest.latitude)/2,
        (bounds.northeast.longitude + bounds.southwest.longitude)/2,
      );

      _controller!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: centerBounds, zoom: 16)));

      zoomToFit(_controller, bounds, centerBounds, padding: 1.5);

      _markers = {};
      for(int i = 0; i < deliveryManList.length; i++) {

        LatLng latLng = LatLng(double.parse(deliveryManList[i].lat!), double.parse(deliveryManList[i].lng!));
        MarkerId markerId = MarkerId('rider_$i');
        _markers.add(Marker(
          markerId: markerId,
          visible: true,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: const Offset(0.5, 0.5),
          position: latLng,
          onTap: () {
            _customInfoWindowController.addInfoWindow!(MapCustomInfoWindow(image: '${Get.find<SplashController>().configModel!.baseUrls!.deliveryManImageUrl}/${deliveryManList[i].image}'), latLng);
          },
          icon: BitmapDescriptor.fromBytes(carMarkerIcon),
        ));

      }
    }catch(_){}
    setState(() {});
  }

  Widget deliveryManCard(DeliveryManListModel deliveryManListModel) {
    return InkWell(
      onTap: () {
        LatLng latLng = LatLng(double.parse(deliveryManListModel.lat!), double.parse(deliveryManListModel.lng!));
        if(_controller != null) {
          _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 16)));
        }
        _customInfoWindowController.addInfoWindow!(MapCustomInfoWindow(image: '${Get.find<SplashController>().configModel!.baseUrls!.deliveryManImageUrl}/${deliveryManListModel.image}'), latLng);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).cardColor,
        ),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
        child: Row(children: [
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              child: CustomImage(
                fit: BoxFit.cover,
                image: '${Get.find<SplashController>().configModel!.baseUrls!.deliveryManImageUrl}/${deliveryManListModel.image}',
              ),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Text(
              deliveryManListModel.name!,
              style: robotoBold, maxLines: 1, overflow: TextOverflow.ellipsis,
            ),

            Text(
              '${deliveryManListModel.distance!} ${'away'.tr}',
              style: robotoRegular,
            ),
            Text(
              '${'active_order'.tr} : ${deliveryManListModel.currentOrders!}',
              style: robotoRegular,
            ),
          ]))
        ]),
      ),
    );
  }

  Future<Uint8List> convertAssetToUnit8List(String imagePath, {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format:ui. ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<void> zoomToFit(GoogleMapController? controller, LatLngBounds? bounds, LatLng centerBounds, {double padding = 0.5}) async {
    bool keepZoomingOut = true;

    while(keepZoomingOut) {
      final LatLngBounds screenBounds = await controller!.getVisibleRegion();
      if(fits(bounds!, screenBounds)){
        keepZoomingOut = false;
        final double zoomLevel = await controller.getZoomLevel() - padding;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
        break;
      }
      else {
        // Zooming out by 0.1 zoom level per iteration
        final double zoomLevel = await controller.getZoomLevel() - 0.1;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
      }
    }
  }

  bool fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
    final bool northEastLatitudeCheck = screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
    final bool northEastLongitudeCheck = screenBounds.northeast.longitude >= fitBounds.northeast.longitude;

    final bool southWestLatitudeCheck = screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
    final bool southWestLongitudeCheck = screenBounds.southwest.longitude <= fitBounds.southwest.longitude;

    return northEastLatitudeCheck && northEastLongitudeCheck && southWestLatitudeCheck && southWestLongitudeCheck;
  }
}
