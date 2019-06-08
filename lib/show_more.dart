import 'package:flutter/material.dart';

class ShowMore extends StatefulWidget {
  ShowMore({this.text, this.maxHeight});

  final String text;
  final double maxHeight;
  bool isExpanded = false;
  @override
  _ShowMoreState createState() => _ShowMoreState();
}

class _ShowMoreState extends State<ShowMore>
    with TickerProviderStateMixin<ShowMore> {
  @override
  Widget build(BuildContext context) {
    return Wrap(alignment: WrapAlignment.center, children: <Widget>[
      AnimatedSize(
          vsync: this,
          duration: const Duration(milliseconds: 500),
          child: new ConstrainedBox(
              constraints: widget.isExpanded
                  ? new BoxConstraints()
                  : new BoxConstraints(maxHeight: widget.maxHeight ?? 70.0),
              child: new Text(
                widget.text,
                softWrap: true,
                overflow: TextOverflow.fade,
              ))),
      widget.isExpanded
          ? new ConstrainedBox(constraints: new BoxConstraints())
          : new InkWell(
              child: Text('expand',
                  style: TextStyle(color: Colors.cyan[600], fontSize: 13)),
              onTap: () => setState(() => widget.isExpanded = true))
    ]);
  }
}
