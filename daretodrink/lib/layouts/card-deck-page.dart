import 'dart:math';

import 'package:daretodrink/data/application_settings.dart';
import 'package:daretodrink/data/card-model.dart';
import 'package:daretodrink/fragments/deck-card.dart';
import 'package:daretodrink/fragments/deck-wild-card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

class CardDeckPage extends StatefulWidget {
  final List<CardModel> cards;
  final List<CardModel> wildCards;
  const CardDeckPage(this.cards, this.wildCards, {Key? key}) : super(key: key);

  @override
  _CardDeckPageState createState() => _CardDeckPageState();
}

class _CardDeckPageState extends State<CardDeckPage>
    with TickerProviderStateMixin {
  static const int MAX_RANDOM = 100;
  int wildCardCounter = 0;

  late MatchEngine _cardsMatchEngine;
  late List<SwipeItem> _cardsSwipeItems;

  late MatchEngine _wildCardsMatchEngine;
  late List<SwipeItem> _wildCardsSwipeItems;

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    initCardsDeck();
    initWildCardsDeck();
    initAnimation();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Stack(
          children: [
            SwipeCards(
              itemChanged: itemChanged,
              matchEngine: _cardsMatchEngine,
              onStackFinished: () {
                initCardsDeck();
              },
              itemBuilder: (BuildContext context, int index) {
                return DeckCard(card: widget.cards[index]);
              },
              upSwipeAllowed: false,
              fillSpace: true,
            ),
            SlideTransition(
                position: _slideAnimation,
                child: SwipeCards(
                  itemChanged: itemChangedWildCard,
                  matchEngine: _wildCardsMatchEngine,
                  onStackFinished: () {
                    initWildCardsDeck();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    if (index % 2 == 0) {
                      return const DeckWildCard();
                    }
                    return DeckCard(card: widget.wildCards[index]);
                  },
                  upSwipeAllowed: false,
                  fillSpace: true,
                ))
          ],
        ),
      ),
    );
  }

  List<SwipeItem> _getSwipeItemsFromCards() {
    List<SwipeItem> toReturn = [];
    widget.cards.shuffle();
    for (int i = 0; i < widget.cards.length; i++) {
      toReturn.add(SwipeItem(
        content: widget.cards[i],
        likeAction: likeAction,
        nopeAction: nopeAction,
      ));
    }

    return toReturn;
  }

  List<SwipeItem> _getSwipeItemsFromWildCards() {
    List<SwipeItem> toReturn = [];
    widget.wildCards.shuffle();
    for (int i = 0; i < widget.wildCards.length; i++) {
      toReturn.add(SwipeItem(
        content: null,
        likeAction: likeActionWildCard,
        nopeAction: nopeActionWildCard,
      ));
      toReturn.add(SwipeItem(
        content: widget.wildCards[i],
        likeAction: likeActionWildCard,
        nopeAction: nopeActionWildCard,
      ));
    }

    return toReturn;
  }

  likeAction() {}

  nopeAction() {}

  likeActionWildCard() {}

  nopeActionWildCard() {}

  itemChanged(SwipeItem item, int index) {
    showWildCard();
  }

  itemChangedWildCard(SwipeItem item, int index) {
    if (item.content != null) {
      return;
    }
    hideWildCard();
    _wildCardsMatchEngine.currentItem!.like();
  }

  initCardsDeck() {
    _cardsSwipeItems = _getSwipeItemsFromCards();
    _cardsMatchEngine = MatchEngine(
      swipeItems: _cardsSwipeItems,
    );
  }

  initWildCardsDeck() {
    _wildCardsSwipeItems = _getSwipeItemsFromWildCards();
    _wildCardsMatchEngine = MatchEngine(
      swipeItems: _wildCardsSwipeItems,
    );
  }

  initAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(1.5, 0), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _animationController, curve: Curves.bounceIn));
  }

  bool shouldWildCardShow() {
    return wildCardCounter++ > 7 &&
        Random().nextInt(MAX_RANDOM) <=
            ApplicationSettings.instance.wildCardChance;
  }

  showWildCard() {
    if (shouldWildCardShow()) {
      _animationController
          .forward()
          .then((value) => _wildCardsMatchEngine.currentItem!.superLike());
    }
  }

  hideWildCard() {
    _animationController.reverse();
  }
}
