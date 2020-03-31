

import 'package:flutter/material.dart';
import 'package:flutter_responsive/category.dart';
import 'dart:math' as math;

const double kFlingVelocity = 2.0;

class BackdropPanel extends StatelessWidget{
  const BackdropPanel({
    Key key,
    this.onTap,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.title,
    this.child,

}) : super(key: key);

  final VoidCallback onTap;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final Widget title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragUpdate: onVerticalDragUpdate,
            onVerticalDragEnd: onVerticalDragEnd,
            onTap: onTap,
            child: Container(
              height: 48.0,
              padding: EdgeInsetsDirectional.only(start: 16.0),
              alignment: AlignmentDirectional.centerStart,
              child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.subhead,
                  child: title,
              ),
            ),
          ),
          Divider(
            height: 1.0,
          ),
          Expanded(child: child,)
        ],
      ),
    );
  }
}

class BackdropTitle extends AnimatedWidget {
  final Widget frontTitle;
  final Widget backTitle;

  const BackdropTitle({
    Key key,
    Listenable listenable,
    this.frontTitle,
    this.backTitle,
}) : super(key:key,listenable:listenable);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = this.listenable;
    return DefaultTextStyle(
        style: Theme.of(context).primaryTextTheme.title,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        child: Stack(
          children: <Widget>[
            Opacity(
                opacity: CurvedAnimation(
                    parent: ReverseAnimation(animation), 
                    curve: Interval(0.5, 1.0),
                ).value,
              child: backTitle,
            ),
            Opacity(
                opacity: CurvedAnimation(
                    parent: animation,
                    curve: Interval(0.5,1.0),
                ).value,
              child: frontTitle,
            )
          ],
        ),
    );
  }
}

class Backdrop extends StatefulWidget {
  final Category currentCategory;
  final Widget frontPanel;
  final Widget backPanel;
  final Widget frontTitle;
  final Widget backTitle;

  const Backdrop({
    @required this.currentCategory,
    @required this.frontPanel,
    @required this.backTitle,
    @required this.frontTitle,
    @required this.backPanel,
}): assert(currentCategory != null),
    assert(frontTitle != null),
    assert(backPanel != null),
    assert(frontPanel != null),
    assert(backTitle != null);

  @override
  BackdropState createState() {
    return BackdropState();
  }
}

class BackdropState extends State<Backdrop> with SingleTickerProviderStateMixin{
  final GlobalKey backdropKey = GlobalKey(debugLabel: 'Backdrop');
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(Backdrop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.currentCategory != oldWidget.currentCategory){
      setState(() {
        controller.fling(
          velocity:
            backdropPanelVisible ? -kFlingVelocity : kFlingVelocity
        );
      });
    }else if(!backdropPanelVisible){
      setState(() {
        controller.fling(velocity: kFlingVelocity);
      });
    }
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool get backdropPanelVisible{
    final AnimationStatus status = controller.status;
    return status == AnimationStatus.completed || status == AnimationStatus.forward;
  }

  void _toggleBackdropPanelVisibility() {
    FocusScope.of(context).requestFocus(FocusNode());
    controller.fling(
        velocity: backdropPanelVisible ? -kFlingVelocity : kFlingVelocity);
  }

  double get _backdropHeight {
    final RenderBox renderBox = backdropKey.currentContext.findRenderObject();
    return renderBox.size.height;
  }

  // By design: the panel can only be opened with a swipe. To close the panel
  // the user must either tap its heading or the backdrop's menu icon.

  void _handleDragUpdate(DragUpdateDetails details) {
    if (controller.isAnimating ||
        controller.status == AnimationStatus.completed) return;

    controller.value -= details.primaryDelta / _backdropHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (controller.isAnimating ||
        controller.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / _backdropHeight;
    if (flingVelocity < 0.0)
      controller.fling(velocity: math.max(kFlingVelocity, -flingVelocity));
    else if (flingVelocity > 0.0)
      controller.fling(velocity: math.min(-kFlingVelocity, -flingVelocity));
    else
      controller.fling(
          velocity:
          controller.value < 0.5 ? -kFlingVelocity : kFlingVelocity);
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double panelTitleHeight = 48.0;
    final Size panelSize = constraints.biggest;
    final double panelTop = panelSize.height - panelTitleHeight;

    Animation<RelativeRect> panelAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          0.0, panelTop, 0.0, panelTop - panelSize.height),
      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(controller.view);

    return Container(
      key: backdropKey,
      color: widget.currentCategory.color,
      child: Stack(
        children: <Widget>[
          widget.backPanel,
          PositionedTransition(
            rect: panelAnimation,
            child: BackdropPanel(
              onTap: _toggleBackdropPanelVisibility,
              onVerticalDragUpdate: _handleDragUpdate,
              onVerticalDragEnd: _handleDragEnd,
              title: Text(widget.currentCategory.name),
              child: widget.frontPanel,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.currentCategory.color,
        elevation: 0.0,
        leading: IconButton(
          onPressed: _toggleBackdropPanelVisibility,
          icon: AnimatedIcon(
            icon: AnimatedIcons.close_menu,
            progress: controller.view,
          ),
        ),
        title: BackdropTitle(
          listenable: controller.view,
          frontTitle: widget.frontTitle,
          backTitle: widget.backTitle,
        ),
      ),
      body: LayoutBuilder(
        builder: _buildStack,
      ),
      resizeToAvoidBottomPadding: false,
    );
  }


}