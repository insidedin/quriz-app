class SiswaModel {
  int? id;
  String? nama, kelas, absen;

  SiswaModel({this.id, this.nama, this.kelas, this.absen});

  factory SiswaModel.fromJson(Map<String, dynamic> json) {
    return SiswaModel(
      id: json['id'],
      nama: json['nama'],
      kelas: json['kelas'],
      absen: json['absen'],
    );
  }
}
