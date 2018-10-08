//
//  AdjustCommandExecutor.h
//  testlib
//
//  Created by Srdjan Tubin on 01.10.18.
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
