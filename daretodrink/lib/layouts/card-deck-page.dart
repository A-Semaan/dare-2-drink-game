import 'dart:math';

import 'package:daretodrink/data/application-properties.dart';
import 'package:daretodrink/data/application_settings.dart';
import 'package:daretodrink/data/card-model.dart';
import 'package:daretodrink/data/dare-card-model.dart';
import 'package:daretodrink/data/twisted-card-model.dart';
import 'package:daretodrink/fragments/deck-card.dart';
import 'package:daretodrink/fragments/deck-twisted-card.dart';
import 'package:daretodrink/fragments/deck-wild-card.dart';
import 'package:daretodrink/fragments/twisted-card-label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

class CardDeckPage extends StatefulWidget {
  final Level level;
  final List<CardModel> cards;
  final List<CardModel> wildCards;
  final List<TwistedCardModel>? twistedCards;
  const CardDeckPage(this.cards, this.wildCards, this.level,
      {Key? key, this.twistedCards})
      : super(key: key);

  @override
  _CardDeckPageState createState() => _CardDeckPageState();
}

class _CardDeckPageState extends State<CardDeckPage>
    with TickerProviderStateMixin {
  static const int MAX_RANDOM = 100;
  int _swipeCounter = 0;

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

  bool _isTwistedEnabled = false;
  bool _userPromptedForTwisted = false;

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
    List<Widget> _cardStacks = [
      SwipeCards(
        itemChanged: itemChanged,
        matchEngine: _cardsMatchEngine,
        onStackFinished: () {
          setState(() {
            initCardsDeck();
          });
        },
        itemBuilder: (BuildContext context, SwipeItem item, Widget? widget) {
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
    ];
    if (widget.twistedCards != null) {
      _cardStacks.add(SlideTransition(
          position: _twistedSlideAnimation,
          child: SwipeCards(
            itemChanged: itemChangedTwistedCard,
            matchEngine: _twistedCardsMatchEngine!,
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
          )));
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Stack(
          children: _cardStacks,
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
      widget.twistedCards!.removeWhere((element) =>
          element.id == (item.content as TwistedCardModel).id &&
          !element.repeatable);
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
      _twistedCardsSwipeItems = _getSwipeItemsFromTwistedCards();

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
        Tween<Offset>(begin: const Offset(1.5, 0), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _twistedAnimationController, curve: Curves.bounceIn));
  }

  bool shouldWildCardShow() {
    return Random().nextInt(MAX_RANDOM) <=
        ApplicationSettings.instance.wildCardChance;
  }

  bool shouldTwistedCardShow() {
    return widget.level == Level.hornyMFs &&
        _isTwistedEnabled &&
        Random().nextInt(MAX_RANDOM) <=
            ApplicationSettings.instance.twistedCardChance;
  }

  showWildOrTwistedCard() {
    if (++_swipeCounter < 7) {
      return false;
    }
    if (widget.level == Level.hornyMFs && _swipeCounter >= 20 && !_userPromptedForTwisted && !_isTwistedEnabled) {
      promptForTwisted();
    } else if (shouldTwistedCardShow()) {
      _twistedAnimationController
          .forward()
          .then((value) => _twistedCardsMatchEngine!.currentItem!.superLike());
    } else if (shouldWildCardShow()) {
      _wildAnimationController
          .forward()
          .then((value) => _wildCardsMatchEngine.currentItem!.superLike());
    }
  }

  promptForTwisted() {
    showDialog(
        context: context,
        builder: (context) {
          AlertDialog dialog = AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: ApplicationProperties.instance.borderRadius),
            title: const Text("Turn on Twisted Mode?"),
            content: SizedBox(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "You seem to be enjoying this mode :p",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold)),
                  ]),
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      _isTwistedEnabled = true;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Hell Yeah!")),
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("No WTF"))
            ],
          );

          return dialog;
        });
    _userPromptedForTwisted = true;
  }

  hideWildCard() {
    _wildAnimationController.reverse();
  }

  hideTwistedCard() {
    _twistedAnimationController.reverse();
  }
}
