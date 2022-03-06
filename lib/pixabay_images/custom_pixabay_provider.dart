import 'package:flutter/cupertino.dart';
import 'package:pixabay_picker/model/pixabay_media.dart';
import 'package:pixabay_picker/pixabay_api.dart';

class CustomPixabayProvider extends PixabayMediaProvider {
  CustomPixabayProvider({required String apiKey}) : super(apiKey: apiKey);

  @override
  Future<PixabayResponse?> requestMediaWithKeyword(
      {MediaType? media,
      String? keyword,
      int resultsPerPage = 30,
      int? page,
      String? category}) async {
    // Search for media associated with the keyword
    String url = "https://pixabay.com/api/";
    PixabayResponse? res;

    if (media == MediaType.video) url += "videos/";

    if (resultsPerPage < 3) {
      resultsPerPage = 3;
    }

    url += "?key=" + apiKey;

    if (keyword != null) url += "&q=" + Uri.encodeFull(keyword);

    url += "&lang=" + Uri.encodeFull(language) + "&per_page=$resultsPerPage";

    if (category != null) url += "&category=$category";

    url += "&safesearch=true";
    url += "&editors_choice=true";
    url += "&image_type=photo";
    // url += "&colors=turquoise";

    if (page != null) url += "&page=$page";

    if (media == MediaType.video) {
      var data = await getVideos(url);

      if (data != null && data.length > 0) {
        List<PixabayVideo> videos =
            List<PixabayVideo>.generate(data['hits'].length, (index) {
          return PixabayVideo.fromJson(data['hits'][index]);
        });

        res = PixabayResponse(
            total: data["total"], totalHits: data["totalHits"], hits: videos);
      }
    } else {
      debugPrint(url);
      var data = await getImages(url);

      if (data != null && data.length > 0) {
        List<PixabayImage> images =
            List<PixabayImage>.generate(data['hits'].length, (index) {
          return PixabayImage.fromJson(data['hits'][index]);
        });

        res = PixabayResponse(
            total: data["total"], totalHits: data["totalHits"], hits: images);
      }
    }
    return res;
  }
}
