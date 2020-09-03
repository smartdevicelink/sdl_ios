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

/// Contains information about a weather alert
///
/// @since RPC 5.1
@interface SDLWeatherAlert : SDLRPCStruct

/**
 *  Convenience init for all parameters
 *
 *  @param title        The title of the alert
 *  @param summary      A summary for the alert
 *  @param expires      The date the alert expires
 *  @param regions      Regions affected
 *  @param severity     Severity
 *  @param timeIssued   The date the alert was issued
 *  @return             A SDLWeatherAlert alert
 */
- (instancetype)initWithTitle:(nullable NSString *)title summary:(nullable NSString *)summary expires:(nullable SDLDateTime *)expires regions:(nullable NSArray<NSString *> *)regions severity:(nullable NSString *)severity timeIssued:(nullable SDLDateTime *)timeIssued;

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
 *  Severity of the weather alert.
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
