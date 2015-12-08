//
//  SDLInteriorZone.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Describes the origin and span of a zone in the vehicle. Vehicle zones can be overlapping.
 */
@interface SDLInteriorZone : SDLRPCStruct

/**
 *  Integer, 0 - 100
 */
@property (copy, nonatomic) NSNumber *column;

/**
 *  Integer, 0 - 100
 */
@property (copy, nonatomic) NSNumber *row;

/**
 *  Integer, 0 - 100
 */
@property (copy, nonatomic) NSNumber *level;

/**
 *  Integer, 0 - 100
 */
@property (copy, nonatomic) NSNumber *columnSpan;

/**
 *  Integer, 0 - 100
 */
@property (copy, nonatomic) NSNumber *rowSpan;

/**
 *  Integer, 0 - 100
 */
@property (copy, nonatomic) NSNumber *levelSpan;

@end

NS_ASSUME_NONNULL_END
