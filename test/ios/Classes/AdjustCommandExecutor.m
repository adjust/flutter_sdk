//
//  AdjustCommandExecutor.m
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 1st October 2018.
//  Copyright (c) 2018 Adjust GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdjustCommandExecutor.h"

@interface AdjustCommandExecutor ()

@property(nonatomic, weak) FlutterMethodChannel *channel;

@end

@implementation AdjustCommandExecutor
- (id)initWithMethodChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    NSLog(@"Initializing Test Library with Method Channel ...");
    self.channel = channel;
    return self;
}

- (void)executeCommand:(NSString *)className
            methodName:(NSString *)methodName
            parameters:(NSString *)jsonParameters {
    NSLog(@"executeCommand className: %@, methodName: %@, parameters: %@", className, methodName, jsonParameters);
    NSMutableDictionary *methodParams = [[NSMutableDictionary alloc] init];
    [methodParams setObject:className forKey:@"className"];
    [methodParams setObject:methodName forKey:@"methodName"];
    [methodParams setObject:jsonParameters forKey:@"jsonParameters"];
    [self.channel invokeMethod:@"execute-method" arguments:methodParams];
}

@end
