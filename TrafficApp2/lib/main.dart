import 'package:flutter/material.dart';
import 'auth_screen.dart';
import 'auth.dart';
import 'splash_screen.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'networkCall.dart';
import 'uploadImage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Traffic Sign App',
          theme: ThemeData(
              primarySwatch: Colors.indigo,
              accentColor: Colors.amber,
              fontFamily: 'Amaranth',
              pageTransitionsTheme: PageTransitionsTheme(builders: {})),
          home: auth.isAuth
              ? DetectMain()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
        ),
      ),
    );
  }
}

class DetectMain extends StatefulWidget {
  @override
  _DetectMainState createState() => new _DetectMainState();
}

class _DetectMainState extends State<DetectMain> {
  Future<List<ImageData>> list;
  List<ImageData> _searchList;
  List<ImageData> auxList;
  TextEditingController _searchController = new TextEditingController();
  bool _search = false;
  @override
  void initState() {
    list = loadImages();
    auxList = [];

    _searchController.addListener(() {
      print("clicked");
      _searchList = auxList
          .where((i) => i.prediction.startsWith(_searchController.text))
          .toList();
      _search = true;
      // onChip = getMemebrs(originaList);

      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Traffic Sign Detection"), bottom: getSearchBar()),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Upload()));
          },
        ),
        body: FutureBuilder(
            future: list,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError)
                return new Text('Nothing Added yet Try Adding Some',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w700));
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new LinearProgressIndicator(
                    backgroundColor: Colors.deepPurpleAccent,
                  );
                default:
                  if (_search == true) {
                    return GridView.count(
                        crossAxisCount: 2,
                        children:
                            List<Widget>.generate(_searchList.length, (index) {
                          return GridImage(
                            uri: _searchList[index].uri,
                            pre: _searchList[index].prediction,
                          );
                        }));
                  } else
                    return GridView.count(
                        crossAxisCount: 2,
                        children: List<Widget>.generate(snapshot.data.length,
                            (index) {
                          auxList.add(ImageData(snapshot.data[index].uri,
                              snapshot.data[index].prediction));
                          return GridImage(
                            uri: snapshot.data[index].uri,
                            pre: snapshot.data[index].prediction,
                          );
                        }));
              }
            }));
  }

  getSearchBar() {
    return PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
              trailing: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
              title: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    hintText: 'Search image  ', border: InputBorder.none),
              ),
            ),
          ),
        ));
  }
}

// ignore: must_be_immutable
class GridImage extends StatelessWidget {
  String uri;
  String pre;
  GridImage({this.uri, this.pre});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
          child: Column(
        children: <Widget>[Image.network(uri), Text("prediction:" + pre)],
      )),
    );
  }
}
