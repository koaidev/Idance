class VideosPaid {
  List<VideoPaid>? listVideoPaid = [];
  String? uid;

  VideosPaid({this.uid, this.listVideoPaid});

  VideosPaid.fromJson(Map<String, dynamic>? json) {
    this.uid = json?["uid"];
    if (json?['list_video_paid'] != null) {
      this.listVideoPaid = <VideoPaid>[];
      json?['list_video_paid'].forEach((v) {
        listVideoPaid?.add(new VideoPaid.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'list_video_paid': this.listVideoPaid?.map((v) => v.toJson()).toList(),
    };
  }
}

class VideoPaid {
  int? videoId;
  int? numberCanWatch;
  String? uid;
  bool? status;
  String? name;
  String? thumb;

  VideoPaid(
      {this.videoId,
      this.numberCanWatch,
      this.uid,
      this.status,
      this.name,
      this.thumb});

  VideoPaid.fromJson(
    Map<String, dynamic>? json,
  ) : this(
            videoId: json?['video_id'],
            numberCanWatch: json?['number_can_watch'],
            uid: json?['uid'],
            status: json?['status'],
            name: json?['name'],
            thumb: json?['thumb']);

  Map<String, dynamic> toJson() {
    return {
      'video_id': videoId,
      'number_can_watch': numberCanWatch,
      'uid': uid,
      'status': status,
      'thumb': thumb,
      'name': name
    };
  }
}
