import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class MlModel {
  static Future<void> predict(File image) async {
    var recognitions;
    try {
      String res;
      res = await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
      );
      print(res);
    } on PlatformException {
      print("failed to load the model");
    }
    try {
      recognitions = await Tflite.runModelOnImage(
        path: image.path, //required
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, //defaults to 5
        threshold: 0.2, //defaults to 0.1
        asynch: true, //defaults to true
      );
    } on PlatformException {
      print("Failed to run Model");
    }
    print(recognitions);
    Tflite.close();
    return recognitions;
  }
}

class ImageData {
//  static String  BASE_URL ='http://192.168.1.103:5000/';
  String uri;
  String prediction;
  ImageData(this.uri, this.prediction);
}

Future<List<ImageData>> loadImages() async {
  var data = await http.get('http://192.168.29.136:5000/api/');
  var jsondata = json.decode(data.body);
  List<ImageData> newslist = [];
  for (var data in jsondata) {
    ImageData n = ImageData(data['url'], data['prediction']);
    newslist.add(n);
  }

  return newslist;
}
