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
static NSString *dartAttributionCallback = nil;
static NSString *dartSessionSuccessCallback = nil;
static NSString *dartSessionFailureCallback = nil;
static NSString *dartEventSuccessCallback = nil;
static NSString *dartEventFailureCallback = nil;
static NSString *dartDeferredDeeplinkCallback = nil;
static NSString *dartSkanUpdatedCallback = nil;

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
                              skanUpdatedCallback:(NSString *)swizzleSkanUpdatedCallback
                     shouldLaunchDeferredDeeplink:(BOOL)shouldLaunchDeferredDeeplink
                                    methodChannel:(FlutterMethodChannel *)channel {
    dispatch_once(&onceToken, ^{
        defaultInstance = [[AdjustSdkDelegate alloc] init];
        
        // do the swizzling where and if needed
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
            [defaultInstance swizzleCallbackMethod:@selector(adjustDeferredDeeplinkReceived:)
                                  swizzledSelector:@selector(adjustDeferredDeeplinkReceivedWannabe:)];
            dartDeferredDeeplinkCallback = swizzleDeferredDeeplinkCallback;
        }
        if (swizzleSkanUpdatedCallback != nil) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustSkanUpdatedWithConversionData:)
                                  swizzledSelector:@selector(adjustSkanUpdatedWithConversionDataWannabe:)];
            dartSkanUpdatedCallback = swizzleSkanUpdatedCallback;
        }

        [defaultInstance setShouldLaunchDeferredDeeplink:shouldLaunchDeferredDeeplink];
        [defaultInstance setChannel:channel];
    });

    return defaultInstance;
}

+ (void)teardown {
    defaultInstance = nil;
    onceToken = 0;
    dartAttributionCallback = nil;
    dartSessionSuccessCallback = nil;
    dartSessionFailureCallback = nil;
    dartEventSuccessCallback = nil;
    dartEventFailureCallback = nil;
    dartDeferredDeeplinkCallback = nil;
    dartSkanUpdatedCallback = nil;
}

#pragma mark - Private & helper methods

- (void)adjustAttributionChangedWannabe:(ADJAttribution *)attribution {
    if (nil == attribution || nil == dartAttributionCallback) {
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
        @"costCurrency"
    };
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
    if (nil == sessionSuccessResponseData || nil == dartSessionSuccessCallback) {
        return;
    }

    id keys[] = {
        @"message",
        @"timestamp",
        @"adid",
        @"jsonResponse"
    };
    id values[] = {
        [self getValueOrEmpty:[sessionSuccessResponseData message]],
        [self getValueOrEmpty:[sessionSuccessResponseData timestamp]],
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
    if (nil == sessionFailureResponseData || nil == dartSessionFailureCallback) {
        return;
    }

    NSString *willRetryString = [sessionFailureResponseData willRetry] ? @"true" : @"false";
    id keys[] = {
        @"message",
        @"timestamp",
        @"adid",
        @"willRetry",
        @"jsonResponse"
    };
    id values[] = {
        [self getValueOrEmpty:[sessionFailureResponseData message]],
        [self getValueOrEmpty:[sessionFailureResponseData timestamp]],
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
    if (nil == eventSuccessResponseData || nil == dartEventSuccessCallback) {
        return;
    }
    
    id keys[] = {
        @"message",
        @"timestamp",
        @"adid",
        @"eventToken",
        @"callbackId",
        @"jsonResponse"
    };
    id values[] = {
        [self getValueOrEmpty:[eventSuccessResponseData message]],
        [self getValueOrEmpty:[eventSuccessResponseData timestamp]],
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
    if (nil == eventFailureResponseData || nil == dartEventFailureCallback) {
        return;
    }

    NSString *willRetryString = [eventFailureResponseData willRetry] ? @"true" : @"false";
    id keys[] = {
        @"message",
        @"timestamp",
        @"adid",
        @"eventToken",
        @"callbackId",
        @"willRetry",
        @"jsonResponse"
    };
    id values[] = {
        [self getValueOrEmpty:[eventFailureResponseData message]],
        [self getValueOrEmpty:[eventFailureResponseData timestamp]],
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

- (BOOL)adjustDeferredDeeplinkReceivedWannabe:(NSURL *)deeplink {
    if (nil == deeplink || nil == dartDeferredDeeplinkCallback) {
        return NO;
    }

    id keys[] = { @"deeplink" };
    id values[] = { [deeplink absoluteString] };
    NSUInteger count = sizeof(values) / sizeof(id);
    NSDictionary *deeplinkMap = [NSDictionary dictionaryWithObjects:values
                                                            forKeys:keys
                                                              count:count];
    [self.channel invokeMethod:dartDeferredDeeplinkCallback arguments:deeplinkMap];
    return self.shouldLaunchDeferredDeeplink;
}

- (void)adjustSkanUpdatedWithConversionDataWannabe:(NSDictionary<NSString *,NSString *> *)data {
    if (nil == data || nil == dartSkanUpdatedCallback) {
        return;
    }

    [self.channel invokeMethod:dartSkanUpdatedCallback arguments:data];
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
