//
//  TestLibPlugin.java
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 1st October 2018.
//  Copyright (c) 2018 Adjust GmbH. All rights reserved.
//

package com.adjust.test.lib;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import com.adjust.test.ICommandJsonListener;
import com.adjust.test.TestLibrary;

import java.util.HashMap;
import java.util.Map;

/** TestLibPlugin */
public class TestLibPlugin implements MethodCallHandler {
    private static String TAG = "ADJUST-TESTLIB-PLUGIN-BRIDGE";
    private TestLibrary testLibrary = null;
    private MethodChannel channel;

    TestLibPlugin(MethodChannel channel) {
        this.channel = channel;
    }

    /** Plugin registration. */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "test_lib");
        channel.setMethodCallHandler(new TestLibPlugin(channel));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        log("Trying to call a method: " + call.method);

        switch (call.method) {
            case "getPlatformVersion": getPlatformVersion(result); break;
            case "init":                init(call, result); break;
            case "startTestSession":    startTestSession(call, result); break;
            case "addInfoToSend":       addInfoToSend(call, result); break;
            case "sendInfoToServer":    sendInfoToServer(call, result); break;
            case "addTest":             addTest(call, result); break;
            case "addTestDirectory":    addTestDirectory(call, result); break;
            case "doNotExitAfterEnd":   doNotExitAfterEnd(result); break;

            default:
                error("Not implemented method: " + call.method);
                result.notImplemented();
                break;
        }
    }

    private void getPlatformVersion(final Result result) {
        result.success("Android " + android.os.Build.VERSION.RELEASE);
    }

    private void init(final MethodCall call, final Result result) {
        Map paramsMap = (Map)call.arguments;
        if(!paramsMap.containsKey("baseUrl") || !paramsMap.containsKey("controlUrl")) {
            result.error("0", "Arguments null or wrong (missing >baseUrl< or >controlUrl<)", null);
            return;
        }

        String baseUrl = (String) paramsMap.get("baseUrl");
        String controlUrl = (String) paramsMap.get("controlUrl");

        testLibrary = new TestLibrary(baseUrl, controlUrl, new ICommandJsonListener() {
            @Override
            public void executeCommand(String className, String methodName, String jsonParameters) {
                HashMap methodParams = new HashMap();
                methodParams.put("className", className);
                methodParams.put("methodName", methodName);
                methodParams.put("jsonParameters", jsonParameters);
                log("Trying to call a method [execute-method] with: " + className + "." + methodName);
                channel.invokeMethod("execute-method", methodParams);
            }
        });
    }

    private void startTestSession(final MethodCall call, final Result result) {
        if(testLibrary == null) {
            result.error("0", "Test Library not initialized. Call >init< first.", null);
            return;
        }

        Map paramsMap = (Map)call.arguments;
        if(!paramsMap.containsKey("clientSdk")) {
            result.error("0", "Arguments null or wrong (missing argument >clientSdk<", null);
            return;
        }

        String clientSdk = (String) paramsMap.get("clientSdk");
        testLibrary.startTestSession(clientSdk);
    }

    private void addInfoToSend(final MethodCall call, final Result result) {
        if(testLibrary == null) {
            result.error("0", "Test Library not initialized. Call >init< first.", null);
            return;
        }

        Map paramsMap = (Map)call.arguments;
        String key = (String) paramsMap.get("key");
        String value = (String) paramsMap.get("value");

        testLibrary.addInfoToSend(key, value);
    }

    private void sendInfoToServer(final MethodCall call, final Result result) {
        if(testLibrary == null) {
            result.error("0", "Test Library not initialized. Call >init< first.", null);
            return;
        }

        Map paramsMap = (Map)call.arguments;
        String basePath = (String) paramsMap.get("basePath");

        testLibrary.sendInfoToServer(basePath);
    }

    private void addTest(final MethodCall call, final Result result) {
        if(testLibrary == null) {
            result.error("0", "Test Library not initialized. Call >init< first.", null);
            return;
        }

        Map paramsMap = (Map)call.arguments;
        String testName = (String) paramsMap.get("testName");

        testLibrary.addTest(testName);
    }

    private void addTestDirectory(final MethodCall call, final Result result) {
        if(testLibrary == null) {
            result.error("0", "Test Library not initialized. Call >init< first.", null);
            return;
        }

        Map paramsMap = (Map)call.arguments;
        String testDirectory = (String) paramsMap.get("testDirectory");

        testLibrary.addTestDirectory(testDirectory);
    }

    private void doNotExitAfterEnd(final Result result) {
        if(testLibrary == null) {
            result.error("0", "Test Library not initialized. Call >init< first.", null);
            return;
        }

        testLibrary.doNotExitAfterEnd();
    }

    public static void log(String message) {
        // Todo: use android logging instead
        System.out.println(TAG + ": " + message);
    }

    public static void error(String message) {
        // Todo: use android logging instead
        System.out.println(TAG + ": ERROR - " + message);
    }
}
