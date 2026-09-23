//
//  AdjustSdkGoogleOdm.m
//  Adjust SDK
//
//  Copyright © 2026-Present Adjust GmbH. All rights reserved.
//

#import "./include/adjust_sdk_google_odm/AdjustSdkGoogleOdm.h"

@implementation AdjustSdkGoogleOdm

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    // no Dart API, this plugin only links the native Google ODM plugin
    // which the Adjust SDK looks up at runtime (ADJOdmPlugin)
}

@end
