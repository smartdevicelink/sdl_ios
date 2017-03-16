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

Boolean CVPixelBufferAddText(CVPixelBufferRef CV_NONNULL pixelBuffer, NSString *text);

NS_ASSUME_NONNULL_END
