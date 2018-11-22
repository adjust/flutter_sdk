//
//  AdjustSdkDelegate.h
//  Adjust SDK
//
//  Created by Srdjan Tubin (srdjan@adjust.com) on 22nd November 2018.
//  Copyright © 2012-2018 Adjust GmbH. All rights reserved.
//

#import <Flutter/Flutter.h>
#import <Adjust/Adjust.h>

@interface AdjustSdkDelegate : NSObject<AdjustDelegate>

@property (nonatomic) BOOL shouldLaunchDeferredDeeplink;
@property (nonatomic, weak) FlutterMethodChannel* channel;

+ (id)getInstanceWithSwizzleOfAttributionCallback:(BOOL)swizzleAttributionCallback
                           eventSucceededCallback:(BOOL)swizzleEventSucceededCallback
                              eventFailedCallback:(BOOL)swizzleEventFailedCallback
                         sessionSucceededCallback:(BOOL)swizzleSessionSucceededCallback
                            sessionFailedCallback:(BOOL)swizzleSessionFailedCallback
                         deferredDeeplinkCallback:(BOOL)swizzleDeferredDeeplinkCallback
                     shouldLaunchDeferredDeeplink:(BOOL)shouldLaunchDeferredDeeplink
                                withMethodChannel:(FlutterMethodChannel*)channel;

+ (void)teardown;

@end
