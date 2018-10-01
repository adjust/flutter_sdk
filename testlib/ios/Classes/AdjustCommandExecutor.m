//
//  AdjustCommandExecutor.m
//  testlib
//
//  Created by Srdjan Tubin on 01.10.18.
//

#import <Foundation/Foundation.h>
#import "AdjustCommandExecutor.h"

@interface AdjustCommandExecutor ()
@property(nonatomic, weak) FlutterMethodChannel *channel;
@end

@implementation AdjustCommandExecutor
- (id)initWithMethodChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self == nil) return nil;
    
    self.channel = channel;
    
    NSLog(@"Initializing Test Library with Method Channel...");
    
    return self;
}

- (void)executeCommand:(NSString *)className
            methodName:(NSString *)methodName
            parameters:(NSString *)jsonParameters {
    NSLog(@"executeCommand className: %@, methodName: %@, parameters: %@", className, methodName, jsonParameters);
    NSDictionary *methodParams = [NSDictionary dictionary];
    [methodParams setValue:className forKey:@"className"];
    [methodParams setValue:methodName forKey:@"methodName"];
    [methodParams setValue:jsonParameters forKey:@"jsonParameters"];
    [self.channel invokeMethod:@"execute-method" arguments:methodParams];
}

@end
