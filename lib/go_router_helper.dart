library go_router_helper;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class RoutingHelper {
  String get path;
  String get name;

  /// go_router 에서 path를 지정할 때, [path] 뒤에 붙여 사용하는 용도.
  ///
  ///       GoRoute(
  ///           path: path + paramFormat,
  ///           ...
  ///
  String get paramFormat;

  /// remove..? or change to getter&setter?
  Map<String, String>? get params;

  /// push 할 때 값을 pathParam으로 변환하는 것을 strict하게!
  /// '/:one/:two/:three' => '/data1/data2/data3'; 와 같이 반환함.
  String get pathParam => paramFormat.split('/:').map((e) => params![e]).join('/').toString();

  RoutingHelper();


  ///이 생성자를 반드시 구현하도록.. strict하게 구현하고 싶은데..
  RoutingHelper.iWantRequireNamedConstructor();
  // 하위 클래스에서, 생성자를 구현하도록 할 수 없으니 이렇게 해야하나? =>>>
  //RouteWithParam init(Map<String, String> params);

  /// Functionable method. Use: 'RouteWithParam() as Function';
  ///
  ///push할 때 사용될 Uri (ex, /detail/data1/data2...)
  String call();

  /// ㅇㅕ기다가 push, go를?? or 추상화에 한번에 가능한가.?

  Future<T?> push<T extends Object?>({dynamic arg}) async {
    /// push(this) 는 안되려나?
    return rootNavigatorKey.currentContext!.push(call(), extra: arg);
  }

  void go(BuildContext context, {Object? extra}) async {
    return context.go(path, extra: extra);
  }
}



/***
 * Use in Project! =================================================================================
 *
 * < Example >
 * 프로젝트 안에서는 아래처럼 구현할 수 있다는 예시
 */

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class DetailRoute extends RoutingHelper {
  @override
  String get path => name + paramFormat;
  //TODO: static 이어야.. GoRoute/path 에 등록을 편하게 할 텐데.. static은 override가 안되고.. 일일이 작성하길 바라기..?
  /// 아니면,,, 밑에 푸시할 때 사용한다고 적은, 일반 생성자를 properties 를 받지않고, 생성 가능하도록 할까..? 푸시할 때 쓰는 생성자는 따로 만들고..?

  /// GoRoute 에서의 name 과는 다르긴 한데..
  @override
  String get name => "/detail";

  @override
  String paramFormat = '/:serviceCategory/:tab/:tid';

  /// 추상화 클래스에서는 getter인데, 변수로 만드는게 가능한가보네...??  ... 그러고보니 아래도 그럼
  @override
  Map<String, String>? params;

  @override
  call() => path + pathParam;

  /**
   * 아래부터는 사용 시, 직접 구현할 부분들
   * */

  final String serviceCategory;
  final String tab;
  final String tid;

  /// 이건 푸시할 때 쓰고
  DetailRoute(this.serviceCategory, this.tab, this.tid) : params = null;

  /// 이건 라우트 빌더 안에서...?
  DetailRoute.init(this.params)
      : serviceCategory = params![RouteArgs.arg_serviceCategory]!,
        tab = params[RouteArgs.arg_tab]!,
        tid = params[RouteArgs.arg_tid]!;

}
class RouteArgs {
  static const String arg_tid = 'tid';
  static const String arg_tab = 'tab';
  static const String arg_serviceCategory = 'serviceCategory';
}

main() {
}