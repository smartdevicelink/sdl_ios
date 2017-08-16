//
//  SDLRdsData.h
//

#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLRdsData : SDLRPCStruct

- (instancetype)initWithProgramService:(nullable NSString *)PS;

- (instancetype)initWithRadioText:(nullable NSString *)RT;

- (instancetype)initWithClockText:(nullable NSString *)CT;

- (instancetype)initWithProgramIdentification:(nullable NSString *)PI;

- (instancetype)initWithProgramType:(nullable NSNumber<SDLInt> *)PTY;

- (instancetype)initWithTrafficProgramIdentification:(nullable NSNumber<SDLBool> *)TP;

- (instancetype)initWithTrafficAnnouncementIdentification:(nullable NSNumber<SDLBool> *)TA;

- (instancetype)initWithRegion:(nullable NSString *)REG;

/**
 * @abstract Program Service Name
 *
 * optional, 0-8 length
 */
@property (nullable, strong, nonatomic) NSString *PS;

/**
 * @abstract Radio Text
 *
 * optional, 0-64 length
 */
@property (nullable, strong, nonatomic) NSString *RT;

/**
 * @abstract The clock text in UTC format as YYYY-MM-DDThh:mm:ss.sTZD
 *
 * optional, 24 length
 */
@property (nullable, strong, nonatomic) NSString *CT;

/**
 * @abstract  Program Identification - the call sign for the radio station
 *
 * optional, 0-6 length
 */
@property (nullable, strong, nonatomic) NSString *PI;

/**
 * @abstract The program type - The region should be used to differentiate between EU
 * and North America program types
 *
 * optional, 0-31 length
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *PTY;

/**
 * @abstract Traffic Program Identification - Identifies a station that offers traffic
 *
 * optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *TP;

/**
 * @abstract Traffic Announcement Identification - Indicates an ongoing traffic announcement
 *
 * optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *TA;

/**
 * @abstract Region
 *
 * optional, 0-8 length
 */
@property (nullable, strong, nonatomic) NSString *REG;

@end

NS_ASSUME_NONNULL_END
