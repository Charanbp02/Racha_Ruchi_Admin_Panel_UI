import 'package:get/get.dart';
import 'package:racha_ruchi_admin_panel/Modules/Pending_Approval/controller/pending_approval_controller.dart';

class PendingApprovalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PendingApprovalController>(() => PendingApprovalController());
  }
}
