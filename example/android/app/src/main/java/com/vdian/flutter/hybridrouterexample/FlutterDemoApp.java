package com.vdian.flutter.hybridrouterexample;

import android.app.Activity;
import android.app.Application;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import android.view.Window;

import com.vdian.flutter.hybridrouter.FlutterManager;
import com.vdian.flutter.hybridrouter.page.EmptyFlutterWrapConfig;
import com.vdian.flutter.hybridrouter.page.FlutterRouteOptions;
import com.vdian.flutter.hybridrouter.page.IFlutterNativePage;

import io.flutter.view.FlutterMain;

/**
 * ┏┛ ┻━━━━━┛ ┻┓
 * ┃　　　　　　 ┃
 * ┃　　　━　　　┃
 * ┃　┳┛　  ┗┳　┃
 * ┃　　　　　　 ┃
 * ┃　　　┻　　　┃
 * ┃　　　　　　 ┃
 * ┗━┓　　　┏━━━┛
 * * ┃　　　┃   神兽保佑
 * * ┃　　　┃   代码无BUG！
 * * ┃　　　┗━━━━━━━━━┓
 * * ┃　　　　　　　    ┣┓
 * * ┃　　　　         ┏┛
 * * ┗━┓ ┓ ┏━━━┳ ┓ ┏━┛
 * * * ┃ ┫ ┫   ┃ ┫ ┫
 * * * ┗━┻━┛   ┗━┻━┛
 *
 * @author qigengxin
 * @since 2019/2/11 12:08 PM
 */
public class FlutterDemoApp extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        // 提前初始化
        FlutterMain.startInitialization(this);
        // 可以添加一些自定义的行为
        FlutterManager.getInstance().setFlutterWrapConfig(new EmptyFlutterWrapConfig() {

            @Override
            public void postFlutterApplyTheme(@NonNull IFlutterNativePage nativePage) {
                // 修改当前沉浸式主题的背景色为透明
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP &&
                        nativePage.getContext() instanceof Activity) {
                    Window window = ((Activity) nativePage.getContext()).getWindow();
                    window.setStatusBarColor(Color.TRANSPARENT);
                }
            }

            @Override
            public boolean onFlutterPageRoute(@NonNull IFlutterNativePage nativePage,
                                              @Nullable FlutterRouteOptions routeOptions, int requestCode) {
                // 自定义flutter 页面的跳转
                Intent intent = FlutterExampleActivity.builder().route(routeOptions)
                        .buildIntent(nativePage.getContext());
                nativePage.startActivityForResult(intent, requestCode);
                return true;
            }
        });

    }
}
