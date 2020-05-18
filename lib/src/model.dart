// MIT License
// -----------

// Copyright (c) 2019 WeiDian Group
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:

// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
///
/// ┏┛ ┻━━━━━┛ ┻┓
/// ┃　　　　　　 ┃
/// ┃　　　━　　　┃
/// ┃　┳┛　  ┗┳　┃
/// ┃　　　　　　 ┃
/// ┃　　　┻　　　┃
/// ┃　　　　　　 ┃
/// ┗━┓　　　┏━━━┛
/// * ┃　　　┃   神兽保佑
/// * ┃　　　┃   代码无BUG！
/// * ┃　　　┗━━━━━━━━━┓
/// * ┃　　　　　　　    ┣┓
/// * ┃　　　　         ┏┛
/// * ┗━┓ ┓ ┏━━━┳ ┓ ┏━┛
/// * * ┃ ┫ ┫   ┃ ┫ ┫
/// * * ┗━┻━┛   ┗━┻━┛
/// @author qigengxin
/// @since 2019-02-26 15:10
///
import 'package:flutter/material.dart';
import 'navigator.dart';

/// the data struct that native page return
class NativePageResult<T> {
  /// the code that android platform return
  final int resultCode;

  /// the data that native page return
  final T data;

  NativePageResult({this.resultCode, this.data});
}

/// 路由 push 类型
enum HybridPushType { Flutter, Native }

/// 路由页面构造方法
typedef HybridRouteFactory = Route<T> Function<T extends Object>(
    RouteSettings settings);

typedef HybridWidgetBuilder = Widget Function(BuildContext context, Object args);

/// 页面 transition 动画类型
enum NativePageTransitionType {
  /// 使用默认动画，不做修改
  DEFAULT,

  /// 强制使用底部弹出
  BOTTOM_TOP,

  /// 强制使用从右往左
  RIGHT_LEFT
}

/// [Navigator] push route 的时候，可以传入此 route 来决定是否通过 native 来启动
/// 新的 flutter 页面
class HybridPageRoute<T> extends MaterialPageRoute<T> {
  /// native 页面动画
  final NativePageTransitionType transitionType;

  /// 页面打开类型
  HybridPushType pushType;

  HybridPageRoute({
    @required WidgetBuilder builder,
    this.transitionType = NativePageTransitionType.DEFAULT,
    HybridPushType pushType,
    RouteSettings settings
  })  : assert(builder != null),
        assert(transitionType != null),
        this.pushType = pushType ?? HybridNavigator.defaultPushType,
        super(
            settings: _parseSetting(pushType, settings),
            builder: builder);

  //v1.17 https://flutter.dev/docs/release/breaking-changes/route-navigator-refactoring
  static RouteSettings _parseSetting(HybridPushType pushType, RouteSettings defaultSetting) {
    pushType = pushType ?? HybridNavigator.defaultPushType;
    if (pushType == HybridPushType.Native) {
      if (defaultSetting == null) {
        return RouteSettings();
      }
//      else if (!defaultSetting.isInitialRoute){
//        return defaultSetting.copyWith(isInitialRoute: true);
//      }
    }
    return defaultSetting;
  }
}
