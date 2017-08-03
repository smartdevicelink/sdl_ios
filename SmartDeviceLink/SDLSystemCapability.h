//
//  SDLSystemCapability.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/10/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLRPCStruct.h"

@class SDLPhoneCapability;
@class SDLNavigationCapability;
@class SDLSystemCapabilityType;
@class SDLVideoStreamingCapability;

/**
 The systemCapabilityType indicates which type of data should be changed and identifies which data object exists in this struct. For example, if the SystemCapability Type is NAVIGATION then a "navigationCapability" should exist.
 * First implemented in SDL Core v4.4
 */
@interface SDLSystemCapability : SDLRPCStruct

/**
 * @abstract Constructs a newly allocated SDLSystemCapability object
 */
- (instancetype)init;

/**
 * @abstract Constructs a newly allocated SDLSystemCapability object indicated by the dictionary parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithNavigationCapability:(SDLNavigationCapability *)capability;

- (instancetype)initWithPhoneCapability:(SDLPhoneCapability *)capability;

- (instancetype)initWithVideoStreamingCapability:(SDLVideoStreamingCapability *)capability;

@property (strong, nonatomic) SDLSystemCapabilityType *systemCapabilityType;

@property (strong, nonatomic) SDLNavigationCapability *navigationCapability;

@property (strong, nonatomic) SDLPhoneCapability *phoneCapability;

@property (strong, nonatomic) SDLVideoStreamingCapability *videoStreamingCapability;

@end
