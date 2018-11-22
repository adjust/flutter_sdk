//
//  AdjustSdkDelegate.h
//  Adjust SDK
//
//  Created by Srdjan Tubin (srdjan@adjust.com) on 22nd November 2018.
//  Copyright © 2012-2018 Adjust GmbH. All rights reserved.
//

#import <objc/runtime.h>
#import "AdjustSdkDelegate.h"

static dispatch_once_t onceToken;
static AdjustSdkDelegate *defaultInstance = nil;

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

+ (id)getInstanceWithSwizzleOfAttributionCallback:(BOOL)swizzleAttributionCallback
                           eventSucceededCallback:(BOOL)swizzleEventSucceededCallback
                              eventFailedCallback:(BOOL)swizzleEventFailedCallback
                         sessionSucceededCallback:(BOOL)swizzleSessionSucceededCallback
                            sessionFailedCallback:(BOOL)swizzleSessionFailedCallback
                         deferredDeeplinkCallback:(BOOL)swizzleDeferredDeeplinkCallback
                     shouldLaunchDeferredDeeplink:(BOOL)shouldLaunchDeferredDeeplink
                                withMethodChannel:(FlutterMethodChannel*)channel {
    
    dispatch_once(&onceToken, ^{
        defaultInstance = [[AdjustSdkDelegate alloc] init];
        
        // Do the swizzling where and if needed.
        if (swizzleAttributionCallback) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustAttributionChanged:)
                                  swizzledSelector:@selector(adjustAttributionChangedWannabe:)];
        }
        
        if (swizzleEventSucceededCallback) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustEventTrackingSucceeded:)
                                  swizzledSelector:@selector(adjustEventTrackingSucceededWannabe:)];
        }
        
        if (swizzleEventFailedCallback) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustEventTrackingFailed:)
                                  swizzledSelector:@selector(adjustEventTrackingFailedWannabe:)];
        }
        
        if (swizzleSessionSucceededCallback) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustSessionTrackingSucceeded:)
                                  swizzledSelector:@selector(adjustSessionTrackingSucceededWannabe:)];
        }
        
        if (swizzleSessionFailedCallback) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustSessionTrackingFailed:)
                                  swizzledSelector:@selector(adjustSessionTrackingFailedWananbe:)];
        }
        
        if (swizzleDeferredDeeplinkCallback) {
            [defaultInstance swizzleCallbackMethod:@selector(adjustDeeplinkResponse:)
                                  swizzledSelector:@selector(adjustDeeplinkResponseWannabe:)];
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
    
    id keys[] = { @"trackerToken", @"trackerName", @"network", @"campaign", @"adgroup", @"creative", @"clickLabel", @"adid" };
    id values[] = {
        [self getValueOrEmpty:[attribution trackerToken]],
        [self getValueOrEmpty:[attribution trackerName]],
        [self getValueOrEmpty:[attribution network]],
        [self getValueOrEmpty:[attribution campaign]],
        [self getValueOrEmpty:[attribution adgroup]],
        [self getValueOrEmpty:[attribution creative]],
        [self getValueOrEmpty:[attribution clickLabel]],
        [self getValueOrEmpty:[attribution adid]]
    };
    NSUInteger count = sizeof(values) / sizeof(id);
    NSDictionary *adjustAttributionMap = [NSDictionary dictionaryWithObjects:values
                                                                     forKeys:keys
                                                                       count:count];
    
    [self.channel invokeMethod:@"attribution-change" arguments:adjustAttributionMap];
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
        [self toJson:[eventSuccessResponseData jsonResponse]]
    };
    NSUInteger count = sizeof(values) / sizeof(id);
    NSDictionary *adjustSessionSuccessMap = [NSDictionary dictionaryWithObjects:values
                                                                        forKeys:keys
                                                                          count:count];
    
    [self.channel invokeMethod:@"event-success" arguments:adjustSessionSuccessMap];
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
        [self toJson:[eventFailureResponseData jsonResponse]]
    };
    NSUInteger count = sizeof(values) / sizeof(id);
    NSDictionary *adjustSessionSuccessMap = [NSDictionary dictionaryWithObjects:values
                                                                        forKeys:keys
                                                                          count:count];
    
    [self.channel invokeMethod:@"event-fail" arguments:adjustSessionSuccessMap];
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
        [self toJson:[sessionSuccessResponseData jsonResponse]]
    };
    NSUInteger count = sizeof(values) / sizeof(id);
    NSDictionary *adjustSessionSuccessMap = [NSDictionary dictionaryWithObjects:values
                                                                        forKeys:keys
                                                                          count:count];
    
    [self.channel invokeMethod:@"session-success" arguments:adjustSessionSuccessMap];
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
        [self toJson:[sessionFailureResponseData jsonResponse]]
    };
    NSUInteger count = sizeof(values) / sizeof(id);
    NSDictionary *adjustFailureSuccessMap = [NSDictionary dictionaryWithObjects:values
                                                                        forKeys:keys
                                                                          count:count];
    
    [self.channel invokeMethod:@"session-fail" arguments:adjustFailureSuccessMap];
}

- (BOOL)adjustDeeplinkResponseWannabe:(NSURL *)deeplink {
    id keys[] = { @"uri" };
    id values[] = { [deeplink absoluteString] };
    NSUInteger count = sizeof(values) / sizeof(id);
    NSDictionary *deeplinkUriParamsMap = [NSDictionary dictionaryWithObjects:values
                                                                     forKeys:keys
                                                                       count:count];
    
    [self.channel invokeMethod:@"receive-deferred-deeplink" arguments:deeplinkUriParamsMap];
    
    return self.shouldLaunchDeferredDeeplink;
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

-(NSString*)toJson:(id)object
{
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&writeError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSString*)getValueOrEmpty:(NSString *)value {
    if (value == nil) {
        return @"";
    }
    return value;
}

@end
