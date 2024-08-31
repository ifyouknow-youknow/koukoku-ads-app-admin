import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koukoku_ads_admin/COMPONENTS/accordion_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/blur_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/button_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/calendar_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/checkbox_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/dropdown_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/fade_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/loading_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/main_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/map_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/padding_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/pager_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/qrcode_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/roundedcorners_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/scrollable_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/segmented_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/separated_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/split_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/switch_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/text_view.dart';
import 'package:koukoku_ads_admin/FUNCTIONS/colors.dart';
import 'package:koukoku_ads_admin/FUNCTIONS/date.dart';
import 'package:koukoku_ads_admin/FUNCTIONS/media.dart';
import 'package:koukoku_ads_admin/FUNCTIONS/misc.dart';
import 'package:koukoku_ads_admin/FUNCTIONS/recorder.dart';
import 'package:koukoku_ads_admin/FUNCTIONS/server.dart';
import 'package:koukoku_ads_admin/MODELS/coco.dart';
import 'package:koukoku_ads_admin/MODELS/constants.dart';
import 'package:koukoku_ads_admin/MODELS/DATAMASTER/datamaster.dart';
import 'package:koukoku_ads_admin/MODELS/firebase.dart';
import 'package:koukoku_ads_admin/MODELS/screen.dart';
import 'package:record/record.dart';

class PlaygroundView extends StatefulWidget {
  final DataMaster dm;
  const PlaygroundView({super.key, required this.dm});

  @override
  State<PlaygroundView> createState() => _PlaygroundViewState();
}

class _PlaygroundViewState extends State<PlaygroundView> {
  @override
  Widget build(BuildContext context) {
    return MainView(dm: widget.dm, children: [
      const PaddingView(
        child: Center(
          child: TextView(
            text: "Hello! This is the IIC Flutter App Template",
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      ButtonView(
          child: const TextView(
            text: 'Press Me',
          ),
          onPress: () {
            function_ScanQRCode(context);
          }),
      const SizedBox(
        height: 10,
      ),
    ]);
  }
}
