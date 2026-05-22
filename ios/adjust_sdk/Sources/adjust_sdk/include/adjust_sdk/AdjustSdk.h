//
//  AdjustSdk.h
//  Adjust SDK
//
//  Created by Srdjan Tubin (@2beens) on 6th June 2018.
//  Copyright © 2018-Present Adjust GmbH. All rights reserved.
//

#import <Flutter/Flutter.h>
#if __has_include(<Flutter/FlutterSceneLifeCycle.h>)
#import <Flutter/FlutterSceneLifeCycle.h>
#define ADJUST_FLUTTER_HAS_SCENE_LIFECYCLE 1
#endif

@interface AdjustSdk : NSObject<FlutterPlugin, FlutterApplicationLifeCycleDelegate
#if ADJUST_FLUTTER_HAS_SCENE_LIFECYCLE
, FlutterSceneLifeCycleDelegate
#endif
>
@end
