import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rev_fb_app/modals/user_modal.dart';

enum AdType {
  bannerAd,
  interstitialAd,
  appOpenAd,
  rewardAd,
  nativeAd,
}

class FbHelper {
  FbHelper._();
  static final FbHelper fbHelper = FbHelper._();

  String collectionPath = "Users";

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<String> getAdId({required AdType adType}) async {
    log("================================================");
    log("AdType: ${adType.name}");
    log("================================================");

    DocumentSnapshot<Map<String, dynamic>> data =
        await fireStore.collection("AdUnitId").doc(adType.name).get();
    Map adData = data.data() as Map<String, dynamic>;
    String adId = adData['id'];

    return adId;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUsers() {
    return fireStore.collection(collectionPath).snapshots();
  }

  addState({required String state}) {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    fireStore.collection("AppStates").doc(id).set({
      'id': id,
      'state': state,
    });
  }

  addUser({required UserModal userModal}) {
    fireStore
        .collection(collectionPath)
        .doc(userModal.uId.toString())
        .set(userModal.toMap);
  }

  editUser({required UserModal userModal}) {
    fireStore
        .collection(collectionPath)
        .doc(userModal.uId.toString())
        .update(userModal.toMap);
  }

  deleteUser({required UserModal userModal}) {
    fireStore
        .collection(collectionPath)
        .doc(
          userModal.uId.toString(),
        )
        .delete();
  }
}
