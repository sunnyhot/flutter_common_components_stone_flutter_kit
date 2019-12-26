import 'package:stone_flutter_kit/stone_flutter_kit.dart';

class Shop  {
  Shop({
    this.name,
    this.address,
    this.iconCode,
  });

  factory Shop.fromJson(StoneJson json) => Shop(
    name: json['name'].stringValue(),
    address: json['address'].stringValue(),
    iconCode: json['iconCode'].intValue(),
  );

  String name;
  String address;
  int iconCode;
}