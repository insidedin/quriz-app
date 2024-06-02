import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quriz/database/database_instance.dart';
import 'package:quriz/database/hafalan_model.dart';
import 'package:quriz/utils/Function/function.dart';
import 'package:quriz/view/Hafalan_db/daftarsurah.dart';
import 'package:quriz/view/Hafalan_db/tambahafalan.dart';
import 'package:quriz/view/Home/home.dart';
import 'package:quriz/view/Widget/appbarview.dart';
import 'package:quriz/view/Widget/textview.dart';

class UpdateHafalanForm extends StatefulWidget {
  final HafalanModel? hafalanModel;
  final int? idh;
  const UpdateHafalanForm({super.key, this.hafalanModel, this.idh});

  @override
  State<UpdateHafalanForm> createState() => _UpdateHafalanFormState();
}

class _UpdateHafalanFormState extends State<UpdateHafalanForm> {
  DatabaseInstance databaseInstance = DatabaseInstance();
  String? selectedSurah;
  final TextEditingController _ayatController = TextEditingController();
  StatusHafalan? _selectedStatus;
  final TextEditingController _hariController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();

  @override
  @override
void initState() {
  super.initState();
  databaseInstance.database();
  if (widget.hafalanModel != null) {
    print('Selected Surah: $selectedSurah');
    print('Ayat: ${_ayatController.text}');
    print('Status: $_selectedStatus');
    print('Hari: ${_hariController.text}');
    print('Tanggal: ${_tanggalController.text}');

    selectedSurah = widget.hafalanModel!.surah ?? '';
    _ayatController.text = widget.hafalanModel!.ayat ?? '';
    _selectedStatus = widget.hafalanModel!.status as StatusHafalan?;
    _hariController.text = widget.hafalanModel!.hari ?? '';
    _tanggalController.text = widget.hafalanModel!.tanggal ?? '';
  } else {
    print('widget.hafalanModel is null');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarCostum(
          'Update Hafalan', () => navigationReplace(context, const Home())),
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
                    await databaseInstance
                        .updateHafalan(widget.hafalanModel!.idh!, {
                      'surah': selectedSurah,
                      'ayat': _ayatController.text,
                      'status':
                          _selectedStatus.toString(),
                      'hari': _hariController.text,
                      'tanggal': _tanggalController.text
                    });
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
