

import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/notification/model/list_notification.model.dart';
import 'package:hanigold_admin/src/domain/notification/model/notification.model.dart';

import '../logger/app_logger.dart';
import '../network/dio_Interceptor.dart';
import '../network/error/network.error.dart';
import '../network/error_handler.dart';

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
      return ListNotificationModel.fromJson(response.data);
    }catch (e, s) {
      AppLogger.e('getNotificationListPager failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List< dynamic>> deleteNotification({
    required int notificationId,
  })async{
    try{
      Map<String,dynamic> notificationData={
        "id": notificationId,
      };


      var response=await notificationDio.delete('Notification/delete',data: notificationData);
      return response.data;
    }
    catch (e, s) {
      AppLogger.e('deleteNotification failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
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
      return NotificationModel.fromJson(response.data);
    } catch (e, s) {
      AppLogger.e('updateStatusNotification failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
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
      final response = await notificationDio.put('Notification/update', data: options);
      if (response.statusCode == 200) {
        return
          NotificationModel.fromJson(response.data);
      }
      else {
        throw ErrorException('خطا');
      }
    }
    catch (e, s) {
      AppLogger.e('updateNotification failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
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
      return response.data;

    }catch (e, s) {
      AppLogger.e('insertNotification failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }


}