//
//  SDLVideoEncoderDelegate.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/1/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLVideoEncoder;

@protocol SDLVideoEncoderDelegate <NSObject>

- (void)videoEncoder:(SDLVideoEncoder *)encoder hasEncodedFrame:(NSData*)encodedVideo;

@end
