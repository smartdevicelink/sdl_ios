//
//  SDLCarWindow.h
//
//  Created by Muller, Alexander (A.) on 10/6/16.
//  Copyright © 2016 Ford Motor Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDLStreamingMediaConfiguration;
@class SDLStreamingMediaVideoLifecycleManager;

NS_ASSUME_NONNULL_BEGIN

/**
 SDLCarWindow is a class somewhat mimicking a `UIWindow` in that it has a `UIViewController` root, but it takes that ViewController, listens for a start to Video Streaming, and streams whatever is on that view controller to the head unit.
 */
@interface SDLCarWindow : NSObject

/**
 Initialize the CarWindow automatic streamer.

 @param streamManager The stream manager to use for retrieving head unit dimension details and forwarding video frame data
 @param configuration The streaming media configuration
 @return An instance of this class
 */
- (instancetype)initWithStreamManager:(SDLStreamingMediaVideoLifecycleManager *)streamManager configuration:(SDLStreamingMediaConfiguration *)configuration;

/**
 *  View Controller that will be streamed.
 */
@property (strong, nonatomic, nullable) UIViewController *rootViewController;

- (void)syncFrame;

@end

NS_ASSUME_NONNULL_END
