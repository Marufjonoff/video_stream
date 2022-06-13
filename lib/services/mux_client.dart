import 'package:dio/dio.dart';

import '../models/asset_data.dart';
import '../models/video_data.dart';
import 'dio_constanta.dart';

class MUXClient {
  Dio dio = Dio();

  initializeDio() {
    BaseOptions options = BaseOptions(
      baseUrl: muxServerUrl,
      connectTimeout: 8000,
      receiveTimeout: 5000,
      headers: {
        "Content-Type": contentType, // application/json
      },
    );
    dio = Dio(options);
  }

  Future<VideoData?>? storeVideo({String? videoUrl}) async {
    Response response;

    try {
      response = await dio.post(
        "/assets",
        data: {
          "videoUrl": videoUrl,
        },
      );
    } catch (e) {
      print('Error starting build: $e');
      throw Exception('Failed to store video on MUX');
    }

    if (response.statusCode == 200) {
      VideoData? videoData = VideoData.fromJson(response.data);

      String? status = videoData.data?.status;

      while (status == 'preparing') {
        print('processing...');
        await Future.delayed(Duration(seconds: 1));
        videoData = await checkPostStatus(videoId: videoData?.data?.id);
        status = videoData?.data?.status;
      }

      return videoData;
    }

    return null;
  }

  Future<VideoData?> checkPostStatus({String? videoId}) async {
    try {
      Response response = await dio.get(
        "/asset",
        queryParameters: {
          'videoId': videoId,
        },
      );

      if (response.statusCode == 200) {
        VideoData videoData = VideoData.fromJson(response.data);

        return videoData;
      }
    } catch (e) {
      print('Error starting build: $e');
      throw Exception('Failed to check status');
    }

    return null;
  }

  Future<AssetData?>? getAssetList() async {
    try {
      Response response = await dio.get(
        "/assets",
      );

      if (response.statusCode == 200) {
        AssetData assetData = AssetData.fromJson(response.data);

        return assetData;
      }
    } catch (e) {
      print('Error starting build: $e');
      throw Exception('Failed to retrieve videos from MUX');
    }

    return null;
  }
}