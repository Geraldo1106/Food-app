import 'package:efood_multivendor_restaurant/data/api/api_client.dart';
import 'package:efood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';

class ReportRepo {
  final ApiClient apiClient;

  ReportRepo({required this.apiClient});

  Future<Response> getTransactionReportList({required int offset, required String? from, required String? to}) async {
    return apiClient.getData('${AppConstants.transactionReportUri}?limit=10&offset=$offset&filter=custom&from=$from&to=$to');
  }

  Future<Response> getOrderReportList({required int offset, required String? from, required String? to}) async {
    return apiClient.getData('${AppConstants.orderReportUri}?limit=10&offset=$offset&filter=custom&from=$from&to=$to');
  }

  Future<Response> getCampaignReportList({required int offset, required String? from, required String? to}) async {
    return apiClient.getData('${AppConstants.campaignReportUri}?limit=10&offset=$offset&filter=custom&from=$from&to=$to');
  }

  Future<Response> getFoodReportList({required int offset, required String? from, required String? to}) async {
    return apiClient.getData('${AppConstants.foodReportUri}?limit=10&offset=$offset&filter=custom&from=$from&to=$to');
  }

}