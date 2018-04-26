//  SDLGetDTCs.h
//


#import "SDLRPCRequest.h"

/**
 * This RPC allows to request diagnostic module trouble codes from a certain
 * vehicle module
 * <p>
 * Function Group: ProprietaryData
 * <p>
 * <b>HMILevel needs to be FULL, LIMITED or BACKGROUND</b>
 * <p>
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLGetDTCs : SDLRPCRequest

- (instancetype)initWithECUName:(UInt16)name;

- (instancetype)initWithECUName:(UInt16)name mask:(UInt8)mask;

/**
 * a name of the module to receive the DTC form
 * @discussion an NSNumber value representing a name of the module to receive
 *            the DTC form
 *            <p>
 *            <b>Notes: </b>Minvalue:0; Maxvalue:65535
 */
@property (strong, nonatomic) NSNumber<SDLInt> *ecuName;
/**
 *  DTC Mask Byte to be sent in diagnostic request to module. NSNumber* dtcMask Minvalue:0; Maxvalue:255
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *dtcMask;
@end

NS_ASSUME_NONNULL_END
