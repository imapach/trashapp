import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class HttpHelper {
  Dio _dio;

  static final _instance = HttpHelper._internal();

  factory HttpHelper() => _instance;

  HttpHelper._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: "https://www.xx.com/api",
      // connectTimeout: 5000,
      // receiveTimeout: 3000,
    );
    _dio = Dio(options);
    _dio.interceptors.add(LogInterceptor());
  }

  Dio get dio => _dio;

  // Future<Response<T>> request<T>(
  //   String path, {
  //   data,
  //   Map<String, dynamic> queryParameters,
  //   CancelToken cancelToken,
  //   Options options,
  //   ProgressCallback onSendProgress,
  //   ProgressCallback onReceiveProgress,
  // }) {
  //   return _dio.request(path,
  //       data: data,
  //       queryParameters: queryParameters,
  //       cancelToken: cancelToken,
  //       options: options,
  //       onSendProgress: onSendProgress,
  //       onReceiveProgress: onReceiveProgress);
  // }
}

final Dio dio = HttpHelper().dio;



// 图像数据，base64编码，要求base64编码后大小不超过4M，最短边至少15px，最长边最大4096px,支持jpg/png/bmp格式。
// 注意：图片需要base64编码、去掉编码头（data:image/jpg;base64,）后，再进行urlencode。
Future<void> fun(File image) async {

  var uint8list = await image.readAsBytes();
  String base64encode = base64Encode(uint8list);



  FormData formData = FormData.fromMap({"image": base64encode});
  Map<String,dynamic> queryParameters = {"access_token":"24.f35d056a5af721557442fd1a336f9275.2592000.1589640659.282335-19290160"};
  Response response = await dio.post(
      "https://aip.baidubce.com/rest/2.0/image-classify/v2/advanced_general",
      data: formData,
      queryParameters: queryParameters,
      options: Options(contentType: Headers.formUrlEncodedContentType));
print(response.data);
}
