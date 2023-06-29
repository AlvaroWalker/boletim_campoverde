import 'dart:ui';

import 'package:download/download.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'boletim.dart';

Future<void> captureAndSaveImage(GlobalKey key, double pixelRatioFinal) async {
  final boundary =
      key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  final image = await boundary?.toImage(pixelRatio: pixelRatioFinal);
  final byteData = await image?.toByteData(format: ImageByteFormat.png);
  final imageBytes = byteData?.buffer.asUint8List();

  if (imageBytes != null) {
    final stream = Stream.fromIterable(imageBytes.toList());

    download(stream, 'boletim $dataBoletim.jpg');
  }
}
