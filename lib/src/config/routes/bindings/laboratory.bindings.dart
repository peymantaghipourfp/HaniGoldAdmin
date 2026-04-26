import 'package:get/get.dart';
import '../../../domain/laboratory/controller/laboratory.controller.dart';

class LaboratoryBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>LaboratoryController());
    //Get.lazyPut(()=>HomeController());
  }

}