import 'package:efood_multivendor_restaurant/data/api/api_client.dart';
import 'package:efood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class DisbursementRepo {
  final ApiClient apiClient;

  DisbursementRepo({required this.apiClient});

  Future<Response> addWithdraw(Map<String?, String> data) async {
    return await apiClient.postData(AppConstants.addWithdrawMethodUri, data);
  }

  Future<Response> getDisbursementMethodList() async {
    return await apiClient.getData('${AppConstants.disbursementMethodListUri}?limit=10&offset=1');
  }

  Future<Response> makeDefaultMethod(Map<String?, String> data) async {
    return await apiClient.postData(AppConstants.makeDefaultDisbursementMethodUri, data);
  }

  Future<Response> deleteMethod(int id) async {
    return await apiClient.postData(AppConstants.deleteDisbursementMethodUri, {'_method': 'delete', 'id': id});
  }

  Future<Response> getDisbursementReport(int offset) async {
    return await apiClient.getData('${AppConstants.getDisbursementReportUri}?limit=10&offset=$offset');
  }

}