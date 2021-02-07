import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tartapain/constant.dart';
import 'package:tartapain/screens/home/components/category_display.dart';
import 'package:tartapain/screens/home/components/header_with_searchbox.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

Future<CatNames> fetchNames(type, api) async {
  String url = 'http://tartapain.bzh/api/apps/produits.php?' +
      'type=' +
      type +
      '&api=' +
      api;
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return CatNames.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load the post');
  }
}

class CatNames {
  final List<dynamic> names;
  final String lenght;

  CatNames({
    this.names,
    this.lenght,
  });

  factory CatNames.fromJson(Map<String, dynamic> json) {
    return CatNames(
      names: json['names'],
      lenght: json['lenght'],
    );
  }
}

class _BodyState extends State<Body> {
  Future<CatNames> futureNames;
  @override
  void initState() {
    super.initState();
    futureNames = fetchNames(
      'get-category-name',
      kApi,
    );
  }

  @override
  Widget build(BuildContext context) {
    String name = 'test';
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
        future: futureNames,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  HeaderWithSearchBox(
                    size: size,
                    name: name,
                    searchBox: true,
                  ),
                  for (var i = 0; i < int.parse(snapshot.data.lenght); i++)
                    CategoryDisplay(
                      category: snapshot.data.names[i],
                    ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(kPrimaryColor));
          }
        });
  }
}
