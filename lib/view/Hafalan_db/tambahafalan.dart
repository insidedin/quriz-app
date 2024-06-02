import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quriz/database/database_instance.dart';
import 'package:quriz/utils/Function/function.dart';
import 'package:quriz/view/Hafalan/hafalan.dart';
import 'package:quriz/view/Hafalan_db/daftarsurah.dart';
import 'package:quriz/view/Widget/appbarview.dart';
import 'package:quriz/view/Widget/textview.dart';

enum StatusHafalan { lancar, murojaah, ulangi }

class TambahHafalanForm extends StatefulWidget {
  final int? idSiswa;

  const TambahHafalanForm({super.key, this.idSiswa});

  @override
  State<TambahHafalanForm> createState() => _TambahHafalanFormState();
}

class _TambahHafalanFormState extends State<TambahHafalanForm> {
  DatabaseInstance databaseInstance = DatabaseInstance();
  String? selectedSurah;
  final TextEditingController _ayatController = TextEditingController();
  StatusHafalan? _selectedStatus;
  final TextEditingController _hariController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    await databaseInstance.database();
  }

  bool _validateTambah() {
    if (_ayatController.text.isEmpty ||
        _hariController.text.isEmpty ||
        _tanggalController.text.isEmpty) {
      return false;
    }

    if (selectedSurah == null) {
      return false;
    }

    if (_selectedStatus == null) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarCostum('Tambah Hafalan',
          () => navigationReplace(context, const HafalanProgress())),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //////////
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: textView(
                  "Pilih Surah :",
                  17,
                  const Color.fromRGBO(31, 89, 7, 1),
                  FontWeight.w600,
                  TextAlign.start,
                  const EdgeInsets.all(5),
                ),
              ),
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  return daftarSurah.where((String option) {
                    return option
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  setState(() {
                    selectedSurah = selection;
                  });
                },
                displayStringForOption: (String option) => option,
                optionsViewBuilder: (context, Function(String) onSelected,
                    Iterable<String> options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4,
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        padding: const EdgeInsets.all(0),
                        color: Colors.white,
                        child: ListView(
                          children: options
                              .map((String option) => ListTile(
                                    title: Text(
                                      option,
                                      style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily),
                                    ),
                                    onTap: () {
                                      onSelected(option);
                                    },
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 15,
              ),

              ////////////
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: textView(
                  "Masukan Ayat :",
                  17,
                  const Color.fromRGBO(31, 89, 7, 1),
                  FontWeight.w600,
                  TextAlign.start,
                  const EdgeInsets.all(0),
                ),
              ),
              TextField(
                controller: _ayatController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 15,
              ),

              //////////
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: textView(
                  "Status Hafalan :",
                  17,
                  const Color.fromRGBO(31, 89, 7, 1),
                  FontWeight.w600,
                  TextAlign.start,
                  const EdgeInsets.all(5),
                ),
              ),
              Column(
                children: [
                  RadioListTile<StatusHafalan>(
                    title: Text(
                      'Lancar',
                      style: TextStyle(
                          color: _selectedStatus == StatusHafalan.lancar
                              ? Colors.green
                              : Colors.black,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.bold),
                    ),
                    value: StatusHafalan.lancar,
                    groupValue: _selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    },
                    activeColor: Colors.green,
                  ),
                  RadioListTile<StatusHafalan>(
                    title: Text(
                      'Murojaah',
                      style: TextStyle(
                          color: _selectedStatus == StatusHafalan.murojaah
                              ? Colors.orangeAccent
                              : Colors.black,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.bold),
                    ),
                    value: StatusHafalan.murojaah,
                    groupValue: _selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    },
                    activeColor: Colors.orangeAccent,
                  ),
                  RadioListTile<StatusHafalan>(
                    title: Text(
                      'Ulangi',
                      style: TextStyle(
                          color: _selectedStatus == StatusHafalan.ulangi
                              ? Colors.red
                              : Colors.black,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.bold),
                    ),
                    value: StatusHafalan.ulangi,
                    groupValue: _selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    },
                    activeColor: Colors.red,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),

              /////////////
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textView(
                      "Hari & Tanggal :",
                      17,
                      const Color.fromRGBO(31, 89, 7, 1),
                      FontWeight.w600,
                      TextAlign.start,
                      const EdgeInsets.all(5),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'Hari',
                              hintText: '',
                            ),
                            controller: _hariController,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.datetime,
                            decoration: const InputDecoration(
                              labelText: 'Tanggal',
                              hintText: 'DD-MM-YYYY',
                            ),
                            controller: _tanggalController,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40.0),

              ////////////
              ElevatedButton(
                onPressed: () async {
                  if (_validateTambah()) {
                    try {
                      if (widget.idSiswa != null && widget.idSiswa != 0) {
                        String idSiswaString = widget.idSiswa.toString();
                        int? idSiswa = int.tryParse(idSiswaString);
                        if (idSiswa == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("ID siswa tidak valid."),
                            ),
                          );
                          return;
                        }

                        await databaseInstance.tambahHafalan(
                          idSiswa,
                          selectedSurah ?? '',
                          _ayatController.text,
                          _selectedStatus ?? StatusHafalan.lancar,
                          _hariController.text,
                          _tanggalController.text,
                        );

                        // Data berhasil ditambahkan, sekarang cetak informasinya
                        print('Data berhasil ditambahkan:');
                        print('Surah: $selectedSurah');
                        print('Ayat: ${_ayatController.text}');
                        print('Status Hafalan: $_selectedStatus');
                        print('Hari: ${_hariController.text}');
                        print('Tanggal: ${_tanggalController.text}');

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: textView(
                              "Data berhasil ditambahkan",
                              14,
                              Colors.white,
                              FontWeight.w600,
                              TextAlign.start,
                              const EdgeInsets.all(5),
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("ID siswa tidak ditemukan."),
                          ),
                        );
                      }
                    } catch (error, stackTrace) {
                      if (kDebugMode) {
                        print('Error: $error');
                        print('StackTrace: $stackTrace');
                      }
                    }
                  }
                },
                child: textView(
                  "Simpan",
                  15,
                  const Color.fromRGBO(31, 89, 7, 1),
                  FontWeight.w600,
                  TextAlign.start,
                  const EdgeInsets.all(5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
