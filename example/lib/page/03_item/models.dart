import 'package:flutter/material.dart';

class Palette {
  const Palette({
    @required this.name,
    @required this.primary,
    this.accent,
    this.threshold = 900,
  });

  final String name;
  final MaterialColor primary;
  final MaterialAccentColor accent;
  final threshold;
  bool get isValid => name != null && primary != null && threshold != null;
}

// ==============================================  示例数据 ==============================================

const List<int> kPrimaryColorKeys = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900];

const List<int> kAccentColorKeys = [100, 200, 400, 700];

const List<Palette> kSamplePalettes = <Palette>[
  Palette(
    name: 'RED',
    primary: Colors.red,
    accent: Colors.redAccent,
    threshold: 300,
  ),
  Palette(
    name: 'PINK',
    primary: Colors.pink,
    accent: Colors.pinkAccent,
    threshold: 200,
  ),
  Palette(
    name: 'PURPLE',
    primary: Colors.purple,
    accent: Colors.purpleAccent,
    threshold: 200,
  ),
  Palette(
    name: 'DEEP PURPLE',
    primary: Colors.deepPurple,
    accent: Colors.deepPurpleAccent,
    threshold: 200,
  ),
  Palette(
    name: 'INDIGO',
    primary: Colors.indigo,
    accent: Colors.indigoAccent,
    threshold: 200,
  ),
  Palette(
    name: 'BLUE',
    primary: Colors.blue,
    accent: Colors.blueAccent,
    threshold: 400,
  ),
  Palette(
    name: 'LIGHT BLUE',
    primary: Colors.lightBlue,
    accent: Colors.lightBlueAccent,
    threshold: 500,
  ),
  Palette(
    name: 'CYAN',
    primary: Colors.cyan,
    accent: Colors.cyanAccent,
    threshold: 600,
  ),
  Palette(
    name: 'TEAL',
    primary: Colors.teal,
    accent: Colors.tealAccent,
    threshold: 400,
  ),
  Palette(
    name: 'GREEN',
    primary: Colors.green,
    accent: Colors.greenAccent,
    threshold: 500,
  ),
  Palette(
    name: 'LIGHT GREEN',
    primary: Colors.lightGreen,
    accent: Colors.lightGreenAccent,
    threshold: 600,
  ),
  Palette(
    name: 'LIME',
    primary: Colors.lime,
    accent: Colors.limeAccent,
    threshold: 800,
  ),
  Palette(
    name: 'YELLOW',
    primary: Colors.yellow,
    accent: Colors.yellowAccent,
  ),
  Palette(
    name: 'AMBER',
    primary: Colors.amber,
    accent: Colors.amberAccent,
  ),
  Palette(
    name: 'ORANGE',
    primary: Colors.orange,
    accent: Colors.orangeAccent,
    threshold: 700,
  ),
  Palette(
    name: 'DEEP ORANGE',
    primary: Colors.deepOrange,
    accent: Colors.deepOrangeAccent,
    threshold: 400,
  ),
  Palette(
    name: 'BROWN',
    primary: Colors.brown,
    threshold: 200,
  ),
  Palette(
    name: 'GREY',
    primary: Colors.grey,
    threshold: 500,
  ),
  Palette(
    name: 'BLUE GREY',
    primary: Colors.blueGrey,
    threshold: 500,
  ),
];