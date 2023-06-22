class TrackModel {
  String? id;
  String? albumId;
  String? name;

  TrackModel(this.id, this.albumId, this.name);

  TrackModel.fromMap(Map<String, dynamic> map) {
    id = map["id"] ?? "";
    albumId = map["albumId"] ?? "";
    name = map["name"] ?? "";
  }
}
