package com.adjust.test.testlib;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import com.adjust.testlibrary.ICommandJsonListener;
import com.adjust.testlibrary.TestLibrary;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** TestlibPlugin */
public class TestlibPlugin implements MethodCallHandler {
    private static String TAG = "ADJUST-TESTLIB-PLUGIN-BRIDGE";
    private static MethodChannel channel;
    private static TestLibrary testLibrary = null;

    /** Plugin registration. */
    public static void registerWith(Registrar registrar) {
        if (channel != null) {
          throw new IllegalStateException("You should not call registerWith more than once.");
        }

        channel = new MethodChannel(registrar.messenger(), "testlib");
        channel.setMethodCallHandler(new TestlibPlugin());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        log("Trying to call a method: " + call.method);

        switch (call.method) {
            case "getPlatformVersion": getPlatformVersion(result); break;
            case "init": init(call, result); break;
            case "startTestSession": startTestSession(call, result); break;
            case "addInfoToSend": addInfoToSend(call, result); break;
            case "sendInfoToServer": sendInfoToServer(call, result); break;
            case "addTest": addTest(call, result); break;
            case "addTestDirectory": addTestDirectory(call, result); break;
            case "doNotExitAfterEnd": doNotExitAfterEnd(result); break;

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
        if(!paramsMap.containsKey("baseUrl")) {
            result.error("0", "Arguments null or wrong (missing argument >baseUrl<", null);
            return;
        }

        String baseUrl = (String) paramsMap.get("baseUrl");

        testLibrary = new TestLibrary(baseUrl, new ICommandJsonListener() {
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
        }

        Map paramsMap = (Map)call.arguments;
        String key = (String) paramsMap.get("key");
        String value = (String) paramsMap.get("value");

        testLibrary.addInfoToSend(key, value);
    }

    private void sendInfoToServer(final MethodCall call, final Result result) {
        if(testLibrary == null) {
            result.error("0", "Test Library not initialized. Call >init< first.", null);
        }

        Map paramsMap = (Map)call.arguments;
        String basePath = (String) paramsMap.get("basePath");

        testLibrary.sendInfoToServer(basePath);
    }

    private void addTest(final MethodCall call, final Result result) {
        if(testLibrary == null) {
            result.error("0", "Test Library not initialized. Call >init< first.", null);
        }

        Map paramsMap = (Map)call.arguments;
        String testName = (String) paramsMap.get("testName");

        testLibrary.addTest(testName);
    }

    private void addTestDirectory(final MethodCall call, final Result result) {
        if(testLibrary == null) {
            result.error("0", "Test Library not initialized. Call >init< first.", null);
        }

        Map paramsMap = (Map)call.arguments;
        String testDirectory = (String) paramsMap.get("testDirectory");

        testLibrary.addTestDirectory(testDirectory);
    }

    private void doNotExitAfterEnd(final Result result) {
        if(testLibrary == null) {
            result.error("0", "Test Library not initialized. Call >init< first.", null);
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
