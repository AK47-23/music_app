class TrackModel {
  String? id;
  String? albumId;
  String? name;
  String? albumName;
  String? artistName;
  String? previewUrl;

  TrackModel(this.id, this.albumId, this.name, this.albumName, this.artistName,
      this.previewUrl);

  TrackModel.fromMap(Map<String, dynamic> map) {
    id = map["id"] ?? "";
    albumId = map["albumId"] ?? "";
    name = map["name"] ?? "";
    albumName = map["albumName"] ?? "";
    artistName = map["artistName"] ?? "";
    previewUrl = map["previewURL"] ?? "";
  }
}
