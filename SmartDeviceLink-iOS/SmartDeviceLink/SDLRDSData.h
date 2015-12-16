//
//  SDLRDSData.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLRPCStruct.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLRDSData : SDLRPCStruct

- (instancetype)init;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

/**
 *  Length 0 - 8
 */
@property (copy, nonatomic) NSString *programServiceName;

/**
 *  Length 0 - 64
 */
@property (copy, nonatomic) NSString *radioText;

/**
 *  The clock text in UTC format as YYYY-MM-DDThh:mm:ss.sTZD
 *
 *  Length 24
 */
@property (copy, nonatomic) NSString *clockText;

/**
 *  Program Identification - the call sign for the radio station
 *
 *  Length 0 - 6
 */
@property (copy, nonatomic) NSString *programIdentification;

/**
 *  The program type - The region should be used to differentiate between EU and North America program types.
 *
 *  Value 0 - 31
 */
@property (copy, nonatomic) NSNumber *programType;

/**
 *  Traffic Program Identification - Identifies a station that offers traffic
 *
 *  Boolean
 */
@property (copy, nonatomic) NSNumber *offersTrafficAnnouncements;

/**
 *  Traffic Announcement Identification - Indicates an ongoing traffic announcement
 *
 *  Boolean
 */
@property (copy, nonatomic) NSNumber *announcingTraffic;

@property (copy, nonatomic) NSString *region;

@end

NS_ASSUME_NONNULL_END
