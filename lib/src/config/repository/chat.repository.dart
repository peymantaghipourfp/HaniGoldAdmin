import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/home/model/chat_message.model.dart';
import 'package:hanigold_admin/src/domain/home/model/chat_user.model.dart';
import 'package:hanigold_admin/src/domain/home/model/topic.model.dart';
import 'package:hanigold_admin/src/domain/home/model/user.model.dart';

import '../network/dio_Interceptor.dart';

class ChatRepository {
  Dio chatDio = Dio();

  ChatRepository() {
    chatDio.options.baseUrl = BaseUrl.baseUrl;
    chatDio.interceptors.add(DioInterceptor());
  }

  // Get user chat list
  Future<List<ChatUserModel>> getUserChatList(String userId, {int startIndex = 1, int toIndex = 10}) async {
    try {
      Map<String, dynamic> options = {"options" : { "message" :{
        "Predicate": [
          {
            "innerCondition": 1,
            "outerCondition": 0,
            "filters": [
              {
                "fieldName": "FromUserId",
                "filterValue": userId,
                "filterType": 5,
                "RefTable": "Message"
              },
              {
                "fieldName": "ToUserId",
                "filterValue": userId,
                "filterType": 5,
                "RefTable": "Message"
              }
            ]
          }
        ],
        "orderBy": "Message.Id",
        "orderByType": "desc",
        "StartIndex": startIndex,
        "ToIndex": toIndex
      }}};

      print("request getUserChatList : $options");
      final response = await chatDio.post('Message/getUserChat', data: options);
      print("request getUserChatList : $options");
      print("response getUserChatList : ${response.data}");

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((chat) => ChatUserModel.fromJson(chat)).toList();
      } else {
        throw ErrorException('خطا در دریافت لیست چت‌ها');
      }
    } catch (e) {
      throw ErrorException('خطا:$e');
    }
  }

  // Get chat messages between two users
  Future<List<ChatMessageModel>> getChatMessages(String userId, String otherUserId, {int startIndex = 1, int toIndex = 10}) async {
    try {
      Map<String, dynamic> options = {"options" :
      { "message": {
        "Predicate": [
          {
            "innerCondition": 1,
            "outerCondition": 0,
            "filters": [
              {
                "fieldName": "FromUserId",
                "filterValue": userId,
                "filterType": 5,
                "RefTable": "Message"
              },
              {
                "fieldName": "ToUserId",
                "filterValue": userId,
                "filterType": 5,
                "RefTable": "Message"
              }
            ]
          },
          {
            "innerCondition": 1,
            "outerCondition": 0,
            "filters": [
              {
                "fieldName": "FromUserId",
                "filterValue": otherUserId,
                "filterType": 5,
                "RefTable": "Message"
              },
              {
                "fieldName": "ToUserId",
                "filterValue": otherUserId,
                "filterType": 5,
                "RefTable": "Message"
              }
            ]
          }
        ],
        "orderBy": "Message.Id",
        "orderByType": "desc",
        "StartIndex": startIndex,
        "ToIndex": toIndex
      }
      }
      };

      final response = await chatDio.post('Message/get', data: options);
      print("request getChatMessages : $options");
      print("response getChatMessages : ${response.data}");

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((message) => ChatMessageModel.fromJson(message)).toList();
      } else {
        throw ErrorException('خطا در دریافت پیام‌ها');
      }
    } catch (e) {
      throw ErrorException('خطا:$e');

    }
  }

  // Get topics for a user
  Future<List<TopicModel>> getTopics(String userId) async {
    try {
      final response = await chatDio.get('Message/getTopic?id=$userId');
      print("request getTopics : id=$userId");
      print("response getTopics : ${response.data}");

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((topic) => TopicModel.fromJson(topic)).toList();
      } else {
        throw ErrorException('خطا در دریافت موضوعات');
      }
    } catch (e) {
      throw ErrorException('خطا:$e');
    }
  }

  // Send a message
  Future<bool> sendMessage(Map<String, dynamic> sendData) async {
    try {
      final response = await chatDio.post('Message/insert', data: sendData);
      print("request sendMessage : $sendData");
      print("response sendMessage : ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw ErrorException('خطا در ارسال پیام');
      }
    } catch (e) {
      throw ErrorException('خطا:$e');
    }
  }

  Future<bool> updateSeen(String id) async {
    try {
      final response = await chatDio.put('Message/updateSeen?id=$id');
      print("request updateSeen : id=$id");
      print("response updateSeen : ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw ErrorException('خطا در آپدیت');
      }
    } catch (e) {
      throw ErrorException('خطا:$e');
    }
  }
}
