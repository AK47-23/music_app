class Common {
  static const baseUrl =
      "https://napi-v2-2-cloud-run-b3gtd5nmxq-uw.a.run.app/v2.2/";

  static const apiKey = "NWMzNzExNmEtZmFhMi00ZjYwLWJhZTYtOWJlOTY4N2ZmNmFl";

  static String returnImgUrl(String id) {
    return "https://api.napster.com/imageserver/v2/albums/$id/images/500x500.jpg";
  }
}
