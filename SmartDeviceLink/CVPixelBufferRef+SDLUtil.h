//
//  CVPixelBufferRef+SDLUtil.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 3/16/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreVideo/CVPixelBuffer.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Take a CVPixelBuffer frame and append some text onto it, attempting to fit it to the rect. This is used for a "blank" screen when streaming navigation is pushed to the background or otherwise disabled in progress.

 @param pixelBuffer The pixel buffer to draw text over
 @param text The text to draw
 @return Whether or not it succeeded.
 */
Boolean CVPixelBufferAddText(CVPixelBufferRef CV_NONNULL pixelBuffer, NSString *text);

NS_ASSUME_NONNULL_END
