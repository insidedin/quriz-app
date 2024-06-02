import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quriz/database/database_instance.dart';
import 'package:quriz/database/hafalan_model.dart';
import 'package:quriz/utils/Function/function.dart';
import 'package:quriz/view/Widget/appbarview.dart';
import 'package:quriz/view/Widget/textview.dart';
import 'package:quriz/view/Hafalan_db/tambahafalan.dart';
import 'package:quriz/view/Home/home.dart';

class HafalanProgress extends StatefulWidget {
  final int? idSiswa;
  final String? namaSiswa;
  final String? kelasSiswa;
  final String? absenSiswa;

  const HafalanProgress({
    super.key,
    this.idSiswa,
    this.namaSiswa,
    this.kelasSiswa,
    this.absenSiswa,
  });

  @override
  State<HafalanProgress> createState() => _HafalanProgressState();
}

class _HafalanProgressState extends State<HafalanProgress> {
  DatabaseInstance databaseInstance = DatabaseInstance();
  List<HafalanModel> hafalanList = [];

  @override
  void initState() {
    super.initState();
    print('ID Siswa: ${widget.idSiswa}');
    _getHafalanData();
  }

  Future<void> _getHafalanData() async {
    if (widget.idSiswa != null) {
      print(
          'Memulai pengambilan data hafalan untuk idSiswa: ${widget.idSiswa}');
      List<HafalanModel> hafalan =
          await databaseInstance.getAllHafalanBySiswaId(widget.idSiswa!);
      print('Jumlah data hafalan yang diterima: ${hafalan.length}');

      setState(() {
        hafalanList = hafalan;
      });

      print('Jumlah data hafalan dalam hafalanList: ${hafalanList.length}');
    }
  }

  Future<void> deleteHafalan(int idRap) async {
    try {
      await databaseInstance.deleteHafalan(idRap);
      _getHafalanData();
    } catch (e) {
      print('Error saat menghapus data hafalan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarCostum2('Hafalan Siswa',
          () => navigationReplace(context, const Home()), hafalanList, widget),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textView(
                "Nama   = ${widget.namaSiswa ?? ""}",
                18,
                const Color.fromARGB(255, 0, 0, 0),
                FontWeight.w600,
                TextAlign.start,
                const EdgeInsets.all(5),
              ),
              textView(
                "Kelas  = ${widget.kelasSiswa ?? ""}",
                16,
                const Color.fromARGB(255, 0, 0, 0),
                FontWeight.w500,
                TextAlign.start,
                const EdgeInsets.all(5),
              ),
              textView(
                "Absen  = ${widget.absenSiswa ?? ""}",
                16,
                const Color.fromARGB(255, 0, 0, 0),
                FontWeight.w500,
                TextAlign.start,
                const EdgeInsets.all(5),
              ),
              const SizedBox(height: 20),
              textView(
                "Progress Hafalan :",
                18,
                const Color.fromRGBO(31, 89, 7, 1),
                FontWeight.bold,
                TextAlign.start,
                const EdgeInsets.all(5),
              ),
              const SizedBox(height: 5),

              ////////
              ListView.builder(
                shrinkWrap: true,
                itemCount: hafalanList.length,
                itemBuilder: (context, index) {
                  HafalanModel hafalan = hafalanList[index];
                  StatusHafalan status = getStatusFromString(hafalan.status);
                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      color: const Color.fromARGB(221, 255, 255, 255),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.red),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      deleteHafalan(hafalan.idh!).then((_) {
                        _getHafalanData();
                      });
                    },
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => UpdateHafalanForm(hafalanModel: hafalan),
                        //   ),
                        // ).then((_) {
                        //   _getHafalanData();
                        // });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 221, 221, 221),
                          borderRadius:
                              BorderRadius.circular(8.0), // Sudut kotak
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${hafalan.hari}, ${hafalan.tanggal}',
                                    style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 80),
                                  Text(
                                    'Status: ${hafalan.status}',
                                    style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      color: _getStatusColor(status),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                'QS. ${hafalan.surah}',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Ayat: ${hafalan.ayat}',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),

      ////////////
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (widget.idSiswa != null) {
            navigationReplace(
                context, TambahHafalanForm(idSiswa: widget.idSiswa));
          } else {
            print('ID siswa tidak terdeteksi');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('ID siswa tidak terdeteksi'),
              ),
            );
          }
        },
        tooltip: 'Tambah Hafalan',
        backgroundColor: const Color.fromRGBO(31, 89, 7, 1),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

// Fungsi untuk mendapatkan warna berdasarkan status hafalan
Color _getStatusColor(StatusHafalan status) {
  switch (status) {
    case StatusHafalan.lancar:
      return Colors.green;
    case StatusHafalan.murojaah:
      return Colors.orangeAccent;
    case StatusHafalan.ulangi:
      return Colors.red;
    default:
      return Colors.black;
  }
}

StatusHafalan getStatusFromString(String? statusString) {
  if (statusString == null) {
    return StatusHafalan.lancar;
  }
  switch (statusString.toLowerCase()) {
    case 'lancar':
      return StatusHafalan.lancar;
    case 'murojaah':
      return StatusHafalan.murojaah;
    case 'ulangi':
      return StatusHafalan.ulangi;
    default:
      return StatusHafalan.lancar;
  }
}
