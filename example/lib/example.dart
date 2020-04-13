import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hybrid_router/hybrid_router.dart';

class ExamplePage extends StatefulWidget {
  final String title;

  ExamplePage({@required this.title});

  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> with WidgetsBindingObserver {
  final Color color = _ColorMaker.getNextColor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: color,
          title: Text(widget.title ?? "FlutterExample"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop("I am message from flutter example");
            },
          ),
          actions: <Widget>[
            PopupMenuButton(
              child: Text("上下文菜单"),
              tooltip: "长按提示",
              initialValue: "menu1",
              padding: EdgeInsets.all(0.0),
              itemBuilder: (BuildContext context) {
                return <PopupMenuItem<String>>[
                  PopupMenuItem<String>(
                    child: Text("菜单一"),
                    value: "menu1",
                  ),
                  PopupMenuItem<String>(
                    child: Text("菜单二"),
                    value: "menu2",
                  ),
                ];
              },
              onSelected: (String action) {
                switch (action) {
                  case "menu1":
                    print("菜单一");
                    break;
                  case "menu2":
                    print("菜单二");
                    break;
                }
              },
              onCanceled: () {
                print("onCanceled");
              },
            )
          ]),
      body: new _ExampleBody(color: color),
    );
  }
}

class TabExamplePage extends StatefulWidget {
  @override
  _TabExamplePageState createState() => _TabExamplePageState();
}

class _TabExamplePageState extends State<TabExamplePage>
    with NativeContainerExitMixin {
  final Color color = _ColorMaker.getNextColor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: color,
          title: Text('Flutter tab example'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context)
                  .maybePop("I am message from flutter example");
            },
          ),
          actions: <Widget>[
            PopupMenuButton(
              child: Text("上下文菜单"),
              tooltip: "长按提示",
              initialValue: "menu1",
              padding: EdgeInsets.all(0.0),
              itemBuilder: (BuildContext context) {
                return <PopupMenuItem<String>>[
                  PopupMenuItem<String>(
                    child: Text("菜单一"),
                    value: "menu1",
                  ),
                  PopupMenuItem<String>(
                    child: Text("菜单二"),
                    value: "menu2",
                  ),
                ];
              },
              onSelected: (String action) {
                switch (action) {
                  case "menu1":
                    print("菜单一");
                    break;
                  case "menu2":
                    print("菜单二");
                    break;
                }
              },
              onCanceled: () {
                print("onCanceled");
              },
            )
          ]),
      body: _ExampleBody(
        color: color,
      ),
    );
  }
}

class _ExampleBody extends StatelessWidget {
  final Color color;

  const _ExampleBody({
    Key key,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text(
              '通过 pushNamed 跳转到 flutter examlpe (native)',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              String message = await Navigator.of(context)
                  .pushNamed("example", arguments: "Jump From Flutter");
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text(message ?? "No result found")));
            },
          ),
          ListTile(
            title: Text(
              '通过 push 跳转到 flutter examlpe (native)',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              String message = await Navigator.of(context).push(
                HybridPageRoute(builder: (context) {
                  return ExamplePage(
                    title: "Jump from flutter",
                  );
                }),
              );
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text(message ?? "No result found")));
            },
          ),
          ListTile(
            title: Text(
              '通过 push 跳转到 flutter examlpe (flutter)',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              String message = await Navigator.of(context).push(HybridPageRoute(
                  pushType: HybridPushType.Flutter,
                  builder: (context) {
                    return ExamplePage(
                      title: 'Jump from flutter',
                    );
                  }));
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text(message ?? "No result found")));
            },
          ),
          ListTile(
            title: Text(
              '跳转到 native example',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              NativePageResult result = await HybridNavigator.of(context)
                  .openNativePage(
                      url: "native://hybridstackmanager/example",
                      args: {"title": "jump from native"});
              if (result != null && result.data is Map) {
                Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text((result.data["message"] as String) ??
                        "No result found")));
              }
            },
          ),
          ListTile(
            title: Text(
              '测试页面 not found',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              Navigator.of(context).pushNamed("404");
            },
          ),
          ListTile(
            title: Text(
              '测试自定义 open native 动画',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              NativePageResult result = await HybridNavigator.of(context)
                  .openNativePage(
                      url: "native://hybridstackmanager/example",
                      args: {"title": "jump from native"},
                      transitionType: NativePageTransitionType.RIGHT_LEFT);
              if (result != null && result.data is Map) {
                Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text((result.data["message"] as String) ??
                        "No result found")));
              }
            },
          ),
          ListTile(
            title: Text(
              '测试自定义 open flutter 动画(in native)',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              String message = await HybridNavigator.of(context).pushNamed(
                  "example",
                  arguments: "jump from flutter",
                  transitionType: NativePageTransitionType.RIGHT_LEFT);
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text(message ?? "No result found")));
            },
          ),
          ListTile(
            title: Text(
              '跳转到 android 数据非法的 native 页面',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              NativePageResult result = await HybridNavigator.of(context)
                  .openNativePage(
                      url: "native://hybridstackmanager/illegal_result");
              print("返回的数据是: ${result.data}");
            },
          ),
          ListTile(
            title: Text(
              '通过 HybridNavigator 跳转到透明Activity',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              NativePageResult result = await HybridNavigator.of(context)
                  .openNativePage(
                      url: "native://hybridstackmanager/translucent",
                      args: {"title": "jump from native"});
              if (result != null && result.data is Map) {
                Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text((result.data["message"] as String) ??
                        "No result found")));
              }
            },
          ),
          ListTile(
            title: Text(
              '通过 HybridNavigator 跳转到非透明Activity',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              NativePageResult result = await HybridNavigator.of(context)
                  .openNativePage(
                      url: "native://hybridstackmanager/notranslucent",
                      args: {"title": "jump from native"});
              if (result != null && result.data is Map) {
                Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text((result.data["message"] as String) ??
                        "No result found")));
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ColorMaker {
  static int _currentIndex = 0;
  static List<Color> _colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow[700],
    Colors.green,
    Colors.cyan,
    Colors.blue,
    Colors.purple
  ];

  static Color getNextColor() {
    Color ret = _colors[_currentIndex];
    _currentIndex = (_currentIndex + 1) % _colors.length;
    return ret;
  }
}
