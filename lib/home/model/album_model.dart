class AlbumModel {
  String? albumId;
  String? albumName;
  String? artistName;

  AlbumModel(this.albumId, this.albumName, this.artistName);

  AlbumModel.fromMap(Map<String, dynamic> map) {
    albumId = map["id"];
    albumName = map["name"];
    artistName = map["artistName"];
  }
}
