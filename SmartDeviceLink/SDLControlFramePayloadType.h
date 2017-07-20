//
//  SDLControlFramePayload.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/20/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SDLControlFramePayloadType <NSObject>

- (NSData *)data;
- (instancetype)initWithData:(NSData *)data;;

@end

NS_ASSUME_NONNULL_END
