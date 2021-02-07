import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tartapain/constant.dart';
import 'package:tartapain/screens/detail/page_detail.dart';
import 'package:http/http.dart' as http;

Future<Produits> fecthProduits(id, type, api) async {
  String url = 'http://tartapain.bzh/api/apps/produits.php?id=' +
      id.toString() +
      '&type=' +
      type +
      '&api=' +
      api;
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return Produits.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load the post');
  }
}

class Produits {
  final String id;
  final String name;
  final String desc;
  final String imageUrl;
  //final String aImg;
  final String price;
  final String category;

  Produits(
      {this.id,
      this.name,
      this.desc,
      this.imageUrl,
      this.price,
      this.category});

  factory Produits.fromJson(Map<String, dynamic> json) {
    return Produits(
        id: json['id'],
        name: json['name'],
        desc: json['desc'],
        imageUrl: json['image'],
        category: json['cat'],
        price: json['price']);
  }
}

class CardElement extends StatefulWidget {
  final String idProduits;
  final String categoryName;

  const CardElement({Key key, this.idProduits, this.categoryName})
      : super(key: key);

  @override
  _CardElement createState() => _CardElement();
}

class _CardElement extends State<CardElement> {
  Future<Produits> futureProduits;
  @override
  void initState() {
    futureProduits = fecthProduits(
      widget.idProduits,
      'get-one',
      kApi,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: futureProduits,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailPage(
                            id: int.parse(widget.idProduits),
                            category: widget.categoryName,
                          )));
            },
            child: Container(
              margin: EdgeInsets.only(
                  left: kDefaultPadding,
                  top: kDefaultPadding / 2,
                  bottom: kDefaultPadding * 2.5),
              width: size.width * 0.4,
              child: Column(
                children: <Widget>[
                  Image.network('http://www.tartapain.bzh/apps/images/' +
                      snapshot.data.imageUrl),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(kDefaultPadding / 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 50,
                            color: kPrimaryColor.withOpacity(0.23),
                          )
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: snapshot.data.name + "\n".toUpperCase(),
                                  style: Theme.of(context).textTheme.button,
                                ),
                                TextSpan(
                                  text: widget.categoryName.toUpperCase(),
                                  style: TextStyle(
                                    color: kPrimaryColor.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Text(
                            snapshot.data.price.toString() + '€',
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(color: kPrimaryColor),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
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
