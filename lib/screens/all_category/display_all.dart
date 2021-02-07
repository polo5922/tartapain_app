import 'package:flutter/material.dart';
import 'package:tartapain/screens/all_category/component/body.dart';
import 'package:tartapain/screens/home/page_home.dart';

class DisplayAllC extends StatefulWidget {
  final String cName;

  const DisplayAllC({Key key, this.cName}) : super(key: key);
  @override
  _DisplayAllC createState() => _DisplayAllC();
}

class _DisplayAllC extends State<DisplayAllC> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(),
      body: Body(cName: widget.cName),
    );
  }

  AppBar buildAppbar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
          icon: Icon(
            Icons.home,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
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
}
