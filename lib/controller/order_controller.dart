import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/data/api/api_checker.dart';
import 'package:efood_multivendor_restaurant/data/api/api_client.dart';
import 'package:efood_multivendor_restaurant/data/model/body/update_status_body.dart';
import 'package:efood_multivendor_restaurant/data/model/response/delivery_man_list_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/order_cancellation_body.dart';
import 'package:efood_multivendor_restaurant/data/model/response/order_details_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/order_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/running_order_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/subscription_model.dart';
import 'package:efood_multivendor_restaurant/data/repository/order_repo.dart';
import 'package:efood_multivendor_restaurant/helper/custom_print.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class OrderController extends GetxController implements GetxService {
  final OrderRepo orderRepo;
  OrderController({required this.orderRepo});

  late List<OrderModel> _allOrderList;
  List<OrderModel>? _orderList;
  List<OrderModel>? _runningOrderList;
  List<RunningOrderModel>? _runningOrders;
  List<OrderModel>? _historyOrderList;
  List<OrderDetailsModel>? _orderDetailsModel;
  bool _isLoading = false;
  int _orderIndex = 0;
  bool _campaignOnly = false;
  bool _subscriptionOnly = false;
  String _otp = '';
  int _historyIndex = 0;
  final List<String> _statusList = ['all', 'delivered', 'refunded'];
  bool _paginate = false;
  int? _pageSize;
  List<int> _offsetList = [];
  int _offset = 1;
  String _orderType = 'all';
  OrderModel? _orderModel;
  List<CancellationData>? _orderCancelReasons;
  String? _cancelReason = '';
  SubscriptionModel? _subscriptionModel;
  bool _isFirstTimeSubOrder = true;
  bool _showDeliveryImageField = false;
  List<XFile> _pickedPrescriptions = [];
  bool _hideNotificationButton = false;
  List<DeliveryManListModel>? _deliveryManList;
  List<DeliveryManListModel> _selectableDeliveryman = [];
  DeliveryManListModel? _selectedDeliveryman;

  List<OrderModel>? get orderList => _orderList;
  List<OrderModel>? get runningOrderList => _runningOrderList;
  List<RunningOrderModel>? get runningOrders => _runningOrders;
  List<OrderModel>? get historyOrderList => _historyOrderList;
  List<OrderDetailsModel>? get orderDetailsModel => _orderDetailsModel;
  bool get isLoading => _isLoading;
  int get orderIndex => _orderIndex;
  bool get campaignOnly => _campaignOnly;
  bool get subscriptionOnly => _subscriptionOnly;
  String get otp => _otp;
  int get historyIndex => _historyIndex;
  List<String> get statusList => _statusList;
  bool get paginate => _paginate;
  int? get pageSize => _pageSize;
  int get offset => _offset;
  String get orderType => _orderType;
  OrderModel? get orderModel => _orderModel;
  List<CancellationData>? get orderCancelReasons => _orderCancelReasons;
  String? get cancelReason => _cancelReason;
  SubscriptionModel? get subscriptionModel => _subscriptionModel;
  bool get showDeliveryImageField => _showDeliveryImageField;
  List<XFile> get pickedPrescriptions => _pickedPrescriptions;
  bool get hideNotificationButton => _hideNotificationButton;
  List<DeliveryManListModel>? get deliveryManList => _deliveryManList;
  List<DeliveryManListModel> get selectableDeliveryman => _selectableDeliveryman;
  DeliveryManListModel? get selectedDeliveryMan => _selectedDeliveryman;

  Future<List<DeliveryManListModel>> searchDeliveryMan(String text) async {
    _selectableDeliveryman = [];
    if(text.isNotEmpty) {
      for (var deliveryMan in _deliveryManList!) {
        if(deliveryMan.name!.startsWith(text)){
          _selectableDeliveryman.add(deliveryMan);
        }
      }
    }
    print('=====selectable delivery mans : ${_selectableDeliveryman}');
    return _selectableDeliveryman;
  }

  void selectDeliveryManInMap(DeliveryManListModel? deliveryMan, {bool canUpdate = true}) {
    _selectedDeliveryman = deliveryMan;
    if(canUpdate) {
      update();
    }
  }

  Future<bool> sendDeliveredNotification(int? orderID) async {
    _hideNotificationButton = true;
    update();
    Response response = await orderRepo.sendDeliveredNotification(orderID);
    bool isSuccess;
    if(response.statusCode == 200) {
      isSuccess = true;
    }else {
      ApiChecker.checkApi(response);
      isSuccess = false;
    }
    _hideNotificationButton = false;
    update();
    return isSuccess;
  }

  void changeDeliveryImageStatus({bool isUpdate = true}){
    _showDeliveryImageField = !_showDeliveryImageField;
    if(isUpdate) {
      update();
    }
  }

  void pickPrescriptionImage({required bool isRemove, required bool isCamera}) async {
    if(isRemove) {
      _pickedPrescriptions = [];
    }else {
      XFile? xFile = await ImagePicker().pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery, imageQuality: 50);
      if(xFile != null) {
        _pickedPrescriptions.add(xFile);
        if(Get.isDialogOpen!){
          Get.back();
        }
      }
      update();
    }
  }

  void removePrescriptionImage(int index) {
    _pickedPrescriptions.removeAt(index);
    update();
  }

  void setOrderCancelReason(String? reason){
    _cancelReason = reason;
    update();
  }

  Future<void> getOrderCancelReasons()async {
    Response response = await orderRepo.getCancelReasons();
    if (response.statusCode == 200) {
      OrderCancellationBody orderCancellationBody = OrderCancellationBody.fromJson(response.body);
      _orderCancelReasons = [];
      for (var element in orderCancellationBody.reasons!) {
        _orderCancelReasons!.add(element);
      }

    }else{
      ApiChecker.checkApi(response);
    }
    update();
  }


  Future<void> setOrderDetails(OrderModel orderModel) async{
    if(orderModel.orderStatus != null && orderModel.customer != null && orderModel.deliveryMan != null){
      _orderModel = orderModel;
      customPrint('having all order model');
    }else{
      customPrint('having not all order model');
      Response response = await orderRepo.getOrderWithId(orderModel.id);
      if(response.statusCode == 200) {
        _orderModel = OrderModel.fromJson(response.body);
        customPrint('order model : ${_orderModel!.toJson()}');
      }else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  Future<void> getAllOrders() async {
    _historyIndex = 0;
    Response response = await orderRepo.getAllOrders();
    if(response.statusCode == 200) {
      _allOrderList = [];
      _orderList = [];
      response.body.forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);
        _allOrderList.add(orderModel);
        _orderList!.add(orderModel);
      });
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getCurrentOrders() async {
    Response response = await orderRepo.getCurrentOrders();
    if(response.statusCode == 200) {
      _runningOrderList = [];
      _runningOrders = [
        RunningOrderModel(status: 'pending', orderList: []),
        RunningOrderModel(status: 'confirmed', orderList: []),
        RunningOrderModel(status: 'cooking', orderList: []),
        RunningOrderModel(status: 'ready_for_handover', orderList: []),
        RunningOrderModel(status: 'food_on_the_way', orderList: []),
      ];
      response.body.forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);
        // print('--------subscriptionId->>> : ${_orderModel.subscriptionId}/----${_orderModel.id}');
        _runningOrderList!.add(orderModel);
      });
      _campaignOnly = true;
      toggleCampaignOnly();
      // _subscriptionOnly = true;
      // toggleSubscriptionOnly();
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  // Future<void> getCompletedOrders() async {
  //   Response response = await orderRepo.getCompletedOrders();
  //   if(response.statusCode == 200) {
  //     _historyOrderList = [];
  //     response.body.forEach((order) {
  //       OrderModel _orderModel = OrderModel.fromJson(order);
  //       _historyOrderList.add(_orderModel);
  //     });
  //   }else {
  //     ApiChecker.checkApi(response);
  //   }
  //   setHistoryIndex(0);
  // }

  Future<void> getPaginatedOrders(int offset, bool reload) async {
    if(offset == 1 || reload) {
      _offsetList = [];
      _offset = 1;
      if(reload) {
        _historyOrderList = null;
      }
      update();
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      Response response = await orderRepo.getPaginatedOrderList(offset, _statusList[_historyIndex]);
      if (response.statusCode == 200) {
        if (offset == 1) {
          _historyOrderList = [];
        }
        if(response.body != null) {
          _historyOrderList!.addAll(PaginatedOrderModel.fromJson(response.body).orders!);
        }
        _pageSize = PaginatedOrderModel.fromJson(response.body).totalSize;
        _paginate = false;
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      if(_paginate) {
        _paginate = false;
        update();
      }
    }
  }

  void showBottomLoader() {
    _paginate = true;
    update();
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void setOrderType(String type) {
    _orderType = type;
    getPaginatedOrders(1, true);
  }

  Future<bool> updateOrderStatus(int? orderID, String status, {bool back = false, String? processingTime, String? reason}) async {
    _isLoading = true;
    update();
    List<MultipartBody> multiParts = [];
    for(XFile file in _pickedPrescriptions) {
      multiParts.add(MultipartBody('order_proof[]', file));
    }
    UpdateStatusBody updateStatusBody = UpdateStatusBody(
      orderId: orderID, status: status,
      otp: status == 'delivered' ? _otp : null,
      processingTime: processingTime,
      reason: reason,
    );
    Response response = await orderRepo.updateOrderStatus(updateStatusBody, multiParts);
    Get.back(result: response.statusCode == 200);
    bool isSuccess;
    if(response.statusCode == 200) {
      if(back) {
        Get.back();
      }
      getCurrentOrders();
      showCustomSnackBar(response.body['message'], isError: false);
      isSuccess = true;
    }else {
      ApiChecker.checkApi(response);
      isSuccess = false;
    }
    _isLoading = false;
    update();
    return isSuccess;
  }

  Future<void> getOrderDetails(int? orderID) async {
    _orderDetailsModel = null;
    Response response = await orderRepo.getOrderDetails(orderID);
    if(response.statusCode == 200) {
      _orderDetailsModel = [];
      response.body['order']['details'].forEach((orderDetails) => _orderDetailsModel!.add(OrderDetailsModel.fromJson(orderDetails)));
      if(response.body['order']['subscription'] != null){
        _subscriptionModel = SubscriptionModel.fromJson(response.body['order']['subscription']);
      }
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setOrderIndex(int index) {
    _orderIndex = index;
    update();
  }

  void toggleCampaignOnly() {
    if(_subscriptionOnly ){
      _subscriptionOnly = !_subscriptionOnly;
    }
    _campaignOnly = !_campaignOnly;
    _runningOrders![0].orderList = [];
    _runningOrders![1].orderList = [];
    _runningOrders![2].orderList = [];
    _runningOrders![3].orderList = [];
    _runningOrders![4].orderList = [];
    for (var order in _runningOrderList!) {
      if(order.orderStatus == 'pending' && (Get.find<SplashController>().configModel!.orderConfirmationModel != 'deliveryman'
          || order.orderType == 'take_away' || Get.find<AuthController>().profileModel!.restaurants![0].selfDeliverySystem == 1)
          && (_campaignOnly ? order.foodCampaign == 1 :  order.subscriptionId == null)) {
        _runningOrders![0].orderList.add(order);
      }else if((order.orderStatus == 'confirmed' || (order.orderStatus == 'accepted' && order.confirmed != null))
          && (_campaignOnly ? order.foodCampaign == 1 : order.subscriptionId == null)) {
        _runningOrders![1].orderList.add(order);
      }else if(order.orderStatus == 'processing' && (_campaignOnly ? order.foodCampaign == 1 : order.subscriptionId == null)) {
        _runningOrders![2].orderList.add(order);
      }else if(order.orderStatus == 'handover' && (_campaignOnly ? order.foodCampaign == 1 : order.subscriptionId == null)) {
        _runningOrders![3].orderList.add(order);
      }else if(order.orderStatus == 'picked_up' && (_campaignOnly ? order.foodCampaign == 1 : order.subscriptionId == null)) {
        _runningOrders![4].orderList.add(order);
      }
    }
    update();
  }

  void toggleSubscriptionOnly() {

    if(_campaignOnly && !_isFirstTimeSubOrder){
      _campaignOnly = !_campaignOnly;
    }
    _isFirstTimeSubOrder = false;
    _subscriptionOnly = !_subscriptionOnly;
    _runningOrders![0].orderList = [];
    _runningOrders![1].orderList = [];
    _runningOrders![2].orderList = [];
    _runningOrders![3].orderList = [];
    _runningOrders![4].orderList = [];
    for (var order in _runningOrderList!) {
      if(order.orderStatus == 'pending' && (Get.find<SplashController>().configModel!.orderConfirmationModel != 'deliveryman'
          || order.orderType == 'take_away' || Get.find<AuthController>().profileModel!.restaurants![0].selfDeliverySystem == 1)
        && (_subscriptionOnly ? order.subscriptionId != null : order.subscriptionId == null)) {
        _runningOrders![0].orderList.add(order);
      }else if((order.orderStatus == 'confirmed' || (order.orderStatus == 'accepted' && order.confirmed != null))
         && (_subscriptionOnly ? order.subscriptionId != null : order.subscriptionId == null)) {
        _runningOrders![1].orderList.add(order);
      }else if(order.orderStatus == 'processing' && (_subscriptionOnly ? order.subscriptionId != null : order.subscriptionId == null)) {
        _runningOrders![2].orderList.add(order);
      }else if(order.orderStatus == 'handover' && (_subscriptionOnly ? order.subscriptionId != null : order.subscriptionId == null)) {
        _runningOrders![3].orderList.add(order);
      }else if(order.orderStatus == 'picked_up' && (_subscriptionOnly ? order.subscriptionId != null : order.subscriptionId == null)) {
        _runningOrders![4].orderList.add(order);
      }
    }
    update();
  }

  void setOtp(String otp) {
    _otp = otp;
    if(otp != '') {
      update();
    }
  }

  void setHistoryIndex(int index) {
    _historyIndex = index;
    getPaginatedOrders(offset, true);
    update();
  }

  // int countHistoryList(int index) {
  //   int _length;
  //   if(index == 0) {
  //     _length = _historyOrderList.length;
  //   }else {
  //     _length = _historyOrderList.where((order) => order.orderStatus == _statusList[index]).length;
  //   }
  //   return _length;
  // }

  Future<void> getDeliveryManList() async {
    _deliveryManList = null;
    Response response = await orderRepo.getDeliveryManList();
    if(response.statusCode == 200) {
      _deliveryManList = [];
      response.body.forEach((deliveryMan) {
        _deliveryManList!.add(DeliveryManListModel.fromJson(deliveryMan));
      });
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<bool> assignDeliveryMan(int? deliveryManId, int? orderId) async {
    _isLoading = true;
    update();
    Response response = await orderRepo.assignDeliveryMan(deliveryManId, orderId);
    bool isSuccess;
    if(response.statusCode == 200) {
      isSuccess = true;
      setOrderDetails(OrderModel(id: orderId));
      Get.back();
    }else {
      ApiChecker.checkApi(response);
      isSuccess = false;
    }
    _isLoading = false;
    update();
    return isSuccess;
  }

}