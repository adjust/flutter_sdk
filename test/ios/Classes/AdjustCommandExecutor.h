//
//  AdjustCommandExecutor.h
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 1st October 2018.
//  Copyright (c) 2018 Adjust GmbH. All rights reserved.
//

#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>
#import <AdjustTestLibrary/ATLTestLibrary.h>

@interface AdjustCommandExecutor : NSObject<AdjustCommandDelegate>
- (id)initWithMethodChannel:(FlutterMethodChannel *)channel;
- (void)executeCommand:(NSString *)className
            methodName:(NSString *)methodName
            parameters:(NSString *)jsonParameters;
@end
