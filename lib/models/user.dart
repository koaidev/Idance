class UserIDance {
  String? name;
  String? phone;
  String? email;
  String? uid;
  String? fcmToken;
  String? image;
  String? currentPlan;
  int? lastPlanDate;
  int? dateCreate;

  UserIDance(
      {this.name,
      this.phone,
      this.email,
      this.uid,
      this.fcmToken,
      this.image,
      this.currentPlan,
      this.lastPlanDate,
      this.dateCreate});

  UserIDance.fromJson(
    Map<String, dynamic>? json,
  ) : this(
          name: json?['name'] as String,
          phone: json?['phone'] as String,
          email: json?['email'] as String,
          uid: json?['uid'] as String,
          fcmToken: json?['fcmToken'] as String,
          image: json?['image'] as String,
          currentPlan: json?['currentPlan'] as String,
          lastPlanDate: json?['lastPlanDate'] as int,
          dateCreate: json?['dateCreate'] as int,
        );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'uid': uid,
      'fcmToken': fcmToken,
      'image': image,
      'currentPlan': currentPlan,
      'lastPlanDate': lastPlanDate,
      'dateCreate': dateCreate,
    };
  }
}
