import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pet_care/logic/funcs/debug_logger.dart';

abstract class PetApi {
  Future<List<Map<String, dynamic>>> getAllBreeds(
      {int limit = 10, int page = 0});
}

abstract class BasePetApi implements PetApi {
  final String baseUrl;
  final String errorMessage;
  final Dio dio = Dio();
  final String apiKey = dotenv.get('API_KEY');

  BasePetApi({required this.baseUrl, required this.errorMessage}) {
    if (apiKey.isEmpty) {
      throw Exception('API_KEY отсутствует в .env');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllBreeds(
      {int limit = 10, int page = 0}) async {
    try {
      final response = await dio.get(
        '$baseUrl/breeds',
        queryParameters: {
          'limit': limit,
          'page': page,
        },
        options: Options(
          headers: {'x-api-key': apiKey},
        ),
      );
      DebugLogger.print('Ответ API ($baseUrl): ${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> breeds = response.data;
        final List<Map<String, dynamic>> breedsWithImages = [];

        for (var breed in breeds) {
          final breedMap = Map<String, dynamic>.from(breed);

          if (breedMap['image'] == null || breedMap['image']['url'] == null) {
            if (breedMap['reference_image_id'] != null) {
              try {
                final imageResponse = await dio.get(
                  '$baseUrl/images/${breedMap['reference_image_id']}',
                  options: Options(headers: {'x-api-key': apiKey}),
                );
                DebugLogger.print(
                    'Изображение для ${breedMap['name']}: ${imageResponse.data}');
                if (imageResponse.statusCode == 200 &&
                    imageResponse.data['url'] != null) {
                  breedMap['image'] = {'url': imageResponse.data['url']};
                } else {
                  breedMap['image'] = null;
                }
              } catch (e) {
                DebugLogger.print(
                    'Ошибка при загрузке изображения для ${breedMap['name']}: $e');
                breedMap['image'] = null;
              }
            } else {
              breedMap['image'] = null;
            }
          }

          breedsWithImages.add(breedMap);
        }

        return breedsWithImages;
      } else {
        throw Exception(errorMessage);
      }
    } catch (e) {
      DebugLogger.print('Ошибка в getAllBreeds ($baseUrl): $e');
      throw Exception('$errorMessage: $e');
    }
  }
}

class Dog extends BasePetApi {
  Dog()
      : super(
          baseUrl: 'https://api.thedogapi.com/v1',
          errorMessage: 'Error with dogs breeds',
        );
}

class Cat extends BasePetApi {
  Cat()
      : super(
          baseUrl: 'https://api.thecatapi.com/v1',
          errorMessage: 'Error with cats breeds',
        );
}
