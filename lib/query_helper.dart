class QueryHelper {

  static const String createTabelSampah = '''
      CREATE TABLE "data_sampah" (
        "key"	TEXT,
        "id"	INTEGER,
        "jenis"	TEXT,
        "berat"	INTEGER,
        "created_at"	TEXT,
        PRIMARY KEY("id" AUTOINCREMENT)
      );
  ''';

  static const String createTableNotifikasi = '''
      CREATE TABLE "data_notifikasi" (
        "id"	INTEGER,
        "key"	TEXT,
        "created_at"	TEXT,
        "notif_title" TEXT,
        "notif_body" TEXT,
        "jadwal_notifikasi" TEXT,
        "is_sampah_organik" TEXT,
        "sudah_dilihat"	INTEGER,
        "is_active" INTEGER,
        "viewed_at" TEXT,
        "notif_status" INTEGER, 
        PRIMARY KEY("id" AUTOINCREMENT)
      );
  ''';

  static const String createTabelNotifHistory = '''
      CREATE TABLE "notif_history" (
        "key"	TEXT,
        "id"	INTEGER,
        "notification_date"	TEXT,
        "notified_at"	TEXT,
        "sudah_dilihat"	INTEGER,
        "viewed_at" TEXT,
        "notif_status" INTEGER,
        PRIMARY KEY("id" AUTOINCREMENT)
      );
  ''';

  ///Notes:
  /// - untuk nilai integer data tidak perlu di apit dengan tanda petik
  /// - untuk nilai notif_status --> 1 = notif pertama kali ketika data disimpan, 7 = notif untuk hari ke7, 14 = notif untuk hari ke-14

  /// ************************* INSERT QUERY ****************************** ///

  static String insertDataSampah({required String key, required String jenisSampah, required int berat, required String createdAt}) {
    return "INSERT INTO data_sampah (key, jenis, berat, created_at) VALUES ('$key', '$jenisSampah', $berat, '$createdAt')";
  }

  static String insertDataNotifikasi({required String notifKey, required String notifTitle, required String notifBody, required String jadwalNotif, required int isSampahOrganik}) {
    return "INSERT INTO data_notifikasi (key, notif_title, notif_body, jadwal_notifikasi, is_sampah_organik, sudah_dilihat, is_active, viewed_at, notif_status) VALUES ('$notifKey', '$notifTitle', '$notifBody', '$jadwalNotif', $isSampahOrganik, 0, 1, 'unset', 1)"; // nilai awal sudah dilihat selalu 0 artinya belum dilihat ketika pertama kali insert data notif
  }

  static String insertDataNotifHistory({required String notifKey, required String notificationDate, required String notifiedAt, required int notifStatus}) {
    return "INSERT INTO notif_history (key, notification_date, notified_at, sudah_dilihat, viewed_at, notif_status) VALUES ('$notifKey', '$notificationDate', '$notifiedAt', 0, 'unset', $notifStatus)"; // nilai sudah_dilihat pasti 0 ketika baru input data dan nilai viewed_at = unset ketika pertama kali data disimpan
  }

  /// ************************* UPDATE QUERY ****************************** ///

  static String updateDataNotifikasi({required String notifKey, required String notifTitle, required String notifBody, required String jadwalNotifikasiBaru, required int isActive, required int isSudahDilihat, required String viewedAt, required int notifStatus}) {
    return "UPDATE data_notifikasi SET notif_title='$notifTitle', notif_body='$notifBody', jadwal_notifikasi='$jadwalNotifikasiBaru', is_active=$isActive, sudah_dilihat=$isSudahDilihat, viewed_at='$viewedAt', notif_status=$notifStatus WHERE key='$notifKey'";
  }

  static String updateDataNotifHistory({required String notifKey, required int sudahDilihat, required String viewedAt, required int notifStatus}) {
    return "UPDATE notif_history SET sudah_dilihat=$sudahDilihat, viewed_at=$viewedAt, notif_status=$notifStatus WHERE key='$notifKey'";
  }

}