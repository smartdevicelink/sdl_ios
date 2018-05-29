//  SDLReadDID.h
//


#import "SDLRPCRequest.h"

/**
 * Non periodic vehicle data read request. This is an RPC to get diagnostics
 * data from certain vehicle modules. DIDs of a certain module might differ from
 * vehicle type to vehicle type
 * <p>
 * Function Group: ProprietaryData
 * <p>
 * <b>HMILevel needs to be FULL, LIMITED or BACKGROUND</b>
 * <p>
 *
 * Since SmartDeviceLink 2.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLReadDID : SDLRPCRequest

- (instancetype)initWithECUName:(UInt16)ecuNumber didLocation:(NSArray<NSNumber<SDLUInt> *> *)didLocation;

/**
 * An ID of the vehicle module
 *            <br/><b>Notes: </b>Minvalue:0; Maxvalue:65535
 */
@property (strong, nonatomic) NSNumber<SDLInt> *ecuName;

/**
 * Raw data from vehicle data DID location(s)
 *            <br/>a Vector<Integer> value representing raw data from vehicle
 *            data DID location(s)
 *            <p>
 *            <b>Notes: </b>
 *            <ul>
 *            <li>Minvalue:0; Maxvalue:65535</li>
 *            <li>ArrayMin:0; ArrayMax:1000</li>
 *            </ul>
 */
@property (strong, nonatomic) NSArray<NSNumber<SDLInt> *> *didLocation;

@end

NS_ASSUME_NONNULL_END
