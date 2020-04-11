import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

///上拉抽屉
class BottomDragWidget extends StatelessWidget {
  final Widget body;
  final DragContainer dragContainer;

  BottomDragWidget({Key key, @required this.body, @required this.dragContainer})
      : assert(body != null),
        assert(dragContainer != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // 这是 底部的 container
        body,
        // 这是 能上拉 的 抽屉
        Align(
          alignment: Alignment.bottomCenter,
          child: dragContainer,
          // child: Container(
          //   width: double.infinity,
          //   height: 700.0,
          //   decoration: BoxDecoration(
          //     color: Colors.red,
          //     borderRadius: BorderRadiusDirectional.circular(10.0),
          //   ),
          // ),
        ),
      ],
    );
  }
}

typedef DragListener = void Function(
    double dragDistance, ScrollNotificationListener isDragEnd);

class DragController {
  DragListener _dragListener;

  setDrag(DragListener l) {
    _dragListener = l;
  }

  /// 更新 drag 的 distance,
  void updateDragDistance(
      double dragDistance,
      ScrollNotificationListener isDragEnd,
      ) {
    if (_dragListener != null) {
      _dragListener(dragDistance, isDragEnd);
    }
  }
}

class DragContainer extends StatefulWidget {
  ///drawer 会变成 container 中间放的 widget
  ///defaultShowHeight 是抽屉默认显示出来多少
  ///height是 DragContainer 有多高
  final Widget drawer;
  final double defaultShowHeight;
  final double height;

  DragContainer(
      {Key key,
        @required this.drawer,
        @required this.defaultShowHeight,
        @required this.height})
      : assert(drawer != null),
        assert(defaultShowHeight != null),
        assert(height != null),
        super(key: key) {
    _controller = DragController();
  }

  @override
  _DragContainerState createState() => _DragContainerState();
}

/// TickerProviderStateMixin 是给 animation 用的,
/// 这里做出如果滑到中间位置, 判断是animate往上滑还是往下滑
class _DragContainerState extends State<DragContainer>
    with TickerProviderStateMixin {
  AnimationController animalController;

  ///滑动位置超过这个位置，会滚到顶部；小于，会滚动底部。
  ///这里 拉到 0.0, 就代表全部都拉出来了,
  ///这里 如果大于 maxOffsetDistance, 就代表还有很多没拉出来, 就自动恢复回去
  double maxOffsetDistance;

  /// 重新 initialize controller 从底部开始
  bool onResetControllerValue = false;
  double offsetDistance;
  Animation<double> animation;
  bool offstage = false;

  /// _isFling 判断是否是 快拉, 如果快拉则是 Fling,
  /// 那样即使 offsetDistance 还处在比 maxOffsetDistance 大的那一侧,
  /// 也能直接快拉到 顶部去
  /// 不支持 快拉从 顶部到底部去
  bool _isFling = false;

  ///开始的时候 还剩这么多可以拉出来
  double get defaultOffsetDistance => widget.height - widget.defaultShowHeight;

  @override
  void initState() {
    animalController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    maxOffsetDistance = (widget.height + widget.defaultShowHeight) * 0.3;

//    if (controller != null) {
    _controller.setDrag(
          (double value, ScrollNotificationListener notification) {
        if (notification != ScrollNotificationListener.edge) {
          /// 只要不是 start 和 end 都是 就自动滑到顶部或者底部
          _handleDragEnd(null);
        } else {
          setState(() {
            /// 已经到达顶部或者底部了, 更新offsetDistance
            offsetDistance = offsetDistance + value;
          });
        }
      },
    );
//    }
    super.initState();
  }

  /// 生成一个 custom gesture recognizer
  GestureRecognizerFactoryWithHandlers<MyVerticalDragGestureRecognizer>
  getRecognizer() {
    return GestureRecognizerFactoryWithHandlers<
        MyVerticalDragGestureRecognizer>(
          () => MyVerticalDragGestureRecognizer(
        flingListener: (bool isFling) {
          _isFling = isFling;
        },
      ), //constructor
          (MyVerticalDragGestureRecognizer instance) {
        //initializer
        instance
          ..onStart = _handleDragStart
          ..onUpdate = _handleDragUpdate
          ..onEnd = _handleDragEnd;
      },
    );
  }

  @override
  void dispose() {
    animalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (offsetDistance == null || onResetControllerValue) {
      ///说明是第一次加载,由于BottomDragWidget中 alignment: Alignment.bottomCenter,故直接设置
      offsetDistance = defaultOffsetDistance;
    }

    ///偏移值在这个范围内
    offsetDistance = offsetDistance.clamp(0.0, defaultOffsetDistance);

    /// 是否滑到顶上去
    offstage = offsetDistance < maxOffsetDistance;

    return Transform.translate(
      offset: Offset(0.0, offsetDistance),
      child: RawGestureDetector(
        gestures: {MyVerticalDragGestureRecognizer: getRecognizer()},
        child: Stack(
          children: <Widget>[
            Container(
              child: widget.drawer,
              height: widget.height,
            ),
            /// 图层会覆盖上去, 如果offstage是 false, 则不能进行操作,
            /// 代表如果 抽屉在 底部,则无法 scroll 抽屉里面的东西,
            /// 如果 抽屉上来了, 就可以 scroll 其中的 东西了
            Offstage(
              child: Container(
                color: Colors.transparent,
                ///使用图层来解决当抽屉露出头时，上拉抽屉上移。解决的方案最佳
                height: widget.height,
              ),
              offstage: offstage,
            )
          ],
        ),
      ),
    );
  }

  /// screen height
  double get screenH => MediaQuery.of(context).size.height;

  /// 当拖拽结束时调用
  /// 用来展现 animation
  void _handleDragEnd(DragEndDetails details) {
    onResetControllerValue = true;

    /// 很重要！！！动画完毕后，controller.value = 1.0， 这里要将value的值重置为0.0，才会再次运行动画
    /// 重置value的值时, 我们手动刷新UI(用setState), 故这里使用[onResetControllerValue]来进行过滤。
    /// onResetControllerValue = true 的时候 offsetDistance = DefaultOffsetDistance
    /// 这里 animalController 的值发生变化就会 call listener, 这里的 listener 是后面的 animation
    /// 因为 animation 的parent 是 animalController
    animalController.value = 0.0;
    onResetControllerValue = false;

    /// 判断是滑到顶部 还是 滑到底部
    double start;
    double end;
    if (offsetDistance <= maxOffsetDistance) {
      ///这个判断通过，说明已经child位置超过警戒线了，需要滚动到顶部了
      start = offsetDistance;
      end = 0.0;
    } else {
      start = offsetDistance;
      end = defaultOffsetDistance;
    }

    if (_isFling &&
        details != null &&
        details.velocity != null &&
        details.velocity.pixelsPerSecond != null &&
        details.velocity.pixelsPerSecond.dy < 0) {
      ///这个判断通过，说明是快速向上滑动，此时需要滚动到顶部了
      start = offsetDistance;
      end = 0.0;
    }

    ///easeOut 先快后慢
    final CurvedAnimation curve =
    new CurvedAnimation(parent: animalController, curve: Curves.easeOut);
    animation = Tween(begin: start, end: end).animate(curve)
      ..addListener(() {
        if (!onResetControllerValue) {
          /// 得到 animation.value 变化出来的值, 放在 transform.translate 里面,
          offsetDistance = animation.value;

          /// animate 都需要 setState() 来重新 render UI
          setState(() {});
        }
      });

    ///自己滚动
    animalController.forward();
  }

  /// 当 widget 被滑动的时候被call, 不停控制 offsetDistance 来让抽屉被手指 控制
  /// 都需要 setState() 来 render UI 发生变化
  void _handleDragUpdate(DragUpdateDetails details) {
    offsetDistance = offsetDistance + details.delta.dy;
    setState(() {});
  }

  /// 开始的时候 等于 initialization, 不用 re-render UI
  void _handleDragStart(DragStartDetails details) {
    _isFling = false;
  }
}

typedef FlingListener = void Function(bool isFling);

///MyVerticalDragGestureRecognizer 负责任务
///1.监听child的位置更新
///2.判断child在手松的那一刻是否是出于fling状态
class MyVerticalDragGestureRecognizer extends VerticalDragGestureRecognizer {
  final FlingListener flingListener;

  /// Create a gesture recognizer for interactions in the vertical axis.
  MyVerticalDragGestureRecognizer({Object debugOwner, this.flingListener})
      : super(debugOwner: debugOwner);

  final Map<int, VelocityTracker> _velocityTrackers = <int, VelocityTracker>{};

  @override
  void handleEvent(PointerEvent event) {
    super.handleEvent(event);
    if (!event.synthesized &&
        (event is PointerDownEvent || event is PointerMoveEvent)) {
      final VelocityTracker tracker = _velocityTrackers[event.pointer];
      assert(tracker != null);
      tracker.addPosition(event.timeStamp, event.position);
    }
  }

  @override
  void addPointer(PointerEvent event) {
    super.addPointer(event);
    _velocityTrackers[event.pointer] = VelocityTracker();
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    final double minVelocity = minFlingVelocity ?? kMinFlingVelocity;
    final double minDistance = minFlingDistance ?? kTouchSlop;
    final VelocityTracker tracker = _velocityTrackers[pointer];

    ///VelocityEstimate 计算二维速度的
    final VelocityEstimate estimate = tracker.getVelocityEstimate();
    bool isFling = false;
    if (estimate != null && estimate.pixelsPerSecond != null) {
      isFling = estimate.pixelsPerSecond.dy.abs() > minVelocity &&
          estimate.offset.dy.abs() > minDistance;
    }
    _velocityTrackers.clear();
    if (flingListener != null) {
      flingListener(isFling);
    }

    ///super.didStopTrackingLastPointer(pointer) 会调用[_handleDragEnd]
    ///所以将[flingListener(isFling);]放在前一步调用
    super.didStopTrackingLastPointer(pointer);
  }

  @override
  void dispose() {
    _velocityTrackers.clear();
    super.dispose();
  }
}

typedef ScrollListener = void Function(
    double dragDistance, ScrollNotificationListener notification);

DragController _controller;

///监听手指在child处于边缘时的滑动
///例如：当child滚动到顶部时，此时下拉，会回调[ScrollNotificationListener.edge],
///或者child滚动到底部时，此时下拉，会回调[ScrollNotificationListener.edge],
///当child为[ScrollView]的子类时，例如：[ListView] / [GridView] 等，时，需要将其`physics`属性设置为[ClampingScrollPhysics]
///想看原因的，可以看下：
/// ///这个属性是用来断定滚动的部件的物理特性，例如：
//        ///scrollStart
//        ///ScrollUpdate
//        ///Overscroll
//        ///ScrollEnd
//        ///在Android和ios等平台，其默认值是不同的。我们可以在scroll_configuration.dart中看到如下配置
//
//        /// The scroll physics to use for the platform given by [getPlatform].
//        ///
//        /// Defaults to [BouncingScrollPhysics] on iOS and [ClampingScrollPhysics] on
//        /// Android.
////  ScrollPhysics getScrollPhysics(BuildContext context) {
////    switch (getPlatform(context)) {
////    case TargetPlatform.iOS:/*/
////         return const BouncingScrollPhysics();
////    case TargetPlatform.android:
////    case TargetPlatform.fuchsia:
////        return const ClampingScrollPhysics();
////    }
////    return null;
////  }
///在ios中，默认返回BouncingScrollPhysics，对于[BouncingScrollPhysics]而言，
///由于   double applyBoundaryConditions(ScrollMetrics position, double value) => 0.0;
///会导致：当listview的第一条目显示时，继续下拉时，不会调用上面提到的Overscroll监听。
///故这里，设定为[ClampingScrollPhysics]
class OverscrollNotificationWidget extends StatefulWidget {
  const OverscrollNotificationWidget({
    Key key,
    @required this.child,
//    this.scrollListener,
  })  : assert(child != null),
        super(key: key);

  final Widget child;
//  final ScrollListener scrollListener;

  @override
  OverscrollNotificationWidgetState createState() =>
      OverscrollNotificationWidgetState();
}

/// Contains the state for a [OverscrollNotificationWidget]. This class can be used to
/// programmatically show the refresh indicator, see the [show] method.
class OverscrollNotificationWidgetState
    extends State<OverscrollNotificationWidget>
    with TickerProviderStateMixin<OverscrollNotificationWidget> {
  final GlobalKey _key = GlobalKey();

  ///[ScrollStartNotification] 部件开始滑动
  ///[ScrollUpdateNotification] 部件位置发生改变
  ///[OverscrollNotification] 表示窗口小部件未更改它的滚动位置，因为更改会导致滚动位置超出其滚动范围
  ///[ScrollEndNotification] 部件停止滚动
  ///之所以不能使用这个来build或者layout，是因为这个通知的回调是会有延迟的。
  ///Any attempt to adjust the build or layout based on a scroll notification would
  ///result in a layout that lagged one frame behind, which is a poor user experience.

  @override
  Widget build(BuildContext context) {
    // print('NotificationListener build');
    final Widget child = NotificationListener<ScrollStartNotification>(
      key: _key,
      child: NotificationListener<ScrollUpdateNotification>(
        child: NotificationListener<OverscrollNotification>(
          child: NotificationListener<ScrollEndNotification>(
            /// 这里 widget.child 就是 OverscrollNotificationWidget 里面的参数 child,
            /// 这里就是 我们抽屉里 放的东西
            child: widget.child,
            onNotification: (ScrollEndNotification notification) {
              /// 滑动结束所以不用改变当前 scroll position
              /// 因为之前 OverScrollNotification 已经算好了
              /// updateDragDistance 就是 animation
              // print('ScrollEndNotification called');
              _controller.updateDragDistance(
                  0.0, ScrollNotificationListener.end);
              return false;
            },
          ),
          onNotification: (OverscrollNotification notification) {
            // print('OverScrollNotification called');

            /// 滑动到了超出listView能滑动范围,
            /// 改变 抽屉的 scroll position
            if (notification.dragDetails != null &&
                notification.dragDetails.delta != null) {
              _controller.updateDragDistance(notification.dragDetails.delta.dy,
                  ScrollNotificationListener.edge);
            }

            /// true 则把 notification 现在消化掉, 不往 widget tree 底下继续传了
            /// false 则继续往下传
            return false;
          },
        ),
        onNotification: (ScrollUpdateNotification notification) {
          // print('ScrollUpdaeNotification called');

          /// 正在滑动的时候, 是在滑动 抽屉里面的 listView, ���以不用管
          return false;
        },
      ),
      onNotification: (ScrollStartNotification scrollUpdateNotification) {
        // print('ScrollStartNotification called');

        /// ���始滑动的时候
        _controller.updateDragDistance(0.0, ScrollNotificationListener.start);
        return false;
      },
    );

    /// this is a notificationListener
    return child;
  }
}

enum ScrollNotificationListener {
  ///滑动开始
  start,

  ///滑动结束
  end,

  ///滑动时，控件在边缘（最上面显示或者最下面显示）位置
  edge
}