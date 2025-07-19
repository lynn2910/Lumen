import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lumen/constants.dart';
import 'package:lumen/services/pixabay_image.dart';

import '../utils.dart' show buildUrlWithQueryParams;

const baseUrl = "https://pixabay.com/api";

Future<PixabayResponse> fetchPhotos({
  String? search,
  int? perPage,
  bool? editorsChoice,
  int? page,
}) async {
  var params = {'key': PIXABAY_KEY};
  if (search != null) params["search"] = search;
  if (perPage != null) params["per_page"] = perPage.toString();
  if (page != null) params["page"] = page.toString();
  if (editorsChoice != null) {
    params['editors_choice'] = editorsChoice.toString();
  }

  final url = buildUrlWithQueryParams(baseUrl, params);

  try {
    var res = await http.get(Uri.parse(url));

    if (res.statusCode != 200) {
      return Future.error("Cannot fetch photos: ${res.body}");
    }

    Map<String, dynamic> jsonMap = jsonDecode(res.body);
    PixabayResponse pixabayResponse = PixabayResponse.fromJson(jsonMap);

    return pixabayResponse;
  } catch (e) {
    throw Exception("Failed to fetch photos: $e");
  }
}
