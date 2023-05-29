import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:project_sampah/custom_widget.dart';

class KalkulasiPage extends StatelessWidget {
  const KalkulasiPage({Key? key, this.data}) : super(key: key);
  final Map? data;

  @override
  Widget build(BuildContext context) {
    /// mengambil nilai argument dari page sebelumnya (main_page)
    // final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomWidget.buildCurveTitle(title: 'Total yang \ndiperlukan'),
            const Flexible(
                child: SizedBox(
              height: 60,
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Center(
                    child: LottieBuilder.asset(
                      'assets/recycle.json',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            CustomWidget.customText(
                teks: 'Em4', fontSize: 26, color: Colors.black),
            const SizedBox(
              height: 20,
            ),
            CustomWidget.customContainer(teks: '${data?['em4'] ?? 'unset'} ml'),
            const SizedBox(
              height: 40,
            ),
            CustomWidget.customText(
                teks: 'Molase', fontSize: 26, color: Colors.black),
            const SizedBox(
              height: 20,
            ),
            CustomWidget.customContainer(
                teks: '${data?['molase'] ?? 'unset'} ml'),
          ],
        ),
      ),
    );
  }
}
