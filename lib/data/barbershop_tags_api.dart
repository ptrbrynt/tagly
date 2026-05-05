import 'package:dio/dio.dart';
import 'package:tagly/data/tags_xml_parser.dart';

class BarbershopTagsApi {
  BarbershopTagsApi({required Dio dio}) : _dio = dio;

  final Dio _dio;

  static final Uri _url = Uri.parse('https://www.barbershoptags.com/api.php');

  Future<TagsResponse> getTags({int? count}) async {
    final response = await _dio.getUri<String>(
      _url.replace(query: count != null ? 'n=$count' : null),
    );

    return TagsXmlParser.parse(response.data!);
  }
}
