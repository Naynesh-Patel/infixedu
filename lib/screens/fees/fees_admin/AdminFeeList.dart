// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:Saksham/utils/CustomAppBarWidget.dart';
import 'package:Saksham/utils/Utils.dart';
import 'package:Saksham/utils/apis/Apis.dart';
import 'package:Saksham/utils/model/AdminFees.dart';
import 'package:Saksham/utils/widget/Admin_Fees_List_Row.dart';

class AdminFeeListView extends StatefulWidget {
  const AdminFeeListView({Key? key}) : super(key: key);

  @override
  _AdminFeeListViewState createState() => _AdminFeeListViewState();
}

class _AdminFeeListViewState extends State<AdminFeeListView> {
  Future<AdminFeesList>? fees;

  String? _token;

  @override
  void initState() {
    super.initState();
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value ?? '';
        fees = getAllFee();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(
          title: 'Fee Type',
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder<AdminFeesList>(
          future: fees,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: snapshot.data?.adminFees.length ?? 0,
                itemBuilder: (context, index) {
                  return AdminFeesListRow(snapshot.data?.adminFees[index] ?? AdminFees());
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Future<AdminFeesList> getAllFee() async {
    final response = await http.get(Uri.parse(InfixApi.adminFeeList),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return AdminFeesList.fromjson(jsonData['feesGroups']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
