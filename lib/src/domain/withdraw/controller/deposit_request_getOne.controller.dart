
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/deposit_request_getOne.repository.dart';
import 'package:hanigold_admin/src/domain/deposit/controller/deposit.controller.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/deposit_request.model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as html;

import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/deposit.repository.dart';
import '../../../config/repository/url/base_url.dart';
import 'package:path/path.dart' as path;

enum PageState{loading,err,empty,list}
class DepositRequestGetOneController extends GetxController{

  final DepositController depositController=Get.find<DepositController>();

  final DepositRequestGetOneRepository depositRequestGetOneRepository=DepositRequestGetOneRepository();
  final DepositRepository depositRepository=DepositRepository();

  var id=0.obs;
  final Rxn<DepositRequestModel> getOneDepositRequest = Rxn<DepositRequestModel>();
  Rx<PageState> state=Rx<PageState>(PageState.list);
  var isLoading=true.obs;
  var isLoadingRegister=true.obs;
  var errorMessage=''.obs;

  @override
  void onInit() {
    id.value=(int.parse(Get.parameters["id"]!));
    print("depositIdddd:${id.value}");
    fetchGetOneDepositRequest(id.value);
    super.onInit();
  }
  Future<void> fetchGetOneDepositRequest(int id)async{
    try {
      state.value=PageState.loading;
      //EasyLoading.show(status: 'دریافت اطلاعات از سرور...');
      var fetchedGetOneDepositRequest = await depositRequestGetOneRepository.getOneDepositRequest(id);
      if(fetchedGetOneDepositRequest!=null){
        getOneDepositRequest.value = fetchedGetOneDepositRequest;
        state.value=PageState.list;
        //EasyLoading.dismiss();
        print('deposits:  ${getOneDepositRequest.value?.deposits?.length}');
      }else{
        state.value=PageState.empty;
      }

    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی به وجود آمده است ${e.toString()}";
    }
  }

  Future<List<dynamic>?> deleteDeposit(int depositId,bool isDeleted)async{
    try{
      isLoading.value = true;
      var response=await depositRepository.deleteDeposit(isDeleted: isDeleted, depositId: depositId);
      if(response!= null){
        Get.snackbar("موفقیت آمیز","حذف واریزی با موفقیت انجام شد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text('حذف واریزی با موفقیت انجام شد',textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        depositController.getDepositListPager();
        fetchGetOneDepositRequest(id.value);
      }
    }catch(e){
      throw ErrorException('خطا در حذف واریزی: $e');
    }finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<List<dynamic>?> updateRegistered(int depositId,bool registered) async {
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try {
      isLoadingRegister.value = true;
      var response = await depositRepository.updateRegistered(
        depositId: depositId,
        registered: registered,
      );
      if(response!= null){
        //EasyLoading.dismiss();
        Get.snackbar(response.first['title'],response.first["description"],
            titleText: Text(response.first['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(response.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        depositController.getDepositListPager();
        fetchGetOneDepositRequest(id.value);
      }

    } catch (e) {
      EasyLoading.dismiss();
      throw ErrorException('خطا در ریجیستر: $e');
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }

    return null;
  }

  void downloadImage(String guidId) async {
    if (kIsWeb){
      final url = "${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=$guidId";
      final anchor = html.AnchorElement(href: url)
        ..download = "image_$guidId"
        ..style.display = 'none';

      html.document.body?.children.add(anchor);
      anchor.click();
      anchor.remove();
    }else{
      try {
        final status = await Permission.storage.request();
        if (!status.isGranted) return;

        final dio = Dio();
        final url = "${BaseUrl.baseUrl}Attachment/downloadAttachment?fileName=$guidId";
        final downloadsDir = await getDownloadsDirectory();
        if (downloadsDir == null) {
          throw Exception('Could not access downloads directory');
        }
        String fileExtension = path.extension(guidId);
        if(fileExtension.isEmpty) fileExtension = '.png';
        final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}$fileExtension';
        final savePath = path.join(downloadsDir.path, fileName);
        /*final dir = await getApplicationDocumentsDirectory();
        final path = '${dir.path}/images_$guidId.png';*/
        await dio.download(url, savePath);
        print(savePath);
        Get.snackbar(
          'موفقیت',
          'تصویر با موفقیت ذخیره شد',
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        Get.snackbar(
          'خطا',
          'خطا در دانلود تصویر: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}