import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quriz/database/database_instance.dart';
import 'package:quriz/database/siswa_model.dart';
import 'package:quriz/utils/Function/function.dart';
import 'package:quriz/view/Hafalan/hafalan.dart';
import 'package:quriz/view/Login/login.dart';
import 'package:quriz/view/Siswa_db/tambah.dart';
import 'package:quriz/view/Siswa_db/update.dart';
import 'package:quriz/view/Widget/appbarview.dart';
import 'package:quriz/view/Widget/textview.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatabaseInstance? databaseInstance;

  //// inisialisasi pencarian
  late TextEditingController _searchController;
  String _searchText = '';
  late FocusNode _focusNode;

  Future _refresh() async {
    setState(() {});
  }

  Future initDatabase() async {
    databaseInstance = DatabaseInstance();
    await databaseInstance?.database();
    setState(() {});
  }

  Future delete(int id) async {
    await databaseInstance!.delete(id);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();
    initDatabase();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarHome(),

      //Drawer kanan
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 206, 210, 214),
              ),
              child: Image.asset('assets/images/appbar/setor.png'),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: textView(
                "Logout",
                15,
                Colors.grey,
                FontWeight.w600,
                TextAlign.start,
                const EdgeInsets.only(left: 10),
              ),
              onTap: () {
                _showLogoutConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),

      // Halaman Utama, Fungsi ketika dijalankan
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: databaseInstance != null
            ? FutureBuilder<List<SiswaModel>?>(
                future: databaseInstance!.all(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Color.fromRGBO(31, 89, 7, 1),
                        color: Color.fromRGBO(31, 89, 7, 1),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  } else {
                    if (snapshot.data!.isEmpty) {
                      return Center(
                        child: textView(
                          "Data Masih Kosong",
                          17,
                          Colors.black,
                          FontWeight.w500,
                          TextAlign.start,
                          const EdgeInsets.only(left: 15, bottom: 5),
                        ),
                      );
                    }

                    //// Ketika berhasil dijalankan, maka akan tampil widget
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, top: 20),
                          child: textView(
                            "Assalamualaikum,",
                            20,
                            const Color.fromRGBO(31, 89, 7, 1),
                            FontWeight.w600,
                            TextAlign.start,
                            const EdgeInsets.only(left: 15, bottom: 5),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, bottom: 20),
                          child: textView(
                            "Ustadz",
                            25,
                            const Color.fromRGBO(31, 89, 7, 1),
                            FontWeight.bold,
                            TextAlign.start,
                            const EdgeInsets.only(left: 15, bottom: 5),
                          ),
                        ),

                        ///// Widget pencarian
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: TextField(
                            focusNode: _focusNode,
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                _searchText = value.toLowerCase();
                              });
                              _focusNode.requestFocus();
                            },
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Cari Siswa',
                              hintStyle: const TextStyle(fontFamily: 'Poppins'),
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: _searchController.text
                                      .isNotEmpty // IconButton untuk menghapus teks pencarian
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          _searchController
                                              .clear(); // Membersihkan teks pencarian
                                          _searchText =
                                              ''; // Mengosongkan _searchText
                                        });
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color.fromRGBO(31, 89, 7, 1)),
                              ),
                            ),
                          ),
                        ),

                        ///// Menampilkan widget nama siswa yang ditambahkan
                        const SizedBox(height: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final siswa = snapshot.data![index];
                                final namaLowerCase = siswa.nama!.toLowerCase();
                                if (_searchText.isEmpty ||
                                    namaLowerCase.contains(_searchText)) {
                                  return GestureDetector(
                                    onTap: () {
                                      navigationPush(
                                        context,
                                        HafalanProgress(
                                          idSiswa: siswa.id,
                                          namaSiswa: siswa.nama,
                                          kelasSiswa: siswa.kelas,
                                          absenSiswa: siswa.absen,
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            siswa.nama ?? '',
                                            style: TextStyle(
                                              fontFamily: GoogleFonts.poppins().fontFamily,
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            'Kelas: ${siswa.kelas ?? ''} | Absen: ${siswa.absen ?? ''}',
                                            style: TextStyle(
                                              fontFamily:  GoogleFonts.poppins().fontFamily,
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                          ),

                                          //// Fungsi Edit dan Deleted data
                                          trailing: PopupMenuButton(
                                            itemBuilder:
                                                (BuildContext context) {
                                              return [
                                                const PopupMenuItem(
                                                  value: 'edit',
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.edit),
                                                      SizedBox(width: 8),
                                                      Text('Edit'),
                                                    ],
                                                  ),
                                                ),
                                                const PopupMenuItem(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.delete),
                                                      SizedBox(width: 8),
                                                      Text('Delete'),
                                                    ],
                                                  ),
                                                ),
                                              ];
                                            },
                                            onSelected: (String value) {
                                              if (value == 'edit') {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (builder) {
                                                  return UpdateSiswaForm(
                                                    siswaModel: siswa,
                                                  );
                                                })).then((value) {
                                                  setState(() {});
                                                });
                                              } else if (value == 'delete') {
                                                _showDeleteConfirmationDialog(
                                                  context,
                                                  siswa.id!,
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                        const Divider()
                                      ],
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: Color.fromRGBO(31, 89, 7, 1),
                ),
              ),
      ),

      // Add Siswa
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (builder) {
            return const TambahSiswaForm();
          })).then((value) {
            setState(() {});
          });
        },
        tooltip: 'Tambah Siswa',
        backgroundColor: const Color.fromRGBO(31, 89, 7, 1),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  // Pop Up Validasi delete
  void _showDeleteConfirmationDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: textView(
            "Konfirmasi!",
            20,
            const Color.fromRGBO(31, 89, 7, 1),
            FontWeight.w600,
            TextAlign.start,
            const EdgeInsets.all(5),
          ),
          content: textView(
            "Apakah Anda yakin ingin menghapus data siswa ini?",
            14,
            const Color.fromRGBO(31, 89, 7, 1),
            FontWeight.w400,
            TextAlign.start,
            const EdgeInsets.all(5),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: textView(
                "Tidak",
                13,
                const Color.fromARGB(255, 234, 14, 14),
                FontWeight.w600,
                TextAlign.start,
                const EdgeInsets.all(5),
              ),
            ),
            TextButton(
              onPressed: () {
                delete(id);
                Navigator.of(context).pop();
              },
              child: textView(
                "Ya",
                13,
                const Color.fromARGB(255, 15, 173, 246),
                FontWeight.w600,
                TextAlign.start,
                const EdgeInsets.all(5),
              ),
            ),
          ],
        );
      },
    );
  }

  // Pop Up Validasi sebelum Log Out
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: textView("Konfirmasi!", 20, const Color.fromRGBO(31, 89, 7, 1),
              FontWeight.w600, TextAlign.start, const EdgeInsets.all(5)),
          content: textView(
              "Apakah Anda yakin ingin keluar Aplikasi?",
              14,
              const Color.fromRGBO(31, 89, 7, 1),
              FontWeight.w400,
              TextAlign.start,
              const EdgeInsets.all(5)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: textView(
                "Tidak",
                13,
                const Color.fromARGB(255, 15, 173, 246),
                FontWeight.w600,
                TextAlign.start,
                const EdgeInsets.all(5),
              ),
            ),
            TextButton(
              onPressed: () {
                navigationReplace(context, const Login());
              },
              child: textView(
                "Ya",
                13,
                const Color.fromARGB(255, 234, 14, 14),
                FontWeight.w600,
                TextAlign.start,
                const EdgeInsets.all(5),
              ),
            ),
          ],
        );
      },
    );
  }
}
