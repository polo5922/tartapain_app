import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tartapain/constant.dart';
import 'package:tartapain/screens/home/components/CardElement.dart';

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

class CardContainer extends StatefulWidget {
  final int id;
  final String categoryName;

  const CardContainer({Key key, this.id, this.categoryName}) : super(key: key);

  @override
  _CardContainer createState() => _CardContainer();
}

class _CardContainer extends State<CardContainer> {
  Future<Ids> futureIds;
  @override
  void initState() {
    super.initState();
    futureIds = fetchIds(
      widget.categoryName,
      'get-category',
      kApi,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureIds,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < int.parse(snapshot.data.lenght); i++)
                  CardElement(
                    idProduits: snapshot.data.ids[i],
                    categoryName: widget.categoryName,
                  )
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(kPrimaryColor));
        }
      },
    );
  }
}
