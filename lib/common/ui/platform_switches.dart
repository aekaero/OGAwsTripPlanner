import 'package:flutter/material.dart';

// This file is to hold widgets that will change with the platform: Android
// IOS, Web, Widows, etc...

Widget ApProgressIndicator() {
// will have to look up the below options to finish this, found on some sample code
// // Default to IOS showing its own, everthing else can be standard indicator
//   return Platform.isAndroid
//         ? CircularProgressIndicator()
//         : CupertinoActivityIndicator(),
  return CircularProgressIndicator();
}
