import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:koukoku_ads_admin/MODELS/DATAMASTER/datamaster.dart';
import 'package:koukoku_ads_admin/MODELS/firebase.dart';
import 'package:koukoku_ads_admin/VIEWS/Requests.dart';
import 'package:koukoku_ads_admin/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  messaging_SetUp();
  await dotenv.load(fileName: "lib/.env");

  runApp(
    MaterialApp(
      home: Requests(dm: DataMaster()),
    ),
    // initialRoute: "/",
    // routes: {
    //   // "/": (context) => const PlaygroundView(),
    // },
  );
}
