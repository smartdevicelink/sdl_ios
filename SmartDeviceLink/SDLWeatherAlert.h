//
//  SDLWeatherAlert.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/6/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"
#import "SDLDateTime.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLWeatherAlert : SDLRPCStruct

/**
 *  The title of the alert.
 *
 *  String, Optional
 */
@property (nullable, strong, nonatomic) NSString *title;

/**
 *  A summary for the alert.
 *
 *  String, Optional
 */
@property (nullable, strong, nonatomic) NSString *summary;

/**
 *  The date the alert expires.
 *
 *  SDLDateTime, Optional
 */
@property (nullable, strong, nonatomic) SDLDateTime *expires;

/**
 *  Regions affected.
 *
 *  Array of Strings, Optional, minsize="1" maxsize="99"

 */
@property (nullable, strong, nonatomic) NSArray<NSString *> *regions;

/**
 *  Severity.
 *
 *  String, Optional
 */
@property (nullable, strong, nonatomic) NSString *severity;

/**
 *  The date the alert was issued.
 *
 *  SDLDateTime, Optional
 */
@property (nullable, strong, nonatomic) SDLDateTime *timeIssued;

@end

NS_ASSUME_NONNULL_END
