//  SDLFuelCutoffStatus.h
//


#import "SDLEnum.h"

/** 
 * Reflects the status of the Restraints Control Module fuel pump cutoff.
 * The fuel pump is cut off typically after the vehicle has had a collision.
 *
 * @since SDL 2.0
 */
@interface SDLFuelCutoffStatus : SDLEnum {
}

/**
 * @abstract Convert String to SDLFuelCutoffStatus
 *
 * @param value String value to retrieve the object for
 *
 * @return SDLFuelCutoffStatus
 */
+ (SDLFuelCutoffStatus *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLFuelCutoffStatus
 *
 * @return an array that stores all possible SDLFuelCutoffStatus
 */
+ (NSArray *)values;

/** 
 * @abstract Fuel is cut off
 * @return the fuel cutoff status: *TERMINATE_FUEL*
 */
+ (SDLFuelCutoffStatus *)TERMINATE_FUEL;

/** 
 * @abstract Fuel is not cut off
 * @return the fuel cutoff status: *NORMAL_OPERATION*
 */
+ (SDLFuelCutoffStatus *)NORMAL_OPERATION;

/** 
 * @abstract Status of the fuel pump cannot be determined
 * @return the fuel cutoff status: *FAULT*
 */
+ (SDLFuelCutoffStatus *)FAULT;

@end
