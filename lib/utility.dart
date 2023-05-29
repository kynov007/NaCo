import 'package:flutter/material.dart';
import 'package:project_sampah/constant.dart';
import 'package:project_sampah/database_helper.dart';
import 'package:project_sampah/model/data_notifikasi.dart';
import 'package:project_sampah/query_helper.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'model/data_sampah.dart';

class Utility {
  static late SharedPreferences preferences;
  static bool isShowIntro = false;

  static Future<void> init() async {
    await DatabaseHelper.instance.database;
    // filteredSampah.initFilterSampah();
    preferences = await SharedPreferences.getInstance();
  }

  static Future<void> simpanDataSampahKeDatabase(
      {required DataSampah dataSampah}) async {
    final String query = QueryHelper.insertDataSampah(
        key: dataSampah.key,
        jenisSampah: dataSampah.jenisSampah,
        berat: dataSampah.beratSampah,
        createdAt: dataSampah.createdAt.toString());

    // print('[utility] query data sampah');
    // print(query);

    await DatabaseHelper.instance.insertSingleData(queryAndData: query);
  }

  static Future<Map<String, dynamic>> ambilDataSampahDariDatabase() async {
    Map<String, dynamic> hasil = {};
    List<Map<String, dynamic>> semuaDataSampah =
        await DatabaseHelper.instance.loadAllData('SELECT * FROM data_sampah');

    filteredSampah.sampahOrganik.clear();
    filteredSampah.sampahNonOrganik.clear();

    for (final dbData in semuaDataSampah) {
      // print('[utility] dbData');
      // print(dbData);
      /// kumpulkan key data sampah
      hasil[dbData.values.first] = dbData; // dbData.values.first = key

      if (hasil[dbData.values.first]['jenis'] == 'sampah organik') {
        // print('organik');
        filteredSampah.sampahOrganik.add(DataSampah(
          beratSampah: dbData['berat'],
          jenisSampah: dbData['jenis'],
          createdAt: DateTime.parse(dbData['created_at']),
          key: dbData['key'],
        ));
      } else {
        // print('non organik / ${hasil["jenis"]}');
        // filteredSampah.sampahNonOrganik.add(Utility.convertMapToDataSampah(dbData));
        filteredSampah.sampahNonOrganik.add(DataSampah(
            beratSampah: dbData['berat'],
            jenisSampah: dbData['jenis'],
            createdAt: DateTime.parse(dbData['created_at']),
            key: dbData['key']));
      }
    }

    filteredSampah.allDataSampah.addAll(hasil);

    // print('[utility] list key in all data sampah');
    String daftarKey = '';
    for (final data in filteredSampah.allDataSampah.keys) {
      // print(data); // 2023-05-25 06:12:03.707079
      // print(filteredSampah.allDataSampah[data]); // {key: 2023-05-25 06:12:03.707079, id: 1, jenis: sampah organik, berat: 343, created_at: 2023-05-25 06:12:03.707079}
      daftarKey += "'$data', ";
    }

    /// hapus 2 karakter akhir di daftar key (karakter koma dan spasi)
    daftarKey = daftarKey.substring(0, daftarKey.length - 2);

    /// ambil jumlah history yang ada di tabel notif history
    await loadAndFilterHistoryData(daftarKey: daftarKey);

    debugPrint('[utility] filtered history');
    debugPrint(
        'historySampahOrganik length: ${filteredSampah.historySampahOrganik.length}');
    debugPrint(
        'historySampahNonOrganik length: ${filteredSampah.historySampahNonOrganik.length}');

    return hasil;
  }

  static Future loadAndFilterHistoryData({required String daftarKey}) async {
    String query = "SELECT * FROM notif_history WHERE key IN ($daftarKey)";

    List<Map<String, dynamic>> data =
        await DatabaseHelper.instance.loadAllData(query);
    debugPrint('[utility] data length: ${data.length}');

    // int counter = 0;
    filteredSampah.historySampahOrganik.clear();
    filteredSampah.historySampahNonOrganik.clear();

    for (final dbData in data) {
      // debugPrint('dbdata');
      // debugPrint(dbData);
      if (filteredSampah.allDataSampah[dbData["key"]]["jenis"] ==
          "sampah organik") {
        filteredSampah.historySampahOrganik.add(DataSampah(
            beratSampah: filteredSampah.allDataSampah[dbData["key"]]["berat"],
            jenisSampah: filteredSampah.allDataSampah[dbData["key"]]["jenis"],
            createdAt: DateTime.parse(
                filteredSampah.allDataSampah[dbData["key"]]["created_at"]),
            key: dbData['key']));
      } else {
        filteredSampah.historySampahNonOrganik.add(DataSampah(
            beratSampah: filteredSampah.allDataSampah[dbData["key"]]["berat"],
            jenisSampah: filteredSampah.allDataSampah[dbData["key"]]["jenis"],
            createdAt: DateTime.parse(
                filteredSampah.allDataSampah[dbData["key"]]["created_at"]),
            key: dbData['key']));
      }
      // counter++;
    }

    // debugPrint('data di proses $counter');
  }

  static Future<void> simpanDataNotifikasiKeDatabase(
      {required DataSampah dataSampah}) async {
    DateTime jadwalNotif = dataSampah.createdAt.add(Constant.durasiNotifikasi);

    final String query = QueryHelper.insertDataNotifikasi(
        notifKey: dataSampah.key,
        notifTitle: Constant.notifTitleKetikaInputData,
        notifBody: Constant.notifBodyKetikaInputData,
        jadwalNotif: jadwalNotif.toString(),
        isSampahOrganik: dataSampah.jenisSampah == "sampah organik" ? 1 : 0);

    // debugPrint('[utility] query notifikasi');
    // debugPrint(query);

    await DatabaseHelper.instance.insertSingleData(queryAndData: query);
  }

  static Future<void> ambilDataNotifikasiDariDatabase() async {
    Map<String, dynamic> hasil = {};
    List<Map<String, dynamic>> data = await DatabaseHelper.instance
        .loadAllData('SELECT * FROM data_notifikasi');

    // debugPrint('[utility] data notifikasi dari database');
    for (final dbData in data) {
      hasil[dbData['key']] = dbData;
    }

    debugPrint('[utility] data notifikasi length: ${hasil.length}');
    // debugPrint(hasil);
    // DataNotifikasi.instance.data = {};
    DataNotifikasi.instance.data.addAll(hasil);
  }

  static Future<void> simpanDataNotifHistoryKeDatabase(
      {required String notifKey,
      required String notifDate,
      required String notifiedAt,
      required int notifStatus}) async {
    final String query = QueryHelper.insertDataNotifHistory(
        notifKey: notifKey,
        notificationDate: notifDate,
        notifiedAt: notifiedAt,
        notifStatus: notifStatus);

    // debugPrint('[utility] notif history query');
    // debugPrint(query);

    await DatabaseHelper.instance.insertSingleData(queryAndData: query);
  }

  static Future<Map<String, dynamic>>
      ambilDataNotifHistoryDariDatabase() async {
    // static Future<Map<String, dynamic>> ambilDataNotifHistoryDariDatabase() async {
    Map<String, dynamic> hasil = {};
    List<Map<String, dynamic>> data = await DatabaseHelper.instance
        .loadAllData('SELECT * FROM notif_history');

    debugPrint('[utility] data notif history dari database');
    for (final dbData in data) {
      hasil[dbData['key']] = dbData;
    }

    debugPrint('[utility] notif history length: ${hasil.length}');
    // debugPrint(hasil);
    DataNotifikasi.instance.notificationHistory = {};
    DataNotifikasi.instance.notificationHistory.addAll(hasil);

    return hasil;
  }

  static Future<void> updateDataNotifikasi(
      {required String notifKey,
      required String notifTitle,
      required String notifBody,
      required String jadwalNotifikasiBaru,
      required int isActive,
      required int isSudahDilihat,
      required String viewedAt,
      required int notifStatus}) async {
    await DatabaseHelper.instance.execQuery(QueryHelper.updateDataNotifikasi(
        notifKey: notifKey,
        notifTitle: notifTitle,
        notifBody: notifBody,
        jadwalNotifikasiBaru: jadwalNotifikasiBaru,
        isActive: isActive,
        isSudahDilihat: isSudahDilihat,
        viewedAt: viewedAt,
        notifStatus: notifStatus));
  }
}
