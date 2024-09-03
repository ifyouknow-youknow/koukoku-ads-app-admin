import 'package:flutter/material.dart';
import 'package:koukoku_ads_admin/COMPONENTS/asyncimage_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/border_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/button_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/future_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/image_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/main_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/padding_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/roundedcorners_view.dart';
import 'package:koukoku_ads_admin/COMPONENTS/text_view.dart';
import 'package:koukoku_ads_admin/FUNCTIONS/array.dart';
import 'package:koukoku_ads_admin/FUNCTIONS/colors.dart';
import 'package:koukoku_ads_admin/FUNCTIONS/misc.dart';
import 'package:koukoku_ads_admin/MODELS/DATAMASTER/datamaster.dart';
import 'package:koukoku_ads_admin/MODELS/constants.dart';
import 'package:koukoku_ads_admin/MODELS/firebase.dart';
import 'package:koukoku_ads_admin/MODELS/screen.dart';

class Requests extends StatefulWidget {
  final DataMaster dm;
  const Requests({super.key, required this.dm});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  List<dynamic> _requests = [];
  Map<String, dynamic>? _chosenAd;

  Future<List<dynamic>> _fetchAllRequests() async {
    final docs = await firebase_GetAllDocumentsOrdered(
        '${appName}_Requests', 'date', "asc");
    return docs;
  }

  void _fetchRequests() async {
    final docs = await firebase_GetAllDocumentsOrdered(
        '${appName}_Requests', 'date', "asc");
    if (docs.isNotEmpty) {
      setState(() {
        _chosenAd = docs[0];
      });
    }
    setState(() {
      _requests = docs;
    });
  }

  void onApprove() async {
    setState(() {
      widget.dm.setToggleLoading(true);
    });
    final tempChosenAd = _chosenAd!;
    final user = await firebase_GetDocument(
        '${appName}_Businesses', tempChosenAd['userId']);
    final success = await firebase_CreateDocument(
        '${appName}_Campaigns', randomString(25), {
      'paymentIntent': tempChosenAd['paymentIntent'],
      'chosenOption': tempChosenAd['chosenOption'],
      'date': tempChosenAd['date'],
      'expDate': tempChosenAd['expDate'],
      'imagePath': tempChosenAd['imagePath'],
      'isCoupon': tempChosenAd['isCoupon'],
      'isRepeating': tempChosenAd['isRepeating'],
      'userId': tempChosenAd['userId'],
      'views': tempChosenAd['views']
    });

    if (success) {
      final success2 = await firebase_DeleteDocument(
          '${appName}_Requests', tempChosenAd['id']);
      if (success2) {
        await sendPushNotification(user['token'], 'Your ad was approved.',
            'Congratulations! Your ad was approved and is now showing up on customer devices!');
        final _ = await firebase_CreateDocument(
            '${appName}_Notifications', randomString(25), {
          'userId': tempChosenAd['userId'],
          'title': 'Your ad was approved.',
          'body':
              'Congratulations! Your ad was approved and is now showing up on customer devices!',
          'date': DateTime.now().millisecondsSinceEpoch
        });

        setState(() {
          widget.dm.setToggleLoading(false);
          _requests = removeObjById(
              (_requests as List<Map<String, dynamic>>), tempChosenAd['id']);
        });
      }
    }
  }

  void onReject() async {
    setState(() {
      widget.dm.setToggleLoading(true);
    });
    final tempChosenAd = _chosenAd!;
    final user = await firebase_GetDocument(
        '${appName}_Businesses', tempChosenAd['userId']);

    final success = await firebase_DeleteDocument(
        '${appName}_Requests', tempChosenAd['id']);
    if (success) {
      await sendPushNotification(user['token'], 'Your ad was rejected.',
          'Our apologies! Your ad was not approved.');
      final _ = await firebase_CreateDocument(
          '${appName}_Notifications', randomString(25), {
        'userId': tempChosenAd['userId'],
        'title': 'Your ad was rejected.',
        'body':
            'We regret to inform you that your ad was not approved because it contained content that may be deemed irrelevant or inappropriate. Please consider revising your ad and submitting it again with content that better aligns with our guidelines.',
        'date': DateTime.now().millisecondsSinceEpoch
      });
      _fetchRequests();
      setState(() {
        widget.dm.setToggleLoading(false);
        _requests = removeObjById(
            (_requests as List<Map<String, dynamic>>), tempChosenAd['id']);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
    return MainView(
      dm: widget.dm,
      children: [
        // TOP
        PaddingView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  ImageView(
                    imagePath: 'assets/logo.png',
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextView(
                    text: 'Requests',
                    size: 20,
                    weight: FontWeight.w600,
                  ),
                ],
              ),
              ButtonView(
                  child: const Icon(
                    Icons.menu,
                    size: 32,
                  ),
                  onPress: () {})
            ],
          ),
        ),
        // MAIN
        Flexible(
          child: Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LIST
                SingleChildScrollView(
                  child: BorderView(
                    top: true,
                    topColor: Colors.black26,
                    child: Column(
                      children: [
                        ..._requests.map((req) {
                          return BorderView(
                            bottom: true,
                            right: true,
                            bottomColor: Colors.black26,
                            rightColor: Colors.black26,
                            child: PaddingView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextView(
                                    text: req['userId'],
                                  ),
                                  Row(
                                    children: [
                                      TextView(
                                        text: req['chosenOption'],
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      TextView(
                                        text: '${req['views']} views',
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                // AD
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureView(
                        future: _fetchAllRequests(),
                        childBuilder: (data) {
                          final first = data.first;
                          return AsyncImageView(
                            imagePath: first['imagePath'],
                            width: first['chosenOption'] == '2 x 1'
                                ? getWidth(context) * 0.7
                                : getWidth(context) * 0.4,
                            height: first['chosenOption'] == '2 x 1'
                                ? getWidth(context) * 0.35
                                : getWidth(context) * 0.4,
                          );
                        },
                        emptyWidget: const Center(
                          child: TextView(
                            text: 'Failed to load',
                            size: 20,
                          ),
                        )),
                    const Spacer(),
                    PaddingView(
                      paddingBottom: 0,
                      paddingRight: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RoundedCornersView(
                            topLeft: 10,
                            topRight: 10,
                            bottomLeft: 0,
                            bottomRight: 0,
                            child: ButtonView(
                              paddingTop: 10,
                              paddingBottom: 35,
                              paddingLeft: 30,
                              paddingRight: 30,
                              backgroundColor: hexToColor("#FF1617"),
                              child: const TextView(
                                text: 'Reject',
                                color: Colors.white,
                                size: 20,
                                weight: FontWeight.w500,
                                wrap: false,
                              ),
                              onPress: () {
                                // REJECT
                                onReject();
                              },
                            ),
                          ),
                          RoundedCornersView(
                            topLeft: 10,
                            topRight: 10,
                            bottomLeft: 0,
                            bottomRight: 0,
                            child: ButtonView(
                              paddingTop: 10,
                              paddingBottom: 35,
                              paddingLeft: 30,
                              paddingRight: 30,
                              backgroundColor: hexToColor("#19DC3F"),
                              child: const TextView(
                                text: 'Approve',
                                color: Colors.white,
                                size: 20,
                                weight: FontWeight.w500,
                                wrap: false,
                              ),
                              onPress: () {
                                // REJECT
                                onApprove();
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ))
              ],
            ),
          ),
        )
      ],
    );
  }
}
