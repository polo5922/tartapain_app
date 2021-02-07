import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tartapain/constant.dart';
import 'package:tartapain/screens/home/components/CardContainer.dart';
import 'package:tartapain/screens/home/components/title_with_more_button.dart';
import 'package:http/http.dart' as http;

Future<IdCategory> fetchCatName(name) async {
  final reponse = await http.get(
      'http://www.tartapain.bzh/api/apps/produits.php?category=' +
          name +
          '&type=get-cat-id&api=PqfGRojEGhj4m8oGDsoqeHy57Boq8CnXyNiQbp');
  if (reponse.statusCode == 200) {
    return IdCategory.fromJson(json.decode(reponse.body));
  } else {
    throw Exception('Cound get the id of the name of cat');
  }
}

class IdCategory {
  final int idCat;

  IdCategory({this.idCat});

  factory IdCategory.fromJson(Map<String, dynamic> json) {
    return IdCategory(idCat: int.parse(json['id']));
  }
}

class CategoryDisplay extends StatefulWidget {
  final String category;

  const CategoryDisplay({Key key, this.category}) : super(key: key);

  @override
  _CategoryDisplay createState() => _CategoryDisplay();
}

class _CategoryDisplay extends State<CategoryDisplay> {
  Future<IdCategory> futureIdCat;
  @override
  void initState() {
    super.initState();
    futureIdCat = fetchCatName(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleWithButton(
          title: widget.category,
          btn: false,
        ),
        FutureBuilder(
            future: futureIdCat,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CardContainer(
                    id: snapshot.data.idCat, categoryName: widget.category);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else {
                return CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(kPrimaryColor),
                );
              }
            })
      ],
    );
  }
}
