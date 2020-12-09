import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  File imgPath;
  var output = "Speed Limit 30";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image"),
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              imgPath != null
                  ? new Image.file(imgPath)
                  : new Text("Select an image to upload"),
              SizedBox(height: 20),
              RaisedButton(
                color: Colors.indigo,
                textColor: Colors.white,
                child: Text(
                  "Pick Image from gallery",
                ),
                onPressed: () async {
                  var filename = await ImagePicker()
                      .getImage(source: ImageSource.gallery, maxWidth: 600);
                  File image = File(filename.path);
                  setState(() {
                    imgPath = image;
                  });
                },
              ),
              SizedBox(height: 20),
              RaisedButton(
                color: Colors.indigo,
                textColor: Colors.white,
                child: Text(
                  "Pick Image from Camera",
                ),
                onPressed: () async {
                  var filename = await ImagePicker()
                      .getImage(source: ImageSource.camera, maxWidth: 600);
                  File image = File(filename.path);
                  setState(() {
                    imgPath = image;
                  });
                },
              ),
              SizedBox(height: 20),
              RaisedButton(
                color: Colors.indigo,
                textColor: Colors.white,
                child: Text("Upload to server"),
                onPressed: () {
                  {
                    AlertDialog(
                      title: Text('Traffic Sign Detected'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(
                                'Congratulations you have detected a Traffic Sign'),
                            Text('The traffic Sign Detected is $output'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Ok'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  } //uploadImageToServer(imgPath);
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        )),
      ),
    );
  }

  uploadImageToServer(File imageFile) async {
    print("attempting to connect to server……");
    var stream1 = new http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    print(length);
    var uri = Uri.parse('http://192.168.29.136:5000/predict');
    print(uri);
    print("connection established.");
    var request = new http.MultipartRequest("POST", uri);
    request.files.add(new http.MultipartFile('file', stream1, length,
        filename: basename(imageFile.path)));
    print("file is added");
    var response = await request.send();
    print("shakalaka boom boom");
    print(response.statusCode);
  }
}
