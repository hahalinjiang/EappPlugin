package com.skytech.eapp;


import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;

import com.yanzhenjie.permission.Action;
import com.yanzhenjie.permission.AndPermission;
import com.yanzhenjie.permission.Permission;
import com.yzq.zxinglibrary.android.CaptureActivity;
import com.yzq.zxinglibrary.bean.ZxingConfig;
import com.yzq.zxinglibrary.common.Constant;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

import java.util.List;

import static android.app.Activity.RESULT_OK;

/**
 * This class echoes a string called from JavaScript.
 */
public class EappPlugin extends CordovaPlugin {
    private CallbackContext callback;
    private Context context;
    NewActivity newActivity;
    public static String OPENTYPE = "by_right";
    private int REQUEST_CODE_SCAN = 111;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        this.callback = callbackContext;
        context = cordova.getActivity();

        if (action.equals("openNewView")) {
            try {
                if (!TextUtils.isEmpty(args.getString(0))) {
                    OPENTYPE = args.getString(0);
                }
                Intent intent = new Intent(context, NewActivity.class);
                intent.putExtra("url", args.getString(1));
                context.startActivity(intent);
                callback.success("打开页面成功");
            } catch (JSONException e) {
                callback.error("打开页面失败");
            }
            return true;
        }
        if (action.equals("viewBack")) {
            if (null == newActivity) {

                try {
                    newActivity = (NewActivity) cordova.getActivity();
                    newActivity.onBack();
                    callback.success("关闭页面成功");
                } catch (Exception e) {
                    callback.error("关闭页面失败");
                }
            }
            return true;

        }
        if (action.equals("barcodeScanne")) {
            EappPlugin pluginthis = this;
            AndPermission.with(context)
                    .permission(Permission.CAMERA, Permission.READ_EXTERNAL_STORAGE)
                    .onGranted(new Action() {
                        @Override
                        public void onAction(List<String> permissions) {
                            Intent intent = new Intent(context, CaptureActivity.class);
                            /*ZxingConfig是配置类
                             *可以设置是否显示底部布局，闪光灯，相册，
                             * 是否播放提示音  震动
                             * 设置扫描框颜色等
                             * 也可以不传这个参数
                             * */
                            ZxingConfig config = new ZxingConfig();
                            config.setFullScreenScan(false);//是否全屏扫描  默认为true  设为false则只会在扫描框中扫描
                            intent.putExtra(Constant.INTENT_ZXING_CONFIG, config);
                            PluginResult mPlugin = new PluginResult(PluginResult.Status.NO_RESULT);
                            mPlugin.setKeepCallback(true);

                            callbackContext.sendPluginResult(mPlugin);
                            cordova.startActivityForResult(pluginthis, intent, REQUEST_CODE_SCAN);
                        }
                    })
                    .onDenied(new Action() {
                        @Override
                        public void onAction(List<String> permissions) {
                            callbackContext.error("没有权限无法扫描呦");
                        }
                    }).start();

            return true;

        }

        if (action.equals("getValueFromApp")) {
            try {
                String value=SharedPreferencesHelper.getString(context, args.getString(0), "");
                callback.success(value);
            } catch (Exception e) {
                callback.error("取值失败");
            }
            return true;

        }

        if (action.equals("setValueForApp")) {
            try {
                SharedPreferencesHelper.putString(context, args.getString(0), args.getString(1));
                callback.success("存值成功");
            } catch (Exception e) {
                callback.error("存值失败");
            }
            return true;
        }
        return false;
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);
        // 扫描二维码/条码回传
        if (requestCode == REQUEST_CODE_SCAN) {
            if (resultCode == RESULT_OK) {
                if (intent != null) {
                    String content = intent.getStringExtra(Constant.CODED_CONTENT);
                    callback.success(content);
                }
            } else {
                callback.error("页面点击取消扫描");

            }

        }
    }
}
