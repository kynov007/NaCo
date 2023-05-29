import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:project_sampah/constant.dart';
import 'package:project_sampah/model/data_notifikasi.dart';
import 'package:project_sampah/routes.dart';
import 'package:project_sampah/services/notification_service.dart';
import 'package:project_sampah/utility.dart';

import 'package:workmanager/workmanager.dart';
import 'database_helper.dart';
import 'model/data_sampah.dart';

FilteredSampah filteredSampah = FilteredSampah();

// key: workmanager
@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // add code execution
      debugPrint('[${DateTime.now()}] background task executed');

      debugPrint('[main] input data value');
      debugPrint(inputData.toString());
      debugPrint('[main] workmanager task value: $task');

      /// load data dari storage/DB
      await Utility.init();

      await DataNotifikasi.instance.loadAndExtractNotifData();

      /// karena ketika tombol jumlah di pencet langsung mengeksekusi background task (callbackDispatcher) ini
      /// maka diperlukan untuk mengecek apakah tanggal/jam sekarang sudah melewati jadwal notifikasi / durasi frequency background task
      /// yang ada di key inputData['backgroundTaskFreq']

      /// pengecekan ini ditujukan agar ketika tombol jumlah dipencet tidak langsung menampilkan notifikasi
      final durasi = DateTime.parse(inputData!['backgroundTaskFreq'])
          .difference(
              DateTime.now()); // waktu notifikasi dikurangi waktu sekarang
      // const durasi = Duration(minutes: 0);

      debugPrint('[main] durasi in minute: ${durasi.inMinutes}');
      if (durasi.inMinutes <= 0) {
        // jika < 0 berarti waktu sekarang sudah melewati jadwal notifikasi

        /// cek history status di data notifikasi
        // String key = "2023-05-24 20:24:30.393815";
        String key = task;
        List<
            Map<String,
                dynamic>> data = await DatabaseHelper.instance.loadAllData(
            "SELECT key, notif_status, jadwal_notifikasi, is_sampah_organik FROM data_notifikasi WHERE key='$key' AND is_active = 1");
        // debugPrint('notif status $notifStatus');
        debugPrint('[main] data');
        debugPrint(data.toString());

        if (data.isNotEmpty) {
          int notifStatus = 1;
          String tipeSampah = "true";
          String jadwalNotifikasiSebelumnya = '';
          for (final val in data) {
            // if (val['key'] == key) {
            debugPrint(
                "[main] val['is_sampah_organik'] ${val['is_sampah_organik']}");
            notifStatus = val['notif_status'];
            tipeSampah = val['is_sampah_organik'] == 1 ? "true" : "false";
            jadwalNotifikasiSebelumnya = val['jadwal_notifikasi'];
            // }
          }
          // debugPrint('[main] tipe sampah: $tipeSampah');
          // debugPrint('[main] notif status sebelum update: $notifStatus');

          /// cek waktu sekarang dengan jadwalNotifikasi apakah waktu sekarang >= jadwalNotifikasi
          /// jika waktu sekarang >= jadwal notifikasi, maka tampilkan notifikasi
          /// jika waktu sekarang < jadwal notifikasi, maka notifikasi tidak ditampilkan
          final notifDurasiRemaining =
              DateTime.parse(jadwalNotifikasiSebelumnya)
                  .difference(DateTime.now());

          debugPrint(
              '[main] notif durasi remaining: ${notifDurasiRemaining.inMinutes}');
          if (notifDurasiRemaining.inMinutes <= 0) {
            debugPrint('[main] jadwal notifikasi sudah >= waktu sekarang');

            /// notif status = 1 --> baru sekali notif ditampilkan yaitu pada saat data disimpan
            /// notif status = 7 --> notif untuk hari ke 7
            /// notif status = 14 --> notif untuk hari ke 14
            final notifTitle = notifStatus == 1
                ? Constant.notifTitleHarike7
                : Constant.notifTitleHarike14;
            final notifBody = notifStatus == 1
                ? Constant.notifBodyHarike7
                : Constant.notifBodyHarike14;
            const imgLocation = Constant.imageNotifDays7;

            await NotificationService.createNewNotification(
                notifTitle: notifTitle,
                notifBody: notifBody,
                imageLocation: imgLocation,
                notifKey: task,
                isSampahOrganik: tipeSampah);

            Future.delayed(Duration.zero, () async {
              tipeSampah == 'true'
                  ? DataNotifikasi.instance.jumlahNotifSampahOrganik++
                  : DataNotifikasi.instance.jumlahNotifSampahNonOrganik++;
            });

            /// ubah nilai notif status sebelum disimpan ke database
            notifStatus = notifStatus == 1 ? 7 : 14;

            /// update data notifikasi di database untuk notif key yang sekarang
            Utility.updateDataNotifikasi(
                notifKey: key,
                notifTitle: notifTitle,
                notifBody: notifBody,
                jadwalNotifikasiBaru:
                    DateTime.now().add(Constant.durasiNotifikasi).toString(),
                isActive: notifStatus < 14 ? 1 : 0,
                isSudahDilihat: 0,
                viewedAt: 'unset',
                notifStatus: notifStatus);

            /// simpan history baru ke tabel history
            await Utility.simpanDataNotifHistoryKeDatabase(
                notifKey: key,
                notifDate: jadwalNotifikasiSebelumnya,
                notifiedAt: DateTime.now().toString(),
                notifStatus: notifStatus);

            /// reload kembali data dari database
            await DataNotifikasi.instance.loadAndExtractNotifData();

            if (notifStatus == 14) {
              debugPrint('[main] task & notif for notif key $task dimatikan');

              /// nonaktifkan schedule setelah 14 hari
              await Workmanager().cancelByUniqueName(task);
            }
          }
        } else {
          debugPrint('[main] Data for notif key: $task is empty');
        }
      }
    } catch (err) {
      Logger().e(err
          .toString()); // Logger flutter package, debugPrints error on the debug console
      debugPrint('[main] error in callbackDispatcher: $err');
      throw Exception(err);
    }

    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeLocalNotifications();
  await Utility.init();
  Utility.isShowIntro =
      Utility.preferences.getBool(Constant.isShowIntroKey) ?? true;
  runApp(const MyHomePage());
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       debugShowCheckedModeBanner: false,
//       routes: <String, WidgetBuilder>{
//         "/kalkulasi-page": (BuildContext context) => const KalkulasiPage(),
//         "/notification-list-page": (BuildContext context) => const NotificationListPage(),
//         "/notification-detail-page": (BuildContext context) => const NotificationDetailPage(),
//       },
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  // The navigator key is necessary to navigate using static methods
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Color mainColor = const Color(0xFF9D50DD);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  // static const routeHome = '/';
  // static const routeNotification = '/notification-list-page';
  // static const routeKalkulasiPage = '/kalkulasi-page';
  // static const routeDetailNotifPage = '/notification-detail-page';

  @override
  void initState() {
    super.initState();
    NotificationService.startListeningNotificationEvents();

    // key: workmanager
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode:
          false, // jika diaktifkan dan nilainya true, maka akan muncul notifikasi ketika task di eksekusi
    );
    debugPrint('[main] background service is running');
    asyncMethod();
    debugPrint('[main] notif data loaded in initState');
  }

  void asyncMethod() async {
    await DataNotifikasi.instance.loadAndExtractNotifData();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return const Scaffold(
  //     // appBar: AppBar(
  //     //   title: Text(widget.title),
  //     // ),
  //     body: MainPage()
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Awesome Notifications - Simple Example',
      navigatorKey: MyHomePage.navigatorKey,
      onGenerateInitialRoutes: Routes.onGenerateInitialRoutes,
      onGenerateRoute: Routes.onGenerateRoute,
      debugShowCheckedModeBanner: false,
      // routes: <String, WidgetBuilder>{
      //   "/kalkulasi-page": (BuildContext context) => const KalkulasiPage(),
      //   // "/notification-list-page": (BuildContext context) => NotificationListPage(receivedAction: receivedAction),
      //   "/notification-detail-page": (BuildContext context) => const NotificationDetailPage(),
      // },
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      // home: const MainPage(),
    );
  }
}
