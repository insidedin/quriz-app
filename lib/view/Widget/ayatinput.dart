import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AyatInputField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final int? minAyat;
  final int? maxAyat;

  const AyatInputField({super.key,
    required this.controller,
    required this.labelText,
    this.minAyat,
    this.maxAyat,
  });

  @override
  State <AyatInputField> createState() => _AyatInputFieldState();
}

class _AyatInputFieldState extends State<AyatInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+-?\d*$')),
      ],
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: const TextStyle(
          color: Color.fromRGBO(31, 89, 7, 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromRGBO(31, 89, 7, 1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      style: const TextStyle(
        color: Colors.black,
      ),
    );
  }
}
