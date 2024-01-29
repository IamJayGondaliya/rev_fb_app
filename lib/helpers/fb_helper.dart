import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rev_fb_app/modals/user_modal.dart';

class FbHelper {
  FbHelper._();
  static final FbHelper fbHelper = FbHelper._();

  String collectionPath = "Users";

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getUsers() {
    return fireStore.collection(collectionPath).snapshots();
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
