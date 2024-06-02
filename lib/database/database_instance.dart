import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quriz/database/hafalan_model.dart';
import 'package:quriz/database/siswa_model.dart';
import 'package:quriz/view/Hafalan_db/tambahafalan.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseInstance {
  final String _databaseName = 'quriz.db';
  final int _databaseVersion = 2;

  //// tabel siswa
  final String table = 'siswa';
  final String id = 'id';
  final String nama = 'nama';
  final String kelas = 'kelas';
  final String absen = 'absen';

  //// tabel hafalan
  final String hafalan = 'hafalan';
  final String idh = 'idh';
  final String idSiswa = 'idSiswa';
  final String surah = 'surah';
  final String ayat = 'ayat';
  final String status = 'status';
  final String hari = 'hari';
  final String tanggal = 'tanggal';

  //// pengecekan database
  Database? _database;
  Future<Database> database() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  //// inisialisasi database
  Future _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  //// membuat tabel
  Future _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $table ($id INTEGER PRIMARY KEY, $nama TEXT NULL, $kelas TEXT NULL, $absen TEXT NULL)');

    await db.execute(
        'CREATE TABLE $hafalan ($idh INTEGER PRIMARY KEY, $idSiswa INTEGER, $surah TEXT, $ayat TEXT, $status TEXT, $hari TEXT, $tanggal TEXT, FOREIGN KEY ($idSiswa) REFERENCES $table($id) ON DELETE CASCADE)');
  }

/////////////////

  //// membuat data model siswa
  Future<List<SiswaModel>> all() async {
    final data = await _database!.query(table);
    List<SiswaModel> result = data.map((e) => SiswaModel.fromJson(e)).toList();
    return result;
  }

  //// insert data siswa
  Future<int> insert(Map<String, dynamic> row) async {
    final id = await _database!.insert(table, row);
    print('Insert berhasil dengan ID siswa: $id');
    return id;
  }

  /// update data siswa
  Future<int> update(int idPar, Map<String, dynamic> row) async {
    final query = await _database!
        .update(table, row, where: '$id = ?', whereArgs: [idPar]);
    return query;
  }

  /// deleted data siswa
  Future delete(int idPar) async {
    await _database!.delete(table, where: '$id = ?', whereArgs: [idPar]);
  }

/////////////////

  Future<List<HafalanModel>> getAllHafalanBySiswaId(int idSiswa) async {
    final Database db = await database();
    final List<Map<String, dynamic>> results =
        await db.query(hafalan, where: 'idSiswa = ?', whereArgs: [idSiswa]);

    print('Jumlah data hafalan yang diterima: ${results.length}');

    return results
        .map((e) => HafalanModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> tambahHafalan(int idSiswa, String surah, String ayat,
      StatusHafalan status, String hari, String tanggal) async {
    final Map<String, dynamic> hafalanData = {
      'idSiswa': idSiswa,
      'surah': surah,
      'ayat': ayat,
      'status': convertStatusHafalanToString(status),
      'hari': hari,
      'tanggal': tanggal,
    };

    await insertHafalan(idSiswa, hafalanData);
  }

  Future<int> insertHafalan(int idSiswa, Map<String, dynamic> row) async {
    final Database db = await database();
    try {
      row['idSiswa'] = idSiswa;
      final query = await db.insert(hafalan, row);
      print('Insert berhasil dengan ID: $query');
      return query;
    } catch (e) {
      print('Error saat melakukan insert ke tabel hafalan: $e');
      throw e;
    }
  }

  String convertStatusHafalanToString(StatusHafalan status) {
    switch (status) {
      case StatusHafalan.lancar:
        return 'lancar';
      case StatusHafalan.murojaah:
        return 'murojaah';
      case StatusHafalan.ulangi:
        return 'ulangi';
      default:
        throw Exception('Unknown status hafalan: $status');
    }
  }

  Future<int> updateHafalan(int idRap, Map<String, dynamic> row) async {
      final query = await _database!.update(hafalan, row,
        where: '$idh = ?',
        whereArgs: [idRap] );
      print('Update berhasil dengan ID: $query');
      return query;
  }

  Future<int> deleteHafalan(int idRap) async {
    final Database db = await database();
    try {
      final query = await db.delete(
        hafalan,
        where: '$idh = ?',
        whereArgs: [idRap],
      );
      print('Delete berhasil dengan ID: $idRap');
      return query;
    } catch (e) {
      print('Error saat melakukan delete pada tabel hafalan: $e');
      rethrow;
    }
  }
}
