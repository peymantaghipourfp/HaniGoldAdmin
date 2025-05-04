

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hanigold_admin/src/config/repository/deposit_request.repository.dart';
import 'package:hanigold_admin/src/config/repository/reason_rejection.repository.dart';
import 'package:hanigold_admin/src/config/repository/withdraw.repository.dart';
import 'package:hanigold_admin/src/config/repository/withdraw_getOne.repository.dart';
import 'package:hanigold_admin/src/domain/account/model/account.model.dart';
import 'package:hanigold_admin/src/domain/remittance/model/balance.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/deposit_request.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/controller/withdraw_getOne.controller.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/filter.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/options.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/predicate.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/reason_rejection.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/reason_rejection_req.model.dart';
import 'package:hanigold_admin/src/domain/withdraw/model/withdraw.model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import '../../../config/network/error/network.error.dart';
import '../../../config/repository/account.repository.dart';
import '../../../config/repository/item.repository.dart';
import '../../../config/repository/remittance.repository.dart';
import '../../product/model/item.model.dart';
import '../model/remittance.model.dart';


enum PageState{loading,err,empty,list}

class RemittanceController extends GetxController{

  Rx<PageState> state=Rx<PageState>(PageState.list);
  RxInt currentPage = 1.obs;
  RxInt itemsPerPage = 10.obs;
  RxBool hasMore = true.obs;
  RxBool isOpenMore = false.obs;
  RxBool isOpenMoreB = false.obs;
  final RemittanceRepository remittanceRepository=RemittanceRepository();
  final AccountRepository accountRepository=AccountRepository();
  final ItemRepository itemRepository=ItemRepository();
  ScrollController scrollController = ScrollController();
  final TextEditingController searchController=TextEditingController();
  final TextEditingController searchControllerP=TextEditingController();
  final TextEditingController dateController=TextEditingController();
  final TextEditingController namePayerController=TextEditingController();
  final TextEditingController mobilePayerController=TextEditingController();
  final TextEditingController quantityPayerController=TextEditingController();
  RxList<String> getList = RxList([]);
  RxList<RemittanceModel> remittanceList = RxList([]);
  final List<AccountModel> accountList=<AccountModel>[].obs;
  final List<ItemModel> itemList=<ItemModel>[].obs;
  final List<AccountModel> accountListP=<AccountModel>[].obs;
  var errorMessage=''.obs;
  final Rxn<AccountModel> selectedAccount = Rxn<AccountModel>();
  final Rxn<AccountModel> selectedAccountP = Rxn<AccountModel>();
  RxList<AccountModel> searchedAccounts = <AccountModel>[].obs;
  RxList<AccountModel> searchedAccountsP = <AccountModel>[].obs;
  final Rxn<ItemModel> selectedItem=Rxn<ItemModel>();
  BalanceModel? balanceModel;
  String? indexAccountPayerGet;
  var namePayer="".obs;
  var mobilePayer="".obs;
  getAccountPayer(String index){
    indexAccountPayerGet=index;
    for(int i=0;i<accountList.length;i++){
      if(accountList[i].id==int.parse(index)){
        namePayer.value=accountList[i].name!;
        namePayerController.text=accountList[i].name!;
        mobilePayerController.text=accountList[i].contactInfo??"";

        mobilePayer.value=accountList[i].contactInfo??"";
      }
    }
    update();
    print(namePayer.value);

  }
  void changeSelectedItem(ItemModel? newValue) {
    selectedItem.value = newValue;
  }


  void changeSelectedAccount(AccountModel? newValue) {
    selectedAccount.value = newValue;
    // selectedWalletAccount.value = null;
    // getWalletAccount(selectedAccount.value?.id ?? 0);
  }
  void changeSelectedAccountP(AccountModel? newValue) {
    selectedAccountP.value = newValue;
    // selectedWalletAccount.value = null;
    // getWalletAccount(selectedAccount.value?.id ?? 0);
  }
  void resetAccountSearch() {
    searchController.clear();
    searchedAccounts.assignAll(accountList);
  }
  void resetAccountSearchP() {
    searchControllerP.clear();
    searchedAccountsP.assignAll(accountList);
  }
  String? indexAccountRecieptGet;
  getAccountReciept(String index){
    indexAccountRecieptGet=index;
    update();
  }

  String? indexProductGet;
  getProduct(String index){
    indexProductGet=index;
    update();
  }

  setStateRemittance(PlutoGridOnLoadedEvent event){
    stateManager = event.stateManager;
    stateManager.setShowColumnFilter(true);
    update();
  }

  @override
  void onInit() {
    searchController.addListener(onSearchChanged);
    searchControllerP.addListener(onSearchChangedP);
    fetchRemittanceList();

    fetchItemList();
    fetchAccountList("");
    super.onInit();
  }

  Timer? debounce;
  void onSearchChanged(){
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce=Timer(const Duration(milliseconds: 500), () async {
      final query = searchController.text.trim();
      if (query.isEmpty) {
        searchedAccounts.assignAll(accountList);
        state.value = PageState.list;
        return;
      }
      await fetchAccountList(query);

    });
  }
Timer? debounceP;

  void onSearchChangedP(){
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce=Timer(const Duration(milliseconds: 500), () async {
      final query = searchControllerP.text.trim();
      if (query.isEmpty) {
        searchedAccountsP.assignAll(accountList);
        state.value = PageState.list;
        return;
      }
      await fetchAccountListP(query);

    });
  }


  // لیست محصولات
  Future<void> fetchItemList() async{
    try{
     // state.value=PageState.loading;
      var fetchedItemList=await itemRepository.getItemList();
      itemList.assignAll(fetchedItemList);
      itemList.removeWhere((e) => e.price==null,);
    //  state.value=PageState.list;
      if(itemList.isEmpty){
     //   state.value=PageState.empty;
      }
    }
    catch(e){
     // state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{

    }
  }



  // لیست حواله
  Future<void> fetchRemittanceList() async{
    print("kkkkkkkkkk");
    remittanceList.clear();
    try{
      state.value=PageState.loading;
      var fetchedAccountList=await remittanceRepository.getRemittanceList();
      remittanceList.addAll(fetchedAccountList);
      print(fetchedAccountList.first.balanceReciept);
      state.value=PageState.list;

      if(remittanceList.isEmpty){
        state.value=PageState.empty;
      }
     // remittanceList.refresh();
      update();
    }
    catch(e){
      state.value=PageState.err;
    }finally{
    }
  }

  // لیست کاربران
  Future<void> fetchAccountList(String name) async{
    try{
   //   state.value=PageState.loading;
      var fetchedAccountList=await accountRepository.searchAccountListNew(name);
      accountList.assignAll(fetchedAccountList);
      searchedAccounts.assignAll(fetchedAccountList);
    //  state.value=PageState.list;
      if(accountList.isEmpty){
     //   state.value=PageState.empty;
      }
      print('تعداد :${accountList.length}');
    }
    catch(e){
    //  state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
    }
  }

  Future<void> fetchAccountListP(String name) async{
    try{
     // state.value=PageState.loading;
      var fetchedAccountList=await accountRepository.searchAccountListNew(name);
      accountListP.assignAll(fetchedAccountList);
      searchedAccountsP.assignAll(fetchedAccountList);
     // state.value=PageState.list;
      if(accountList.isEmpty){
      //  state.value=PageState.empty;
      }
      print('تعداد :${accountList.length}');
    }
    catch(e){
     // state.value=PageState.err;
      errorMessage.value=" خطایی هنگام بارگذاری به وجود آمده است ${e.toString()}";
    }finally{
    }
  }


  List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
        title: 'ثبت کننده',
        readOnly: true,
        field: 'register',
        type: PlutoColumnType.text(),
        backgroundColor: AppColor.textFieldColor,
        renderer: (rendererContext) {
          return Text(
            textAlign: TextAlign.right,
            rendererContext.cell.value.toString(),
            style: AppTextStyle.labelText.copyWith(fontSize: 12,
                fontWeight: FontWeight.bold,color: AppColor.textColor ),
          );
        }
    ),
    PlutoColumn(
        title: 'بدهکار',
        field: 'Reciept',
        type: PlutoColumnType.text(),
        readOnly: true,
        backgroundColor: AppColor.textFieldColor,
        renderer: (rendererContext) {
          return Text(
            textAlign: TextAlign.right,
            rendererContext.cell.value.toString(),
            style: AppTextStyle.labelText.copyWith(fontSize: 12,
                fontWeight: FontWeight.bold,color: AppColor.accentColor ),
          );
        }
    ),
    PlutoColumn(
        title: 'بستانکار',
        field: 'Payer',
        readOnly: true,
        type: PlutoColumnType.text(),
        backgroundColor: AppColor.textFieldColor,
        renderer: (rendererContext) {
          return Text(
            textAlign: TextAlign.right,
            rendererContext.cell.value.toString(),
            style: AppTextStyle.labelText.copyWith(fontSize: 12,
                fontWeight: FontWeight.bold,color: AppColor.primaryColor ),
          );
        }
    ),
    PlutoColumn(
        title: 'محصول',
        field: 'Product',
        readOnly: true,
        type: PlutoColumnType.text(),
        backgroundColor: AppColor.textFieldColor,
        renderer: (rendererContext) {
          return Text(
            textAlign: TextAlign.right,
            rendererContext.cell.value.toString(),
            style: AppTextStyle.labelText.copyWith(fontSize: 12,
                fontWeight: FontWeight.bold,color: AppColor.iconViewColor ),
          );
        }
    ),
    PlutoColumn(
        title: 'مبلغ/مقدار',
        field: 'Total',
        readOnly: true,
        type: PlutoColumnType.text(),
        backgroundColor: AppColor.textFieldColor,
        renderer: (rendererContext) {
          return Text(
            textAlign: TextAlign.right,
            rendererContext.cell.value.toString(),
            style: AppTextStyle.labelText.copyWith(fontSize: 12,
              fontWeight: FontWeight.bold, ),
          );
        }
    ),
    PlutoColumn(
        title: 'وضعیت',
        field: 'Status',
        readOnly: true,
        backgroundColor: AppColor.textFieldColor,
        type: PlutoColumnType.select(<String>[
          'نامشخص',
          'تایید نشده',
          'تایید شده',
        ]),
        renderer: (rendererContext) {
          return Text(
            textAlign: TextAlign.right,
            rendererContext.cell.value.toString(),
            style: AppTextStyle.labelText.copyWith(fontSize: 12,
                fontWeight: FontWeight.bold,
                color:rendererContext.cell.value! =="تایید شده"?AppColor.secondary2Color: AppColor.accentColor

            ),
          );
        }
    ),
    PlutoColumn(
        title: 'شرح',
        field: 'Description',
        readOnly: true,
        type: PlutoColumnType.text(),
        backgroundColor: AppColor.textFieldColor,

        renderer: (rendererContext) {
          return Text(
            textAlign: TextAlign.right,
            rendererContext.cell.value.toString(),
            style: AppTextStyle.labelText.copyWith(fontSize: 10,
              fontWeight: FontWeight.normal, ),
          );
        }
    ),
    PlutoColumn(
        title: 'تاریخ ایجاد',
        field: 'DateTime',
        readOnly: true,
        type: PlutoColumnType.date(),
        backgroundColor: AppColor.textFieldColor,
        renderer: (rendererContext) {
          return Text(
            textAlign: TextAlign.right,
            rendererContext.cell.value.toString(),
            style: AppTextStyle.labelText.copyWith(fontSize: 12,
              fontWeight: FontWeight.bold, ),
          );
        }

    ),
     PlutoColumn(
       title: 'Action',
       field: 'Action',
       type: PlutoColumnType.text(),
       enableRowDrag: false,
       enableDropToResize: false,
       enableEditingMode: false,
       width: 150,
         renderer: (rendererContext) {
           return Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               IconButton(
                 icon: Icon(Icons.edit, color: Colors.blue),
                 onPressed: () => print(rendererContext.row.type),
               ),
               IconButton(
                 icon: Icon(Icons.delete, color: Colors.red),
                 onPressed: () => print(rendererContext.row.type),
               ),
             ],
           );
         }
     ),

     // PlutoColumn(
    //   title: 'salary',
    //   field: 'salary',
    //   type: PlutoColumnType.currency(),
    //   footerRenderer: (rendererContext) {
    //     return PlutoAggregateColumnFooter(
    //       rendererContext: rendererContext,
    //       formatAsCurrency: true,
    //       type: PlutoAggregateColumnType.sum,
    //       format: '#,###',
    //       alignment: Alignment.center,
    //       titleSpanBuilder: (text) {
    //         return [
    //           const TextSpan(
    //             text: 'Sum',
    //             style: TextStyle(color: Colors.red),
    //           ),
    //           const TextSpan(text: ' : '),
    //           TextSpan(text: text),
    //         ];
    //       },
    //     );
    //   },
    // ),
  ];



  late PlutoGridStateManager stateManager;


}