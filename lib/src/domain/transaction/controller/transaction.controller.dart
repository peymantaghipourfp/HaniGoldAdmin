
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/domain/users/model/state_item.model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../config/repository/laboratory.repository.dart';
import '../../../config/repository/remittance.repository.dart';
import '../../../config/repository/transaction.repository.dart';
import '../../../config/repository/url/base_url.dart';
import '../../users/model/paginated.model.dart';
import '../../users/model/transaction_item.model.dart';
import '../model/transaction_item.model.dart';
import 'package:universal_html/html.dart' as html;
import 'package:path/path.dart' as path;


enum PageStateTrans{loading,err,empty,list}

class TransactionController extends GetxController{

  Rx<PageStateTrans> state=Rx<PageStateTrans>(PageStateTrans.list);
  RxInt currentPageIndex = 1.obs;
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  var isChecked=false.obs;
  var isLoading=false.obs;
  var startDateFilter=''.obs;
  var endDateFilter=''.obs;
  final RemittanceRepository remittanceRepository=RemittanceRepository();
  final TextEditingController nameFilterController=TextEditingController();
  final TextEditingController mobileFilterController=TextEditingController();
  final TextEditingController dateStartController=TextEditingController();
  final TextEditingController dateEndController=TextEditingController();
  final TextEditingController dateController=TextEditingController();
  final TextEditingController namePayerController=TextEditingController();
  final TextEditingController nameRecieptController=TextEditingController();
  RxnInt sortColumnIndex = RxnInt();
  RxBool sortAscending = true.obs;
  TransactionRepository transactionRepository=TransactionRepository();
  ScrollController scrollController = ScrollController();
  final TextEditingController searchController=TextEditingController();
  RxList<TransactionModel> transactionList = <TransactionModel>[].obs;
  final TextEditingController nameController=TextEditingController();
  final TextEditingController phoneController=TextEditingController();
  final TextEditingController addressController=TextEditingController();
  RxList<String> imageList = <String>[].obs;
  PaginatedModel? paginated;
  var sort = true.obs; // or `false`...
  var errorMessage = "".obs;
  var sortIndex = 0.obs; // or `false`...
  final PageController pageController = PageController();
  RxInt currentImagePage = 0.obs;
  @override
  void onInit() {
    super.onInit();
    fetchTransactionList();
  }

  void onSort(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    // if (columnIndex == 1) { // Date column
    //   remittanceList.sort((a, b) {
    //     if (a.date == null || b.date == null) return 0;
    //     return ascending ? a.date!.compareTo(b.date!) : b.date!.compareTo(a.date!);
    //   });
    // }else if (columnIndex == 2) { // Name column
    //   remittanceList.sort((a, b) {
    //     final aName = a.createdBy?.name ?? 'نامشخص';
    //     final bName = b.createdBy?.name ?? 'نامشخص';
    //     return ascending ? aName.compareTo(bName) : bName.compareTo(aName);
    //   });
    // }
  }

  setSort(int index,bool val){
    sort.value= val;
    sortIndex.value= index;
    update();
  }

  void isChangePage(int index){
    currentPage.value=index*10-10;
    itemsPerPage.value=index*10;
    fetchTransactionList();
  }

  void clearSearch() {
    currentPage.value = 1;
    nameController.clear();
    fetchTransactionList();
  }

  // لیست عکس ها
  Future<void> getImage(String fileName,String type) async{
    print('تعداد image:');
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    imageList.clear();
    try{
      var fetch=await remittanceRepository.getImage(fileName: fileName, type: type);
      imageList.addAll(fetch.guidIds );
      print('تعداد image:${imageList.first}');
      imageList.refresh();
      update();
    }
    catch(e){
      //  state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      EasyLoading.dismiss();
    }
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
  // لیست تراکنش ها ها
  Future<void> fetchTransactionList()async{
    try{
      state.value=PageStateTrans.loading;
      var response=await transactionRepository.getTransactionList(
          currentPage.value,
          itemsPerPage.value,
      );
      transactionList.assignAll((response.transactionJournals??[]));
      print(transactionList.length);
      paginated=response.paginated;
      state.value=PageStateTrans.list;
    }
    catch(e){
      state.value=PageStateTrans.err;
    }
  }

}