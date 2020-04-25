import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class HttpHelper {
  Dio _dio;

  static final _instance = HttpHelper._internal();

  factory HttpHelper() => _instance;

  HttpHelper._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: "http://192.168.0.100:8081",
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
// {log_id: 6702989604445047061, result_num: 5, result: [{score: 0.214262, root: 建筑-室内, keyword: 室内一角}, {score: 0.157089, root: 建筑-居家室内, keyword: 电视背景墙}, {score: 0.104574, root: 非自然图像-其他, keyword: 装修效果图}, {score: 0.053477, root: 建筑-居家室内, keyword: 室内效果图}, {score: 0.00274, root: 建筑-居家室内, keyword: 吊顶}]}
Future<List<String>> patternRecognition(File image) async {
  var uint8list = await image.readAsBytes();
  String base64encode = base64Encode(uint8list);

  FormData formData = FormData.fromMap({"image": base64encode});
  Map<String,dynamic> queryParameters = {"access_token":"24.f35d056a5af721557442fd1a336f9275.2592000.1589640659.282335-19290160"};
  Response response = await dio.post(
      "https://aip.baidubce.com/rest/2.0/image-classify/v2/advanced_general",
      data: formData,
      queryParameters: queryParameters,
      options: Options(contentType: Headers.formUrlEncodedContentType));


      List<String> ret = List();
      var data = response.data;
      var result = data["result"];
      for (var item in result) {
        String keyword = item["keyword"];
        ret.add(keyword);
      }
      return ret;
}


Future<dynamic> garbageSearch(String name) async {
  Map<String,dynamic> data = {"name":name};
  Response response = await dio.post("/garbage/getAllObjects",data:data);
  var result = response.data;
  var result2 = result["data"];
  return result2["items"];
}


Future<dynamic> allGarbages(int garbageType) async {
    Map<String,dynamic> data = {"garbageType":garbageType,"size":5000};
  Response response = await dio.post("/garbage/getAllObjects",data:data);
  return response.data["data"]["items"];
}


        // "publishId": 8,
        // "detailsId": 19,
        // "newsTitle": "覆盖达95%以上 南京高淳打造农村垃圾分类“示范样本”",
        // "publishTime": 1587486339,
        // "formatTime": "2020-04-22 00:25:39",
        // "reviewId": 9,
        // "type": 2,
        // "categoryName": "垃圾分类资讯",
        // "stop": false
Future<dynamic> newsList(int page) async {
    Map<String,dynamic> queryParameters = {"page":page,"limit":10};
  var response =  await dio.get("/news/api/list",queryParameters: queryParameters);
  var data = response.data["data"];
  return data["list"];
}

// {
//   "success": true,
//   "code": 200,
//   "data": {
//     "detailsId": 17,
//     "newsTitle": "梁莉莉测试标题",
//     "author": "梁莉莉",
//     "type": 2,
//     "cover": "",
//     "newsContent": "<h1>资讯的内容，测试发布使用<img src=\"http://img.t.sinajs.cn/t4/appstyle/expression/ext/normal/50/pcmoren_huaixiao_org.png\" alt=\"[坏笑]\" data-w-e=\"1\" style=\"font-size: 12px;\"></h1>"
//   }
// }
Future<dynamic> newsDetail(int id) async {
  var response = await dio.get("/news/api/details/2/$id");
  return response.data["data"];
}

