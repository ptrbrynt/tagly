import 'package:dio/dio.dart';
import 'package:tagly/data/tags_xml_parser.dart';

class BarbershopTagsApi {
  BarbershopTagsApi({required Dio dio}) : _dio = dio;

  final Dio _dio;

  static final _url = Uri.parse('https://barbershoptags.com/api.php');

  Future<TagsResponse> getTags({int? count}) async {
    final response = await _dio.getUri<String>(
      _url.replace(queryParameters: {'n': ?count}),
    );

    return TagsXmlParser.parse(response.data!);
  }
}
