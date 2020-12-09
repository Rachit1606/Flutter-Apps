import 'dart:io';
import 'package:flutter/foundation.dart';
import '../helpers/db_helper.dart';
import '../models/signs.dart';

class ScannedSigns with ChangeNotifier {
  List<Sign> _items = [];

  List<Sign> get items {
    return [..._items];
  }

  final String authToken;
  final String userId;
  ScannedSigns(this.authToken, this.userId, this._items);

  Future<void> addPlace(
      String pickedtitle, File pickedimage, var recognitions) async {
    final newSign = Sign(
        id: DateTime.now().toString(),
        title: (recognitions == null || recognitions.isEmpty)
            ? pickedtitle
            : recognitions,
        image: pickedimage);
    _items.add(newSign);
    notifyListeners();
    DBHelper.insert('user_signs', {
      'id': newSign.id,
      'title': newSign.title,
      'image': newSign.image.path,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_signs');
    dataList
        .map(
          (item) => Sign(
            id: item['id'],
            title: item['title'],
            image: File(item['image']),
          ),
        )
        .toList();
    notifyListeners();
  }

  Sign findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }
}
