//
//  AdjustSdkDelegate.m
//  Adjust SDK
//
//  Created by Srdjan Tubin (2beens) on 22nd November 2018.
//  Copyright © 2018-Present Adjust GmbH. All rights reserved.
//

#import <objc/runtime.h>
#import "AdjustSdkDelegate.h"

static dispatch_once_t onceToken;
static AdjustSdkDelegate *defaultInstance = nil;
static NSString *dartAttributionCallback;
static NSString *dartSessionSuccessCallback;
static NSString *dartSessionFailureCallback;
static NSString *dartEventSuccessCallback;
static NSString *dartEventFailureCallback;
static NSString *dartDeferredDeeplinkCallback;
static NSString *dartConversionValueUpdatedCallback;
static NSString *dartSkad4ConversionValueUpdatedCallback;

@implementation AdjustSdkDelegate

#pragma mark - Object lifecycle methods

- (id)init {
    self = [super init];
    if (nil == self) {
        return nil;
    }
    return self;
}

#pragma mark - Public methods

+ (id)getInstanceWithSwizzleOfAttributionCallback:(NSString *)swizzleAttributionCallback
                           sessionSuccessCallback:(NSString *)swizzleSessionSuccessCallback
                           sessionFailureCallback:(NSString *)swizzleSessionFailureCallback
                             eventSuccessCallback:(NSString *)swizzleEventSuccessCallback
                             eventFailureCallback:(NSString *)swizzleEventFailureCallback
                         deferredDeeplinkCallback:(NSString *)swizzleDeferredDeeplinkCallback
                   conversionValueUpdatedCallback:(NSString *)swizzleConversionValueUpdatedCallback
              skad4ConversionValueUpdatedCallback:(NSString *)swizzleSkad4ConversionValueUpdatedCallback
                     shouldLaunchDeferredDeeplink:(BOOL)shouldLaunchDeferredDeeplink
                                 andMethodChannel:(FlutterMethodChannel *)channel {
    
    dispatch_once(&onceToken, ^{
        defaultInstance = [[AdjustSdkDelegate alloc] init];
        
        // Do the swizzling where and if needed.
        if (swizzleAttributionCallback != nil) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustAttributionChanged:)
                                  swizzledSelector:@selector(adjustAttributionChangedWannabe:)];
            dartAttributionCallback = swizzleAttributionCallback;
        }
        if (swizzleSessionSuccessCallback != nil) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustSessionTrackingSucceeded:)
                                  swizzledSelector:@selector(adjustSessionTrackingSucceededWannabe:)];
            dartSessionSuccessCallback = swizzleSessionSuccessCallback;
        }
        if (swizzleSessionFailureCallback != nil) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustSessionTrackingFailed:)
                                  swizzledSelector:@selector(adjustSessionTrackingFailedWananbe:)];
            dartSessionFailureCallback = swizzleSessionFailureCallback;
        }
        if (swizzleEventSuccessCallback != nil) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustEventTrackingSucceeded:)
                                  swizzledSelector:@selector(adjustEventTrackingSucceededWannabe:)];
            dartEventSuccessCallback = swizzleEventSuccessCallback;
        }
        if (swizzleEventFailureCallback != nil) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustEventTrackingFailed:)
                                  swizzledSelector:@selector(adjustEventTrackingFailedWannabe:)];
            dartEventFailureCallback = swizzleEventFailureCallback;
        }
        if (swizzleDeferredDeeplinkCallback != nil) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustDeeplinkResponse:)
                                  swizzledSelector:@selector(adjustDeeplinkResponseWannabe:)];
            dartDeferredDeeplinkCallback = swizzleDeferredDeeplinkCallback;
        }
        if (swizzleConversionValueUpdatedCallback != nil) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustConversionValueUpdated:)
                                  swizzledSelector:@selector(adjustConversionValueUpdatedWannabe:)];
            dartConversionValueUpdatedCallback = swizzleConversionValueUpdatedCallback;
        }
        if (swizzleSkad4ConversionValueUpdatedCallback != nil) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustConversionValueUpdated:coarseValue:lockWindow:)
                                  swizzledSelector:@selector(adjustConversionValueUpdatedWannabe:coarseValue:lockWindow:)];
            dartSkad4ConversionValueUpdatedCallback = swizzleSkad4ConversionValueUpdatedCallback;
        }

        [defaultInstance setShouldLaunchDeferredDeeplink:shouldLaunchDeferredDeeplink];
        [defaultInstance setChannel:channel];
    });

    return defaultInstance;
}

+ (void)teardown {
    defaultInstance = nil;
    onceToken = 0;
}

#pragma mark - Private & helper methods

- (void)adjustAttributionChangedWannabe:(ADJAttribution *)attribution {
    if (attribution == nil) {
        return;
    }
    
    id keys[] = {
        @"trackerToken",
        @"trackerName",
        @"network",
        @"campaign",
        @"adgroup",
        @"creative",
        @"clickLabel",
        @"costType",
        @"costAmount",
        @"costCurrency" };
    id values[] = {
        [self getValueOrEmpty:[attribution trackerToken]],
        [self getValueOrEmpty:[attribution trackerName]],
        [self getValueOrEmpty:[attribution network]],
        [self getValueOrEmpty:[attribution campaign]],
        [self getValueOrEmpty:[attribution adgroup]],
        [self getValueOrEmpty:[attribution creative]],
        [self getValueOrEmpty:[attribution clickLabel]],
        [self getValueOrEmpty:[attribution costType]],
        [self getNumberValueOrEmpty:[attribution costAmount]],
        [self getValueOrEmpty:[attribution costCurrency]]
    };
    NSUInteger count = sizeof(values) / sizeof(id);
    NSDictionary *attributionMap = [NSDictionary dictionaryWithObjects:values
                                                                     forKeys:keys
                                                                       count:count];
    [self.channel invokeMethod:dartAttributionCallback arguments:attributionMap];
}

- (void)adjustSessionTrackingSucceededWannabe:(ADJSessionSuccess *)sessionSuccessResponseData {
    if (nil == sessionSuccessResponseData) {
        return;
    }

    id keys[] = { @"message", @"timestamp", @"adid", @"jsonResponse" };
    id values[] = {
        [self getValueOrEmpty:[sessionSuccessResponseData message]],
        [self getValueOrEmpty:[sessionSuccessResponseData timeStamp]],
        [self getValueOrEmpty:[sessionSuccessResponseData adid]],
        [self toJson:[self getObjectValueOrEmpty:[sessionSuccessResponseData jsonResponse]]]
    };
    NSUInteger count = sizeof(values) / sizeof(id);
    NSDictionary *sessionSuccessMap = [NSDictionary dictionaryWithObjects:values
                                                                  forKeys:keys
                                                                    count:count];
    [self.channel invokeMethod:dartSessionSuccessCallback arguments:sessionSuccessMap];
}

- (void)adjustSessionTrackingFailedWananbe:(ADJSessionFailure *)sessionFailureResponseData {
    if (nil == sessionFailureResponseData) {
        return;
    }

    NSString *willRetryString = [sessionFailureResponseData willRetry] ? @"true" : @"false";
    id keys[] = { @"message", @"timestamp", @"adid", @"willRetry", @"jsonResponse" };
    id values[] = {
        [self getValueOrEmpty:[sessionFailureResponseData message]],
        [self getValueOrEmpty:[sessionFailureResponseData timeStamp]],
        [self getValueOrEmpty:[sessionFailureResponseData adid]],
        willRetryString,
        [self toJson:[self getObjectValueOrEmpty:[sessionFailureResponseData jsonResponse]]]
    };
    NSUInteger count = sizeof(values) / sizeof(id);
    NSDictionary *sessionFailureMap = [NSDictionary dictionaryWithObjects:values
                                                                  forKeys:keys
                                                                    count:count];
    [self.channel invokeMethod:dartSessionFailureCallback arguments:sessionFailureMap];
}

- (void)adjustEventTrackingSucceededWannabe:(ADJEventSuccess *)eventSuccessResponseData {
    if (nil == eventSuccessResponseData) {
        return;
    }
    
    id keys[] = { @"message", @"timestamp", @"adid", @"eventToken", @"callbackId", @"jsonResponse" };
    id values[] = {
        [self getValueOrEmpty:[eventSuccessResponseData message]],
        [self getValueOrEmpty:[eventSuccessResponseData timeStamp]],
        [self getValueOrEmpty:[eventSuccessResponseData adid]],
        [self getValueOrEmpty:[eventSuccessResponseData eventToken]],
        [self getValueOrEmpty:[eventSuccessResponseData callbackId]],
        [self toJson:[self getObjectValueOrEmpty:[eventSuccessResponseData jsonResponse]]]
    };
    NSUInteger count = sizeof(values) / sizeof(id);
    NSDictionary *eventSuccessMap = [NSDictionary dictionaryWithObjects:values
                                                                forKeys:keys
                                                                  count:count];
    [self.channel invokeMethod:dartEventSuccessCallback arguments:eventSuccessMap];
}

- (void)adjustEventTrackingFailedWannabe:(ADJEventFailure *)eventFailureResponseData {
    if (nil == eventFailureResponseData) {
        return;
    }

    NSString *willRetryString = [eventFailureResponseData willRetry] ? @"true" : @"false";
    id keys[] = { @"message", @"timestamp", @"adid", @"eventToken", @"callbackId", @"willRetry", @"jsonResponse" };
    id values[] = {
        [self getValueOrEmpty:[eventFailureResponseData message]],
        [self getValueOrEmpty:[eventFailureResponseData timeStamp]],
        [self getValueOrEmpty:[eventFailureResponseData adid]],
        [self getValueOrEmpty:[eventFailureResponseData eventToken]],
        [self getValueOrEmpty:[eventFailureResponseData callbackId]],
        willRetryString,
        [self toJson:[self getObjectValueOrEmpty:[eventFailureResponseData jsonResponse]]]
    };
    NSUInteger count = sizeof(values) / sizeof(id);
    NSDictionary *eventFailureMap = [NSDictionary dictionaryWithObjects:values
                                                                forKeys:keys
                                                                  count:count];
    [self.channel invokeMethod:dartEventFailureCallback arguments:eventFailureMap];
}

- (BOOL)adjustDeeplinkResponseWannabe:(NSURL *)deeplink {
    id keys[] = { @"uri" };
    id values[] = { [deeplink absoluteString] };
    NSUInteger count = sizeof(values) / sizeof(id);
    NSDictionary *deeplinkMap = [NSDictionary dictionaryWithObjects:values
                                                            forKeys:keys
                                                              count:count];
    [self.channel invokeMethod:dartDeferredDeeplinkCallback arguments:deeplinkMap];
    return self.shouldLaunchDeferredDeeplink;
}

- (void)adjustConversionValueUpdatedWannabe:(NSNumber *)conversionValue {
    id keys[] = { @"conversionValue" };
    id values[] = { [conversionValue stringValue] };
    NSUInteger count = sizeof(values) / sizeof(id);
    NSDictionary *conversionValueMap = [NSDictionary dictionaryWithObjects:values
                                                                   forKeys:keys
                                                                     count:count];
    [self.channel invokeMethod:dartConversionValueUpdatedCallback arguments:conversionValueMap];
}

- (void)adjustConversionValueUpdatedWannabe:(nullable NSNumber *)fineValue
                                coarseValue:(nullable NSString *)coarseValue
                                 lockWindow:(nullable NSNumber *)lockWindow {
    NSMutableDictionary *conversionValueMap = [NSMutableDictionary dictionary];
    if (![fineValue isKindOfClass:[NSNull class]] && fineValue != nil) {
        [conversionValueMap setValue:[fineValue stringValue] forKey:@"fineValue"];
    }
    if (![coarseValue isKindOfClass:[NSNull class]] && coarseValue != nil) {
        [conversionValueMap setValue:coarseValue forKey:@"coarseValue"];
    }
    if (![lockWindow isKindOfClass:[NSNull class]] && lockWindow != nil) {
        [conversionValueMap setValue:[lockWindow stringValue] forKey:@"lockWindow"];
    }
    [self.channel invokeMethod:dartSkad4ConversionValueUpdatedCallback arguments:conversionValueMap];
}

- (void)swizzleCallbackMethod:(SEL)originalSelector
             swizzledSelector:(SEL)swizzledSelector {
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)addValueOrEmpty:(NSObject *)value
                withKey:(NSString *)key
           toDictionary:(NSMutableDictionary *)dictionary {
    if (nil != value) {
        [dictionary setObject:[NSString stringWithFormat:@"%@", value] forKey:key];
    } else {
        [dictionary setObject:@"" forKey:key];
    }
}

- (NSString *)toJson:(id)object {
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&writeError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSString *)getValueOrEmpty:(NSString *)value {
    if (value == nil || value == NULL) {
        return @"";
    }
    return value;
}

- (id)getNumberValueOrEmpty:(NSNumber *)value {
    if (value == nil || value == NULL) {
        return @"";
    }
    return [value stringValue];
}

- (id)getObjectValueOrEmpty:(id)value {
    if (value == nil || value == NULL) {
        return [NSDictionary dictionary];
    }
    return value;
}

@end
