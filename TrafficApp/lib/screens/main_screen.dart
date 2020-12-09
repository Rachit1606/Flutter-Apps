import 'package:TrafficApp/providers/signsScanned.dart';
import 'package:TrafficApp/screens/AddSignScreen.dart';
import 'package:TrafficApp/screens/TrafficSignDetail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './AddSignScreen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Detected Sign'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddSignScreen.routeName);
              }),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<ScannedSigns>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<ScannedSigns>(
                child: Center(
                  child:
                      Text('Got no Traffic Signs Yet, Start scanning some! '),
                ),
                builder: (ctx, greatPlaces, ch) => greatPlaces.items.length <= 0
                    ? ch
                    : ListView.builder(
                        itemCount: greatPlaces.items.length,
                        itemBuilder: (ctx, i) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage: FileImage(
                              greatPlaces.items[i].image,
                            ),
                          ),
                          title: Text(greatPlaces.items[i].title),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                TrafficSignDetail.routeName,
                                arguments: greatPlaces.items[i].id);
                          },
                        ),
                      ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddSignScreen.routeName);
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}
