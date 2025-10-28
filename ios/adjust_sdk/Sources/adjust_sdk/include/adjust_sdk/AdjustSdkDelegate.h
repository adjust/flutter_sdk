//
//  AdjustSdkDelegate.h
//  Adjust SDK
//
//  Created by Srdjan Tubin (2beens) on 22nd November 2018.
//  Copyright © 2018-Present Adjust GmbH. All rights reserved.
//

#import <Flutter/Flutter.h>
#import <AdjustSdk/AdjustSdk.h>

@interface AdjustSdkDelegate : NSObject<AdjustDelegate>

@property (nonatomic) BOOL shouldLaunchDeferredDeeplink;
@property (nonatomic, weak) FlutterMethodChannel *channel;

+ (id)getInstanceWithSwizzleOfAttributionCallback:(NSString *)swizzleAttributionCallback
                           sessionSuccessCallback:(NSString *)swizzleSessionSuccessCallback
                           sessionFailureCallback:(NSString *)swizzleSessionFailureCallback
                             eventSuccessCallback:(NSString *)swizzleEventSuccessCallback
                             eventFailureCallback:(NSString *)swizzleEventFailureCallback
                         deferredDeeplinkCallback:(NSString *)swizzleDeferredDeeplinkCallback
                              skanUpdatedCallback:(NSString *)swizzleSkanUpdatedCallback
                     shouldLaunchDeferredDeeplink:(BOOL)shouldLaunchDeferredDeeplink
                                    methodChannel:(FlutterMethodChannel *)channel;

+ (void)teardown;

@end
