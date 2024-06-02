class HafalanModel {
  int? idh, idSiswa;
  String? surah, ayat, status, hari, tanggal;

  HafalanModel(
      {this.idh,
      this.idSiswa,
      this.surah,
      this.ayat,
      this.status,
      this.hari,
      this.tanggal});

  factory HafalanModel.fromJson(Map<String, dynamic> json) {
    return HafalanModel(
      idh: json['idh'],
      idSiswa: json['idSiswa'] is int
          ? json['idSiswa'] as int?
          : int.tryParse(json['idSiswa']),
      surah: json['surah'],
      ayat: json['ayat'],
      status: json['status'],
      hari: json['hari'],
      tanggal: json['tanggal'],
    );
  }
}
