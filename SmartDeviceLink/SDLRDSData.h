//
//  SDLRDSData.h
//

#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Include the data defined in Radio Data System, which is a communications protocol standard for embedding small amounts of digital information in conventional FM radio broadcasts.
 */
@interface SDLRDSData : SDLRPCStruct

- (instancetype)initWithProgramService:(nullable NSString *)programService radioText:(nullable NSString *)radioText clockText:(nullable NSString *)clockText programIdentification:(nullable NSString *)programIdentification programType:(nullable NSNumber<SDLInt> *)programType trafficProgramIdentification:(nullable NSNumber<SDLBool> *)trafficProgramIdentification trafficAnnouncementIdentification:(nullable NSNumber<SDLBool> *)trafficAnnouncementIdentification region:(nullable NSString *)region;

/**
 * Program Service Name
 *
 * optional, 0-8
 */
@property (nullable, strong, nonatomic) NSString *programService;

/**
 * Radio Text
 *
 * optional, 0-64
 */
@property (nullable, strong, nonatomic) NSString *radioText;

/**
 * The clock text in UTC format as YYYY-MM-DDThh:mm:ss.sTZD
 *
 * optional, 0-24
 */
@property (nullable, strong, nonatomic) NSString *clockText;

/**
 *  Program Identification - the call sign for the radio station
 *
 * optional, 0-6
 */
@property (nullable, strong, nonatomic) NSString *programIdentification;

/**
 * The program type - The region should be used to differentiate between EU
 * and North America program types
 *
 * optional, 0-31
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *programType;

/**
 * Traffic Program Identification - Identifies a station that offers traffic
 *
 * optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *trafficProgramIdentification;

/**
 * Traffic Announcement Identification - Indicates an ongoing traffic announcement
 *
 * optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *trafficAnnouncementIdentification;

/**
 * Region
 *
 * optional, 0-8
 */
@property (nullable, strong, nonatomic) NSString *region;

@end

NS_ASSUME_NONNULL_END
