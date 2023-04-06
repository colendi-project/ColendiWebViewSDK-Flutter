extension UriExtension on Uri {
  Uri appendQueryParameter(String key, String value) {
    final newQueryParams =
        Map<String, String>.fromEntries(queryParameters.entries);
    if (newQueryParams.containsKey(key)) {
      newQueryParams.remove(key);
      newQueryParams.addAll({key: value});
    } else {
      newQueryParams.addAll({key: value});
    }
    return Uri(
      scheme: scheme,
      userInfo: userInfo,
      host: host,
      port: port,
      path: path,
      queryParameters: newQueryParams,
      fragment: fragment,
    );
  }
}
