import 'package:flutter/material.dart';

class CLFlow extends StatelessWidget {
  final List<Widget> children;
  final int count;
  double gap;

  CLFlow({Key key, this.children, @required this.count, this.gap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: CLFlowDelegate(
        count: count,
      ),
      children: children,
    );
  }
}

class CLFlowDelegate extends FlowDelegate {
  final int count;
  double gap;
  CLFlowDelegate({
    @required this.count,
    this.gap = 5.0,
  });

  int columns = 1;
  int rows = 1;
  double itemW = 0;
  double itemH = 0;
  double totalW = 0;

  @override
  void paintChildren(FlowPaintingContext context) {
    var x = gap;
    var y = 0.0;

    getItemSize();
    setSize(count);
    totalW = (itemW * rows) + (gap * (rows + 1));

    for (int i = 0; i < count; i++) {
      var w = context.getChildSize(i).width + x;
      if (w < totalW) {
        context.paintChild(i,
            transform: new Matrix4.translationValues(x, y, 0.0));
        x += context.getChildSize(i).width + gap;
      } else {
        x = gap;
        y += context.getChildSize(i).height + gap;
        context.paintChild(i,
            transform: new Matrix4.translationValues(x, y, 0.0));
        x += context.getChildSize(i).width + gap;
      }
    }
  }

  setSize(int length) {
    if (length <= 3) {
      rows = length;
      columns = 1;
    } else if (length == 4) {
      rows = 2;
      columns = 2;
    } else {
      rows = 3;
      columns = 2;
    }
  }

  getItemSize() {
    if (count == 1) {
      itemW = 280;
      itemH = 180;
    } else if (count <= 3) {
      if (count == 2) {
        itemW = 230;
        itemH = 110;
      }
      itemW = 100;
      itemH = 100;
      gap = 10;
    } else if (count <= 6) {
      itemW = 110;
      itemH = 90;
      if (count == 4) {
        itemW = 140;
        itemH = 80;
      }
    }
  }

  getConstraintsForChild(int i, BoxConstraints constraints) {
    getItemSize();
    return BoxConstraints(
        minWidth: itemW, minHeight: itemH, maxWidth: itemW, maxHeight: itemH);
  }

  getSize(BoxConstraints constraints) {
    setSize(count);
    getItemSize();
    double h = (columns * itemH) + ((columns - 1) * gap);
    totalW = (itemW * rows) + (gap * (rows + 1));
    return Size(totalW, h);
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return oldDelegate != this;
  }
}
