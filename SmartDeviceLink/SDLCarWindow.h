//
//  SDLCarWindow.h
//
//  Created by Muller, Alexander (A.) on 10/6/16.
//  Copyright © 2016 Ford Motor Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDLStreamingMediaLifecycleManager;

NS_ASSUME_NONNULL_BEGIN

/**
 SDLCarWindow is a class somewhat mimicking a `UIWindow` in that it has a `UIViewController` root, but it takes that ViewController, listens for a start to Video Streaming, and streams whatever is on that view controller to the head unit.
 */
@interface SDLCarWindow : NSObject

/**
 Initialize the CarWindow automatic streamer.

 @param streamManager The stream manager to use for retrieving head unit dimension details and forwarding video frame data
 @param framesPerSecond The number of frames per second CarWindow should attempt to generate
 @return An instance of this class
 */
- (instancetype)initWithStreamManager:(SDLStreamingMediaLifecycleManager *)streamManager targetFramerate:(NSUInteger)framesPerSecond;

/**
 *  View Controller that will be streamed.
 */
@property (strong, nonatomic, nullable) UIViewController *rootViewController;

@end

NS_ASSUME_NONNULL_END
