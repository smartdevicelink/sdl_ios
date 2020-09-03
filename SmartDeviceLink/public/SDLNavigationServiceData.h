//
//  SDLNavigationServiceData.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/22/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCMessage.h"

@class SDLDateTime;
@class SDLLocationDetails;
@class SDLNavigationInstruction;

NS_ASSUME_NONNULL_BEGIN

/**
 *  This data is related to what a navigation service would provide.
 */
@interface SDLNavigationServiceData : SDLRPCStruct

/**
 *  Convenience init for required parameters.
 *
 *  @param timestamp    Timestamp of when the data was generated
 *  @return             A SDLNavigationServiceData object
 */
- (instancetype)initWithTimestamp:(SDLDateTime *)timestamp NS_DESIGNATED_INITIALIZER;

/**
 *  Convenience init for all parameters.
 *
 *  @param timestamp 	                Timestamp of when the data was generated
 *  @param origin                       The start location
 *  @param destination                  The final destination location
 *  @param destinationETA               The estimated time of arrival at the final destination location
 *  @param instructions                 Array ordered with all remaining instructions
 *  @param nextInstructionETA           The estimated time of arrival at the next destination
 *  @param nextInstructionDistance      The distance to this instruction from current location
 *  @param nextInstructionDistanceScale Distance till next maneuver (starting from) from previous maneuver
 *  @param prompt                       This is a prompt message that should be conveyed to the user through either display or voice (TTS)
 *  @return                             A SDLNavigationServiceData object
 */
- (instancetype)initWithTimestamp:(SDLDateTime *)timestamp origin:(nullable SDLLocationDetails *)origin destination:(nullable SDLLocationDetails *)destination destinationETA:(nullable SDLDateTime *)destinationETA instructions:(nullable NSArray<SDLNavigationInstruction *> *)instructions nextInstructionETA:(nullable SDLDateTime *)nextInstructionETA nextInstructionDistance:(float)nextInstructionDistance nextInstructionDistanceScale:(float)nextInstructionDistanceScale prompt:(nullable NSString *)prompt;

/**
 *  This is the timestamp of when the data was generated. This is to ensure any time or distance given in the data can accurately be adjusted if necessary.
 *
 *  SDLDateTime, Required
 */
@property (strong, nonatomic) SDLDateTime *timestamp;

/**
 *  The start location.
 *
 *  SDLLocationDetails, Optional
 */
@property (nullable, strong, nonatomic) SDLLocationDetails *origin;

/**
 *  The final destination location.
 *
 *  SDLLocationDetails, Optional
 */
@property (nullable, strong, nonatomic) SDLLocationDetails *destination;

/**
 *  The estimated time of arrival at the final destination location.
 *
 *  SDLDateTime, Optional
 */
@property (nullable, strong, nonatomic) SDLDateTime *destinationETA;

/**
 *  This array should be ordered with all remaining instructions. The start of this array should always contain the next instruction.
 *
 *  Array of SDLNavigationInstruction, Optional
 */
@property (nullable, strong, nonatomic) NSArray<SDLNavigationInstruction *> *instructions;

/**
 *  The estimated time of arrival at the next destination.
 *
 *  SDLDateTime, Optional
 */
@property (nullable, strong, nonatomic) SDLDateTime *nextInstructionETA;

/**
 *  The distance to this instruction from current location. This should only be updated ever .1 unit of distance. For more accuracy the consumer can use the GPS location of itself and the next instruction.
 *
 *  Float, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *nextInstructionDistance;

/**
 *  Distance till next maneuver (starting from) from previous maneuver.
 *
 *  Float, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *nextInstructionDistanceScale;

/**
 *  This is a prompt message that should be conveyed to the user through either display or voice (TTS). This param will change often as it should represent the following: approaching instruction, post instruction, alerts that affect the current navigation session, etc.
 *
 *  String, Optional
 */
@property (nullable, strong, nonatomic) NSString *prompt;

@end

NS_ASSUME_NONNULL_END
