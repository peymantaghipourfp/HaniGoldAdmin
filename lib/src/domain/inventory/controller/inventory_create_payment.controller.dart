

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:printing/printing.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/inventory.repository.dart';
import 'package:hanigold_admin/src/config/repository/laboratory.repository.dart';
import 'package:hanigold_admin/src/domain/inventory/controller/inventory.controller.dart';
import 'package:hanigold_admin/src/domain/inventory/model/inventory.model.dart';
import 'package:hanigold_admin/src/domain/inventory/model/inventory_detail.model.dart';
import 'package:hanigold_admin/src/domain/wallet/model/wallet_account_req.model.dart';
import 'package:pdf/pdf.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/account.repository.dart';
import '../../../config/repository/upload.repository.dart';
import '../../../config/repository/user_info_transaction.repository.dart';
import '../../../config/repository/wallet.repository.dart';
import '../../../utils/convert_Jalali_to_gregorian.component.dart';
import '../../account/model/account.model.dart';
import '../../laboratory/model/laboratory.model.dart';
import '../../users/model/balance_item.model.dart';
import '../../users/model/paginated.model.dart';
import '../../wallet/model/wallet.model.dart';
import '../../withdraw/model/filter.model.dart';
import '../../withdraw/model/options.model.dart';
import '../../withdraw/model/predicate.model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_svg/svg.dart';

enum PageState{loading,err,empty,list}

class InventoryCreatePaymentController extends GetxController{

  final InventoryController inventoryController=Get.find<InventoryController>();

  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchLaboratoryController=TextEditingController();
  final TextEditingController quantityController=TextEditingController();
  final TextEditingController impurityController=TextEditingController();
  final TextEditingController weight750Controller=TextEditingController();
  final TextEditingController caratController=TextEditingController();
  final TextEditingController receiptNumberController=TextEditingController();
  final TextEditingController dateController=TextEditingController();
  final TextEditingController descriptionController=TextEditingController();

  final AccountRepository accountRepository=AccountRepository();
  final WalletRepository walletRepository=WalletRepository();
  final InventoryRepository inventoryRepository=InventoryRepository();
  final LaboratoryRepository laboratoryRepository=LaboratoryRepository();
  UserInfoTransactionRepository userInfoTransactionRepository=UserInfoTransactionRepository();
  final UploadRepositoryDesktop uploadRepositoryDesktop=UploadRepositoryDesktop();

  final List<AccountModel> accountList=<AccountModel>[].obs;
  final List<WalletModel> walletAccountList=<WalletModel>[].obs;
  final List<LaboratoryModel> laboratoryList=<LaboratoryModel>[].obs;
  final List<InventoryDetailModel> forPaymentList=<InventoryDetailModel>[].obs;
  final List<BalanceItemModel> balanceList=<BalanceItemModel>[].obs;

  Rx<PageState> state=Rx<PageState>(PageState.list);
  var errorMessage=''.obs;
  var isLoading=true.obs;
  var isLoadingBalance=true.obs;

  final Rxn<PaginatedModel> paginated = Rxn<PaginatedModel>();
  final Rxn<AccountModel> selectedAccount = Rxn<AccountModel>();
  final Rxn<WalletModel> selectedWalletAccount=Rxn<WalletModel>();
  final Rxn<LaboratoryModel> selectedLaboratory=Rxn<LaboratoryModel>();
  final Rxn<InventoryDetailModel> selectedInputItem=Rxn<InventoryDetailModel>();
  final RxList<InventoryDetailModel> tempDetails = <InventoryDetailModel>[].obs;
  final RxBool isFinalizing = false.obs;
  RxList<AccountModel> searchedAccounts = <AccountModel>[].obs;
  Timer? debounce;
  RxList<LaboratoryModel> searchedLaboratories = <LaboratoryModel>[].obs;
  RxInt editingIndex = RxInt(-1);
  RxBool isEditing = false.obs;
  final RxSet<int> selectedForPaymentId = RxSet<int>();
  RxInt selectedLaboratoryId = RxInt(0);
  final ImagePicker _picker = ImagePicker();
  RxList<XFile?> selectedImagesDesktop = RxList<XFile?>();
  RxList<bool> uploadStatusesDesktop = RxList<bool>();
  RxBool isUploadingDesktop = false.obs;
  List<Uint8List> selectedImagesBytes = [];
  List<String> selectedFileNames = [];
  var recordId="".obs;
  var uuid = Uuid();
  var factorChecked = false.obs;
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;

  void changeSelectedAccount(AccountModel? newValue) {
    selectedAccount.value = newValue;
    selectedWalletAccount.value = null;
    getWalletAccount(selectedAccount.value?.id ?? 0);
   // getBalanceList(newValue?.id ?? 0);
    isLoadingBalance.value=false;
  }

  void changeSelectedWalletAccount(WalletModel? newValue) {
    selectedWalletAccount.value = newValue;
    selectedLaboratoryId.value = 0;
    searchLaboratoryController.clear();
    getForPaymentListPager();

    print(selectedWalletAccount.value?.item?.id);
    print(selectedWalletAccount.value?.item?.name);
  }
  void changeSelectedLaboratory(LaboratoryModel? newValue) {
    selectedLaboratory.value=newValue;
  }

  void selectQuantity(double quantity){
    quantityController.text=quantity.toString();
    update();
  }

  void updateTempDetailQuantity(int index, double newQuantity) {
    if (index >= 0 && index < tempDetails.length) {
      final oldDetail = tempDetails[index];
      final newDetail = oldDetail.copyWith(quantity: newQuantity);
      tempDetails[index] = newDetail;
    }
  }
  void updateDetail(int index, String recId,List<XFile> listXfile) {
    if (index >= 0 && index < tempDetails.length) {
      final oldDetail = tempDetails[index];
      List<XFile> list = tempDetails[index].listXfile!=null?tempDetails[index].listXfile!:[];
       if(listXfile.isNotEmpty){
         list .addAll(listXfile);
       }
      final newDetail = oldDetail.copyWith(recId: recId,listXfile: list);
      tempDetails[index] = newDetail;
      print("reccccccc::${recId}");
      print("reccccciddd::${tempDetails[index].recId}");
     update();
    }
  }


  @override
  void onInit() {
    searchController.addListener(onSearchChanged);
    fetchAccountList();
    fetchWalletAccountList();
    getForPaymentListPager();
    var now = Jalali.now();
    DateTime date=DateTime.now();
    dateController.text =
    "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
    super.onInit();
  }
  @override
  void onClose() {
    debounce?.cancel();
    searchController.dispose();
    searchLaboratoryController.dispose();
    super.onClose();
  }

  // لیست کاربران
  Future<void> fetchAccountList() async{
    try{
      state.value=PageState.loading;
      var fetchedAccountList=await accountRepository.getAccountList("1");
      accountList.assignAll(fetchedAccountList);
      searchedAccounts.assignAll(fetchedAccountList);
      state.value=PageState.list;
      if(accountList.isEmpty){
        state.value=PageState.empty;
      }
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      isLoading.value=false;
    }
  }

  void onSearchChanged(){
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce=Timer(const Duration(milliseconds: 500), () async {
      final query = searchController.text.trim();
      if (query.isEmpty) {
        searchedAccounts.assignAll(accountList);
        state.value = PageState.list;
        return;
      }
      await searchAccountList(query);

    });
  }
  Future<void> searchAccountList(String name) async {
    try {
      isLoading.value = true;
      if (name.isEmpty) {
        searchedAccounts.assignAll(accountList);
        state.value = PageState.list;
        return;
      }
      final results = await accountRepository.searchAccountList(name,"1");
      searchedAccounts.assignAll(results);
      state.value = searchedAccounts.isEmpty ? PageState.empty : PageState.list;
    } catch (e) {
      Get.snackbar('خطا', 'خطا در جستجوی کاربران');
    } finally {
      isLoading.value = false;
    }
  }

  // مدل آپشن ولت
  WalletAccountReqModel? walletAccountReqModel;
  getWalletAccount(int id){
    walletAccountReqModel= WalletAccountReqModel(
        wallet: OptionsModel(
            orderBy: "wallet.Id",
            orderByType: "asc",
            startIndex: 1,
            toIndex: 10000,
            predicate: [PredicateModel(
                innerCondition: 0,
                outerCondition: 0,
                filters: [FilterModel(
                    fieldName: "AccountId",
                    filterValue: id.toString(),
                    filterType: 4,
                    refTable: "wallet"
                )
                ]
            )
            ]
        )
    );
    fetchWalletAccountList();
  }

  // لیست ولت اکانت
  Future<void> fetchWalletAccountList()async{
    try{
      state.value=PageState.loading;
      var fetchedWalletAccountList=await walletRepository.getWalletList(walletAccountReqModel!);
      walletAccountList.assignAll(fetchedWalletAccountList);
      state.value=PageState.list;
      if(walletAccountList.isEmpty){
        state.value=PageState.empty;
      }
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=e.toString();
    }
  }

  // لیست آزمایشگاه ها


  Future<void> searchLaboratory(String name) async {
    try {
      isLoading.value = true;
      if (name.isEmpty) {
        searchedLaboratories.clear();
      }
      final laboratory = await laboratoryRepository.searchLaboratoryList(name);
      searchedLaboratories.assignAll(laboratory);
    } catch (e) {
      Get.snackbar('خطا', 'خطا در جستجوی آزمایشگاه');
    } finally {
      isLoading.value = false;
    }
  }
  void selectLaboratory(LaboratoryModel laboratory) {

    selectedLaboratoryId.value = laboratory.id!;
    searchLaboratoryController.text = laboratory.name!;
    Get.back(); // Close search dialog
    getForPaymentListPager();
  }

  void clearSearch() {

    selectedLaboratoryId.value = 0;
    searchLaboratoryController.clear();
    searchedLaboratories.clear();
    getForPaymentListPager();
  }

  void isChangePage(int index){
    currentPage.value=index*10-10;
    itemsPerPage.value=index*10;
    getForPaymentListPager();
  }

  // لیست دریافتی ها
  /*Future<void> fetchForPaymentList()async{
    try{
      isLoading.value=true;
      state.value=PageState.loading;
      var fetchedForPaymentList=await inventoryRepository.getForPaymentlist(
          itemId:selectedWalletAccount.value?.item?.id ?? 0,
        laboratoryId: selectedLaboratoryId.value == 0
            ? null :selectedLaboratoryId.value
      );
      forPaymentList.assignAll(fetchedForPaymentList);
      state.value=PageState.list;
      if(forPaymentList.isEmpty){
        state.value=PageState.empty;
      }
    }
    catch(e){
      state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
      isLoading.value=false;
    }
  }*/

  // لیست دریافتی ها با صفحه بندی
  Future<void> getForPaymentListPager() async {
    print("### getForPaymentListPager ###");
    //isLoading.value=true;
    try {
      //state.value=PageState.loading;
      var response = await inventoryRepository.getForPaymentlistPager(
        startIndex: currentPage.value,
        toIndex: itemsPerPage.value,
          itemId:selectedWalletAccount.value?.item?.id ?? 0,
          laboratoryId: selectedLaboratoryId.value == 0
              ? null :selectedLaboratoryId.value
      );
      forPaymentList.clear();
      //isLoading.value=false;
      forPaymentList.addAll(response.inventories??[]);
      paginated.value=response.paginated;
      //state.value=PageState.list;
      update();
    }
    catch (e) {
      //state.value = PageState.err;
    } finally {}
  }

  Future<void> uploadImagesDesktop( String type, String entityType) async {
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      for(int i=0; i < tempDetails.length; i++){
        recordId.value=uuid.v4();
        if (tempDetails[i].listXfile==null){
          return;
        }
        else{
          isUploadingDesktop.value = true;
          uploadStatusesDesktop.assignAll(List.filled(tempDetails[i].listXfile!.length, false));
            for (int j = 0; j < tempDetails[i].listXfile!.length; j++) {
              final file = tempDetails[i].listXfile![j];
              try{
                final bytes = await file.readAsBytes();
                String success = await uploadRepositoryDesktop.uploadImageDesktop(
                  imageBytes: bytes,
                  fileName: file.name,
                  recordId: tempDetails[i].recId ?? '',
                  type: type,
                  entityType: entityType,
                );
                uploadStatusesDesktop[i] = success.isNotEmpty;
              }catch(e){
                EasyLoading.dismiss();
                Get.snackbar("خطا", "خطا در آپلود تصویر ${i + 1}");
              }
            }
            if (uploadStatusesDesktop.every((status) => status)) {
              EasyLoading.dismiss();
              Get.snackbar("موفقیت", "همه تصاویر با موفقیت آپلود شدند");
            }
        }
      }
    }finally{
      submitFinalInventory();
      EasyLoading.dismiss();
      isUploadingDesktop.value = false;
      selectedImagesDesktop.clear();
      uploadStatusesDesktop.clear();
    }

  }

// لیست موقت فاکتور
  Future<void> addToTempList() async {
    try {
      if (selectedAccount.value == null ||
          selectedWalletAccount.value == null ||
          quantityController.text.isEmpty) {
        throw ErrorException('لطفا فیلدهای ضروری را پر کنید');
      }

      final newDetail = InventoryDetailModel(
        wallet: selectedWalletAccount.value!,
        item: selectedWalletAccount.value!.item!,
        quantity: double.tryParse(quantityController.text.toEnglishDigit()) ?? 0.0,
        type: 1,
        impurity: double.tryParse(impurityController.text.toEnglishDigit()) ?? 0.0,
        weight750: double.tryParse(weight750Controller.text.toEnglishDigit()) ?? 0.0,
        carat: int.tryParse(caratController.text.toEnglishDigit()) ?? 0,
        receiptNumber: receiptNumberController.text,
        laboratory: selectedLaboratory.value,
        stateMode : 1,
        inputItemId: selectedWalletAccount.value!.item?.itemUnit?.id==2 ? selectedInputItem.value?.id : null,
        description: descriptionController.text,
      );

      tempDetails.add(newDetail);
      if (selectedInputItem.value?.id != null &&
          !selectedForPaymentId.contains(selectedInputItem.value!.id)) {
        selectedForPaymentId.add(selectedInputItem.value!.id!);
      }
      // ریست کردن فیلدها
      /*quantityController.clear();
      receiptNumberController.clear();
      descriptionController.clear();
      impurityController.clear();
      weight750Controller.clear();
      caratController.clear();
      selectedWalletAccount.value = null;
      selectedLaboratory.value=null;*/
      Get.snackbar("موفق", "آیتم به لیست موقت اضافه شد");
    } catch (e) {
      throw ErrorException('خطا در افزودن آیتم: ${e.toString()}');
    }
  }

  Future<InventoryModel?> submitFinalInventory()async{
    EasyLoading.show(status: 'لطفا منتظر بمانید');
    try{
      if (tempDetails.isEmpty) {
        throw ErrorException('لیست آیتم‌ها خالی است');
      }
      isLoading.value=true;
      isFinalizing.value=true;

      String gregorianDate = convertJalaliToGregorian(dateController.text);
      var response=await inventoryRepository.insertInventoryPayment(
        date: gregorianDate,
        accountId: selectedAccount.value?.id ?? 0,
        accountName: selectedAccount.value?.name ?? "",
        type: 1,
        details:tempDetails,
        recId: null
      );
      print(response);
      if (response != null) {
        //Get.back();
        tempDetails.clear();
        InventoryModel responseData=InventoryModel.fromJson(response);
        var inventoryDetails=responseData.inventoryDetails;
        Get.snackbar(responseData.infos?.first['title'], responseData.infos?.first["description"],
          titleText: Text(responseData.infos?.first['title'],
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.textColor),),
          messageText: Text(
            responseData.infos?.first["description"], textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.textColor),),
        );
        inventoryController.getInventoryListPager();

        // صدور فاکتور
        if(factorChecked.value==true){

          final ByteData fontData = await rootBundle.load('assets/fonts/IRANSansX-Regular.ttf');
          final ttf = pw.Font.ttf(fontData);
          final pdf = pw.Document();

          pdf.addPage(
            pw.MultiPage(
              pageFormat: PdfPageFormat.a4,
              textDirection: pw.TextDirection.rtl,
              theme: pw.ThemeData.withFont(base: ttf, fontFallback: [ttf]),
              build: (pw.Context context) {
                return [
                  buildInvoiceHeader(responseData),
                  pw.SizedBox(height: 20),
                  pw.Table(
                    border: pw.TableBorder.all(),
                    columnWidths: getInvoiceColumnWidths(),
                    children: [
                      buildInvoiceTableHeader(),
                      for (var i = 0; i < inventoryDetails!.length; i++)
                        buildInvoiceDataRow(inventoryDetails[i], i),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  buildInvoiceFooter(inventoryDetails),
                ];
              },
              footer: (context) => buildPageNumber(context.pageNumber, context.pagesCount),
            ),
          );
          final bytes = await pdf.save();
          if (kIsWeb) {
            final blob = html.Blob([bytes], 'application/pdf');
            final url = html.Url.createObjectUrlFromBlob(blob);
            html.AnchorElement(href: url)
              ..download = 'factorInventoryPayment_${DateTime.now().millisecondsSinceEpoch}.pdf'
              ..click();
            html.Url.revokeObjectUrl(url);
          } else {
            await Printing.sharePdf(
              bytes: bytes,
              filename: 'factorInventoryPayment.pdf',
            );
          }
        }
          Get.toNamed('/inventoryList');
          clearList();
      }
    }catch(e){
      EasyLoading.dismiss();
      throw ErrorException('خطا:$e');
    }finally{
      EasyLoading.dismiss();
      isLoading.value=false;
      isFinalizing.value=false;
    }
    return null;
  }

  pw.Widget buildInvoiceHeader(InventoryModel responseData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        /*pw.Row(
          children: [
            pw.Image(
              pw.MemoryImage(logoBytes),
              width: 100,
              height: 50,
            ),
            pw.SizedBox(width: 20),
            pw.Text('فاکتور رسمی', style: pw.TextStyle(fontSize: 24)),
          ],
        ),*/
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center,
          children:[
            pw.Text('فاکتور مشتری', style: pw.TextStyle(fontSize: 17)),
          ]
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('شماره فاکتور: ${responseData.id ?? '-'}',style: pw.TextStyle(fontSize: 12)),
            pw.Text('تاریخ: ${responseData.date?.toPersianDate(twoDigits: true) ?? '-'}',style: pw.TextStyle(fontSize: 12)),
          ],
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('نام مشتری: ${responseData.account?.name ?? '-'}',style: pw.TextStyle(fontSize: 12)),
            pw.Text('شناسه مشتری: ${selectedAccount.value?.id ?? '-'}',style: pw.TextStyle(fontSize: 12)),
          ],
        ),
        pw.Divider(thickness: 1),
      ],
    );
  }

  Map<int, pw.TableColumnWidth> getInvoiceColumnWidths() {
    return {
      0: pw.FlexColumnWidth(2.5),
      1: pw.FlexColumnWidth(2.5),
      4: pw.FlexColumnWidth(1.5),
    };
  }

  pw.TableRow buildInvoiceTableHeader() {
    return pw.TableRow(
      decoration: pw.BoxDecoration(color: PdfColors.grey300),
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(5.0),
          child: pw.Text('مقدار', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5.0),
          child: pw.Text('محصول', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5.0),
          child: pw.Text('ردیف', textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 8)),
        ),
      ],
    );
  }

  pw.TableRow buildInvoiceDataRow(InventoryDetailModel detail, int index) {
    return pw.TableRow(
      children: [
        buildDataCell(detail.quantity?.toString().seRagham(separator: ",") ?? ''),
        buildDataCell(detail.item?.name ?? ''),
        buildDataCell(detail.rowNum.toString(), isCenter: true),
      ],
    );
  }
  // ساخت سلول‌های داده
  pw.Padding buildDataCell(String text, {bool isCenter = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5.0),
      child: pw.Text(text,
        style: pw.TextStyle(fontSize: 8),
        textAlign:pw.TextAlign.center,
        textDirection: pw.TextDirection.rtl,
      ),
    );
  }

  pw.Widget buildPageNumber(int currentPage, int totalPages) {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Text(
        'صفحه ${currentPage.toString().toPersianDigit()} از ${totalPages.toString().toPersianDigit()}',
        style: pw.TextStyle(fontSize: 8),
      ),
    );
  }

  pw.Widget buildInvoiceFooter(List<InventoryDetailModel> details) {

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 40),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: [
            pw.Column(
              children: [
                pw.Text('امضا مسئول',style: pw.TextStyle(fontSize: 10)),
              ],
            ),
            pw.Column(
              children: [
                pw.Text('مهر و امضا مشتری',style: pw.TextStyle(fontSize: 10)),
              ],
            ),
          ],
        ),
      ],
    );
  }


  // لیست بالانس
  Future<void> getBalanceList(int id) async{
    print("getBalanceList : $id");
    balanceList.clear();
    try{
      state.value=PageState.loading;
      var response=await userInfoTransactionRepository.getBalanceList(id);
      balanceList.addAll(response);
      balanceList.removeWhere((r)=>r.balance==0);
      isLoadingBalance.value=true;
      state.value=PageState.list;
      if(balanceList.isEmpty){
        state.value=PageState.empty;
      }
      update();
    }
    catch(e){
      state.value=PageState.err;
    }finally{
    }
  }

  void clearList() {
    dateController.clear();
    quantityController.clear();
    descriptionController.clear();
    receiptNumberController.clear();
    impurityController.clear();
    weight750Controller.clear();
    caratController.clear();
    selectedWalletAccount.value=null;
    selectedAccount.value = null;
    selectedLaboratory.value=null;
    var now = Jalali.now();
    DateTime date=DateTime.now();
    dateController.text = "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
  }
  void resetFieldsForTab(int tabIndex) {
    //dateController.clear();
    quantityController.clear();
    descriptionController.clear();
    receiptNumberController.clear();
    impurityController.clear();
    weight750Controller.clear();
    caratController.clear();
    selectedWalletAccount.value=null;
    selectedAccount.value = null;
    selectedLaboratory.value=null;
    var now = Jalali.now();
    DateTime date=DateTime.now();
    dateController.text = "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
  }
  void clearItemFields() {
    quantityController.clear();
    impurityController.clear();
    weight750Controller.clear();
    caratController.clear();
    receiptNumberController.clear();
    selectedLaboratory.value = null;
  }
  void resetAccountSearch() {
    searchController.clear();
    searchedAccounts.assignAll(accountList);
  }
  void resetLaboratorySearch() {
    searchLaboratoryController.clear();
    searchedLaboratories.assignAll(laboratoryList);
  }


}
