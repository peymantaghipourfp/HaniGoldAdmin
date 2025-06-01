

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/reason_rejection.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/reason_rejection_req.model.dart';

class ReasonRejectionRepository{
  Dio reasonRejectionDio=Dio();

  ReasonRejectionRepository(){
    reasonRejectionDio.options.baseUrl=BaseUrl.baseUrl;
  }
  
  Future<List<ReasonRejectionModel>> getReasonRejectionList(ReasonRejectionReqModel reasonRejectionReqModel)async{
    final response=await reasonRejectionDio.post('ReasonRejection/get',data: {'options':reasonRejectionReqModel});
    print('Status Code: ${response.statusCode}');
    print('Response Data: ${response.data}');
    List<dynamic> data=response.data;
    return data.map((reasonrejection)=>ReasonRejectionModel.fromJson(reasonrejection)).toList();
  }
}