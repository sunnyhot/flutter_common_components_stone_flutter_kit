import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stone_flutter_kit/stone_flutter_kit.dart';
import 'package:stone_flutter_kit_example/page/03_item/models.dart';
import 'package:stone_flutter_kit_example/service/navigate_service.dart';

/// [StoneItem]、[StoneListView.grouped]
class ItemDemoPage extends StatefulWidget {
  @override
  _ItemDemoPageState createState() => _ItemDemoPageState();
}

class _ItemDemoPageState extends State<ItemDemoPage> {
  bool _grouped = true;
  bool _isCupertino = Platform.isIOS ? true : false;
  StoneButtonType get _buttonType => _isCupertino ? StoneButtonType.cupertino : StoneButtonType.material;
  StoneItemType get _itemType => _isCupertino ? StoneItemType.cupertino : StoneItemType.material;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text('Item'),
      centerTitle: true,
      leading: StoneBackButton(
        type: _buttonType,
      ),
      actions: <Widget>[
        StoneBarButton(
          onPressed: () => setState(() => _grouped = !_grouped),
          type: _buttonType,
          title: Text(_grouped ? '分组' : '简单'),
        ),
        StoneBarButton(
          onPressed: () => setState(() => _isCupertino = !_isCupertino),
          type: _buttonType,
          title: Text(_isCupertino ? '苹果' : '安卓'),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return StoneListView.grouped(
      padding: !_grouped ? null : EdgeInsets.fromLTRB(10.0, 0.0, 10.0, MediaQuery.of(context).padding.bottom),
      sectionCount: kSamplePalettes.sublist(0, kSamplePalettes.length - 3).length,
      itemCount: (section) => kAccentColorKeys.length,
      headerBuilder: _buildHeader,
      itemBuilder: _buildItem,
    );
  }

  Widget _buildHeader(BuildContext context, int section) {
    final palette = kSamplePalettes[section];
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 40.0,
            height: 16.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: kAccentColorKeys.map((key) => palette.accent[key]).toList(),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SizedBox(width: 8.0),
          Text(
            palette.name,
            style: TextStyle(
              color: palette.accent,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int section, int index) {
    final palette = kSamplePalettes[section];
    final backgroundColor = palette.accent[kAccentColorKeys[index]];
    final textColor =  palette.accent.computeLuminance() > 0.6 ? Colors.black : Colors.white;

    final isFirst = index == 0;
    final isLast = index == kAccentColorKeys.length - 1;

    return StoneItem(
      onTap: () => NavigateService.I.push(ItemDemoPage()),
      type: _itemType,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      color: backgroundColor,
      highlightColor: Colors.black26,
      borderRadius: !_grouped ? null : BorderRadius.vertical(
        top: Radius.circular(isFirst ? 12.0 : 0.0),
        bottom: Radius.circular(isLast ? 12.0 : 0.0),
      ),
      child: Row(
        children: <Widget>[
          Text(
            kSamplePalettes[section].name + ' ' + kAccentColorKeys[index].toString(),
            style: TextStyle(
              color: textColor,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          Expanded(child: Container()),
          Icon(Icons.arrow_forward_ios, color: textColor, size: 16.0),
        ],
      ),
    );
  }
}