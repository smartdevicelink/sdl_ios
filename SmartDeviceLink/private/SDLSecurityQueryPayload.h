//
//  SDLSecurityQueryPayload.h
//  SmartDeviceLink
//
//  Created by Frank Elias on 7/28/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLRPCMessageType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLSecurityQueryPayload : NSObject

@property (assign, nonatomic) SDLRPCMessageType rpcType;
@property (assign, nonatomic) UInt32 functionID;
@property (assign, nonatomic) UInt32 correlationID;
@property (nullable, strong, nonatomic) NSData *jsonData;
@property (nullable, strong, nonatomic) NSData *binaryData;

- (NSData *)data;
+ (nullable id)rpcPayloadWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
