class AlbumModel {
  String? albumId;
  String? albumName;
  String? artistId;
  String? artistName;

  AlbumModel(this.albumId, this.albumName, this.artistId, this.artistName);

  AlbumModel.fromMap(Map<String, dynamic> map) {
    albumId = map["id"];
    albumName = map["name"];
    artistId = map["artistId"];
    artistName = map["artistName"];
  }
}
