import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:oxoo/models/user.dart';

class ApiFirebase extends GetxController implements GetxService {
  static const String USERS = "users";

  static const String STATUS_SUCCESS = "status_success";
  static const String STATUS_FAIL = "status_fail";

  final db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser != null
      ? FirebaseAuth.instance.currentUser?.uid ?? ""
      : "";

  bool isLogin() => FirebaseAuth.instance.currentUser != null;

  DocumentReference getUser() => getUserCollection()
      .withConverter(
          fromFirestore: (snapshot, options) => UserIDance.fromJson(snapshot.data()),
          toFirestore: (UserIDance user, options) => user.toJson())
      .doc(uid);

  Future<bool> checkUserIsExits() async {
    DocumentSnapshot value = await getUser().get();
    return value.exists;
  }

  CollectionReference getUserCollection() => db.collection(USERS);

  Stream<DocumentSnapshot> getUserStream() => getUserCollection()
      .withConverter(
          fromFirestore: (snapshot, options) => UserIDance.fromJson(snapshot.data()),
          toFirestore: (UserIDance user, options) => user.toJson())
      .doc(uid)
      .snapshots(includeMetadataChanges: true);

  Future<bool> register(UserIDance userIDance) async => getUser()
      .set(userIDance)
      .then((value) => true)
      .catchError((onError) => false);

  Future<bool> updatePlan(Map<String, dynamic> userIDance) async => getUser()
      .update(userIDance)
      .then((value) => true)
      .catchError((onError) => false);
}
