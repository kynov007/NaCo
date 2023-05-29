import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:project_sampah/app_color.dart';
import 'package:project_sampah/custom_widget.dart';
import 'package:project_sampah/model/data_notifikasi.dart';
import 'package:project_sampah/model/data_sampah.dart';
import 'package:project_sampah/utility.dart';

import '../main.dart';
import '../routes.dart';

class NotificationListPage extends StatefulWidget {
  const NotificationListPage(
      {Key? key,
      this.receivedAction,
      this.buttonIndex,
      this.notifYangBelumDilihat,
      this.allDataNotif})
      : super(key: key);
  final ReceivedAction? receivedAction;
  final int? buttonIndex;
  final Map<String, dynamic>? allDataNotif;
  final Map<String, dynamic>? notifYangBelumDilihat;

  @override
  State<NotificationListPage> createState() => _NotificationListPage();
}

class _NotificationListPage extends State<NotificationListPage>
    with SingleTickerProviderStateMixin {
  late final TabController notifTabController;
  int tabIndex = 0;
  String notifKey = '';
  bool isNotifClicked = false;
  Map<String, dynamic> allNotifData = {};
  String sampahKey = '';
  // Map<String, dynamic> historyData = {};
  late List<Color>? cardColor;
  // List<DataSampah> historyList = [];

  @override
  void initState() {
    super.initState();
    notifTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    notifTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    allNotifData.addAll(DataNotifikasi.instance.data);
    // historyData.addAll(DataNotifikasi.instance.notificationHistory);

    if (widget.buttonIndex == null) {
      if (widget.receivedAction == null) {
        // debugPrint('[notification_list_page] [${DateTime.now()}] received action is null');
        tabIndex = 0;
      } else {
        debugPrint(
            '[notification_list_page] [${DateTime.now()}] received action not null');
        debugPrint(widget.receivedAction.toString());

        /// masuk ke part ini jika notif di pencet
        tabIndex = widget.receivedAction?.payload!["isSampahOrganik"] == "true"
            ? 0
            : 1;
        notifKey = widget.receivedAction!.payload!["notifKey"]!;
      }
    } else {
      debugPrint('[notification_list_page] widget.buttonIndex not null');
      tabIndex = widget.buttonIndex!;
    }

    notifTabController.animateTo(tabIndex);

    return SafeArea(
      child: Scaffold(
          body: FutureBuilder(
              future: Utility.ambilDataSampahDariDatabase(),
              builder: (context, AsyncSnapshot snapshot) {
                debugPrint('snapshot data');
                debugPrint(snapshot.data.toString());
                return Column(
                  children: [
                    Container(
                      height: 60,
                      width: double.maxFinite,
                      color: Colors.grey[200],
                      child: TabBar(
                        controller: notifTabController,
                        labelColor: ButtonColor,
                        unselectedLabelColor: greyColor,
                        indicatorColor: Colors.blue,
                        onTap: (newIndex) {
                          debugPrint(
                              'tapped index: ${notifTabController.index}');
                        },
                        tabs: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Tab(
                                  text: 'Sampah Organik',
                                  icon: Icon(Icons.apple)),
                              DataNotifikasi.instance
                                          .getJumlahNotifikasiSampahOrganik >
                                      0
                                  ? CustomWidget.buildCircleContainer(
                                      text: DataNotifikasi.instance
                                          .getJumlahNotifikasiSampahOrganik
                                          .toString())
                                  : const SizedBox()
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Tab(
                                  text: 'Sampah Non Organik',
                                  icon: Icon(Icons.delete)),
                              DataNotifikasi.instance
                                          .getJumlahNotifikasiSampahNonOrganik >
                                      0
                                  ? CustomWidget.buildCircleContainer(
                                      text: DataNotifikasi.instance
                                          .getJumlahNotifikasiSampahNonOrganik
                                          .toString())
                                  : const SizedBox()
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: double.maxFinite,
                        child: TabBarView(
                          controller: notifTabController,
                          children: [...contentView(snapshot)],
                        ),
                      ),
                    )
                  ],
                );
              })),
    );
  }

  List<Widget> contentView(AsyncSnapshot snapshot) {
    List<Widget> hasil = List.generate(2, (index) => const Text('init value'));

    if (snapshot.connectionState == ConnectionState.waiting) {
      debugPrint('snapshot waiting');
      hasil[0] = const Center(
          child: Text(
        'Loading data sampah Organik',
        style: TextStyle(color: Colors.black),
      ));
      hasil[1] = const Center(
          child: Text(
        'Loading data sampah Non Organik',
        style: TextStyle(color: Colors.black),
      ));
    } else {
      debugPrint('snapshot waiting is finish');
      if (snapshot.hasData) {
        hasil[0] = buildListSampahExpansionTile(isSampahOrganik: true);
        hasil[1] = buildListSampahExpansionTile(isSampahOrganik: false);
      } else {
        if (snapshot.data == null) {
          hasil[0] = const Center(
              child: Text(
            'Data sampah organik kosong',
            style: TextStyle(color: Colors.black),
          ));
          hasil[1] = const Center(
              child: Text(
            'Data sampah Non Organik kosong',
            style: TextStyle(color: Colors.black),
          ));
        } else if (snapshot.hasError) {
          hasil[0] = const Center(
              child: Text(
            'Loading data sampah Organik GAGAL',
            style: TextStyle(color: Colors.black),
          ));
          hasil[1] = const Center(
              child: Text(
            'Loading data sampah Non Organik GAGAL',
            style: TextStyle(color: Colors.black),
          ));
        }
      }
    }

    return hasil;
  }

  buildListSampahExpansionTile({required bool isSampahOrganik}) {
    int beratSampah = 0;
    String tglDibuat = '';
    Color? itemColor;
    // bool warnai = false;
    String key = "";

    debugPrint(
        'filtered organik length: ${filteredSampah.sampahOrganik.length} / non organik length: ${filteredSampah.sampahNonOrganik.length}');
    return ListView.builder(
        itemCount: isSampahOrganik
            ? filteredSampah.sampahOrganik.length
            : filteredSampah.sampahNonOrganik.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, index) {
          if (isSampahOrganik) {
            beratSampah = filteredSampah.sampahOrganik[index].beratSampah;
            sampahKey = filteredSampah.sampahOrganik[index].key;
            itemColor =
                notifKey == filteredSampah.historySampahOrganik[index].key &&
                        isNotifClicked == false
                    ? Colors.amberAccent
                    : null;
          } else {
            beratSampah = filteredSampah.sampahNonOrganik[index].beratSampah;
            sampahKey = filteredSampah.sampahNonOrganik[index].key;
            itemColor =
                notifKey == filteredSampah.historySampahNonOrganik[index].key &&
                        isNotifClicked == false
                    ? Colors.amberAccent
                    : null;
          }

          // key = notifKey == "" ? sampahKey : notifKey;
          key = sampahKey;
          tglDibuat = sampahKey.substring(0, 19);

          return Card(
            color: itemColor,
            child: ExpansionTile(
              backgroundColor: Colors.transparent,
              // minLeadingWidth: 0,
              leading: CustomWidget.buildCircleContainer(
                  text: '${index + 1}',
                  warna: Colors.blueGrey,
                  height: double.maxFinite),
              title: Text('Berat Sampah $beratSampah gram'),
              subtitle: Text('Tanggal dibuat: $tglDibuat'),
              children: [
                ...buildHistoryNotifInfo(
                    index: index, key: key, isSampahOrganik: isSampahOrganik)
              ],
            ),
          );
        });
  }

  List<Widget> buildHistoryNotifInfo(
      {required int index,
      required String key,
      required bool isSampahOrganik}) {
    List<Widget> hasil = [];
    // debugPrint('[notification_list_page] index: $index');
    debugPrint(
        'history data value / organik length: ${filteredSampah.historySampahOrganik.length}');
    debugPrint(
        'history data value / non organik length: ${filteredSampah.historySampahNonOrganik.length}');

    /// jika nilai key ada di data sampah
    if (filteredSampah.allDataSampah.containsKey(key)) {
      debugPrint('[notification_listt_page] history data for key: $key:');

      /// cari notif key yang sama di notif history dengan variabel key
      if (isSampahOrganik) {
        hasil.addAll(buildListTileContent(
            isSampahOrganik: isSampahOrganik,
            listHistorySampah: filteredSampah.historySampahOrganik,
            key: key));
      } else {
        hasil.addAll(buildListTileContent(
            isSampahOrganik: isSampahOrganik,
            listHistorySampah: filteredSampah.historySampahNonOrganik,
            key: key));
      }
    }

    return hasil;
  }

  Widget buildListTile(
      {required String title,
      required String subtitle,
      required bool isSampahOrganik,
      required String key,
      required Map<String, dynamic> dataToSend}) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 40),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () async {
        // unViewedItems.remove(key);

        setState(() {
          notifKey = "";
          isNotifClicked = true;
          isSampahOrganik
              ? (key == sampahKey
                  ? DataNotifikasi.instance.jumlahNotifSampahOrganik--
                  : null)
              : (key == sampahKey
                  ? DataNotifikasi.instance.jumlahNotifSampahNonOrganik--
                  : null);
        });

        /// ************ nilai untuk halaman detail notifikasi ************** ///
        // final Map<String, dynamic> argumentData = {
        //   "jlhHari": durasi.inMinutes.toString(),
        //   "em4": "Nilai em4 100 (masih manual)",
        //   "molase": "NIlai molase 500 (masih manual)"
        // };

        MyHomePage.navigatorKey.currentState?.pushNamedAndRemoveUntil(
            Routes.routeDetailNotifPage,
            (route) =>
                (route.settings.name != Routes.routeDetailNotifPage) ||
                route.isFirst,
            arguments: dataToSend);
      },
    );
  }

  List<Widget> buildListTileContent(
      {required bool isSampahOrganik,
      required List<DataSampah> listHistorySampah,
      required String key}) {
    List<Widget> hasil = [];
    String waktuNotifString = '';
    Duration? durasi;
    String historyTitle = '';
    String historySubtitle = '';
    Map<String, dynamic> argumentData = {};
    int historyCount = 0;
    // List<String> titleList = [];
    // int totalHistoryCocok = 0;

    /// looping pertama untuk mengecek berapa jumlah history yang sesuai dengan key
    // for (int i=0; i < listHistorySampah.length; i++) {
    //   if (listHistorySampah[i].key == key) {
    //     totalHistoryCocok++;
    //   }
    // }

    for (int i = 0; i < listHistorySampah.length; i++) {
      if (listHistorySampah[i].key == key) {
        historyCount++;

        historyTitle = historyCount == 1
            ? 'Hari ke-1'
            : historyCount == 2
                ? 'Hari ke-7'
                : 'Hari ke-14';
        // titleList.add(historyTitle);

        // debugPrint('DataNotifikasi.instance.data[key]');
        // debugPrint(DataNotifikasi.instance.data[key]);
        // waktuNotifString = filteredSampah.allDataSampah[key]['notification_date'] ?? DateTime.now().toString();
        waktuNotifString =
            DataNotifikasi.instance.data[key]['jadwal_notifikasi'];
        // durasi = DateTime.now().difference(DateTime.parse(waktuNotifString)); // waktu sekarang dikurangi waktu notifikasi / waktu sebelah kiri dikurangi waktu sebelah kanan
        //  durasi = DateTime.parse("2023-05-26 12:00:00").difference(DateTime.parse("2023-05-27 12:00:00")); // output = -1 hari jika durasi.inDays
        durasi = DateTime.parse(waktuNotifString).difference(DateTime.now());
        // int notifStatus = DataNotifikasi.instance.data[key]['notif_status']; /// notif status antara 1, 7, dan 14

        // debugPrint('durasi: ${durasi.inMinutes}');
        final isTimeOut = durasi.inMinutes < 0 ? true : false;
        final newtime = waktuNotifString.substring(0, 10);
        // print('history length: ${listHistorySampah.length}');
        // if (totalHistoryCocok == 1) {
        //     historySubtitle = isTimeOut ? 'time out' : 'Jadwal selanjutnya $newtime (${durasi.inMinutes} hari lagi)';
        // }
        // else if (totalHistoryCocok == 2) {
        //   if (historyCount == 1) {
        //       historySubtitle = 'Time out';
        //   }
        //   else {
        //       historySubtitle = isTimeOut ? 'time out' : 'Jadwal selanjutnya $newtime (${durasi.inMinutes} hari lagi)';
        //   }
        // }
        // else {
        //   historySubtitle = historyCount == 1 || historyCount == 2 ? 'time out' : historySubtitle = newtime;
        // }

        // debugPrint('history subtitle');
        // debugPrint(historySubtitle);

        argumentData = {
          "jlhHari": historyTitle,
          "em4": "Nilai em4 100 (masih manual)",
          "molase": "NIlai molase 500 (masih manual)"
        };

        hasil.add(buildListTile(
            title: historyTitle,
            subtitle: historySubtitle,
            isSampahOrganik: isSampahOrganik,
            key: key,
            dataToSend: argumentData));
      }
    }

    return hasil;
  }
}
