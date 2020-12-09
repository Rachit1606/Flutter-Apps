import 'dart:io';
import 'package:flutter/foundation.dart';

class Sign {
  final String id;
  final String title;
  final File image;

  Sign({
    @required this.id,
    @required this.title,
    @required this.image,
  });
}
