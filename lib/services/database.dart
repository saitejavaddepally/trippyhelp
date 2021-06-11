import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserInfoToDB(
      String userid, Map<String, dynamic> userInfoMap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userid)
        .set(userInfoMap);
  }
}

class DatabaseLocationService {
  // Collection for specific user

  final String uid;
  DatabaseLocationService({required this.uid});
  // Collection reference
  final CollectionReference locationInformation =
      FirebaseFirestore.instance.collection("locationInfoOfUser");

  Future updateUserData(
      String startingPoint, String destination, String days) async {
    return await locationInformation.doc(uid).set({
      'startingPoint': startingPoint,
      'destination': destination,
      'days': days
    });
  }

  // get user given location

  Future getUserData() async {
    return await locationInformation.doc(uid).get();
  }
}
