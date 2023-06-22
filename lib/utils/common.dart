class Common {
  static const baseUrl =
      "https://napi-v2-2-cloud-run-b3gtd5nmxq-uw.a.run.app/v2.2/";

  static const apiKey = "YTkxZTRhNzAtODdlNy00ZjMzLTg0MWItOTc0NmZmNjU4Yzk4";

  static String returnImgUrl(String id) {
    return "http://direct.rhapsody.com/imageserver/v2/albums/$id/images/500x500.jpg";
  }
}
