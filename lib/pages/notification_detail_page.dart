import 'package:flutter/material.dart';
import 'package:project_sampah/constant.dart';
import '../custom_widget.dart';

class NotificationDetailPage extends StatelessWidget {
  const NotificationDetailPage({Key? key, this.data}) : super(key: key);
  final Map? data;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            CustomWidget.buildCurveTitle(
                title: "${data!['jlhHari'] ?? 'unset'}",
                topPadding: 14,
                bottomPadding: 10,
                rightPadding: 50),
            const SizedBox(
              height: 60,
            ),
            const Text(
              'Pupuk kamu',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(data?['em4'] ?? 'unset'),
            Text(data?['molase'] ?? 'unset'),
            const SizedBox(
              height: 30,
            ),
            Image.asset(data!['jlhHari'] == 'Hari ke-1'
                ? Constant.imageNotifDay1
                : data!['jlhHari'] == 'Hari ke-7'
                    ? Constant.imageNotifDays7
                    : Constant.imageNotifDays14)
          ],
        ),
      ),
    );
  }
}
