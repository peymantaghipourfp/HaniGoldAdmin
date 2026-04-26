import 'package:dio/dio.dart';
import 'package:hanigold_admin/src/config/network/error/network.error.dart';
import 'package:hanigold_admin/src/config/repository/url/base_url.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/account/model/account_group.model.dart';
import 'package:hanigold_admin/src/domain/users/model/list_user.model.dart';

import '../../domain/users/model/city_item.model.dart';
import '../../domain/users/model/list_user_account.model.dart';
import '../../domain/users/model/state_item.model.dart';
import '../logger/app_logger.dart';
import '../network/dio_Interceptor.dart';
import '../network/error_handler.dart';

class UserRepository {
  Dio userDio = Dio();
  UserRepository() {
    userDio.options.baseUrl = BaseUrl.baseUrl;
    userDio.interceptors.add(DioInterceptor());
  }

  Future<ListUserModel> getUserListExport(
      {required int startIndex,
      required int toIndex,
      required String startDate,
      required String endDate}) async {
    try {
      Map<String, dynamic> options = {
        "options": {
          "account": {
            "Predicate": [
              {
                "innerCondition": 0,
                "outerCondition": 0,
                "filters": startDate != ""
                    ? [
                        {
                          "fieldName": "StartDate",
                          "filterValue": "$startDate|$endDate",
                          "filterType": 25,
                          "RefTable": "Account"
                        }
                      ]
                    : [],
              }
            ],
            "orderBy": "Account.StartDate",
            "orderByType": "DESC",
            "StartIndex": startIndex,
            "ToIndex": toIndex
          }
        }
      };
      final response = await userDio.post('Account/getWrapper', data: options);
      return ListUserModel.fromJson(response.data);
    } catch (e, s) {
      AppLogger.e('getUserListExport failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<ListUserModel> getUserList({
    required int startIndex,
    required int toIndex,
    required String name,
    required String mobile,
  }) async {
    try {
      Map<String, dynamic> options = name != "" || mobile != ""
          ? {
              "options": {
                "account": {
                  "Predicate": [
                    {
                      "innerCondition": 0,
                      "outerCondition": 0,
                      "filters": [
                        name != ""
                            ? {
                                "fieldName": "Name",
                                "filterValue": name,
                                "filterType": 0,
                                "RefTable": "Account"
                              }
                            : mobile != ""
                                ? {
                                    "fieldName": "Value",
                                    "filterValue": mobile,
                                    "filterType": 0,
                                    "RefTable": "Ci"
                                  }
                                : []
                      ]
                    }
                  ],
                  "orderBy": "Account.Name",
                  "orderByType": "asc",
                  "StartIndex": startIndex,
                  "ToIndex": toIndex
                }
              }
            }
          : {
              "options": {
                "account": {
                  "orderBy": "Account.StartDate",
                  "orderByType": "DESC",
                  "StartIndex": startIndex,
                  "ToIndex": toIndex
                }
              }
            };
      final response = await userDio.post('Account/getWrapper', data: options);
      return ListUserModel.fromJson(response.data);
    } catch (e, s) {
      AppLogger.e('getUserList failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<ListUserAccountModel> getUserAccountListPager({
    required int startIndex,
    required int toIndex,
    required String nameAccount,
    required String nameContact,
    required String mobile,
    required String username,
    required int status,
  }) async {
    try {
      Map<String, dynamic> options = {
        "options": {
          "user": {
            "Predicate": [
              {
                "innerCondition": 0,
                "outerCondition": 0,
                "filters": [
                  if (nameAccount != "")
                    {
                      "fieldName": "Name",
                      "filterValue": nameAccount,
                      "filterType": 0,
                      "RefTable": "Account"
                    },
                  if (nameContact != "")
                    {
                      "fieldName": "Name",
                      "filterValue": nameContact,
                      "filterType": 0,
                      "RefTable": "Contact"
                    },
                  if (mobile != "")
                    {
                      "fieldName": "MobileNumber",
                      "filterValue": mobile,
                      "filterType": 0,
                      "RefTable": "Users"
                    },
                  if (username != "")
                    {
                      "fieldName": "UserName",
                      "filterValue": username,
                      "filterType": 0,
                      "RefTable": "Users"
                    },
                  if (status != 0)
                    {
                      "fieldName": "Status",
                      "filterValue": "$status",
                      "filterType": 4,
                      "RefTable": "Users"
                    }
                ]
              }
            ],
            "orderBy": "users.Id",
            "orderByType": "desc",
            "StartIndex": startIndex,
            "ToIndex": toIndex
          }
        }
      };

      final response = await userDio.post('User/getWrapper', data: options);
      return ListUserAccountModel.fromJson(response.data);
    } catch (e, s) {
      AppLogger.e('getUserAccountListPager failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List<CityItemModel>> getCityList({
    required int startIndex,
    required int toIndex,
  }) async {
    try {
      Map<String, dynamic> options = {
        "options": {
          "city": {
            "orderBy": "City.name",
            "orderByType": "asc",
            "StartIndex": startIndex,
            "ToIndex": toIndex
          }
        }
      };
      final response = await userDio.post('City/get', data: options);
      List<dynamic> data = response.data;
      return data.map((city) => CityItemModel.fromJson(city)).toList();
    } catch (e, s) {
      AppLogger.e('getCityList failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List<StateItemModel>> getStateList({
    required int startIndex,
    required int toIndex,
  }) async {
    try {
      Map<String, dynamic> options = {
        "options": {
          "state": {
            "orderBy": "State.Name",
            "orderByType": "asc",
            "StartIndex": startIndex,
            "ToIndex": toIndex
          }
        }
      };
      final response = await userDio.post('State/get', data: options);
      List<dynamic> data = response.data;
      return data.map((state) => StateItemModel.fromJson(state)).toList();
    } catch (e, s) {
      AppLogger.e('getStateList failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List<AccountGroupModel>> getAccountGroup() async {
    try {
      Map<String, dynamic> options = {
        "options" : { "accountGroup" :{
          "orderBy": "AccountGroup.Name",
          "orderByType": "asc",
          "StartIndex": 1,
          "ToIndex": 1000000
        }}
      };
      final response = await userDio.post('AccountGroup/get', data: options);
      List<dynamic> data = response.data;
      return data.map((group) => AccountGroupModel.fromJson(group)).toList();
    } catch (e, s) {
      AppLogger.e('getAccountGroup failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }


  Future<AccountModel> insertUser({
    required int accountGroupId,
    required int accountSalesGroupId,
    required int accountLevelId,
    required String name,
    required String nationalCode,
    required String mobile,
    required String phoneNumber,
    required String email,
    //required String user,
    required bool hasDeposit,
    //required String password,
    required String state,
    required int idState,
    required String city,
    required int idCity,
    required String address,
    required String recId,
  }) async {
    try {
      Map<String, dynamic> options = {
        "type": 1,
        "code": null,
        "hasDeposit": hasDeposit,
        "name": name,
        "nationalCode": nationalCode,
        "parent": {"infos": []},
        "accountGroup": {
          "id": accountGroupId,
          "infos": []
        },
        "accountSalesGroup": {
          "id": accountSalesGroupId,
          "infos": []
        },
        "accountLevel": {
          "id": accountLevelId,
          "infos": []
        },
        "addresses": [
          {
            "StateMode": 1,
            "isMain": true,
            "name": "آدرس",
            "account": {"infos": []},
            "contact": {
              "account": {"infos": []},
              "infos": []
            },
            "country": {"name": "ایران", "id": 1, "infos": []},
            "state": {"name": state, "id": idState, "infos": []},
            "city": {"name": city, "id": idCity, "infos": []},
            "fullAddress": address,
            "rowNum": 1,
            "id": null,
            "attribute": "cus",
            "infos": []
          }
        ],
        "contactInfos": [
          {
            "account": {"id": 1, "infos": []},
            "contact": {
              "account": {"infos": []},
              "infos": []
            },
            "StateMode": 1,
            "type": 0,
            "name": name,
            "value": mobile,
            "rowNum": 1,
            "id": null,
            "attribute": "cus",
            "infos": []
          },
          {
            "account": {"id": 1, "infos": []},
            "contact": {
              "account": {"infos": []},
              "infos": []
            },
            "StateMode": 1,
            "type": 1,
            "name": name,
            "value": phoneNumber,
            "rowNum": 1,
            "id": null,
            "attribute": "cus",
            "infos": []
          },
          {
            "account": {"id": 1, "infos": []},
            "contact": {
              "account": {"infos": []},
              "infos": []
            },
            "StateMode": 1,
            "type": 2,
            "name": name,
            "value": email,
            "rowNum": 1,
            "id": null,
            "attribute": "cus",
            "infos": []
          },
        ],
        "rowNum": 1,
        "id": null,
        "attribute": "cus",
        "recId": recId,
        "infos": []
      };
      final response = await userDio.post('Account/insert', data: options);
      return AccountModel.fromJson(response.data);
    } catch (e, s) {
      AppLogger.e('insertUser failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<AccountModel> updateUser({
    required int accountGroupId,
    required int accountSalesGroupId,
    required int accountLevelId,
    required String name,
    required String nationalCode,
    required int id,
    required String mobile,
    required String phoneNumber,
    required String email,
    //required String user,
    required bool hasDeposit,
    //required String password,
    required String state,
    required int idState,
    required String city,
    required int idCity,
    required String address,
    required int status,
    required int type,
    required String code,
    required int accountId,
    required int contactId,
    required int contactInfoId0,
    required int contactInfoId1,
    required int contactInfoId2,
    required String recId,
    //required int addressId,
  }) async {
    try {
      Map<String, dynamic> options = {
        "type": type,
        "code": code,
        "hasDeposit": hasDeposit,
        "name": name,
        "nationalCode": nationalCode,
        "parent": {"infos": []},
        "accountGroup": {
          "id": accountGroupId,
          "infos": []
        },
        "accountSalesGroup": {
          "id": accountSalesGroupId,
          "infos": []
        },
        "accountLevel": {
          "id": accountLevelId,
          "infos": []
        },
        "addresses": [
          {
            "StateMode": 0,
            "isMain": true,
            "name": "آدرس",
            "account": {"infos": []},
            "contact": {
              "account": {"infos": []},
              "infos": []
            },
            "country": {"name": "ایران", "id": 1, "infos": []},
            "state": {"name": state, "id": idState, "infos": []},
            "city": {"name": city, "id": idCity, "infos": []},
            "fullAddress": address,
            "rowNum": 1,
            //"id": addressId,
            "attribute": "cus",
            "infos": []
          }
        ],
        "contactInfos": [
          {
            "account": {"id": accountId, "infos": []},
            "contact": {
              "account": {"infos": []},
              "infos": [],
              "id":contactId
            },
            "StateMode": 2,
            "type": 0,
            "name": name,
            "value": mobile,
            "rowNum": 1,
            "id": contactInfoId0,
            "attribute": "cus",
            "infos": []
          },
          {
            "account": {"id": accountId, "infos": []},
            "contact": {
              "account": {"infos": []},
              "infos": [],
              "id":contactId
            },
            "StateMode": 2,
            "type": 1,
            "name": name,
            "value": phoneNumber,
            "rowNum": 1,
            "id": contactInfoId1,
            "attribute": "cus",
            "infos": []
          },
          {
            "account": {"id": accountId, "infos": []},
            "contact": {
              "account": {"infos": []},
              "infos": [],
              "id":contactId
            },
            "StateMode": 2,
            "type": 2,
            "name": name,
            "value": email,
            "rowNum": 1,
            "id": contactInfoId2,
            "attribute": "cus",
            "infos": []
          },
        ],
        "rowNum": 1,
        "id": id,
        "status":status,
        "attribute": "cus",
        "recId": recId,
        "infos": []
      };
      final response = await userDio.put('Account/Update', data: options);
      return AccountModel.fromJson(response.data);
    } catch (e, s) {
      AppLogger.e('updateUser failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<AccountModel> updateUserAccount({
    required String userName,
    required int id,
    required String mobile,
    required String email,
  }) async {
    try {
      Map<String, dynamic> options = {
        "contact": {
          "account": {
            "name": "احسان 1",
            "accountGroup": {"infos": []},
            "id": 1,
            "infos": []
          },
          "name": "احسان 1",
          "id": id,
          "infos": []
        },
        "code": "1",
        "userName": userName,
        "mobileNumber": mobile,
        "email": email,
        "rowNum": 1,
        "id": id,
        "attribute": "cus",
        "description": "احسان",
        "recId": null,
        "infos": []
      };
      final response = await userDio.put('User/update', data: options);
      return AccountModel.fromJson(response.data);
    } catch (e, s) {
      AppLogger.e('updateUserAccount failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<AccountModel> updateStatusUserAccount({
    required int id,
    required String status,
  }) async {
    try {
      Map<String, dynamic> options = {
        "contact": {
          "account": {
            "name": "احسان 1",
            "accountGroup": {"infos": []},
            "id": 1,
            "infos": []
          },
          "name": "احسان 1",
          "id": 1,
          "infos": []
        },
        "code": "1",
        "status": status,
        "userName": "09129348848",
        "mobileNumber": "09129348848",
        "email": "ehsan@gmailcom",
        "rowNum": 1,
        "id": id,
        "attribute": "cus",
        "description": "احسان",
        "recId": "416c0b50-d827-4829-8915-bc6725bde371",
        "infos": []
      };
      final response = await userDio.put('User/updateStatus', data: options);
      return AccountModel.fromJson(response.data);
    } catch (e, s) {
      AppLogger.e('updateStatusUserAccount failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<AccountModel> updateStatus({
    required int status,
    required int id,
  }) async {
    try {
      final response = await userDio
          .put('Account/updateStatus', data: {"status": status, "id": id});
      return AccountModel.fromJson(response.data);
    } catch (e, s) {
      AppLogger.e('updateStatus failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<AccountModel> getOneAccount({
    required int id,
  }) async {
    try {
      final response =
          await userDio.get('Account/getOne', queryParameters: {"id": id});
      return AccountModel.fromJson(response.data);
    } catch (e, s) {
      AppLogger.e('getOneAccount failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<Map<String , dynamic>> changePasswordByAdmin(String password,int id)async{
    try{
      Map<String , dynamic> options={
        "password" : password,
        "RetypePassword" : password,
        "user": {
          "id" : id
        }
      };
      final response = await userDio.post('Login/changePasswordByAdmin', data: options);
      return response.data;
    }
    catch (e, s) {
      AppLogger.e('changePasswordByAdmin failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  Future<List<dynamic>> insertMobileTelegram({
    required int id,
    required String mobile,
    required String name,
  }) async {
    try {
      Map<String, dynamic> options = {
        "TelegarmMobile": mobile,
        "AccountId": id,
        "TelegramFirstName": name
      };
      final response = await userDio.post('Account/setTelegramInfo', data: options);
      return response.data;
    } catch (e, s) {
      AppLogger.e('insertMobileTelegram failed', e, s);
      throw ErrorException(ErrorHandler.handle(e));
    }
  }

  // Future<RemittanceModel> insertRemittance({
  //   required String date,
  //   required int accountIdPayer,
  //   required String accountNamePayer,
  //   required int accountIdReciept,
  //   required String accountNameReciept,
  //   required int itemId,
  //   required double quantity,
  //   required String? description,
  // })async{
  //   try{
  //     Map<String, dynamic> orderData =
  //       {
  //         "date": date,
  //         "walletPayer": {
  //           "address": null,
  //           "account": {
  //             "name": accountNamePayer,
  //             "accountGroup": {
  //               "infos": []
  //             },
  //             "accountItemGroup": {
  //               "infos": []
  //             },
  //             "accountPriceGroup": {
  //               "infos": []
  //             },
  //             "id": accountIdPayer,
  //             "infos": []
  //           },
  //           "item": {
  //             "itemGroup": {
  //               "infos": []
  //             },
  //             "itemUnit": {
  //               "infos": []
  //             },
  //             "infos": []
  //           },
  //           "id": null,
  //           "infos": []
  //         },
  //         "walletReciept": {
  //           "address": null,
  //           "account": {
  //             "name": accountNameReciept,
  //             "accountGroup": {
  //               "infos": []
  //             },
  //             "accountItemGroup": {
  //               "infos": []
  //             },
  //             "accountPriceGroup": {
  //               "infos": []
  //             },
  //             "id": accountIdReciept,
  //             "infos": []
  //           },
  //           "item": {
  //             "itemGroup": {
  //               "infos": []
  //             },
  //             "itemUnit": {
  //               "infos": []
  //             },
  //             "infos": []
  //           },
  //           "id": null,
  //           "infos": []
  //         },
  //         "item": {
  //           "itemGroup": {
  //             "infos": []
  //           },
  //           "itemUnit": {
  //             "name": null,
  //             "id": null,
  //             "infos": []
  //           },
  //           "name": "طلای آبشده",
  //           "icon": "32d97526-459c-4ef0-9be8-646de0e41d09",
  //           "id": itemId,
  //           "infos": []
  //         },
  //         "quantity": quantity,
  //         "status": 1,
  //         "isDeleted": false,
  //         "rowNum": 1,
  //         "id": 1,
  //         "attribute": "cus",
  //         "description": description,
  //         "infos": []
  //
  //     };
  //
  //     var response=await userInfoTransactionDio.post('Remittance/insert',data: orderData);
  //     return RemittanceModel.fromJson(response.data);
  //   }
  //   catch(e){
  //     throw ErrorException('خطا در درج اطلاعات:$e');
  //   }
  // }
}
