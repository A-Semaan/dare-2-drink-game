library swipe_cards;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/profile_card.dart';

class SwipeCards extends StatefulWidget {
  final ValueWidgetBuilder<SwipeItem> itemBuilder;
  final MatchEngine matchEngine;
  final Function onStackFinished;
  Function(SwipeItem, int)? itemChanged;
  final bool fillSpace;
  final bool upSwipeAllowed;

  SwipeCards({
    Key? key,
    required this.matchEngine,
    required this.onStackFinished,
    required this.itemBuilder,
    this.fillSpace = true,
    this.upSwipeAllowed = false,
    this.itemChanged,
  }) : super(key: key);

  @override
  _SwipeCardsState createState() => _SwipeCardsState();
}

class _SwipeCardsState extends State<SwipeCards> {
  Key? _frontCard;
  SwipeItem? _currentItem;
  double _nextCardScale = 0.9;
  SlideRegion? slideRegion;

  @override
  void initState() {
    widget.matchEngine.addListener(_onMatchEngineChange);
    _currentItem = widget.matchEngine.currentItem;
    _currentItem!.addListener(_onMatchChange);
    _frontCard = Key(widget.matchEngine._currentItemIndex.toString());
    super.initState();
  }

  @override
  void dispose() {
    if (_currentItem != null) {
      _currentItem!.removeListener(_onMatchChange);
    }
    widget.matchEngine.removeListener(_onMatchEngineChange);
    super.dispose();
  }

  @override
  void didUpdateWidget(SwipeCards oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.matchEngine != oldWidget.matchEngine) {
      oldWidget.matchEngine.removeListener(_onMatchEngineChange);
      widget.matchEngine.addListener(_onMatchEngineChange);
    }
    if (_currentItem != null) {
      _currentItem!.removeListener(_onMatchChange);
    }
    _currentItem = widget.matchEngine.currentItem;
    if (_currentItem != null) {
      _currentItem!.addListener(_onMatchChange);
    }
  }

  void _onMatchEngineChange() {
    setState(() {
      if (_currentItem != null) {
        _currentItem!.removeListener(_onMatchChange);
      }
      _currentItem = widget.matchEngine.currentItem;
      if (_currentItem != null) {
        _currentItem!.addListener(_onMatchChange);
      }
      _frontCard = Key(widget.matchEngine._currentItemIndex.toString());
    });
  }

  void _onMatchChange() {
    setState(() {
      //match has been changed
    });
  }

  Widget _buildFrontCard() {
    return ProfileCard(
      child: widget.itemBuilder(context, widget.matchEngine.currentItem!, null),
      key: _frontCard,
    );
  }

  Widget _buildBackCard() {
    return Transform(
      transform: Matrix4.identity()..scale(_nextCardScale, _nextCardScale),
      alignment: Alignment.center,
      child: ProfileCard(
        child: widget.itemBuilder(context, widget.matchEngine.nextItem!, null),
      ),
    );
  }

  void _onSlideUpdate(double distance) {
    setState(() {
      _nextCardScale = 0.9 + (0.1 * (distance / 100.0)).clamp(0.0, 0.1);
    });
  }

  void _onSlideRegion(SlideRegion? region) {
    setState(() {
      slideRegion = region;
      SwipeItem? currentMatch = widget.matchEngine.currentItem;
      if (currentMatch != null && currentMatch.onSlideUpdate != null) {
        currentMatch.onSlideUpdate!(region);
      }
    });
  }

  void _onSlideOutComplete(SlideDirection? direction) {
    SwipeItem? currentMatch = widget.matchEngine.currentItem;
    switch (direction) {
      case SlideDirection.left:
        currentMatch!.nope();
        break;
      case SlideDirection.right:
        currentMatch!.like();
        break;
      case SlideDirection.up:
        currentMatch!.superLike();
        break;
    }

    if (widget.matchEngine._nextIndex! <
        widget.matchEngine._swipeItems!.length) {
      widget.itemChanged
          ?.call(widget.matchEngine.nextItem!, widget.matchEngine._nextIndex!);
    }

    widget.matchEngine.cycleMatch();
    if (widget.matchEngine.currentItem == null) {
      widget.onStackFinished();
    }
  }

  SlideDirection? _desiredSlideOutDirection() {
    switch (widget.matchEngine.currentItem!.decision) {
      case Decision.nope:
        return SlideDirection.left;
      case Decision.like:
        return SlideDirection.right;
      case Decision.superLike:
        return SlideDirection.up;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: widget.fillSpace == true ? StackFit.expand : StackFit.loose,
      children: <Widget>[
        if (widget.matchEngine.nextItem != null)
          DraggableCard(
            isDraggable: false,
            card: _buildBackCard(),
            upSwipeAllowed: widget.upSwipeAllowed,
            isBackCard: true,
          ),
        if (widget.matchEngine.currentItem != null)
          DraggableCard(
            card: _buildFrontCard(),
            slideTo: _desiredSlideOutDirection(),
            onSlideUpdate: _onSlideUpdate,
            onSlideRegionUpdate: _onSlideRegion,
            onSlideOutComplete: _onSlideOutComplete,
            upSwipeAllowed: widget.upSwipeAllowed,
            isBackCard: false,
          )
      ],
    );
  }
}

class MatchEngine extends ChangeNotifier {
  final List<SwipeItem>? _mainSwipeItems;
  List<SwipeItem>? _swipeItems = [];
  int? _currentItemIndex;
  bool? _withInterCard;

  MatchEngine({
    List<SwipeItem>? swipeItems,
    bool? withInterCard = false,
  })  : _mainSwipeItems = swipeItems,
        _withInterCard = withInterCard {
    _currentItemIndex = 0;
    _loadSwipeItems();
  }

  int? get _nextIndex => (_currentItemIndex! + 1) % _swipeItems!.length;

  SwipeItem? get currentItem {
    if (_currentItemIndex! < _swipeItems!.length) {
      return _swipeItems![_currentItemIndex!];
    } else {
      _currentItemIndex = 0;
      _mainSwipeItems!.shuffle();
      _loadSwipeItems();
      return _swipeItems![_currentItemIndex!];
    }
  }

  SwipeItem? get nextItem {
    return _swipeItems![_nextIndex!];
  }

  void _loadSwipeItems() {
    if (_withInterCard!) {
      for (int i = 0; i < _mainSwipeItems!.length; i++) {
        SwipeItem si = _mainSwipeItems![i];
        _swipeItems!.add(SwipeItem(
          content: null,
          likeAction: si.likeAction,
          nopeAction: si.nopeAction,
        ));
        _swipeItems!.add(si);
      }
    } else {
      _swipeItems = _mainSwipeItems;
    }
  }

  void cycleMatch() {
    if (currentItem!.decision != Decision.undecided) {
      currentItem!.resetMatch();
      _currentItemIndex = _nextIndex;
      notifyListeners();
    }
  }

  void rewindMatch() {
    if (_currentItemIndex != 0) {
      currentItem!.resetMatch();
      _currentItemIndex = _currentItemIndex! - 1;
      currentItem!.resetMatch();
      notifyListeners();
    }
  }
}

class SwipeItem extends ChangeNotifier {
  final dynamic content;
  final Function? likeAction;
  final Function? superlikeAction;
  final Function? nopeAction;
  final Future Function(SlideRegion? slideRegion)? onSlideUpdate;
  Decision decision = Decision.undecided;

  SwipeItem({
    this.content,
    this.likeAction,
    this.superlikeAction,
    this.nopeAction,
    this.onSlideUpdate,
  });

  void slideUpdateAction(SlideRegion? slideRegion) async {
    try {
      await onSlideUpdate!(slideRegion);
    } catch (e) {}
    notifyListeners();
  }

  void like() {
    if (decision == Decision.undecided) {
      decision = Decision.like;
      try {
        likeAction!();
      } catch (e) {}
      notifyListeners();
    }
  }

  void nope() {
    if (decision == Decision.undecided) {
      decision = Decision.nope;
      try {
        nopeAction!();
      } catch (e) {}
      notifyListeners();
    }
  }

  void superLike() {
    if (decision == Decision.undecided) {
      decision = Decision.superLike;
      if (superlikeAction != null) {
        superlikeAction!();
      }
      notifyListeners();
    }
  }

  void resetMatch() {
    if (decision != Decision.undecided) {
      decision = Decision.undecided;
      notifyListeners();
    }
  }
}

enum Decision { undecided, nope, like, superLike }
