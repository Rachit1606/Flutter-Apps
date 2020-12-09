import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './product.dart';
import 'dart:convert';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    /*Product(
      id: 'p1',
      title: 'Apple',
      description: 'A red Apple - it is pretty red!',
      price: 120.00,
      imageUrl:
          'https://images.pexels.com/photos/102104/pexels-photo-102104.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    ),
    Product(
      id: 'p2',
      title: 'Potato',
      description: 'A nice Potato',
      price: 50.00,
      imageUrl:
          'http://data:image/jpeg;base64,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',
    ),
    Product(
      id: 'p3',
      title: 'Meals',
      description: 'its Hot and spicy',
      price: 199.99,
      imageUrl:
          'https://images.immediate.co.uk/production/volatile/sites/30/2020/08/quick-chicken-and-hummus-bowl-220e449.jpg?quality=90&resize=960,872',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 499.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),*/
  ];
  //var _showFavoritesOnly = false;
  final String authToken;
  final String userId;
  //Products();
  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    /*if (_showFavoritesOnly) {
      return _items.where((proditem) => proditem.isFavorite).toList();
    }*/
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  /*void showFavouritesOnly() {
    _showFavoritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoritesOnly = false;
    notifyListeners();
  }*/
  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://shopapp1-19fef.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://shopapp1-19fef.firebaseio.com/userFavourites/$userId.json?auth=$authToken';
      final favoriteresponse = await http.get(
        url,
      );
      final favoriteData = json.decode(favoriteresponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shopapp1-19fef.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newproduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://shopapp1-19fef.firebaseio.com/products/$id.json?auth=$authToken';

      await http.patch(url,
          body: json.encode({
            'title': newproduct.title,
            'description': newproduct.description,
            'imageUrl': newproduct.imageUrl,
            'price': newproduct.price,
          }));
      _items[prodIndex] = newproduct;
      notifyListeners();
    } else {
      print('.....');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shopapp1-19fef.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could Not delete Product');
    }
    existingProduct = null;
  }
}
