import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:oxoo/models/user.dart';
import 'package:oxoo/models/video_paid.dart';

class ApiFirebase extends GetxController implements GetxService {
  static const String USERS = "users";
  static const String VIDEOS_PAID = "videos_paid";

  static const String STATUS_SUCCESS = "status_success";
  static const String STATUS_FAIL = "status_fail";

  final db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser != null
      ? FirebaseAuth.instance.currentUser?.uid ?? ""
      : "";

  bool isLogin() => FirebaseAuth.instance.currentUser != null;

  DocumentReference getUser() => getUserCollection()
      .withConverter(
          fromFirestore: (snapshot, options) =>
              UserIDance.fromJson(snapshot.data()),
          toFirestore: (UserIDance user, options) => user.toJson())
      .doc(uid);

  DocumentReference getVideosPaid() => getVideosPaidCollection()
      .withConverter(
          fromFirestore: (snapshot, options) =>
              VideosPaid.fromJson(snapshot.data()),
          toFirestore: (VideosPaid videos, options) => videos.toJson())
      .doc(uid);

  Future<bool> checkUserIsExits() async {
    DocumentSnapshot value = await getUser().get();
    return value.exists;
  }

  CollectionReference getUserCollection() => db.collection(USERS);

  CollectionReference getVideosPaidCollection() => db.collection(VIDEOS_PAID);

  Stream<DocumentSnapshot> getVideosPaidStream() => getVideosPaidCollection()
      .withConverter(
          fromFirestore: (snapshot, options) =>
              VideosPaid.fromJson(snapshot.data()),
          toFirestore: (VideosPaid videos, options) => videos.toJson())
      .doc(uid)
      .snapshots(includeMetadataChanges: true);

  Stream<DocumentSnapshot> getUserStream() => getUserCollection()
      .withConverter(
          fromFirestore: (snapshot, options) =>
              UserIDance.fromJson(snapshot.data()),
          toFirestore: (UserIDance user, options) => user.toJson())
      .doc(uid)
      .snapshots(includeMetadataChanges: true);


  Future<bool> updateNewVideosPaid(VideoPaid videoPaid, bool isAdd) async {
    Map<String, Object> map;
    if (isAdd) {
      map = {
        "list_video_paid": FieldValue.arrayUnion([videoPaid.toJson()])
      };
    } else {
      map = {
        "list_video_paid": FieldValue.arrayRemove([videoPaid.toJson()])
      };
    }
    bool response = await getVideosPaid().update(map).then((value) {
      return true;
    }).catchError((onError) {
      print("Error Update: $onError");
      return false;
    });
    return response;
  }

  Future<bool> register(UserIDance userIDance) async => getUser()
      .set(userIDance)
      .then((value) => true)
      .catchError((onError) => false);

  Future<bool> updatePlan(Map<String, dynamic> userIDance) async => getUser()
      .update(userIDance)
      .then((value) => true)
      .catchError((onError) => false);

  Future<bool> createVideosPaid() async {
    var videosPaid = await getVideosPaid().get();
    if (!videosPaid.exists) {
      bool response = await getVideosPaid()
          .set(VideosPaid(uid: uid, listVideoPaid: []))
          .then((value) => true)
          .catchError((onError) => false);
      return response;
    } else {
      return true;
    }
  }
}
