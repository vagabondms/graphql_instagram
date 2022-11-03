class Media {
  Media();

  int? id;
  MediaType? mediaType;
  String? url;
  int? width;
  int? height;

  Media.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        mediaType = json['type'] == "IMAGE" ? MediaType.image : MediaType.video,
        url = json['url'],
        width = json['width'],
        height = json['height'];
}

enum MediaType {
  image,
  video,
}
