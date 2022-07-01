import 'dart:math';

import 'package:daretodrink/data/application_settings.dart';
import 'package:daretodrink/data/card-model.dart';
import 'package:daretodrink/fragments/deck-card.dart';
import 'package:daretodrink/fragments/deck-twisted-card.dart';
import 'package:daretodrink/fragments/deck-wild-card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

class CardDeckPage extends StatefulWidget {
  final Level level;
  final List<CardModel> cards;
  final List<CardModel> wildCards;
  final List<CardModel>? twistedCards;
  const CardDeckPage(this.cards, this.wildCards, this.level,
      {Key? key, this.twistedCards})
      : super(key: key);

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

  late AnimationController _wildAnimationController;
  late Animation<Offset> _wildSlideAnimation;

  late MatchEngine? _twistedCardsMatchEngine;
  late List<SwipeItem>? _twistedCardsSwipeItems;

  late AnimationController _twistedAnimationController;
  late Animation<Offset> _twistedSlideAnimation;

  bool _isTwistedEnabled = true;

  @override
  void initState() {
    initCardsDeck();
    initWildCardsDeck();
    initTwistedCardsDeck();
    initWildAnimation();
    initTwistedAnimation();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _wildAnimationController.dispose();
    _twistedAnimationController.dispose();
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
                setState(() {
                  initCardsDeck();
                });
              },
              itemBuilder:
                  (BuildContext context, SwipeItem item, Widget? widget) {
                // int newIndex = index % widget.cards.length;
                // if (index > widget.cards.length && newIndex == 0) {
                //   setState(() {
                //     initCardsDeck();
                //   });
                // }
                return DeckCard(card: item.content);
              },
              upSwipeAllowed: false,
              fillSpace: true,
            ),
            SlideTransition(
                position: _wildSlideAnimation,
                child: SwipeCards(
                  itemChanged: itemChangedWildCard,
                  matchEngine: _wildCardsMatchEngine,
                  onStackFinished: () {
                    setState(() {
                      initWildCardsDeck();
                    });
                  },
                  itemBuilder:
                      (BuildContext context, SwipeItem item, Widget? widget) {
                    // int newIndex = (index % (widget.wildCards.length * 2));
                    // if (index > widget.wildCards.length && newIndex == 0) {
                    //   setState(() {
                    //     initWildCardsDeck();
                    //   });
                    // }
                    if (item.content == null) {
                      return const DeckWildCard();
                    }
                    return DeckCard(card: item.content);
                  },
                  upSwipeAllowed: false,
                  fillSpace: true,
                )),
            SlideTransition(
                position: _twistedSlideAnimation,
                child: SwipeCards(
                  itemChanged: itemChangedTwistedCard,
                  matchEngine: _wildCardsMatchEngine,
                  onStackFinished: () {
                    setState(() {
                      initTwistedCardsDeck();
                    });
                  },
                  itemBuilder:
                      (BuildContext context, SwipeItem item, Widget? widget) {
                    if (item.content == null) {
                      return const DeckTwistedCard();
                    }
                    return DeckCard(card: item.content);
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
        content: widget.wildCards[i],
        likeAction: likeActionWildCard,
        nopeAction: nopeActionWildCard,
      ));
    }

    return toReturn;
  }

  List<SwipeItem> _getSwipeItemsFromTwistedCards() {
    List<SwipeItem> toReturn = [];
    widget.twistedCards!.shuffle();
    for (int i = 0; i < widget.twistedCards!.length; i++) {
      toReturn.add(SwipeItem(
        content: widget.twistedCards![i],
        likeAction: likeActionTwistedCard,
        nopeAction: nopeActionTwistedCard,
      ));
    }

    return toReturn;
  }

  likeAction() {}

  nopeAction() {}

  likeActionWildCard() {}

  nopeActionWildCard() {}

  likeActionTwistedCard() {}

  nopeActionTwistedCard() {}

  itemChanged(SwipeItem item, int index) {
    showWildOrTwistedCard();
  }

  itemChangedWildCard(SwipeItem item, int index) {
    if (item.content != null) {
      return;
    }

    hideWildCard();
  }

  itemChangedTwistedCard(SwipeItem item, int index) {
    if (item.content != null) {
      return;
    }

    hideTwistedCard();
  }

  initCardsDeck() {
    _cardsSwipeItems = _getSwipeItemsFromCards();
    _cardsMatchEngine = MatchEngine(
      swipeItems: _cardsSwipeItems,
    );
  }

  initWildCardsDeck() {
    _wildCardsSwipeItems = _getSwipeItemsFromWildCards();

    _wildCardsMatchEngine =
        MatchEngine(swipeItems: _wildCardsSwipeItems, withInterCard: true);
  }

  initTwistedCardsDeck() {
    if (widget.twistedCards != null) {
      _twistedCardsSwipeItems = _getSwipeItemsFromWildCards();

      _twistedCardsMatchEngine =
          MatchEngine(swipeItems: _twistedCardsSwipeItems, withInterCard: true);
    }
  }

  initWildAnimation() {
    _wildAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _wildSlideAnimation =
        Tween<Offset>(begin: const Offset(1.5, 0), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _wildAnimationController, curve: Curves.bounceIn));
  }

  initTwistedAnimation() {
    _twistedAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _twistedSlideAnimation =
        Tween<Offset>(begin: const Offset(-1.5, 0), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _twistedAnimationController, curve: Curves.bounceIn));
  }

  bool shouldWildCardShow() {
    return wildCardCounter++ > 7 &&
        Random().nextInt(MAX_RANDOM) <=
            ApplicationSettings.instance.wildCardChance;
  }

  bool shouldTwistedCardShow() {
    return widget.level == Level.hornyMFs &&
        _isTwistedEnabled &&
        wildCardCounter++ > 7 &&
        Random().nextInt(MAX_RANDOM) <=
            ApplicationSettings.instance.wildCardChance;
  }

  showWildOrTwistedCard() {
    if (shouldTwistedCardShow()) {
      _twistedAnimationController
          .forward()
          .then((value) => _twistedCardsMatchEngine!.currentItem!.superLike());
    } else if (shouldWildCardShow()) {
      _wildAnimationController
          .forward()
          .then((value) => _wildCardsMatchEngine.currentItem!.superLike());
    }
  }

  hideWildCard() {
    _wildAnimationController.reverse();
  }

  hideTwistedCard() {
    _twistedAnimationController.reverse();
  }
}
