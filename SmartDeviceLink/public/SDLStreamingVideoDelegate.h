//
//  SDLStreamingVideoDelegate.h
//  SmartDeviceLink
//
//  Created on 6/11/20.
//

#import <CoreGraphics/CGGeometry.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SDLStreamingVideoDelegate <NSObject>

- (void)videoStreamingSizeDidUpdate:(CGSize)displaySize;

@end

NS_ASSUME_NONNULL_END
