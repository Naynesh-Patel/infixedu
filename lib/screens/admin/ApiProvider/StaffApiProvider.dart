// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:Saksham/utils/Utils.dart';
import 'package:Saksham/utils/apis/Apis.dart';
import 'package:Saksham/utils/model/LeaveAdmin.dart';
import 'package:Saksham/utils/model/LibraryCategoryMember.dart';
import 'package:Saksham/utils/model/Staff.dart';
import 'package:http/http.dart' as http;

// Project imports:


class StaffApiProvider {
  String token = '';

  Future<LibraryMemberList> getAllCategory() async {
    await Utils.getStringValue('token').then((value) {
      token = value ?? '';
    });
    final response = await http.get(Uri.parse(InfixApi.getStuffCategory),headers: Utils.setHeader(token));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return LibraryMemberList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<StaffList> getAllStaff(dynamic staffId) async {
    await Utils.getStringValue('token').then((value) {
      token = value ?? '';
    });
    final response = await http.get(
        Uri.parse(InfixApi.getAllStaff(staffId)),
        headers: Utils.setHeader(token));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return StaffList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<LeaveAdminList> getAllLeave(String url, String endPoint) async {
    await Utils.getStringValue('token').then((value) {
      token = value ?? '';
    });
    final response =
        await http.get(Uri.parse(url), headers: Utils.setHeader(token));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return LeaveAdminList.fromJson(jsonData['data'][endPoint]);
    } else {
      throw Exception('Failed to load');
    }
  }
}
