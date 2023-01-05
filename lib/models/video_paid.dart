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
  String? videoId;
  String? numberCanWatch;

  VideoPaid({this.videoId, this.numberCanWatch});

  VideoPaid.fromJson(
    Map<String, dynamic>? json,
  ) : this(
            videoId: json?['video_id'] as String,
            numberCanWatch: json?['number_can_watch']);

  Map<String, dynamic> toJson() {
    return {
      'video_id': videoId,
      'number_can_watch': numberCanWatch,
    };
  }
}
