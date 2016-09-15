//
//  SDLRPCResponseNotification.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/25/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLRPCResponse;


NS_ASSUME_NONNULL_BEGIN

@interface SDLRPCResponseNotification : NSNotification

@property (copy, nonatomic, readonly) __kindof SDLRPCResponse *response;

- (instancetype)initWithName:(NSString *)name object:(nullable id)object rpcResponse:(__kindof SDLRPCResponse *)response;

@end

NS_ASSUME_NONNULL_END
