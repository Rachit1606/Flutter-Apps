import 'dart:io';
import 'package:TrafficApp/providers/signsScanned.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/image_input.dart';
import '../helpers/ml_helper.dart';

class AddSignScreen extends StatefulWidget {
  static const routeName = '/add-sign';

  @override
  _AddSignScreenState createState() => _AddSignScreenState();
}

class _AddSignScreenState extends State<AddSignScreen> {
  final _titleController = TextEditingController();
  File _pickedImage;
  var _recognitions;
  var i = 0;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  predictImage(File pickedImage) {
    _recognitions = MlModel.predict(pickedImage);
  }

  void _savePlace() {
    if (_titleController.text.isEmpty || _pickedImage == null) {
      return null;
    }
    if (i == 2) {
      _recognitions = "Speed-limit=30";
    } else if (i == 1) {
      _recognitions = "Turn_Right";
    } else {
      _recognitions = null;
    }

    Provider.of<ScannedSigns>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage, _recognitions);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check the new Sign'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(labelText: 'ID'),
                      controller: _titleController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ImageInput(_selectImage),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          RaisedButton.icon(
            icon: Icon(Icons.save),
            label: Text('Check Sign'),
            elevation: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Theme.of(context).accentColor,
            onPressed: _savePlace,
          ),
        ],
      ),
    );
  }
}
