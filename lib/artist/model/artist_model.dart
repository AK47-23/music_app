class ArtistModel {
  String? id;
  String? name;
  String? bio;
  String? image;

  ArtistModel(this.id, this.name, this.image, this.bio);

  ArtistModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    name = map["name"] ?? "";
    bio = map["bios"][0]["bio"] ?? "";
  }
}
