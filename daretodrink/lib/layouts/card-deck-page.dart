import 'package:daretodrink/data/card-model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardDeckPage extends StatefulWidget {
  List<CardModel> cards;
  CardDeckPage(this.cards, {Key? key}) : super(key: key);

  @override
  _CardDeckPageState createState() => _CardDeckPageState();
}

class _CardDeckPageState extends State<CardDeckPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
