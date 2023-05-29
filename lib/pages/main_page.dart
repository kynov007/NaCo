// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:project_sampah/constant.dart';
import 'package:project_sampah/model/data_notifikasi.dart';
import 'package:project_sampah/model/data_sampah.dart';
import 'package:project_sampah/utility.dart';

import 'package:workmanager/workmanager.dart';
import '../app_color.dart';
import '../custom_widget.dart';
import '../main.dart';
import '../routes.dart';
import '../services/notification_service.dart';
// import '../services/notification_service.dart';
// import '../services/notification_service.dart';

enum JenisHitung { hitungSampahOrganik, hitungLainnya }

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageNewState();
}

class _MainPageNewState extends State<MainPage> {
  List<bool> isButtonActive = [true, false];
  JenisHitung jenisHitung = JenisHitung.hitungSampahOrganik;
  String judul = 'Sampah';
  late final TextEditingController beratSampah;
  // int jlhSampahOrganik = 0, jlhSampahNonOrganik = 0;
  int jlhNotifikasi = 0;
  int btnIndex =
      0; // untuk menampung index button / menu mana yang sedang aktif
  double screenHeight = 0;
  double screenWidth = 0;
  double appBarHeight = 0;

  final iconList = [Icons.delete, Icons.local_florist_outlined];

  @override
  void initState() {
    super.initState();
    beratSampah = TextEditingController();

    // FilteredSampah.initFilterSampah();
    // jlhSampahOrganik = FilteredSampah.jumlahSampahOrganik;
    // jlhSampahNonOrganik = FilteredSampah.jumlahSampahNonOrganik;

    // print('jumlah sampah organik: $jlhSampahOrganik');
    // print('jumlah sampah Non organik: $jlhSampahNonOrganik');

    jlhNotifikasi = DataNotifikasi.instance.getJumlahNotifikasiSampahOrganik;
  }

  @override
  void dispose() {
    beratSampah.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appBarHeight = AppBar().preferredSize.height;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    judul =
        jenisHitung == JenisHitung.hitungSampahOrganik ? 'Sampah' : 'Lainnya';
    jlhNotifikasi = jenisHitung == JenisHitung.hitungSampahOrganik
        ? DataNotifikasi.instance.getJumlahNotifikasiSampahOrganik
        : DataNotifikasi.instance.getJumlahNotifikasiSampahNonOrganik;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: btnIndex,
        onTap: (int newIndex) {
          setState(() {
            onTapButton(newIndex);
          });
        },
        backgroundColor: Colors.white60,
        gapLocation: GapLocation.center,
        leftCornerRadius: 22,
        rightCornerRadius: 22,
        activeColor: ButtonColor,
        iconSize: 36,
        inactiveColor: greyColor,
      ),
      body: buildRightMenu(context),
      // body: Row(
      //   children: [
      //     buildLeftMenu(),
      //     SingleChildScrollView(
      //       child: Container(
      //         height: screenHeight,
      //         width: screenWidth * 0.8,
      //         decoration: const BoxDecoration(
      //           color: AppColor.mainColor,
      //           // border: Border.all(color: Colors.red)
      //         ),
      //         child: buildRightMenu(context),
      //       ),
      //     )
      //   ],
      // ),
    );
  }

  buildButton(int buttonIndex, IconData buttonIcon) {
    return RawMaterialButton(
      onPressed: () {
        // gunakan fungsi setState untuk merefresh widget
        setState(() {
          // jika tombol atas dipilih
          if (buttonIndex == 0) {
            isButtonActive[0] = true;
            isButtonActive[1] = false;

            // jika tombol atas dipilih maka ubah jenisHitung menjadi hitungSampah
            jenisHitung = JenisHitung.hitungSampahOrganik;

            // jlhNotifikasi = FilteredSampah.jumlahSampahOrganik;
            jlhNotifikasi =
                DataNotifikasi.instance.getJumlahNotifikasiSampahOrganik;
          } else {
            isButtonActive[0] = false;
            isButtonActive[1] = true;
            jenisHitung = JenisHitung.hitungLainnya;
            // jlhNotifikasi = FilteredSampah.jumlahSampahNonOrganik;
            jlhNotifikasi =
                DataNotifikasi.instance.getJumlahNotifikasiSampahNonOrganik;
          }

          btnIndex = buttonIndex;
          beratSampah.clear();
        });

        // print('button index: $buttonIndex / isbutton active: $isButtonActive');
      },
      elevation: 2.0,
      fillColor: isButtonActive[buttonIndex] == true ? Colors.white : null,
      padding: const EdgeInsets.all(12.0),
      shape: const CircleBorder(),
      child: Icon(
        buttonIcon,
        size: 45.0,
      ),
    );
  }

  Function? onTapButton(int index) {
    btnIndex = index;
    beratSampah.clear();

    if (index == 0) {
      jenisHitung = JenisHitung.hitungSampahOrganik;
      // jlhNotifikasi = FilteredSampah.jumlahSampahOrganik;
      jlhNotifikasi = DataNotifikasi.instance.getJumlahNotifikasiSampahOrganik;
    } else {
      jenisHitung = JenisHitung.hitungLainnya;
      // jlhNotifikasi = FilteredSampah.jumlahSampahNonOrganik;
      jlhNotifikasi =
          DataNotifikasi.instance.getJumlahNotifikasiSampahNonOrganik;
    }

    return null;
  }

  buildLeftMenu() {
    return Container(
        height: screenHeight,
        width: screenWidth * 0.2,
        decoration: const BoxDecoration(color: Colors.teal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 60,
            ),
            buildButton(0, Icons.delete),
            const SizedBox(
              height: 40,
            ),
            buildButton(1, Icons.local_florist_outlined),
          ],
        ));
  }

  buildRightMenu(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: screenHeight - appBarHeight,
        width: double.maxFinite,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),

            /// ************* Icon Lonceng Notifikasi ***************** ///
            Row(
              children: [
                const Expanded(child: SizedBox()),
                Stack(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      child: const Icon(
                        Icons.notifications_none,
                        size: 50,
                      ),
                      onTap: () {
                        // Navigator.of(context).pushNamed(Routes.routeNotification, arguments: {"buttonIndex": btnIndex});

                        MyHomePage.navigatorKey.currentState
                            ?.pushNamedAndRemoveUntil(
                                Routes.routeNotification,
                                (route) =>
                                    (route.settings.name !=
                                        Routes.routeNotification) ||
                                    route.isFirst,
                                arguments: {
                              'manualClick': true,
                              'buttonIndex': btnIndex
                            });
                      },
                    ),
                    Positioned(
                        left: 0,
                        top: 10,
                        child: jlhNotifikasi > 0
                            ? CustomWidget.buildCircleContainer(
                                text: jlhNotifikasi.toString())
                            : const SizedBox())
                  ],
                )
              ],
            ),
            Text(
              "Selamat Datang",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 100,
            ),
            Container(
              padding: EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width * 0.9,
              height: 200,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(10, 10), // changes position of shadow
                  ),
                ],
                color: whiteColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  CustomWidget.customText(teks: judul, color: blackColor),
                  const SizedBox(
                    height: 50,
                  ),

                  /// ********** Inputan Jumlah Sampah *********** ///
                  Container(
                    height: 80,
                    width: 260,
                    // decoration: BoxDecoration(
                    //   border: Border.all(color: Colors.red)
                    // ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 80,
                          child: Center(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: beratSampah,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  fillColor: greyColor,
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: greyColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: greyColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                    bottom: 40 /
                                        2, // tinggi sizedbox dibagi 2, agar posisi teks ketengah vertikal
                                  )),
                            ),
                          ),
                        ),
                        CustomWidget.customText(
                            teks: 'Gram', color: blackColor),
                      ],
                    ),
                  ),

                  const Flexible(
                      child: SizedBox(
                    height: 300,
                  )),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.22),

            /// ********** Button Jumlah *********** ///
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 50,
              child: RawMaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  ),
                  fillColor: ButtonColor,
                  child: CustomWidget.customText(
                      teks: 'Jumlah', color: whiteColor),
                  onPressed: () {
                    onPressedButton(context);
                  }),
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Map<String, int> hitungEm4DanMolase({required int gramSampah}) {
    // const nilaiDefaultEm4 = 50;
    // const nilaiDefaultMolase = 70;

    int hasilEm4 = (gramSampah / 1000).floor() * Constant.nilaiDefaultEm4;
    int hasilMolase = (gramSampah / 100).floor() * Constant.nilaiDefaultMolase;

    return {'em4': hasilEm4, 'molase': hasilMolase};
  }

  void onPressedButton(BuildContext context) async {
    if (beratSampah.text.isEmpty) return;

    String gram = "";
    // cek nilai yang diinput, abaikan jika ada karakter selain angka 0..9
    for (int i = 0; i < beratSampah.text.length; i++) {
      // 48 adalah nilai ascii untuk char 0, 49 = 1, 50 = 2, dst...
      for (int x = 48; x < 58; x++) {
        if (beratSampah.text[i] == String.fromCharCode(x)) {
          // print('x: $x is integer');
          gram += beratSampah.text[i];
          break;
        }
      }
    }

    if (gram == "") return;

    // ambil nilai yang diinput yang sudah difilter dan ubah ke integer
    final nilaiGram = int.parse(gram);
    // print('nilai gram $nilaiGram');

    // hitung nilai gram yang diinput menggunakan rumus yang sudah dibuat
    final hasilHitung = hitungEm4DanMolase(gramSampah: nilaiGram);

    final tglSekarang = DateTime.now();
    late DataSampah dataSampahBaru;

    // update jumlah sampah sesuai dengan jenis sampah
    if (jenisHitung == JenisHitung.hitungSampahOrganik) {
      dataSampahBaru = DataSampah(
          beratSampah: nilaiGram,
          jenisSampah: 'sampah organik',
          createdAt: tglSekarang,
          key: tglSekarang.toString());
      // filteredSampah.sampahOrganik.add(dataSampahBaru);
      DataNotifikasi.instance.jumlahNotifSampahOrganik++;
    } else {
      dataSampahBaru = DataSampah(
          beratSampah: nilaiGram,
          jenisSampah: 'sampah non organik',
          createdAt: tglSekarang,
          key: tglSekarang.toString());
      // filteredSampah.sampahNonOrganik.add(dataSampahBaru);
      DataNotifikasi.instance.jumlahNotifSampahNonOrganik++;
    }

    await Utility.simpanDataSampahKeDatabase(dataSampah: dataSampahBaru);
    await Utility.ambilDataSampahDariDatabase();

    await Utility.simpanDataNotifikasiKeDatabase(dataSampah: dataSampahBaru);
    await Utility.ambilDataNotifikasiDariDatabase();

    await NotificationService.createNewNotification(
        notifTitle: Constant.notifTitleKetikaInputData,
        notifBody: Constant.notifBodyKetikaInputData,
        imageLocation: Constant.imageNotifDay1,
        notifKey: dataSampahBaru.key,
        isSampahOrganik:
            dataSampahBaru.jenisSampah == 'sampah organik' ? "true" : "false");

    await Utility.simpanDataNotifHistoryKeDatabase(
        notifKey: dataSampahBaru.key,
        notifDate: tglSekarang.toString(),
        notifiedAt: DateTime.now().toString(),
        notifStatus:
            1 // nilai notif status = 1 ketika input data pertama kali, karena 1 = hari ke 1, 7 = hari ke 7, 14 = hari ke 14
        );

    await Utility.ambilDataNotifHistoryDariDatabase();

    /// simpan data notifikasi baru
    // await DataNotifikasi.instance.addNewNotification(dataSampah: dataSampahBaru);

    setState(() {
      // jlhNotifikasi = jenisHitung == JenisHitung.hitungSampahOrganik ? FilteredSampah.jumlahSampahOrganik : FilteredSampah.jumlahSampahNonOrganik;
      jlhNotifikasi = jenisHitung == JenisHitung.hitungSampahOrganik
          ? DataNotifikasi.instance.getJumlahNotifikasiSampahOrganik
          : DataNotifikasi.instance.getJumlahNotifikasiSampahNonOrganik;
    });

    /// buat jadwal task background
    await Workmanager().registerPeriodicTask(
        tglSekarang.toString(), tglSekarang.toString(),
        frequency: Constant.backgroundTaskFrequency,
        inputData: {
          'taskKey': tglSekarang.toString(),
          // 'notifSchedule': tglSekarang.add(Constant.durasiNotifikasi).toString(),
          'backgroundTaskFreq':
              tglSekarang.add(Constant.backgroundTaskFrequency).toString(),
        });

    // pindah ke page hasil hitung dan tampilkan datanya
    // Navigator.of(context).pushNamed("/kalkulasi-page", arguments: hasilHitung);
    MyHomePage.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        Routes.routeKalkulasiPage,
        (route) =>
            (route.settings.name != Routes.routeKalkulasiPage) || route.isFirst,
        arguments: hasilHitung);
  }
}
