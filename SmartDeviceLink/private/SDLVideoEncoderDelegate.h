//
//  SDLVideoEncoderDelegate.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/1/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLH264VideoEncoder;

@protocol SDLVideoEncoderDelegate <NSObject>

- (void)videoEncoder:(SDLH264VideoEncoder *)encoder hasEncodedFrame:(NSData*)encodedVideo;

@end
