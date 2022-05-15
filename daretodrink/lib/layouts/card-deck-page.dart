import 'package:daretodrink/data/card-model.dart';
import 'package:daretodrink/fragments/deck-card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

class CardDeckPage extends StatefulWidget {
  List<CardModel> cards;
  CardDeckPage(this.cards, {Key? key}) : super(key: key);

  @override
  _CardDeckPageState createState() => _CardDeckPageState();
}

class _CardDeckPageState extends State<CardDeckPage> {
  late MatchEngine _matchEngine;
  late List<SwipeItem> _swipeItems;

  @override
  void initState() {
    _swipeItems = _getSwipeItemsFromCards();
    _matchEngine = MatchEngine(
      swipeItems: _swipeItems,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: SwipeCards(
          itemChanged: itemChanged,
          matchEngine: _matchEngine,
          onStackFinished: () {},
          itemBuilder: (BuildContext context, int index) {
            return DeckCard(card: widget.cards[index]);
          },
          upSwipeAllowed: false,
          fillSpace: true,
        ),
      ),
    );
  }

  List<SwipeItem> _getSwipeItemsFromCards() {
    List<SwipeItem> toReturn = [];
    for (int i = 0; i < widget.cards.length; i++) {
      toReturn.add(SwipeItem(
        content: widget.cards[i],
        likeAction: likeAction,
        nopeAction: nopeAction,
      ));
    }

    return toReturn;
  }

  likeAction() {}

  nopeAction() {}

  itemChanged(SwipeItem item, int index) {}
}
