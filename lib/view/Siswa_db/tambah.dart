import 'package:flutter/material.dart';
import 'package:quriz/database/database_instance.dart';
import 'package:quriz/utils/Function/function.dart';
import 'package:quriz/view/Home/home.dart';
import 'package:quriz/view/Widget/appbarview.dart';
import 'package:quriz/view/Widget/inputview.dart';
import 'package:quriz/view/Widget/textview.dart';

class TambahSiswaForm extends StatefulWidget {
  const TambahSiswaForm({super.key});

  @override
  State<TambahSiswaForm> createState() => _TambahSiswaFormState();
}

class _TambahSiswaFormState extends State<TambahSiswaForm> {
  DatabaseInstance databaseInstance = DatabaseInstance();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kelasController = TextEditingController();
  final TextEditingController _absenController = TextEditingController();

  @override
  void initState() {
    databaseInstance.database();
    super.initState();
  }

  bool _validateData() {
    if (_namaController.text.isEmpty ||
        _kelasController.text.isEmpty ||
        _absenController.text.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarCostum(
          'Tambah Siswa', () => navigationReplace(context, const Home())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: _namaController,
              labelText: 'Nama Siswa',
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              controller: _kelasController,
              labelText: 'Kelas Siswa',
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              controller: _absenController,
              labelText: 'Absen Siswa',
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                if (_validateData()) {
                  if (mounted) {
                    await databaseInstance.insert({
                      'nama': _namaController.text,
                      'kelas': _kelasController.text,
                      'absen': _absenController.text,
                    });
                    Navigator.pop(context);
                    //setState(() {});
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: textView(
                            "Peringatan!",
                            20,
                            const Color.fromRGBO(31, 89, 7, 1),
                            FontWeight.w600,
                            TextAlign.start,
                            const EdgeInsets.all(5)),
                        content: textView(
                            "Harap Lengapi Semua Data",
                            14,
                            const Color.fromRGBO(31, 89, 7, 1),
                            FontWeight.w400,
                            TextAlign.start,
                            const EdgeInsets.all(5)),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: textView(
                                "OK",
                                13,
                                const Color.fromRGBO(31, 89, 7, 1),
                                FontWeight.w600,
                                TextAlign.start,
                                const EdgeInsets.all(5),
                              )),
                        ],
                      );
                    },
                  );
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
    );
  }
}
