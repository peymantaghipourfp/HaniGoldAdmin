

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/remittance/model/balance.model.dart';
import 'package:hanigold_admin/src/domain/users/model/state_item.model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../config/const/app_color.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/laboratory.repository.dart';
import '../../../config/repository/user.repository.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../../account/model/account.model.dart';
import '../../users/model/paginated.model.dart';
import '../model/laboratory.model.dart';



enum PageStateLob{loading,err,empty,list}

class LaboratoryController extends GetxController{

  Rx<PageStateLob> state=Rx<PageStateLob>(PageStateLob.list);
  RxInt currentPageIndex = 1.obs;
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  var isChecked=false.obs;
  var isLoading=false.obs;
  LaboratoryRepository laboratoryRepository=LaboratoryRepository();
  ScrollController scrollController = ScrollController();
  final TextEditingController searchController=TextEditingController();
  RxList<StateItemModel> stateList=<StateItemModel>[].obs;
  RxList<LaboratoryModel> laboratoryList=<LaboratoryModel>[].obs;
  final TextEditingController nameController=TextEditingController();
  final TextEditingController phoneController=TextEditingController();
  final TextEditingController addressController=TextEditingController();

  PaginatedModel? paginated;
  var sort = true.obs; // or `false`...
  var sortIndex = 0.obs; // or `false`...
  @override
  void onInit() {
    super.onInit();
    fetchLaboratoryList();
  }


  setChecked(){
    isChecked.value=!isChecked.value;
    update();
  }
  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex > 0) {
      if (ascending) {
        laboratoryList.sort((a, b) => a.name!.toString().compareTo(b.name!.toString()));
      } else {
        laboratoryList.sort((a, b) => b.name!.toString().compareTo(a.name!.toString()));
      }
    }

    laboratoryList.refresh();
    update();
  }

  setSort(int index,bool val){
    sort.value= val;
    sortIndex.value= index;
    update();
  }

  void isChangePage(int index){
    currentPage.value=index*10-10;
    itemsPerPage.value=index*10;
    fetchLaboratoryList();
  }

  void clearSearch() {
    currentPage.value = 1;
    nameController.clear();
    fetchLaboratoryList();
  }

  // لیست آزمایشگاه ها
  Future<void> fetchLaboratoryList()async{
    try{
      state.value=PageStateLob.loading;
      var fetchedLaboratoryList=await laboratoryRepository.getLaboratoryListPager(
          startIndex: currentPage.value,
          toIndex: itemsPerPage.value,
          name:nameController.text
      );
      laboratoryList.assignAll(fetchedLaboratoryList.laboratories??[]);
      paginated=fetchedLaboratoryList.paginated;
      state.value=PageStateLob.list;
      if(laboratoryList.isEmpty){
        state.value=PageStateLob.empty;
      }
    }
    catch(e){
      state.value=PageStateLob.err;
    }
  }

  // اضافه کردن آزمایشگاه ها
  Future<void> insertLaboratory()async{

    try{
      isLoading.value=false;
      //state.value=PageStateLob.loading;
      var response=await laboratoryRepository.insertLaboratory(name: nameController.text,
          phone: phoneController.text,
          address: addressController.text,
          createdOn: DateTime.now().toString());
      Get.back();
      Get.snackbar(response.infos?.first["title"],response.infos?.first["description"],
          titleText: Text(response.infos?.first["title"],
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.textColor),),
          messageText: Text(response.infos?.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
      isLoading.value=true;
      nameController.text="";
      phoneController.text="";
      addressController.text="";
      fetchLaboratoryList();
      //state.value=PageStateLob.list;
      if(laboratoryList.isEmpty){
       // state.value=PageStateLob.empty;
      }
    }
    catch(e){
     // state.value=PageStateLob.err;
    }
  }
  // اآپدیت آزمایشگاه ها
  Future<void> updateLaboratory(int id,BuildContext context)async{

    try{
      isLoading.value=true;
      //state.value=PageStateLob.loading;
      var response=await laboratoryRepository.updateLaboratory(name: nameController.text,
          phone: phoneController.text,
          address: addressController.text,
         id: id);
      Get.snackbar(response.infos?.first["title"],response.infos?.first["description"],
          titleText: Text(response.infos?.first["title"],
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.textColor),),
          messageText: Text(response.infos?.first["description"],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
      isLoading.value=false;
      nameController.text="";
      phoneController.text="";
      addressController.text="";
      fetchLaboratoryList();
      Navigator.pop(context);
      //state.value=PageStateLob.list;
      if(laboratoryList.isEmpty){
       // state.value=PageStateLob.empty;
      }
    }
    catch(e){
     // state.value=PageStateLob.err;
    }
  }

  Future<List<dynamic>?> deleteLaboratory(int laboratoryId)async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      isLoading.value = true;
      var response=await laboratoryRepository.deleteLaboratory( laboratoryId: laboratoryId);
      if(response.isNotEmpty){
        final info = response.first;
        Get.snackbar(info['title'],info['description'],
            titleText: Text(info['title'],
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColor.textColor),),
            messageText: Text(info['description'],textAlign: TextAlign.center,style: TextStyle(color: AppColor.textColor)));
        fetchLaboratoryList();
      }
    }catch(e){
      EasyLoading.dismiss();
      throw ErrorException('خطا در حذف سفارش: $e');
    }finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
    return null;
  }
}