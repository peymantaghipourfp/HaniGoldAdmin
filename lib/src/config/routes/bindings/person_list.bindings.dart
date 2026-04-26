import 'package:get/get.dart';
import '../../../domain/users/controller/person_list.controller.dart';

class PersonListBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>PersonListController());
    //Get.lazyPut(()=>HomeController());
  }

}