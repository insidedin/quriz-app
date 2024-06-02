import 'package:quriz/utils/Function/function.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quriz/view/Home/home.dart';
import 'package:quriz/view/Widget/textview.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _getSavedCredentials();
  }

  void _getSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      usernameController.text = prefs.getString('username') ?? '';
      passwordController.text = prefs.getString('password') ?? '';
      rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }

  void _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      prefs.setString('username', usernameController.text);
      prefs.setString('password', passwordController.text);
      prefs.setBool('rememberMe', true);
    } else {
      prefs.remove('username');
      prefs.remove('password');
      prefs.setBool('rememberMe', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    left: 150, right: 150, top: 70, bottom: 10),
                child: Image.asset('assets/images/splash/logo.png'),
              )
            ],
          )),
          Positioned.fill(
            bottom: null,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 260,
              margin: const EdgeInsets.only(top: 270),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment(0.00, -1.00),
                  end: Alignment(0, 1),
                  colors: [Color(0xFF6CC945), Color(0xFF356322)],
                ),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),

          //////////
          Positioned(
              left: 54,
              top: 300,
              child: textView(
                  "Setorkan Hafalan Quran Sekarang\nDengan Aplikasi QU'RIZ...",
                  16,
                  const Color(0xFF1F5907),
                  FontWeight.bold,
                  TextAlign.start,
                  const EdgeInsets.all(0))),

          //////////
          Positioned(
              left: 54,
              top: 380,
              child: textView('MASUK AKUN', 18, Colors.white, FontWeight.bold,
                  TextAlign.start, const EdgeInsets.all(0))),

          //////////
          Positioned(
            left: 54,
            top: 420,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 108,
              height: 50,
              child: TextField(
                controller: usernameController,
                textInputAction: TextInputAction.search,
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(),
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_4),
                    labelText: 'Username',
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 110, 110, 110)),
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 110, 110, 110),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never),
              ),
            ),
          ),

          //////////
          Positioned(
            left: 54,
            top: 490,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 108,
              height: 50,
              child: TextField(
                controller: passwordController,
                textInputAction: TextInputAction.search,
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(),
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 110, 110, 110)),
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 110, 110, 110),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never),
              ),
            ),
          ),

          //////////
          Positioned(
            left: 54,
            top: 540,
            child: Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value!;
                    });
                  },
                  checkColor: Colors.black, // Warna centang
                  activeColor: Colors.white,
                ),
                textView('Remember Me', 13, Colors.white, FontWeight.normal,
                    TextAlign.start, const EdgeInsets.all(0)),
              ],
            ),
          ),

          /////////
          Positioned(
            left: 97,
            top: 605,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 200,
              height: 60,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: () {
                    if (usernameController.text == 'adminquriz' &&
                        passwordController.text == 'hafalan123') {
                      _saveCredentials();
                      navigationReplace(context, const Home());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Username atau password salah.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(36, 91, 14, 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'MASUK',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
