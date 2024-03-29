// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:Saksham/utils/CustomAppBarWidget.dart';
import 'package:Saksham/utils/FunctinsData.dart';
import 'package:Saksham/utils/widget/Routine_row.dart';

// ignore: must_be_immutable
class Routine extends StatelessWidget {
  List<String> weeks = AppFunction.weeks;
  String? id;

  Routine({Key? key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Routine'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: weeks.length,
          itemBuilder: (context, index) {
            return RoutineRow(
              title: weeks[index],
              id: id ?? '',
            );
          },
        ),
      ),
    );
  }
}
