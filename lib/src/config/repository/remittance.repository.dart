
import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/account/model/account_search_req.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/remittance.model.dart';

class RemittanceRepository{

  Dio accountDio=Dio();
  RemittanceRepository(){
    accountDio.options.baseUrl=BaseUrl.baseUrl;
  }
  Future<List<RemittanceModel>> getRemittanceList()async{
    try{
      Map<String , dynamic> options={
        "options" : {
          "remittance" :{
          "orderBy": "Remittance.Id",
          "orderByType": "asc",
          "StartIndex": 1,
          "ToIndex": 20
        }
        }
      };
      final response=await accountDio.post('Remittance/get',data: options);
      // print("url : Remittance/get" );
      // print("request : $options" );
      // print("response : ${response.data}" );
      if(response.statusCode==200){
        List<dynamic> data=response.data;
        return data.map((account)=>RemittanceModel.fromJson(account)).toList();
      }else{
        throw ErrorException('خطا');
      }
    }
    catch(e){
      throw ErrorException('خطا:$e');
    }
  }

}