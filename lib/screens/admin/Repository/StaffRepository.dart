// Project imports:
import 'package:Saksham/screens/admin/ApiProvider/StaffApiProvider.dart';
import 'package:Saksham/utils/model/LeaveAdmin.dart';
import 'package:Saksham/utils/model/LibraryCategoryMember.dart';
import 'package:Saksham/utils/model/Staff.dart';

class StaffRepository {
  final StaffApiProvider _provider = StaffApiProvider();

  Future<LibraryMemberList> getStaff() {
    return _provider.getAllCategory();
  }

  Future<StaffList> getStaffList(int id) {
    return _provider.getAllStaff(id);
  }

  Future<LeaveAdminList> getStaffLeave(String url, String endPoint) {
    return _provider.getAllLeave(url, endPoint);
  }
}
