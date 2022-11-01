import 'package:flutter/cupertino.dart';

import '../constants.dart';

const _barsColor = LinearGradient(
  colors: [kPrimary1, kPrimary1],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
);

class Data {
  final int id;
  final String name;
  final int y;
  final Gradient color = _barsColor;

  Data({required this.id, required this.name, required this.y});
}
