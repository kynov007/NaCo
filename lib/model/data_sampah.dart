import '../utility.dart';

/// ************** class untuk mendata sampah ************** ///
class DataSampah {
  final int beratSampah;
  final String jenisSampah;
  final DateTime createdAt;
  final String key; // key digunakan untuk mencocokkan data sampah dengan data sampah yang ada di data notifikasi berdasarkan tanggal input

  DataSampah({required this.beratSampah, required this.jenisSampah, required this.createdAt, required this.key});
}

/// ************** class untuk memfilter data sampah ************** ///

class FilteredSampah {
  Map<String, dynamic> allDataSampah = {};
  List<DataSampah> sampahOrganik = [];
  List<DataSampah> sampahNonOrganik = [];
  List<DataSampah> historySampahOrganik = [];
  List<DataSampah> historySampahNonOrganik = [];

  initFilterSampah() async {
    // print('[data_sampah]init filter sampah');
    // sampahOrganik = [];
    // sampahNonOrganik = [];

    await Utility.ambilDataSampahDariDatabase();
  }

  int get jumlahSampahOrganik => sampahOrganik.length;
  int get jumlahSampahNonOrganik => sampahNonOrganik.length;
}
