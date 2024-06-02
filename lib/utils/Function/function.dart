import 'dart:async';
import 'package:flutter/material.dart';

focusReq(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

navigationPush(BuildContext context, toPage) {
  focusReq(context);
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => toPage),
  );
}

navigationReplace(BuildContext context, toPage) {
  focusReq(context);

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => toPage),
  );
}

navigationReplaceDelay(BuildContext context, Widget widget, int time) async {
  Timer(Duration(seconds: time), () {
    focusReq(context);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget));
  });
}

timerDelay(int seconds, Function() execution) {
  return Timer(Duration(seconds: seconds), execution);
}
