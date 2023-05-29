class Constant {
  static const durasiNotifikasi =
      Duration(days: 7); // ubah ini untuk mengubah durasi notifikasi

  // ubah ini untuk mengaktifkan/menjalankan task di background sesuai durasi yang ditentukan, min 15 menit. tidak boleh < 15 menit.
  static const backgroundTaskFrequency = Duration(hours: 6);

  /// ****************** Daftar key yang digunakan untuk load/simpan data dari storage ************************* //
  static const dataSampahKey = 'dataSampah';
  static const dataNotifikasiKey = 'dataNotifikasi';
  static const isShowIntroKey = 'isShowIntro';
  static const dataHistoriNotifikasiKey = 'dataHistoriNotifikasiKey';
  static const dataUnviewedNotif = 'unViewedNotif';

  /// ****************** Title dan Body untuk Notifikasi ************************* //
  static const notifTitleKetikaInputData = 'Data berhasil di input';
  static const notifBodyKetikaInputData =
      'Tunggu hari ke-7 dan ke-14 untuk notif selanjutnya';

  static const notifTitleHarike7 = 'Pupuk sudah berumur 7 hari';
  static const notifBodyHarike7 =
      'Pupukmu sudah berumur 7 hari, silahkan cek data';

  static const notifTitleHarike14 = 'Pupuk sudah berumur 14 hari';
  static const notifBodyHarike14 =
      'Pupukmu sudah berumur 14 hari, silahkan cek data';

  /// ****************** Config nilai default Em4 dan nilai Molase ************************* //
  static const nilaiDefaultEm4 = 50;
  static const nilaiDefaultMolase = 100;

  /// ****************** Config lokasi image notifikasi hari ke-7 dan ke-14 ************************* //
  static const imageNotifDay1 = 'assets/images/tong_intro.png';
  static const imageNotifDays7 = 'assets/images/tong_intro.png';
  static const imageNotifDays14 = 'assets/images/recycle_pict.png';
}
