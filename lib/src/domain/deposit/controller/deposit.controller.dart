

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/const/app_text_style.dart';
import 'package:hanigold_admin/src/config/repository/deposit.repository.dart';
import 'package:hanigold_admin/src/config/repository/upload.repository.dart';
import 'package:hanigold_admin/src/domain/deposit/model/deposit.model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/reason_rejection.repository.dart';
import '../../withdraw/model/filter.model.dart';
import '../../withdraw/model/options.model.dart';
import '../../withdraw/model/predicate.model.dart';
import '../../withdraw/model/reason_rejection.model.dart';
import '../../withdraw/model/reason_rejection_req.model.dart';

enum PageState{loading,err,empty,list}

typedef XFile= dynamic;

class DepositController extends GetxController{
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  RxBool hasMore = true.obs;
  ScrollController scrollController = ScrollController();

  final UploadRepository uploadRepository=UploadRepository();
  final DepositRepository depositRepository=DepositRepository();
  final ReasonRejectionRepository reasonRejectionRepository=ReasonRejectionRepository();

  var depositList=<DepositModel>[].obs;
  var errorMessage=''.obs;
  var isLoading=true.obs;
  Rx<PageState> state=Rx<PageState>(PageState.list);
  Rx<PageState> stateRR=Rx<PageState>(PageState.list);
  final List<ReasonRejectionModel> reasonRejectionList=<ReasonRejectionModel>[].obs;
  final Rxn<ReasonRejectionModel> selectedReasonRejection = Rxn<ReasonRejectionModel>();

  final ImagePicker _picker = ImagePicker();
  Rx<XFile?> selectedImage = Rx<XFile?>(null);
  RxBool isUploading = false.obs;


  @override
  void onInit() {
    fetchDepositList();
    setupScrollListener();
    super.onInit();
  }

  @override void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200 &&
          hasMore.value &&
          !isLoading.value) {
        loadMore();
      }
    });
  }
  Future<void> loadMore() async {
    if (hasMore.value && !isLoading.value) {
      currentPage++;
      await fetchDepositList();
    }
  }

  Future<void> pickImage(String recordId, String type, String entityType) async {

        final XFile? image = await _picker.pickImage(source: ImageSource.camera);
        if (image == null) {
          final XFile? galleryImage = await _picker.pickImage(source: ImageSource.gallery);
          if(galleryImage!=null) {
        selectedImage.value = File(galleryImage.path);
        await uploadImage(recordId, type, entityType);
      }
    } else {
          selectedImage.value = File(image.path);
          await uploadImage(recordId, type, entityType);
        }
        print("Imaggggge: ${selectedImage}");
  }

  Future<void> uploadImage(String recordId, String type, String entityType) async {
    if (selectedImage.value == null) return;

    isUploading.value = true;
    bool success = await uploadRepository.uploadImage(
      imageFile: selectedImage.value!,
      recordId: recordId,
      type: type,
      entityType: entityType,
    );

    if (success) {
      Get.snackbar("موفقیت‌آمیز", "تصویر با موفقیت آپلود شد");
    } else {
      Get.snackbar("خطا", "ارسال تصویر ناموفق بود");
    }

    isUploading.value = false;
  }


  Future<void> fetchDepositList() async{
    try{

      if (currentPage == 1) {
        depositList.clear();
      }
      isLoading.value = true;
      state.value=PageState.loading;
      final startIndex = (currentPage.value - 1) * itemsPerPage.value +1 ;
      final toIndex = currentPage.value * itemsPerPage.value;
      var fetchedDepositList=await depositRepository.getDepositList(
          startIndex: startIndex,
          toIndex: toIndex
      );
      hasMore.value = fetchedDepositList.length == itemsPerPage.value;
      if (currentPage.value == 1) {
        depositList.assignAll(fetchedDepositList);
      } else {
        depositList.addAll(fetchedDepositList);
      }
      state.value = depositList.isEmpty ? PageState.empty : PageState.list;
    }catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      isLoading.value=false;
    }
  }

  ReasonRejectionReqModel? reasonRejectionReqModel;
  getReasonRejection(String type){
    reasonRejectionList.clear();
    reasonRejectionReqModel=ReasonRejectionReqModel(
        reasonrejection: OptionsModel(
            predicate: [PredicateModel(
                innerCondition: 0,
                outerCondition: 0,
                filters: [FilterModel(
                    fieldName: "Type",
                    filterValue: type,
                    filterType: 4,
                    refTable: "ReasonRejection"
                )
                ]
            )
            ],
            orderBy: "ReasonRejection.Id",
            orderByType: "asc",
            startIndex: 1,
            toIndex: 10000
        )
    );
    fetchReasonRejectionList();
  }

  // لیست Reason Rejection
  Future<void> fetchReasonRejectionList()async{
    try{
      stateRR.value=PageState.loading;
      var fetchedReasonRejectionList=await reasonRejectionRepository.getReasonRejectionList(reasonRejectionReqModel!);
      reasonRejectionList.addAll(fetchedReasonRejectionList);
      stateRR.value=PageState.list;
      if(reasonRejectionList.isEmpty){
        stateRR.value=PageState.empty;
      }
    }
    catch(e){
      stateRR.value=PageState.err;
      errorMessage.value=e.toString();
    }
  }

  Future<void> showReasonRejectionDialog(String type) async {
    getReasonRejection(type);
    await Get.dialog(
      AlertDialog(
        backgroundColor: AppColor.backGroundColor,
        title: Column(
          children: [
            Text('انتخاب دلیل رد واریزی' , style: AppTextStyle.mediumTitleText,textAlign: TextAlign.center,),
            SizedBox(height: 7,),
            Divider(height: 1,color: AppColor.secondaryColor,)
          ],
        ),
        content: Obx(() {
          if (reasonRejectionList.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: reasonRejectionList.map((reason) {
                return Card(
                  color: AppColor.textFieldColor,
                  child: ListTile(
                    title: Text( reason.name ?? '',style: AppTextStyle.bodyTextBold,),
                    onTap: () {
                      selectedReasonRejection.value = reason ;
                      Get.back();
                    },
                  ),
                );
              }).toList(),
            ),
          );
        }),
        actions: [
          TextButton(
            onPressed: () {
              selectedReasonRejection.value = null;

              Get.back();
            },
            child: Text('لغو',style: AppTextStyle.bodyText.copyWith(color: AppColor.secondary2Color,fontSize: 16,fontWeight: FontWeight.bold),),
          ),
        ],
      ),
    );
  }

  Future<DepositModel?> updateStatusDeposit(int depositId,int status,int reasonRejectionId) async {

    try {
      isLoading.value = true;
      var response = await depositRepository.updateStatusDeposit(
        status: status,
        depositId: depositId,
        reasonRejectionId: status==2 ? reasonRejectionId : null,
      );
      if(response!= null){
        Get.snackbar("موفقیت آمیز","وضعیت واریزی با موفقیت تغییر کرد",
            titleText: Text('موفقیت آمیز',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text('وضعیت واریزی با موفقیت تغییر کرد',textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        //fetchDepositList();
      }

    } catch (e) {
      throw ErrorException('خطا در تغییر وضعیت: $e');
    } finally {
      isLoading.value = false;
    }
    return null;
  }
}