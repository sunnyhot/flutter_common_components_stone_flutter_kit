import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:stone_flutter_kit/stone_flutter_kit.dart';
import 'package:stone_flutter_kit_example/constant/colors.dart';
import 'package:stone_flutter_kit_example/constant/styles.dart';

import 'shop.dart';

/// [StoneFutureBody]、[StoneFetchDataError]、[StoneJson]
class FutureBodyDemoPage extends StatefulWidget {
  @override
  _FutureBodyDemoPageState createState() => _FutureBodyDemoPageState();
}

class _FutureBodyDemoPageState extends State<FutureBodyDemoPage> {
  Future<List<List<Shop>>> _dataFuture;

  @override
  void initState() {
    super.initState();

    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text('FutureBody'),
      centerTitle: true,
      leading: StoneBackButton(),
      actions: <Widget>[
        StoneBarButton(
          onPressed: _fetchData,
          title: Icon(Icons.refresh),
        ),
        StoneBarButton(
          onPressed: () => _fetchData(
            StoneFetchDataError(type: StoneFetchDataErrorType.networkError, message: '没有连接到网络'),
          ),
          title: Icon(Icons.network_wifi),
        ),
        StoneBarButton(
          onPressed: () => _fetchData(
            StoneFetchDataError(type: StoneFetchDataErrorType.noList, message: '暂时没有数据哦'),
          ),
          title: Icon(Icons.not_interested),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return StoneFutureBody<List<List<Shop>>>(
      onRetry: _fetchData,
      future: _dataFuture,
      loadingBuilder: _buildLoading,
      contentBuilder: _buildContent,
      errorBuilder: _buildError,
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: AppColors.white,
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildContent(BuildContext context, List<List<Shop>> shopGroups) {
    return StoneListView.grouped(
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10 + MediaQuery.of(context).padding.bottom),
      sectionCount: shopGroups.length,
      itemCount: (section) => shopGroups[section].length,
      itemBuilder: (context, section, index) => _buildItem(context, section, index, shopGroups),
      headerBuilder: (_, section) => SizedBox(height: 10.0),
    );
  }

  Widget _buildError(BuildContext context, StoneFetchDataError error, VoidCallback onRetry) {
    final items = <Widget>[
      Text(
        error.message,
        maxLines: 8,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: AppTextStyles.greyW400(fontSize: 15.0),
      ),
    ];

    if (onRetry != null) {
      items.add(SizedBox(height: 32.0));
      items.add(
        IntrinsicWidth(
          child: StoneButton(
            onPressed: onRetry,
            textStyle: TextStyle(color: AppColors.white, fontSize: 16.0, fontWeight: FontWeight.w400),
            gradient: LinearGradient(colors: AppColors.greenGradient),
            borderRadius: BorderRadius.circular(8.0),
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            constraints: BoxConstraints(minWidth: 120.0),
            height: 36.0,
            child: Text('重试', maxLines: 1),
          ),
        ),
      );
    }

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 80.0),
      color: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items,
      ),
    );
  }

  Widget _buildItem(BuildContext context, int section, int index, List<List<Shop>> shopGroups) {
    final group = shopGroups[section];
    final shop = group[index];
    final isFirst = index == 0;
    final isLast = index == group.length - 1;

    final content = Row(
      children: <Widget>[
        Icon(
          IconData(shop.iconCode, fontFamily: "MaterialIcons"),
          color: AppColors.green,
        ),
        SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20.0,
                child: Text(
                    shop.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)
                ),
              ),
              SizedBox(height: 8.0),
              Text(shop.address),
            ],
          ),
        ),
      ],
    );

    return StoneItem(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(isFirst ? 12.0 : 0.0),
        bottom: Radius.circular(isLast ? 12.0 : 0.0),
      ),
      divider: isLast ? null : Divider(
        height: 1.0,
        color: Color(0xFFD9D9D9),
      ),
      child: content,
    );
  }

  void _fetchData([StoneFetchDataError error]) {
    setState(() {
      _dataFuture = _DataProvider.fetchShopGroup(error);
    });
  }
}

class _DataProvider {
  static Future<List<List<Shop>>> fetchShopGroup([StoneFetchDataError error]) async {
    Completer<List<List<Shop>>> completer = Completer();

    // 模拟网络请求
    Future.delayed(Duration(milliseconds: 500), () async {
      if (error != null) {
        completer.completeError(error);
        return;
      }

      final jsonString = await rootBundle.loadString('res/shops.json');
      final jsonData = StoneJson.decode(jsonString);

      final shopGroups = jsonData.listValue().map((groupJson) {
        return groupJson.listValue().map((shopJson) => Shop.fromJson(shopJson)).toList();
      }).toList();

      completer.complete(shopGroups);
    });

    return completer.future;
  }
}