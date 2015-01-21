//  SDLFuelCutoffStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>
/** Reflects the status of the Restraints Control Module fuel pump cutoff.<br> The fuel pump is cut off typically after the vehicle has had a collision.
 * <p>
 *
 * @Since AppLink 2.0
 *
 */
@interface SDLFuelCutoffStatus : SDLEnum {}

+(SDLFuelCutoffStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

/** Fuel is cut off
 */

+(SDLFuelCutoffStatus*) TERMINATE_FUEL;

/** Fuel is not cut off
 *
 */
+(SDLFuelCutoffStatus*) NORMAL_OPERATION;

/** Status of the fuel pump cannot be determined
 *
 */

+(SDLFuelCutoffStatus*) FAULT;

@end
