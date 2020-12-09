import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPath;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;
  final _picker = ImagePicker();
  Future<void> _takePicture() async {
    final image =
        await _picker.getImage(source: ImageSource.camera, maxWidth: 600);
    final File imageFile = File(image.path);
    if (imageFile == null) {
      return null;
    }
    setState(() {
      _storedImage = imageFile;
    });

    final appDir = await sysPath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  Future<void> _takeFromGallery() async {
    final image =
        await _picker.getImage(source: ImageSource.gallery, maxWidth: 600);
    final File imageFile = File(image.path);
    if (imageFile == null) {
      return null;
    }
    setState(() {
      _storedImage = imageFile;
    });
    final appDir = await sysPath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 375,
          height: 250,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        FlatButton.icon(
          icon: Icon(Icons.camera),
          label: Text('Take Picture'),
          textColor: Theme.of(context).primaryColor,
          onPressed: _takePicture,
        ),
        SizedBox(
          width: 10,
        ),
        FlatButton.icon(
          icon: Icon(Icons.upload_file),
          label: Text('Take From Gallery'),
          textColor: Theme.of(context).primaryColor,
          onPressed: _takeFromGallery,
        ),
      ],
    );
  }
}
