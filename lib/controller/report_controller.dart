import 'package:efood_multivendor_restaurant/data/api/api_checker.dart';
import 'package:efood_multivendor_restaurant/data/model/response/report_model.dart';
import 'package:efood_multivendor_restaurant/data/repository/report_repo.dart';
import 'package:efood_multivendor_restaurant/helper/date_converter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportController extends GetxController implements GetxService {
  final ReportRepo reportRepo;

  ReportController({required this.reportRepo});

  int? _pageSize;
  List<String> _offsetList = [];
  int _offset = 1;
  bool _isLoading = false;
  double? _onHold;
  double? _canceled;
  double? _completedTransactions;
  List<OrderTransactions>? _orderTransactions;
  late DateTimeRange _selectedDateRange;
  String? _from;
  String? _to;
  OtherData? _otherData;
  List<Orders>? _orders;
  List<String>? _label;
  List<double>? _earning;
  double? _earningAvg;
  List<Foods>? _foods;
  List<FlSpot> earningChartList = [];
  double maxValue = 0;
  String? _avgType;

  int? get pageSize => _pageSize;
  int get offset => _offset;
  bool get isLoading => _isLoading;
  double? get onHold => _onHold;
  double? get canceled => _canceled;
  double? get completedTransactions => _completedTransactions;
  List<OrderTransactions>? get orderTransactions => _orderTransactions;
  String? get from => _from;
  String? get to => _to;
  OtherData? get otherData => _otherData;
  List<Orders>? get orders => _orders;
  List<String>? get label => _label;
  List<double>? get earning => _earning;
  double? get earningAvg => _earningAvg;
  List<Foods>? get foods => _foods;
  String? get avgType => _avgType;

  void initSetDate() {
    _from = DateConverter.dateTimeForCoupon(DateTime.now().subtract(const Duration(days: 30)));
    _to = DateConverter.dateTimeForCoupon(DateTime.now());
  }

  Future<void> getTransactionReportList({required String offset, required String? from, required String? to}) async {

    if (offset == '1') {
      _offsetList = [];
      _offset = 1;
      _orderTransactions = null;
      update();
    }

    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);

      Response response = await reportRepo.getTransactionReportList(offset: int.parse(offset), from: from, to: to);
      if (response.statusCode == 200) {
        TransactionReportModel transactionReportModel = TransactionReportModel.fromJson(response.body);
        _onHold = transactionReportModel.onHold;
        _canceled = transactionReportModel.canceled;
        _completedTransactions = transactionReportModel.completedTransactions;
        if (offset == '1') {
          _orderTransactions = [];
        }
        _orderTransactions!.addAll(transactionReportModel.orderTransactions!);
        _pageSize = TransactionReportModel.fromJson(response.body).totalSize;
        _isLoading = false;
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      if (isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  Future<void> getOrderReportList({required String offset, required String? from, required String? to}) async {

    if (offset == '1') {
      _offsetList = [];
      _offset = 1;
      _orders = null;
      update();
    }

    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);

      Response response = await reportRepo.getOrderReportList(offset: int.parse(offset), from: from, to: to);
      if (response.statusCode == 200) {
        OrderReportModel orderReportModel = OrderReportModel.fromJson(response.body);
        _otherData = orderReportModel.otherData;
        if (offset == '1') {
          _orders = [];
        }
        _orders!.addAll(orderReportModel.orders!);
        _pageSize = OrderReportModel.fromJson(response.body).totalSize;
        _isLoading = false;
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      if (isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  Future<void> getCampaignReportList({required String offset, required String? from, required String? to}) async {

    if (offset == '1') {
      _offsetList = [];
      _offset = 1;
      _orders = null;
      update();
    }

    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);

      Response response = await reportRepo.getCampaignReportList(offset: int.parse(offset), from: from, to: to);
      if (response.statusCode == 200) {
        OrderReportModel orderReportModel = OrderReportModel.fromJson(response.body);
        if (offset == '1') {
          _orders = [];
        }
        _orders!.addAll(orderReportModel.orders!);
        _pageSize = OrderReportModel.fromJson(response.body).totalSize;
        _isLoading = false;
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      if (isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  Future<void> getFoodReportList({required String offset, required String? from, required String? to}) async {

    if (offset == '1') {
      _offsetList = [];
      _offset = 1;
      _label = null;
      _earning = null;
      _earningAvg = null;
      _foods = null;
      update();
    }

    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);

      Response response = await reportRepo.getFoodReportList(offset: int.parse(offset), from: from, to: to);
      if (response.statusCode == 200) {
        FoodReportModel foodReportModel = FoodReportModel.fromJson(response.body);
        if (offset == '1') {
          _label = [];
          _earning = [];
          _earningAvg = null;
          _foods = [];
          earningChartList = [];
        }
        _label!.addAll(foodReportModel.label!);
        _earning!.addAll(foodReportModel.earning!);
        _earningAvg = foodReportModel.earningAvg!;
        _avgType = foodReportModel.avgType!;
        _foods!.addAll(foodReportModel.foods!);
        _pageSize = FoodReportModel.fromJson(response.body).totalSize;
        earningChartList = earning!.map((e) => FlSpot(earning!.indexOf(e).toDouble(), e.toDouble())).toList();
        maxValue = earning!.reduce((curr, next) => curr > next ? curr : next).toDouble();
        if (kDebugMode) {
          print("======>maxValue $maxValue");
        }
        _isLoading = false;
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      if (isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void showDatePicker(BuildContext context, {bool transaction = false, bool order = false, bool campaign = false}) async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
      saveText: 'done'.tr,
      confirmText: 'done'.tr,
      cancelText: 'cancel'.tr,
      fieldStartLabelText: 'start_date'.tr,
      fieldEndLabelText: 'end_date'.tr,
      errorInvalidRangeText: 'select_range'.tr,
    );

    if (result != null) {
      _selectedDateRange = result;

      _from = _selectedDateRange.start.toString().split(' ')[0];
      _to = _selectedDateRange.end.toString().split(' ')[0];
      update();
      if(transaction){
        getTransactionReportList(offset: '1', from: _from, to: _to);
        if (kDebugMode) {
          print('============$from / ==========$to');
        }
      }
      if(order){
        getOrderReportList(offset: '1', from: _from, to: _to);
        if (kDebugMode) {
          print('============$from / ==========$to');
        }
      }
      if(campaign) {
        getCampaignReportList(offset: '1', from: _from, to: _to);
        if (kDebugMode) {
          print('============$from / ==========$to');
        }
      }
      getFoodReportList(offset: '1', from: _from, to: _to);
      if (kDebugMode) {
        print('============$from / ==========$to');
      }
    }
  }

}