import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rev_fb_app/firebase_options.dart';
import 'package:rev_fb_app/helpers/ad_helper.dart';
import 'package:rev_fb_app/helpers/fb_helper.dart';
import 'package:rev_fb_app/modals/user_modal.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await MobileAds.instance.initialize();

  await AdHelper.adHelper.loadAppOpenAd();

  await AdHelper.adHelper.loadBannerAd();
  await AdHelper.adHelper.loadInterstitialAd();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    showAppOpenAd();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log("STATE: ${state.name}");
    FbHelper.fbHelper.addState(state: state.name);
    super.didChangeAppLifecycleState(state);
  }

  void showAppOpenAd() {
    if (AdHelper.adHelper.appOpenAdLoaded) {
      AdHelper.adHelper.appOpenAd.show();
    } else {
      log("AOA: not loaded yet....");
      Future.delayed(const Duration(milliseconds: 400), () {
        log("TIME OUT: --------------------------");
        setState(() {});
        AdHelper.adHelper.appOpenAd.show();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    showAppOpenAd();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("FB App"),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: StreamBuilder(
                stream: FbHelper.fbHelper.getUsers(),
                builder: (context, snapShot) {
                  if (snapShot.hasData) {
                    QuerySnapshot? snaps = snapShot.data;
                    List<QueryDocumentSnapshot> data = snaps?.docs ?? [];
                    List<UserModal> allUsers = data
                        .map(
                          (e) => UserModal.fromMap(data: e.data() as Map),
                        )
                        .toList();

                    return ListView.builder(
                        itemCount: allUsers.length,
                        itemBuilder: (context, index) {
                          UserModal user = allUsers[index];

                          return GestureDetector(
                            onTap: () {
                              AdHelper.adHelper.interstitialAd.show().then(
                                    (value) =>
                                        AdHelper.adHelper.loadInterstitialAd(),
                                  );
                            },
                            child: Card(
                              child: ExpansionTile(
                                leading: Text(user.uId.toString()),
                                title: Text(user.name),
                                trailing: Text(user.age.toString()),
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          user.name = "NewName";
                                          FbHelper.fbHelper
                                              .editUser(userModal: user);
                                        },
                                        child: const Text("EDIT"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          FbHelper.fbHelper
                                              .deleteUser(userModal: user);
                                        },
                                        child: const Text("DELETE"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: AdHelper.adHelper.bannerAd.size.height.toDouble(),
              width: double.infinity,
              child: AdWidget(
                ad: AdHelper.adHelper.bannerAd,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AdHelper.adHelper.interstitialAd.show().then(
                  (value) => AdHelper.adHelper.loadInterstitialAd(),
                );

            // int uId = DateTime.now().millisecondsSinceEpoch;
            // UserModal userModal = UserModal(
            //   uId,
            //   "Aman",
            //   18,
            // );
            //
            // FbHelper.fbHelper.addUser(userModal: userModal);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
