import 'package:dio/dio.dart';

Future<MultipartFile?> networkImageToMultipart(String imageUrl) async {
  try {
    final dio = Dio();

    final response = await dio.get<List<int>>(
      imageUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    final bytes = response.data;

    if (bytes == null || bytes.isEmpty) {
      return null;
    }

    final uri = Uri.parse(imageUrl);

    String fileName = uri.pathSegments.isNotEmpty
        ? uri.pathSegments.last
        : 'clinic_image.jpg';

    if (!fileName.contains('.')) {
      fileName = 'clinic_image.jpg';
    }

    return MultipartFile.fromBytes(bytes, filename: fileName);
  } catch (e) {
    return null;
  }
}
