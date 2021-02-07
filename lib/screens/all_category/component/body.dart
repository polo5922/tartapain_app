import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tartapain/constant.dart';
import 'package:tartapain/screens/all_category/component/CardElement.dart';
import 'package:tartapain/screens/home/components/header_with_searchbox.dart';
import 'package:tartapain/screens/home/components/title_with_more_button.dart';
import 'package:http/http.dart' as http;

Future<Ids> fetchIds(category, type, api) async {
  String url = 'http://tartapain.bzh/api/apps/produits.php?category=' +
      category.toString() +
      '&type=' +
      type +
      '&api=' +
      api;
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return Ids.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load the post');
  }
}

class Ids {
  final List<dynamic> ids;
  final String lenght;

  Ids({
    this.ids,
    this.lenght,
  });

  factory Ids.fromJson(Map<String, dynamic> json) {
    return Ids(
      ids: json['ids'],
      lenght: json['lenght'],
    );
  }
}

class Body extends StatefulWidget {
  final cName;
  Body({Key key, this.cName}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<Ids> futureIds;
  @override
  void initState() {
    futureIds = fetchIds(
      widget.cName,
      'get-category',
      kApi,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String name = 'test';
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          HeaderWithSearchBox(size: size, name: name),
          TitleWithButton(
            title: widget.cName,
            btn: false,
          ),
          FutureBuilder(
            future: futureIds,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Row(
                  children: [
                    for (var i = 0; i < int.parse(snapshot.data.lenght); i++)
                      if (i % int.parse(snapshot.data.lenght) == 1)
                        CardElement(
                          idProduits: snapshot.data.ids[i],
                          categoryName: widget.cName,
                        ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(kPrimaryColor),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
