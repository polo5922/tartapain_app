import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tartapain/constant.dart';
import 'package:tartapain/screens/home/components/category_display.dart';
import 'package:tartapain/screens/home/components/header_with_searchbox.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';

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
  String _dir;
  bool _downloading;
  List<String> _images, _tempImages;
  String _zipPath = "http://tartapain.bzh/apps/images/images.zip";
  String _localZipFileName = "images.zip";

  Future<CatNames> futureNames;
  @override
  void initState() {
    super.initState();
    futureNames = fetchNames(
      'get-category-name',
      kApi,
    );
    _images = List();
    _tempImages = List();
    _downloading = false;
    _initDir();
  }

  _initDir() async {
    if(null == _dir)
    {
      _dir = (await getApplicationDocumentsDirectory()).path;
    }
  }


  Future<File> _downloadFile(String url, String fileName) async {
    var req = await http.Client().get(Uri.parse(url));
    var file = File('$_dir/$fileName');
    return file.writeAsBytes(req.bodyBytes);
  }

  Future<void> _downloadZip() async {
    setState(() {
      _downloading = true;
    });

    _images.clear();
    _tempImages.clear();

    var zippedFile = await _downloadFile(_zipPath, _localZipFileName);
    await unarchiveAndSave(zippedFile);

    setState(() {
      _images.addAll(_tempImages);
      _downloading = false;
    });
  }

  unarchiveAndSave(var zippedFile) async{
    var bytes = zippedFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);
    for(var file in archive) {
      var fileName = '$_dir/${file.name}';
      if(file.isFile){
        var outFile = File(fileName);
        print('File:: '+outFile.path);
        _tempImages.add(outFile.path);
        
        outFile = await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
      }
    }
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
