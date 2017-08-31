//
//  SDLPhoneCapability.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/11/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLRPCStruct.h"

@interface SDLPhoneCapability : SDLRPCStruct

/**
 * @abstract Constructs a newly allocated SDLPhoneCapability struct
 */
- (instancetype)init;

/**
 * @abstract Constructs a newly allocated SDLPhoneCapability struct indicated by the dictionary parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithDialNumber:(BOOL)dialNumberEnabled;

/**
 Whether or not the DialNumber RPC is enabled.
 Boolean, optional
 */
@property (strong, nonatomic) NSNumber *dialNumberEnabled;

@end
