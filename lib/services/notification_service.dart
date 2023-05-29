import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class NotificationService {
  static ReceivedAction? initialAction;

  ///  *********************************************
  ///     INITIALIZATIONS
  ///  *********************************************
  ///
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
        null,
        //'resource://drawable/res_app_icon',//
        // 'resource://assets/images/recycle_pic',
        [
          NotificationChannel(
              channelKey: 'calculator_app',
              channelName: 'Alerts',
              channelDescription: 'Notification tests as alerts',
              playSound: true,
              // onlyAlertOnce: true,
              // groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.Max,
              // defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.deepPurple,
              // ledColor: Colors.deepPurple
              channelShowBadge: true
          )
        ],
        debug: true
    );

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications().getInitialNotificationAction(removeFromActionEvents: false);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS LISTENER
  ///  *********************************************
  ///  Notifications events are only delivered after call this method
  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications().setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS
  ///  *********************************************
  ///
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    if (receivedAction.channelKey == 'calculator_app') {
      // kurangi nilai counter badge tiap kali notifikasi dibuka
      AwesomeNotifications().getGlobalBadgeCounter().then((value) {
        if (value > 0) AwesomeNotifications().setGlobalBadgeCounter(value - 1);

        debugPrint('[notification_controller] badget count: $value');
      });
    }

    if (
    receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction
    ){
      // For background actions, you must hold the execution until the end
      debugPrint('Message sent via notification input: "${receivedAction.buttonKeyInput}"');
      await executeLongTaskInBackground();
    }
    else {
      // pindah ke halaman notification-page dan hapus semua halaman lain dari stack
      // selain halaman pertama atau halaman notification-page
      MyHomePage.navigatorKey.currentState?.pushNamedAndRemoveUntil('/notification-list-page', (route) =>
      (route.settings.name != '/notification-list-page') || route.isFirst,
          arguments: receivedAction
      );

    }
  }

  ///  *********************************************
  ///     REQUESTING NOTIFICATION PERMISSIONS
  ///  *********************************************
  ///
  static Future<bool> displayNotificationRationale() async {
    bool userAuthorized = false;
    BuildContext context = MyHomePage.navigatorKey.currentContext!;

    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Get Notified!', style: Theme.of(context).textTheme.titleLarge),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/animated-bell.gif',
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Izinkan aplikasi untuk menampilkan notifikasi!'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Tolak',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () async {
                    userAuthorized = true;
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Izinkan',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.deepPurple),
                  )),
            ],
          );
        });
    return userAuthorized && await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  ///  *********************************************
  ///     BACKGROUND TASKS TEST
  ///  *********************************************
  static Future<void> executeLongTaskInBackground() async {
    debugPrint("starting long task");
    await Future.delayed(const Duration(seconds: 20));
    // final url = Uri.parse("http://google.com");
    // final re = await http.get(url);
    // print(re.body);
    debugPrint("long task done");
  }

  ///  *********************************************
  ///     NOTIFICATION CREATION METHODS
  ///  *********************************************
  ///
  static Future<void> createNewNotification({
    required String notifTitle, required String notifBody,
    required String imageLocation, required String notifKey,
    required String isSampahOrganik,
    String? allNotifData
  }) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    debugPrint('[notification_service] new notification created');

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1, // -1 is replaced by a random number
            channelKey: 'calculator_app',
            // title: 'Huston! direct notif!',
            title: notifTitle,
            body: notifBody,
            // bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
            bigPicture: 'asset://$imageLocation',
            // largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
            //'asset://assets/images/balloons-in-sky.jpg',
            notificationLayout: NotificationLayout.BigPicture,
            payload: {'notifKey': notifKey, "isSampahOrganik": isSampahOrganik, "allNotifData": allNotifData ?? '{}'}
        ),
        // actionButtons: [
        //   NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
        //   NotificationActionButton(
        //       key: 'REPLY',
        //       label: 'Reply Message',
        //       requireInputText: true,
        //       actionType: ActionType.SilentAction
        //   ),
        //   NotificationActionButton(
        //       key: 'DISMISS',
        //       label: 'Dismiss',
        //       actionType: ActionType.DismissAction,
        //       isDangerousOption: true)
        // ]
    );
  }

  static Future<void> resetBadgeCounter() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  static Future<void> cancelNotifications() async {
    await AwesomeNotifications().cancelAll();
  }
}