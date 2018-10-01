#import "TestlibPlugin.h"

@interface TestlibPlugin ()
@property(nonatomic, retain) FlutterMethodChannel *channel;
@property(nonatomic, retain) ATLTestLibrary *testLibrary;
@end

@implementation TestlibPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"testlib"
                                     binaryMessenger:[registrar messenger]];
    TestlibPlugin* instance = [[TestlibPlugin alloc] init];
    instance.channel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];
}

// TODO: check if needed
- (void)dealloc {
    [self.channel setMethodCallHandler:nil];
    self.channel = nil;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"init" isEqualToString:call.method]) {
      [self init:call withResult:result];
  } else if ([@"startTestSession" isEqualToString:call.method]) {
      [self startTestSession:call withResult:result];
  } else if ([@"addInfoToSend" isEqualToString:call.method]) {
      [self addInfoToSend:call withResult:result];
  } else if ([@"sendInfoToServer" isEqualToString:call.method]) {
      [self sendInfoToServer:call withResult:result];
  } else if ([@"addTest" isEqualToString:call.method]) {
      [self addTest:call withResult:result];
  } else if ([@"addTestDirectory" isEqualToString:call.method]) {
      [self addTestDirectory:call withResult:result];
  } else if ([@"doNotExitAfterEnd" isEqualToString:call.method]) {
      [self doNotExitAfterEnd:call withResult:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)init:(FlutterMethodCall*)call withResult:(FlutterResult)result {
    
}

- (void)startTestSession:(FlutterMethodCall*)call withResult:(FlutterResult)result {
    
}

- (void)addInfoToSend:(FlutterMethodCall*)call withResult:(FlutterResult)result {
    
}

- (void)sendInfoToServer:(FlutterMethodCall*)call withResult:(FlutterResult)result {
    
}

- (void)addTest:(FlutterMethodCall*)call withResult:(FlutterResult)result {
    
}

- (void)addTestDirectory:(FlutterMethodCall*)call withResult:(FlutterResult)result {
    
}

- (void)doNotExitAfterEnd:(FlutterMethodCall*)call withResult:(FlutterResult)result {
    
}

@end
