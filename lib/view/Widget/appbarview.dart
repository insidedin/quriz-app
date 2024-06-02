import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quriz/view/Widget/textview.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:file_picker/file_picker.dart';

appBarSplash() {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 50,
          margin: const EdgeInsets.only(
            top: 6,
          ),
          child: Image.asset('assets/images/splash/smp.png'),
        ),
        Row(
          children: [
            textView('SMP Bukit Asam Tanjung Enim', 15, Colors.black,
                FontWeight.bold, TextAlign.start, const EdgeInsets.all(0)),
          ],
        )
      ],
    ),
    automaticallyImplyLeading: false,
  );
}

appBarHome() {
  return AppBar(
    elevation: 5,
    backgroundColor: Colors.white,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.account_circle_rounded,
                color: Color.fromRGBO(31, 89, 7, 1),
              ),
              iconSize: 33,
              onPressed: () => () {},
            ),
            Container(
              margin: const EdgeInsets.only(left: 105),
              height: 20,
              child: Image.asset('assets/images/appbar/setor.png'),
            ),
          ],
        ),
      ],
    ),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.zero, bottomRight: Radius.zero)),
    automaticallyImplyLeading: false,
  );
}

appBarCostum(String nama, ditekan) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
        height: 50,
        margin: const EdgeInsets.only(left: 4.0),
        child: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromRGBO(31, 89, 7, 1), size: 28),
          onPressed: ditekan,
        ),
      ),
      textView(nama, 16, const Color.fromRGBO(31, 89, 7, 1), FontWeight.bold,
          TextAlign.start, const EdgeInsets.only(right: 150))
    ]),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.zero, bottomRight: Radius.zero)),
    automaticallyImplyLeading: false,
  );
}

appBarProfile(ditekan) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      textView(
          'Profile',
          16,
          const Color.fromRGBO(31, 89, 7, 1),
          FontWeight.bold,
          TextAlign.start,
          const EdgeInsets.only(right: 150, left: 20)),
      Container(
        height: 50,
        margin: const EdgeInsets.only(left: 4.0),
        child: IconButton(
          icon: const Icon(Icons.arrow_forward_ios_rounded,
              color: Color.fromRGBO(31, 89, 7, 1), size: 23),
          onPressed: ditekan,
        ),
      ),
    ]),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.zero, bottomRight: Radius.zero)),
    automaticallyImplyLeading: false,
  );
}

appBarCostum2(String nama, VoidCallback ditekan, List<dynamic> hafalanList,
    dynamic widget) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 50,
          margin: const EdgeInsets.only(left: 4.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Color.fromRGBO(31, 89, 7, 1), size: 28),
            onPressed: ditekan,
          ),
        ),
        textView(nama, 16, const Color.fromRGBO(31, 89, 7, 1), FontWeight.bold,
            TextAlign.start, const EdgeInsets.only(right: 10)),
        IconButton(
          icon: const Icon(Icons.download_rounded,
              color: Color.fromRGBO(31, 89, 7, 1), size: 28),
          onPressed: () async {
            final result = await FilePicker.platform.getDirectoryPath();
            if (result != null) {
              final selectedDirectory = Directory(result);
              if (!selectedDirectory.existsSync()) {
                selectedDirectory.createSync(recursive: true);
              }

              final appDocDir = await getApplicationDocumentsDirectory();
              final String fileName =
                  'progress_hafalan_${widget.namaSiswa ?? "unnamed"}.pdf';
              final String filePath = '${appDocDir.path}/$fileName';
              final pdfFile = File(filePath);

              final pdf = pdfLib.Document();
              pdf.addPage(pdfLib.Page(
                build: (pdfLib.Context context) {
                  return pdfLib.Column(
                    crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                    children: [
                      pdfLib.Text('Nama Siswa: ${widget.namaSiswa ?? ""}'),
                      pdfLib.Text('Kelas: ${widget.kelasSiswa ?? ""}'),
                      pdfLib.Text('Absen: ${widget.absenSiswa ?? ""}'),
                      pdfLib.SizedBox(height: 20),
                      pdfLib.Text(
                        'Progress Hafalan',
                        style: pdfLib.TextStyle(
                            fontWeight: pdfLib.FontWeight.bold, fontSize: 18),
                      ),
                      pdfLib.SizedBox(height: 10),
                      for (var hafalan in hafalanList)
                        pdfLib.Column(
                          crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                          children: [
                            pdfLib.Text('${hafalan.hari}, ${hafalan.tanggal}'),
                            pdfLib.Text('Status: ${hafalan.status}'),
                            pdfLib.Text('QS ${hafalan.surah}'),
                            pdfLib.Text('Ayat: ${hafalan.ayat}'),
                            pdfLib.SizedBox(height: 10),
                          ],
                        ),
                    ],
                  );
                },
              ));

              final bytes = await pdf.save();
              await pdfFile.writeAsBytes(bytes);

              final exists = await pdfFile.exists();
              if (exists) {
                print('File PDF berhasil disimpan dengan nama: $fileName');
              } else {
                print('File tidak berhasil disimpan.');
              }
            } else {
              print('Tidak ada lokasi penyimpanan yang dipilih');
            }
          },
        ),
      ],
    ),
    shape: const RoundedRectangleBorder(
      borderRadius:
          BorderRadius.only(bottomLeft: Radius.zero, bottomRight: Radius.zero),
    ),
    automaticallyImplyLeading: false,
  );
}
