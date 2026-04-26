import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/chat/model/chat.model.dart';
import 'package:hanigold_admin/src/domain/chat/model/chat_account.model.dart';

import '../../domain/chat/model/chat_message.model.dart';
import '../../domain/chat/model/topic.model.dart';
import '../logger/app_logger.dart';
import '../network/dio_Interceptor.dart';
import '../network/error_handler.dart';

class ChatRepository {
  Dio chatDio = Dio();

  ChatRepository() {
    chatDio.options.baseUrl = BaseUrl.baseUrl;
    chatDio.interceptors.add(DioInterceptor());
  }

  // Get account chat list
  Future<List<ChatAccountModel>> getChatAccountList({int startIndex = 1, int toIndex = 10}) async {
    try {
      Map<String, dynamic> options = {
        "options" : { "chat" :{

        "orderBy": "Account.Id",
        "orderByType": "desc",
        "StartIndex": startIndex,
        "ToIndex": toIndex
          }
        }
      };

      final response = await chatDio.post('Chat/getChatAccount', data: options);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((chatAccount) => ChatAccountModel.fromJson(chatAccount)).toList();
      } else {
        throw ErrorException('خطا در دریافت لیست چت ‌اکانت ها');
      }
    } catch (e,s) {
      AppLogger.e('getChatAccountList failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  // Get chat list
  Future<List<ChatModel>> getChatList(String accountId, {int startIndex = 1, int toIndex = 10}) async {
    try {
      Map<String, dynamic> options = {
        "options" : { "chat" :{
          "Predicate": [
            {
              "innerCondition": 1,
              "outerCondition": 0,
              "filters": [
                {
                  "fieldName": "accountId",
                  "filterValue": accountId,
                  "filterType": 5,
                  "RefTable": "ChatSession"
                }
              ]
            }
          ],
          "orderBy": "ChatSession.ChatId",
          "orderByType": "desc",
          "StartIndex": startIndex,
          "ToIndex": toIndex
        }}
      };
      final response = await chatDio.post('Chat/getChat', data: options);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((chat) => ChatModel.fromJson(chat)).toList();
      } else {
        throw ErrorException('خطا در دریافت لیست چت‌ها');
      }
    } catch (e,s) {
      AppLogger.e('getChatList failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  // Get chat messages
  Future<List<ChatMessageModel>> getChatMessages(String chatId,{int startIndex = 1, int toIndex = 10}) async {
    try {
      Map<String, dynamic> options = {"options" :
      { "chat": {
        "Predicate": [
          {
            "innerCondition": 1,
            "outerCondition": 0,
            "filters": [
              {
                "fieldName": "ChatId",
                "filterValue": chatId,
                "filterType": 4,
                "RefTable": "ChatMessage"
              }
            ]
          }
        ],
        "orderBy": "ChatMessage.Seq",
        "orderByType": "desc",
        "StartIndex": startIndex,
        "ToIndex": toIndex
      }
      }
      };

      final response = await chatDio.post('Chat/getChatMessagesByChatId', data: options);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((message) => ChatMessageModel.fromJson(message)).toList();
      } else {
        throw ErrorException('خطا در دریافت پیام‌ها');
      }
    } catch (e,s) {
      AppLogger.e('getChatMessages failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));

    }
  }

  // Get topics for a account
  Future<List<TopicModel>> getTopics() async {
    try {
      final response = await chatDio.get('Chat/getTopic');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((topic) => TopicModel.fromJson(topic)).toList();
      } else {
        throw ErrorException('خطا در دریافت موضوعات');
      }
    } catch (e,s) {
      AppLogger.e('getTopics failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  // Send a message
  Future<bool> sendMessage(Map<String, dynamic> sendData) async {
    try {
      final response = await chatDio.post('Message/insert', data: sendData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw ErrorException('خطا در ارسال پیام');
      }
    } catch (e,s) {
      AppLogger.e('sendMessage failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<bool> updateSeen(String id) async {
    try {
      final response = await chatDio.put('Message/updateSeen?id=$id');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw ErrorException('خطا در آپدیت');
      }
    } catch (e,s) {
      AppLogger.e('updateSeen failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }
}
