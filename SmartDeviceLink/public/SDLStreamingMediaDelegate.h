//
//  SDLStreamingMediaDelegate.h
//  SmartDeviceLink
//
//  Created on 6/11/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SDLStreamingMediaDelegate <NSObject>

- (void)videoManager:(id)manager didUpdateSize:(CGSize)displaySize;

- (void)videoManagerDidStop:(id)manager;

@end

NS_ASSUME_NONNULL_END
