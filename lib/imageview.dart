import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';

class ImageView extends StatefulWidget {
  final String url;
  ImageView({this.url});
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      child: Container(
        child: ExtendedImage.network(
          widget.url,
          fit: BoxFit.contain,
          enableLoadState: true,
          cache: false,
          clearMemoryCacheIfFailed: true,
          mode: ExtendedImageMode.Gesture,
          gestureConfig: GestureConfig(maxScale: 50.0),
        ),
      ),
    );
  }
}
