import 'package:flutter/material.dart';
import 'package:quriz/database/database_instance.dart';
import 'package:quriz/database/siswa_model.dart';
import 'package:quriz/utils/Function/function.dart';
import 'package:quriz/view/Home/home.dart';
import 'package:quriz/view/Widget/appbarview.dart';
import 'package:quriz/view/Widget/inputview.dart';
import 'package:quriz/view/Widget/textview.dart';

class UpdateSiswaForm extends StatefulWidget {
  final SiswaModel? siswaModel;
  const UpdateSiswaForm({super.key, this.siswaModel});

  @override
  State<UpdateSiswaForm> createState() => _UpdateSiswaFormState();
}

class _UpdateSiswaFormState extends State<UpdateSiswaForm> {
  DatabaseInstance databaseInstance = DatabaseInstance();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kelasController = TextEditingController();
  final TextEditingController _absenController = TextEditingController();

  @override
  void initState() {
    databaseInstance.database();
    _namaController.text = widget.siswaModel!.nama ?? '';
    _kelasController.text = widget.siswaModel!.kelas ?? '';
    _absenController.text = widget.siswaModel!.absen ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarCostum(
          'Edit Siswa', () => navigationReplace(context, const Home())),
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
                  if (mounted) {
                    await databaseInstance.update(widget.siswaModel!.id!, {
                      'nama': _namaController.text,
                      'kelas': _kelasController.text,
                      'absen': _absenController.text,
                    });
                    Navigator.pop(context);
                    setState(() {});
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
