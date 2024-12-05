//
//  TestLibPlugin.java
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 1st October 2018.
//  Copyright (c) 2018-2021 Adjust GmbH. All rights reserved.
//

package com.adjust.test.lib;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import com.adjust.test.ICommandJsonListener;
import com.adjust.test.TestLibrary;
import com.adjust.test_options.TestConnectionOptions;

import java.util.HashMap;
import java.util.Map;

public class TestLibPlugin implements FlutterPlugin, MethodCallHandler {
    private static String TAG = "TestLibPlugin";
    private TestLibrary testLibrary = null;
    private MethodChannel channel;

    public TestLibPlugin() {}

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        channel = new MethodChannel(binding.getBinaryMessenger(), "com.adjust.test.lib/api");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        if (channel != null) {
            channel.setMethodCallHandler(null);
        }
        channel = null;
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "init":
                init(call, result);
                break;
            case "startTestSession":
                startTestSession(call, result);
                break;
            case "addInfoToSend":
                addInfoToSend(call, result);
                break;
            case "sendInfoToServer":
                sendInfoToServer(call, result);
                break;
            case "addTest":
                addTest(call, result);
                break;
            case "addTestDirectory":
                addTestDirectory(call, result);
                break;
            case "doNotExitAfterEnd":
                doNotExitAfterEnd(result);
                break;
            case "setTestConnectionOptions":
                setTestConnectionOptions(result);
                break;
            default:
                error("Not implemented method: " + call.method);
                result.notImplemented();
                break;
        }
    }

    private void init(final MethodCall call, final Result result) {
        Map paramsMap = (Map)call.arguments;
        if (!paramsMap.containsKey("baseUrl") || !paramsMap.containsKey("controlUrl")) {
            result.error("0", "Arguments null or wrong (missing 'baseUrl' or 'controlUrl')", null);
            return;
        }

        String baseUrl = (String) paramsMap.get("baseUrl");
        String controlUrl = (String) paramsMap.get("controlUrl");
        final String dartMethodName = "adj-test-execute";
        testLibrary = new TestLibrary(baseUrl, controlUrl, new ICommandJsonListener() {
            @Override
            public void executeCommand(String className, String methodName, String jsonParameters) {
                final HashMap<String, String> methodParams = new HashMap<String, String>();
                methodParams.put("className", className);
                methodParams.put("methodName", methodName);
                methodParams.put("jsonParameters", jsonParameters);

                log("Trying to call a method 'adj-test-execute' with: " + className + "." + methodName);
                Handler mainHandler = new Handler(Looper.getMainLooper());
                Runnable myRunnable = new Runnable() {
                    @Override
                    public void run() {
                        channel.invokeMethod(dartMethodName, methodParams);
                    }
                };
                mainHandler.post(myRunnable);
            }
        });
        result.success(null);
    }

    private void startTestSession(final MethodCall call, final Result result) {
        if (testLibrary == null) {
            result.error("0", "Test Library not initialized. Call 'init' method first.", null);
            return;
        }

        Map paramsMap = (Map)call.arguments;
        if (!paramsMap.containsKey("clientSdk")) {
            result.error("0", "Arguments null or wrong (missing argument 'clientSdk'", null);
            return;
        }

        String clientSdk = (String) paramsMap.get("clientSdk");
        testLibrary.startTestSession(clientSdk);
        result.success(null);
    }

    private void addInfoToSend(final MethodCall call, final Result result) {
        if (testLibrary == null) {
            result.error("0", "Test Library not initialized. Call 'init' method first.", null);
            return;
        }

        Map paramsMap = (Map)call.arguments;
        String key = (String) paramsMap.get("key");
        String value = (String) paramsMap.get("value");
        testLibrary.addInfoToSend(key, value);
        result.success(null);
    }

    private void sendInfoToServer(final MethodCall call, final Result result) {
        if (testLibrary == null) {
            result.error("0", "Test Library not initialized. Call 'init' method first.", null);
            return;
        }

        Map paramsMap = (Map)call.arguments;
        String basePath = (String) paramsMap.get("basePath");
        testLibrary.sendInfoToServer(basePath);
        result.success(null);
    }

    private void addTest(final MethodCall call, final Result result) {
        if (testLibrary == null) {
            result.error("0", "Test Library not initialized. Call 'init' method first.", null);
            return;
        }

        Map paramsMap = (Map)call.arguments;
        String testName = (String) paramsMap.get("testName");
        assert testName != null;
        testLibrary.addTest(testName);
        result.success(null);
    }

    private void addTestDirectory(final MethodCall call, final Result result) {
        if (testLibrary == null) {
            result.error("0", "Test Library not initialized. Call 'init' method first.", null);
            return;
        }

        Map paramsMap = (Map)call.arguments;
        String testDirectory = (String) paramsMap.get("testDirectory");
        assert testDirectory != null;
        testLibrary.addTestDirectory(testDirectory);
        result.success(null);
    }

    private void doNotExitAfterEnd(final Result result) {
        if (testLibrary == null) {
            result.error("0", "Test Library not initialized. Call 'init' method first.", null);
            return;
        }

        testLibrary.doNotExitAfterEnd();
        result.success(null);
    }

    private void setTestConnectionOptions(final Result result) {
        if (testLibrary == null) {
            result.error("0", "Test Library not initialized. Call 'init' method first.", null);
            return;
        }

        TestConnectionOptions.setTestConnectionOptions();
        result.success(null);
    }

    private void log(String message) {
        Log.d(TAG, message);
    }

    private void error(String message) {
        Log.e(TAG, message);
    }
}
