import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:project_sampah/pages/intro_page.dart';
import 'package:project_sampah/pages/kalkulasi_page.dart';
import 'package:project_sampah/pages/main_page.dart';
import 'package:project_sampah/pages/notification_detail_page.dart';
import 'package:project_sampah/pages/notification_list_page.dart';
import 'package:project_sampah/services/notification_service.dart';
import 'package:project_sampah/utility.dart';

class Routes {
  static const routeHome = '/';
  static const routeNotification = '/notification-list-page';
  static const routeKalkulasiPage = '/kalkulasi-page';
  static const routeDetailNotifPage = '/notification-detail-page';

  static List<Route<dynamic>> onGenerateInitialRoutes(String initialRouteName) {
    List<Route<dynamic>> pageStack = [];

    pageStack
        .add(MaterialPageRoute(builder: (_) => const NotificationListPage()));

    pageStack.add(MaterialPageRoute(builder: (_) => const KalkulasiPage()));

    pageStack.add(MaterialPageRoute(
        builder: (_) =>
            Utility.isShowIntro ? const IntroPage() : const MainPage()));

    // pageStack.add(
    //     MaterialPageRoute(builder: (_) => const IntroPage())
    // );

    if (initialRouteName == routeNotification &&
        NotificationService.initialAction != null) {
      pageStack.add(MaterialPageRoute(
          builder: (_) => NotificationListPage(
              receivedAction: NotificationService.initialAction!)));
    }
    return pageStack;
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // switch (settings.name) {
    //   case routeHome:
    //     return MaterialPageRoute(builder: (_) => const MainPage());
    //
    //   case routeNotification:
    //       ReceivedAction receivedAction = settings.arguments as ReceivedAction;
    //       return MaterialPageRoute(builder: (_) =>
    //           NotificationListPage(receivedAction: receivedAction));
    //
    //   case routeDetailNotifPage:
    //     return MaterialPageRoute(builder: (_) => const NotificationDetailPage());
    // }
    // return null;
    // debugPrint('[main] onGenerateRoute:');
    // print(settings);

    if (settings.name == routeHome) {
      return MaterialPageRoute(builder: (_) => const MainPage());
    } else if (settings.name == routeDetailNotifPage) {
      final data = settings.arguments as Map;
      return MaterialPageRoute(
          builder: (_) => NotificationDetailPage(data: data));
    } else if (settings.name == routeNotification) {
      // debugPrint('[routes] routing to notification page list');
      // final String tempUnviewedNotif = Utility.preferences.getString(Constant.dataUnviewedNotif) ?? '{}';
      // final unCheckNotif = jsonDecode(tempUnviewedNotif);
      // final unCheckNotif = DataNotifikasi.instance.unViewedNotif;
      // print('[routes] uncheck notif');
      // print(unCheckNotif);

      try {
        /// coba ubah settings.argument menjadi ReceivedAction
        /// jika error, berarti pindah ke halaman list notifikasinya adalah dengan cara di pencet icon lonceng
        /// jika tidak error, berarti pindah ke halaman list notifikasinya adalah dengan cara pencet notifikasi
        ReceivedAction receivedAction = settings.arguments as ReceivedAction;

        // if (receivedAction.payload != null) {
        // print('[routes] receivedAction.payload');
        // print(receivedAction.payload);
        // print(receivedAction.payload!['notifKey']);
        // print(receivedAction.payload!['notifKey'].toString());

        // DataNotifikasi.instance.kurangiJumlahNotif(sampahKey: receivedAction.payload!['notifKey'].toString());
        // }
        // print('[routes] unviewed notif');
        // print(DataNotifikasi.instance.unViewedNotif);

        // Map<String, dynamic> data = {};
        // data.addAll(DataNotifikasi.instance.data);
        // print('[routes] data value');
        // print(data);
        // for (final notifKey in DataNotifikasi.instance.unViewedNotif.keys) {
        //   // print(DataNotifikasi.instance.data[notifKey]);
        //   data[notifKey] = DataNotifikasi.instance.data[notifKey];
        // }

        return MaterialPageRoute(
            builder: (_) =>
                NotificationListPage(receivedAction: receivedAction));
      } catch (error) {
        debugPrint('[routes] error: $error');
        final int btnIndex = (settings.arguments as Map)['buttonIndex'] ?? 0;
        return MaterialPageRoute(
            builder: (_) => NotificationListPage(buttonIndex: btnIndex));
      }
    } else if (settings.name == routeKalkulasiPage) {
      Map data = settings.arguments as Map;
      // print('[main] settings argument as map');
      // print(data);
      return MaterialPageRoute(builder: (_) => KalkulasiPage(data: data));
    }

    return null;
  }
}
