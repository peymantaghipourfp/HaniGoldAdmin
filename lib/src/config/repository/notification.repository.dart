

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/notification/model/list_notification.model.dart';
import 'package:hanigold_admin/src/domain/notification/model/notification.model.dart';

import '../network/dio_Interceptor.dart';
import '../network/error/network.error.dart';

class NotificationRepository{

  Dio notificationDio=Dio();

  NotificationRepository(){
    notificationDio.options.baseUrl = BaseUrl.baseUrl;
    notificationDio.interceptors.add(DioInterceptor());
  }

  Future<ListNotificationModel> getNotificationListPager({
    required int startIndex,
    required int toIndex,
    int? accountId,
    int? type,
    required String startDate,
    required String endDate,
    required String title,
    required String content,
})async{
    try{
      Map<String, dynamic> options =
          {
            "options" : { "notification" :{
              "Predicate": [
                {
                  "innerCondition": 0,
                  "outerCondition": 0,
                  "filters": [
                    if(accountId != null)
                      {
                        "fieldName": "AccountId",
                        "filterValue": accountId.toString(),
                        "filterType": 5,
                        "RefTable": "notification"
                      },
                    if(type != null)
                      {
                        "fieldName": "Type",
                        "filterValue": type.toString(),
                        "filterType": 5,
                        "RefTable": "notification"
                      },
                    if(startDate!="")
                      {
                        "fieldName": "Date",
                        "filterValue": "$startDate|$endDate",
                        "filterType": 25,
                        "RefTable": "notification"
                      },
                    if(title!="")
                      {
                        "fieldName": "Title",
                        "filterValue": title,
                        "filterType": 0,
                        "RefTable": "notification"
                      },
                    if(content!="")
                      {
                        "fieldName": "NotifContent",
                        "filterValue": content,
                        "filterType": 0,
                        "RefTable": "notification"
                      },
                  ],
                }
              ],
              "orderBy": "Notification.Id",
              "orderByType": "desc",
              "StartIndex": startIndex,
              "ToIndex": toIndex
            }}
          };
      final response=await notificationDio.post('Notification/getWrapper',data: options);
      print("request getNotificationListPager : $options" );
      print("response getNotificationListPager : ${response.data}" );
      return ListNotificationModel.fromJson(response.data);
    }catch(e){
      throw ErrorException('خطا:$e');
    }
  }

  Future<List< dynamic>> deleteNotification({
    required int notificationId,
  })async{
    try{
      Map<String,dynamic> notificationData={
        "id": notificationId,
      };

      print(notificationData);

      var response=await notificationDio.delete('Notification/delete',data: notificationData);
      print('Status Code deleteNotification: ${response.statusCode}');
      print('Response Data deleteNotification: ${response.data}');
      return response.data;
    }
    catch(e){
      throw ErrorException('خطا در حذف:$e');
    }
  }

  Future<NotificationModel> updateStatusNotification({
    required int status,
    required int id,
  }) async {
    try {
      Map<String, dynamic> options = {
        "status": status,
        "id": id,
      };
      final response = await notificationDio.put('Notification/updateStatus', data: options);
      print("request updateStatusNotification : $options" );
      print("response updateStatusNotification : ${response.data}" );
      return NotificationModel.fromJson(response.data);
    } catch (e) {
      throw ErrorException('خطا:$e');
    }
  }

  Future<NotificationModel> updateNotification({
    required String date,
    required String topic,
    required String title,
    required String notifContent,
    required int status,
    required int type,
    required int id
  }) async {
    try {
      Map<String, dynamic> options =
      {
      "date":date,
        "topic": topic,
        "title": title,
        "notifContent": notifContent,
        "type": type,
        "status": status,
        "id": id,
      };
      print(options);
      final response = await notificationDio.put('Notification/update', data: options);
      print('Status Code updateNotification: ${response.statusCode}');
      print('Response Data updateNotification: ${response.data}');
      if (response.statusCode == 200) {
        return
          NotificationModel.fromJson(response.data);
      }
      else {
        throw ErrorException('خطا');
      }
    }
    catch (e) {
      throw ErrorException('خطا:$e');
    }
  }

  Future<Map<String , dynamic>> insertNotification({
    required String date,
    required String topic,
    required String title,
    required String notifContent,
    required int status,
    required int type,
  })async{
    try{
      Map<String, dynamic> notificationData =
      {
        "date": date,
        "topic": topic,
        "title": title,
        "notifContent": notifContent,
        "type": type,
        "status": status,
        "infos": []
      };

      var response=await notificationDio.post('Notification/insert',data: notificationData);
      print('Status Code insertNotification: ${response.statusCode}');
      print('Response Data insertNotification: ${response.data}');
      return response.data;

    }catch(e){
      throw ErrorException('خطا در درج اطلاعیه:$e');
    }
  }


}