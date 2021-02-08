import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:tartapain/constant.dart';
import 'package:tartapain/screens/home/page_home.dart';

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

class DetailPage extends StatefulWidget {
  final int id;
  final String category;

  const DetailPage({Key key, this.id, this.category}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Future<Produits> futureProduits;

  @override
  void initState() {
    super.initState();
    futureProduits = fecthProduits(
      widget.id,
      'get-one',
      kApi,
    );
  }


  addItems(id,userID)
  {
    
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          }),
      actions: [
        IconButton(
            icon: Icon(
              Icons.shopping_basket,
              color: Colors.white,
            ),
            onPressed: () {}),
        IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            onPressed: () {}),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: FutureBuilder<Produits>(
        future: futureProduits,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Image(
                        image: NetworkImage(
                            'http://tartapain.bzh/apps/images/' +
                                snapshot.data.imageUrl)),
                    Container(
                      transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                      height: 350,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            snapshot.data.name,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 29),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.category + ' ',
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16),
                              ),
                              Text(
                                '·',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                ' ' + snapshot.data.price + ' €',
                                style: TextStyle(
                                  color: Color.fromRGBO(21, 116, 246, 1),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (widget.category == 'pizza')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Icon(Icons.ad_units_outlined),
                                    Text('1 part  '),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(Icons.ad_units_outlined),
                                    Text('  petite pizza  '),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(Icons.ad_units_outlined),
                                    Text('  Grande pizza'),
                                  ],
                                )
                              ],
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'à propos'.toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              snapshot.data.desc,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'allergène'.toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Image(
                                image: AssetImage('assets/map.png'),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      height: 70,
                      width: double.infinity,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: ButtonTheme(
                              minWidth: 310.0,
                              height: 50.0,
                              buttonColor: Colors.white,
                              child: RaisedButton(
                                onPressed: null,
                                color: Colors.white,
                                child: Text(
                                  'Add to basket!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(40)),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}' + ' test');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
