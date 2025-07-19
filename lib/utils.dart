String buildUrlWithQueryParams(String url, Map<String, dynamic> queryParams) {
  final uri = Uri.parse(url);

  final fullUri = uri.replace(
    queryParameters: {...uri.queryParameters, ...queryParams},
  );

  final parsedUrl = fullUri.toString();

  if (parsedUrl[parsedUrl.length - 1] == '?') {
    return parsedUrl.substring(0, parsedUrl.length - 1);
  } else {
    return parsedUrl;
  }
}
