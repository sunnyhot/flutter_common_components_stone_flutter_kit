import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stone_flutter_kit/stone_flutter_kit.dart';
import 'package:stone_flutter_kit_example/constant/colors.dart';
import 'package:stone_flutter_kit_example/constant/styles.dart';
import 'package:stone_flutter_kit_example/service/navigate_service.dart';

/// 按钮文本样式 - 白色
const TextStyle _kButtonWhiteTextStyle = const TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w400);
/// 按钮文本样式 - 粉色
const TextStyle _kButtonPinkTextStyle = const TextStyle(color: Colors.pink, fontSize: 15.0, fontWeight: FontWeight.w400);
/// 按钮文本样式 - 绿色
const TextStyle _kButtonTealTextStyle = const TextStyle(color: Colors.teal, fontSize: 16.0, fontWeight: FontWeight.w400);
/// 按钮文本样式 - 紫色
const TextStyle _kButtonPurpleTextStyle = const TextStyle(color: Colors.deepPurple, fontSize: 16.0, fontWeight: FontWeight.w400);

/// 按钮正常状态下的圆角 - circular 6.0
const BorderRadius _kButtonNormalBorderRadius = const BorderRadius.all(Radius.circular(6.0));
/// 按钮高亮状态下的圆角 - circular 12.0
const BorderRadius _kButtonHighlightBorderRadius = const BorderRadius.all(Radius.circular(12.0));
/// 按钮禁用状态下的圆角 - circular 0.0
const BorderRadius _kButtonDisableBorderRadius = BorderRadius.zero;

/// 按钮内容内边距
const EdgeInsets _kButtonContentPadding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0);

/// 第 1 组左边按钮的样式
const StoneButtonStyle _kSection1ButtonStyle1 = const StoneButtonStyle(
  key: 'section1_button_style1',
  textStyle: _kButtonWhiteTextStyle,
  color: Colors.green,
  highlightColor: Colors.teal,
  disabledColor: Colors.blueGrey,
  borderRadius: _kButtonNormalBorderRadius,
  splashColor: Colors.white30,
  padding: _kButtonContentPadding,
);

/// 第 1 组右边按钮的样式
const StoneButtonStyle _kSection1ButtonStyle2 = const StoneButtonStyle(
  key: 'section1_button_style2',
  textStyle: _kButtonWhiteTextStyle,
  color: AppColors.red,
  borderRadius: _kButtonNormalBorderRadius,
  highlightBorderRadius: _kButtonHighlightBorderRadius,
  disabledBorderRadius: _kButtonDisableBorderRadius,
  splashColor: Colors.white30,
  elevation: 2.0,
  highlightElevation: 4.0,
  padding: _kButtonContentPadding,
);

/// 第 2 组按钮的样式
const StoneButtonStyle _kSection2ButtonStyle = const StoneButtonStyle(
  key: '_section2_button_style',
  textStyle: _kButtonWhiteTextStyle,
  gradient: LinearGradient(colors: <Color>[Colors.blueAccent, Colors.lightBlue]),
  borderRadius: _kButtonNormalBorderRadius,
  splashColor: Colors.white30,
  padding: _kButtonContentPadding,
);

/// 第 3 组按钮的样式
StoneButtonStyle _kSection3ButtonStyle = StoneButtonStyle(
  key: 'section3_button_style',
  textStyle: _kButtonPinkTextStyle,
  borderSide: BorderSide(color: Colors.pink, width: 1.0),
  borderRadius: _kButtonNormalBorderRadius,
  splashColor: Colors.teal.withOpacity(0.3),
  padding: _kButtonContentPadding,
);

/// 第 4 组按钮的样式
StoneButtonStyle _kSection4ButtonStyle = StoneButtonStyle(
  key: 'section4_button_style',
  textStyle: _kButtonTealTextStyle,
  splashColor: Colors.teal.withOpacity(0.3),
  padding: _kButtonContentPadding,
);

/// 第 5 组按钮的样式
StoneButtonStyle _kSection5ButtonStyle = StoneButtonStyle(
  key: 'section5_button_style',
  textStyle: _kButtonPurpleTextStyle,
  splashColor: Colors.deepPurple.withOpacity(0.3),
  splashShape: CircleBorder(),
  tapTargetSize: Size(40.0, 40.0),
);

/// 第 6 组按钮的样式
StoneButtonStyle _kSection6ButtonStyle = StoneButtonStyle(
  key: 'section6_button_style',
  textStyle: _kButtonTealTextStyle,
  splashColor: Colors.teal.withOpacity(0.3),
  padding: _kButtonContentPadding,
);

/// 第 7 组按钮的样式
const StoneButtonStyle _kSection7ButtonStyle = const StoneButtonStyle(
  key: 'section7_button_style',
  color: AppColors.red,
  splashColor: Colors.white30,
  shape: CircleBorder(),
  elevation: 2.0,
  highlightElevation: 4.0,
  width: 60.0,
  height: 60.0,
);

/// 底部工具栏的样式
const StoneButtonStyle _bottomToolbarButtonStyle = const StoneButtonStyle(
  key: 'bottom_toolbar_button',
  textStyle: _kButtonWhiteTextStyle,
  gradient: LinearGradient(colors: AppColors.greenGradient),
  shape: StadiumBorder(),
  padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
);

/// [StoneBackButton]、[StoneBarButton]
/// [StoneButton]、[StoneButtonStyle]、[StoneButtonTheme]
/// [StoneBottomToolbar]、[StoneBottomToolBarTheme]
class ButtonThemeDemoPage extends StatefulWidget {
  @override
  _ButtonThemeDemoPageState createState() => _ButtonThemeDemoPageState();
}

class _ButtonThemeDemoPageState extends State<ButtonThemeDemoPage> with SingleTickerProviderStateMixin {
  /// 是否启用按钮
  bool _buttonEnabled = true;
  /// 点击按钮后是否开启新页面
  bool _pushPageWhenTapButton = false;

  /// 是否为 iOS
  bool _isCupertino = Platform.isIOS ? true : false;
  /// 按钮类型
  StoneButtonType get _buttonType => _isCupertino ? StoneButtonType.cupertino : StoneButtonType.material;
  /// 按钮文本
  Text get _buttonText => Text(_buttonType == StoneButtonType.cupertino ? 'Cupertino Button' : 'Material Button');

  /// 是否正在加载中
  ///
  /// 用于 [_ButtonDemoPageState._buildSection6]、[_ButtonDemoPageState._buildSection7] 中的按钮。
  bool _isLoading = false;

  /// 动画控制器
  ///
  /// 用于 [_ButtonDemoPageState._buildSection6]、[_ButtonDemoPageState._buildSection7] 中的按钮。
  AnimationController _animationController;

  /// 处理按钮点击事件
  ///
  /// 用于所有按钮。
  VoidCallback get _onPressed {
    if (!_buttonEnabled) {
      return null;
    }
    return _pushPageWhenTapButton ? () => NavigateService.I.push(ButtonThemeDemoPage()) : () {};
  }

  /// 加载数据
  ///
  /// 用于 [_ButtonDemoPageState._buildSection6]、[_ButtonDemoPageState._buildSection7] 中的按钮。
  void _onLoad() {
    _onPressed();
    setState(() => _isLoading = !_isLoading);
    _animationController.forward();

    Future.delayed(_animationController.duration, () {
      setState(() => _isLoading = !_isLoading);
      _animationController.reverse();
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (_animationController == null) {
      _animationController = AnimationController(value: 0.0, duration: Duration(milliseconds: 1500), vsync: this);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    Widget button(onPressed, text) => StoneBarButton(
      onPressed: onPressed,
      type: _buttonType,
      title: Text(text),
    );

    return AppBar(
      title: Text('Button Theme'),
      centerTitle: true,
      leading: StoneBackButton(
        type: _buttonType,
      ),
      actions: <Widget>[
        button(() => setState(() => _buttonEnabled = !_buttonEnabled), _buttonEnabled ? '启用' : '禁用'),
        button(
          () => setState(() => _isCupertino = !_isCupertino),
          _buttonType == StoneButtonType.cupertino ? '苹果' : '安卓',
        ),
      ],
    );
  }

  Widget _buildBody() {
    final content = Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
            children: <Widget>[
              _buildSection1(),
              _buildSection2(),
              _buildSection3(),
              _buildSection4(),
              _buildSection5(),
              _buildSection6(),
              _buildSection7(),
            ],
          ),
        ),
        StoneBottomToolbar(
          child: StoneButton(
            onPressed: !_buttonEnabled ? null : () => setState(() => _pushPageWhenTapButton = !_pushPageWhenTapButton),
            type: _buttonType,
            styleKey: _bottomToolbarButtonStyle.key,
            width: double.infinity,
            child: Text(_pushPageWhenTapButton ? '点击后跳转' : '点击后不跳转'),
          ),
        ),
      ],
    );

    final buttonTheme = StoneButtonTheme(
      styles: <String, StoneButtonStyle>{
        _bottomToolbarButtonStyle.key: _bottomToolbarButtonStyle,
        _kSection1ButtonStyle1.key: _kSection1ButtonStyle1,
        _kSection1ButtonStyle2.key: _kSection1ButtonStyle2,
        _kSection2ButtonStyle.key: _kSection2ButtonStyle,
        _kSection3ButtonStyle.key: _kSection3ButtonStyle,
        _kSection4ButtonStyle.key: _kSection4ButtonStyle,
        _kSection5ButtonStyle.key: _kSection5ButtonStyle,
        _kSection6ButtonStyle.key: _kSection6ButtonStyle,
        _kSection7ButtonStyle.key: _kSection7ButtonStyle,
      },
      child: content,
    );

    return StoneBottomToolbarTheme(
      data: StoneBottomToolbarThemeData(
        padding: EdgeInsets.symmetric(horizontal: 60.0),
        height: 60.0,
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2.0,
            ),
          ],
        ),
      ),
      child: buttonTheme,
    );
  }

  /// 纯色实心按钮组
  Widget _buildSection1() {
    final blueButton = StoneButton(
      onPressed: _onPressed,
      styleKey: _kSection1ButtonStyle1.key,
      type: _buttonType,
      child: _buttonText,
    );

    final redButton = StoneButton(
      onPressed: _onPressed,
      styleKey: _kSection1ButtonStyle2.key,
      type: _buttonType,
      child: _buttonText,
    );

    return _buildSection(
      title: '纯色实心按钮',
      child: Row(
        children: <Widget>[
          Expanded(child: blueButton),
          SizedBox(width: 12.0),
          Expanded(child: redButton),
        ],
      ),
    );
  }

  /// 渐变实心按钮组
  Widget _buildSection2() {
    Widget button(highlightGradient) => StoneButton(
      onPressed: _onPressed,
      styleKey: _kSection2ButtonStyle.key,
      type: _buttonType,
      highlightGradient: highlightGradient,
      child: _buttonText,
    );

    return _buildSection(
      title: '渐变实心按钮',
      child: Row(
        children: <Widget>[
          Expanded(child: button(null)),
          SizedBox(width: 12.0),
          Expanded(child: button(LinearGradient(colors: <Color>[Colors.green, Colors.amber]))),
        ],
      ),
    );
  }

  /// 空心按钮
  Widget _buildSection3() {
    return _buildSection(
      title: '空心按钮',
      child: StoneButton(
        onPressed: _onPressed,
        styleKey: _kSection3ButtonStyle.key,
        type: _buttonType,
        width: double.infinity,
        child: _buttonText,
      ),
    );
  }

  /// 扁平按钮
  Widget _buildSection4() {
    return _buildSection(
      title: '扁平按钮',
      child: StoneButton(
        onPressed: _onPressed,
        styleKey: _kSection4ButtonStyle.key,
        type: _buttonType,
        width: double.infinity,
        child: _buttonText,
      ),
    );
  }

  /// 图标按钮
  Widget _buildSection5() {
    Widget button(useIcon) => StoneButton(
      onPressed: _onPressed,
      styleKey: _kSection5ButtonStyle.key,
      type: _buttonType,
      builder: (_, state) {
        switch (state) {
          case StoneButtonState.normal:
            return useIcon ? Icon(Icons.access_alarm, size: 22.0) : Text('点我');
          case StoneButtonState.highlighted:
            return useIcon ? Icon(Icons.access_time, size: 22.0) : Text('嗯啊');
          case StoneButtonState.disabled:
            return useIcon ? Icon(Icons.accessibility_new, size: 22.0) : Text('哎哎');
        }
        return null;
      },
    );

    return _buildSection(
      title: '图标按钮',
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              button(true),
              button(false),
            ],
          ),
        ],
      ),
    );
  }

  /// 变形按钮
  Widget _buildSection6() {
    final borderSide = BorderSide(color: Colors.teal, width: 1.5);
    final shape = _isLoading
        ? CircleBorder(side: borderSide)
        : RoundedRectangleBorder(borderRadius: _kButtonNormalBorderRadius, side: borderSide);

    return _buildSection(
      title: '变形按钮',
      child: SizedBox(
        width: double.infinity,
        child: StoneButton(
          onPressed: !_buttonEnabled || _isLoading ? null : _onLoad,
          styleKey: _kSection6ButtonStyle.key,
          type: _buttonType,
          textStyle: _kSection7ButtonStyle.textStyle,
          disabledTextStyle: _isLoading ? _kSection7ButtonStyle.textStyle : null,
          shape: shape,
          disabledShape: _isLoading ? shape : null,
          child: _isLoading ? CupertinoActivityIndicator() : Text('点击加载'),
        ),
      ),
    );
  }

  /// 悬浮按钮
  Widget _buildSection7() {
    return _buildSection(
      title: '悬浮按钮',
      child: Center(
        child: StoneButton(
          onPressed: !_buttonEnabled || _isLoading ? null : _onLoad,
          styleKey: _kSection7ButtonStyle.key,
          type: _buttonType,
          child: RotationTransition(
            turns: _animationController,
            child: Icon(Icons.toys, color: AppColors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({String title, Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 4.0,
                height: 16.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.greenGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              Text(
                title,
                style: AppTextStyles.blackW400(fontSize: 14.0),
              ),
            ],
          ),
        ),
        StoneItem(
          borderRadius: BorderRadius.circular(8.0),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          color: AppColors.white,
          child: child,
        ),
      ],
    );
  }
}