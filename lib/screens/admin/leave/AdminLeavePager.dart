// Flutter imports:
import 'package:Saksham/screens/admin/Bloc/LeaveListBloc.dart';
import 'package:Saksham/utils/Utils.dart';
import 'package:Saksham/utils/model/LeaveAdmin.dart';
import 'package:Saksham/utils/widget/LeaveRowLayout.dart';
import 'package:flutter/material.dart';

// Project imports:


// ignore: must_be_immutable
class AdminLeavePage extends StatefulWidget {
  String url;
  String endPoint;

  AdminLeavePage(this.url, this.endPoint, {Key? key}) : super(key: key);

  @override
  _AdminLeavePageState createState() => _AdminLeavePageState();
}

class _AdminLeavePageState extends State<AdminLeavePage> {
  StuffLeaveListBloc? bloc;

  @override
  void initState() {
    super.initState();
    bloc = StuffLeaveListBloc(widget.url, widget.endPoint);
    bloc?.getStaffLeaveList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: StreamBuilder<LeaveAdminList>(
        stream: bloc?.getStaffLeaveSubject.stream,
        builder: (context, snap) {
          if (snap.hasData) {
            if (snap.error != null) {
              return _buildErrorWidget(snap.error.toString());
            }
            if (snap.data!.leaves.isEmpty) {
              return Utils.noDataWidget();
            }

            return ListView.builder(
              itemCount: snap.data?.leaves.length,
              itemBuilder: (context, index) {
                return LeaveRowLayout(snap.data?.leaves[index] ?? LeaveAdmin());
              },
            );
          } else if (snap.hasError) {
            return _buildErrorWidget(snap.error.toString());
          } else {
            return _buildLoadingWidget();
          }
        },
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Error occured: $error"),
      ],
    ));
  }
}
