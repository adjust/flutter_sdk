//
//  TestlibPlugin.m
//  testlib
//
//  Created by Srdjan Tubin on 01.10.18.
//

#import "TestlibPlugin.h"
#import "AdjustCommandExecutor.h"

@interface TestlibPlugin ()
@property(nonatomic, retain) FlutterMethodChannel *channel;
@property(nonatomic, strong) ATLTestLibrary *testLibrary;
@property(nonatomic, strong) AdjustCommandExecutor *adjustCommandExecutor;
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
    NSLog(@"Initializing test lib bridge ...");
    NSString *baseUrl = call.arguments[@"baseUrl"];
    if (![self isFieldValid:baseUrl]) {
        result([FlutterError errorWithCode:@"WRONG-ARGS"
                                   message:@"Arguments null or wrong (missing argument >baseUrl<"
                                   details:nil]);
        return;
    }
    
    self.adjustCommandExecutor = [[AdjustCommandExecutor alloc]initWithMethodChannel:self.channel];
    self.testLibrary = [ATLTestLibrary testLibraryWithBaseUrl:baseUrl
                                           andCommandDelegate:self.adjustCommandExecutor];
    NSLog(@"Test lib bridge initialized.");
}

- (void)startTestSession:(FlutterMethodCall*)call withResult:(FlutterResult)result {
    if ([self testLibOk:result] == NO) {
        NSLog(@"Error. Cannot start test session. Test lib bridge not initialized.");
        return;
    }
    
    NSString *clientSdk = call.arguments[@"clientSdk"];
    if (![self isFieldValid:clientSdk]) {
        result([FlutterError errorWithCode:@"WRONG-CLIENT-SDK"
                                   message:@"Arguments null or wrong (missing argument >clientSdk<"
                                   details:nil]);
        return;
    }
    
    NSLog(@"Starting test session. Client SDK %@", clientSdk);
    [self.testLibrary startTestSession:clientSdk];
}

- (void)addInfoToSend:(FlutterMethodCall*)call withResult:(FlutterResult)result {
    if ([self testLibOk:result] == NO) {
        return;
    }
    
    NSString *key = call.arguments[@"key"];
    NSString *value = call.arguments[@"value"];
    [self.testLibrary addInfoToSend:key value:value];
}

- (void)sendInfoToServer:(FlutterMethodCall*)call withResult:(FlutterResult)result {
    if ([self testLibOk:result] == NO) {
        return;
    }
    
    NSString *basePath = call.arguments[@"basePath"];
    [self.testLibrary sendInfoToServer:basePath];
}

- (void)addTest:(FlutterMethodCall*)call withResult:(FlutterResult)result {
    if ([self testLibOk:result] == NO) {
        return;
    }
    
    NSString *testName = call.arguments[@"testName"];
    [self.testLibrary addTest:testName];
}

- (void)addTestDirectory:(FlutterMethodCall*)call withResult:(FlutterResult)result {
    if ([self testLibOk:result] == NO) {
        return;
    }
    
    NSString *testDirectory = call.arguments[@"testDirectory"];
    [self.testLibrary addTestDirectory:testDirectory];
}

- (void)doNotExitAfterEnd:(FlutterMethodCall*)call withResult:(FlutterResult)result {
    if ([self testLibOk:result] == NO) {
        return;
    }
    
    // not awailable for iOS
    NSLog(@">doNotExitAfterEnd< not available on iOS");
}

//////////// HELPER METHODS ///////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)testLibOk:(FlutterResult)result {
    if (self.testLibrary == nil) {
        result([FlutterError errorWithCode:@"TEST-LIB-NIL"
                                   message:@"Test Library not initialized. Call >init< first."
                                   details:nil]);
        return NO;
    }
    return YES;
}

- (BOOL)isFieldValid:(NSObject *)field {
    if (field == nil) {
        return NO;
    }
    
    // Check if its an instance of the singleton NSNull
    if ([field isKindOfClass:[NSNull class]]) {
        return NO;
    }
    
    // If field can be converted to a string, check if it has any content.
    NSString *str = [NSString stringWithFormat:@"%@", field];
    if (str != nil) {
        if ([str length] == 0) {
            return NO;
        }
    }
    
    return YES;
}

@end
