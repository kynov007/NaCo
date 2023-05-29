import 'package:flutter/material.dart';
import 'package:project_sampah/model/data_sampah.dart';
import 'package:project_sampah/utility.dart';

import '../constant.dart';

class DataNotifikasi {
  List<DateTime> notifikasiTerlewat = [];
  Map<String, dynamic> notificationHistory =
      {}; // mendata key notifikasi mana saja yang sudah di tampilkan notifikasinya
  Map<String, dynamic> data = {};
  int jumlahNotifSampahOrganik = 0;
  int jumlahNotifSampahNonOrganik = 0;

  // singleton
  static final DataNotifikasi instance = DataNotifikasi._privateConst();

  factory DataNotifikasi() {
    return instance;
  }

  DataNotifikasi._privateConst() {
    debugPrint('[data_notifikasi] DataNotifikasi initialized');
  }

  int get getJumlahNotifikasiSampahOrganik {
    return jumlahNotifSampahOrganik;
  }

  int get getJumlahNotifikasiSampahNonOrganik {
    return jumlahNotifSampahNonOrganik;
  }

  Future<void> addNewNotification({
    required DataSampah dataSampah,
  }) async {
    DateTime jadwalNotif = dataSampah.createdAt.add(Constant.durasiNotifikasi);

    data[dataSampah.createdAt.toString()] = {
      "notificationTitle": Constant.notifBodyKetikaInputData,
      "notificationBody": Constant.notifBodyKetikaInputData,
      "jadwal_notifikasi": jadwalNotif.toString(),
      "isSampahOrganik": dataSampah.jenisSampah == "sampah organik",
      "beratSampah": dataSampah.beratSampah,
      "isActive": true,
      // "history": jsonEncode([])
    };

    /// history format
    // "history":
    // [
    //   {
    //     "notificationDate": ",
    //     "notifiedAt": ""
    //   },
    //   {
    //     "notificationDate": ,
    //     "notifiedAt": ""
    //   },
    // ]
    debugPrint('[data_notifikasi] Data notifikasi baru disimpan');
  }

  Future<void> loadAndExtractNotifData() async {
    debugPrint('[data_notifikasi] loadAndExtractNotifData');

    /// ambil data notifikasi dari database
    await Utility.ambilDataNotifikasiDariDatabase();

    /// ambil data notif history dari database
    await Utility.ambilDataNotifHistoryDariDatabase();
  }
}
