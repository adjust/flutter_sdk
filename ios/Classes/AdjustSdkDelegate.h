//
//  AdjustSdkDelegate.h
//  Adjust SDK
//
//  Created by Srdjan Tubin (2beens) on 22nd November 2018.
//  Copyright © 2018-Present Adjust GmbH. All rights reserved.
//

#import <Flutter/Flutter.h>
#import <AdjustSdk/Adjust.h>

@interface AdjustSdkDelegate : NSObject<AdjustDelegate>

@property (nonatomic) BOOL shouldLaunchDeferredDeeplink;
@property (nonatomic, weak) FlutterMethodChannel *channel;

+ (id)getInstanceWithSwizzleOfAttributionCallback:(NSString *)swizzleAttributionCallback
                           sessionSuccessCallback:(NSString *)swizzleSessionSuccessCallback
                           sessionFailureCallback:(NSString *)swizzleSessionFailureCallback
                             eventSuccessCallback:(NSString *)swizzleEventSuccessCallback
                             eventFailureCallback:(NSString *)swizzleEventFailureCallback
                         deferredDeeplinkCallback:(NSString *)swizzleDeferredDeeplinkCallback
                   conversionValueUpdatedCallback:(NSString *)swizzleConversionValueUpdatedCallback
              skad4ConversionValueUpdatedCallback:(NSString *)swizzleSkad4ConversionValueUpdatedCallback
                     shouldLaunchDeferredDeeplink:(BOOL)shouldLaunchDeferredDeeplink
                                 andMethodChannel:(FlutterMethodChannel *)channel;

+ (void)teardown;

@end
