//
//  SDLControlFramePayloadStartServiceAck.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/20/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLControlFramePayloadType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLControlFramePayloadRPCStartServiceAck : NSObject <SDLControlFramePayloadType>

/// Hash ID to identify this service and used when sending an EndService control frame
@property (assign, nonatomic, readonly) int32_t hashId;

/// Max transport unit to be used for this service
@property (assign, nonatomic, readonly) int64_t mtu;

/// A token used to authenticate a websocket connection on app activation.
@property (copy, nonatomic, readonly, nullable) NSString *authToken;

/// The negotiated version of the protocol. Must be in the format "Major.Minor.Patch"
@property (copy, nonatomic, readonly, nullable) NSString *protocolVersion;

/** The transport types for Secondary Transport */
@property (copy, nonatomic, readonly, nullable) NSArray<NSString *> *secondaryTransports;

/** List of transports that are allowed to carry audio service. The values can be either 1 (primary transport) or 2 (secondary transport) and are listed in preferred order. */
@property (copy, nonatomic, readonly, nullable) NSArray<NSNumber *> *audioServiceTransports;

/** List of transports that are allowed to carry video service. The values can be either 1 (primary transport) or 2 (secondary transport) and are listed in preferred order. */
@property (copy, nonatomic, readonly, nullable) NSArray<NSNumber *> *videoServiceTransports;

/// The connected vehicle make, e.g. "Ford", "Toyota", or "Subaru"
///
/// Added in Protocol Spec 5.4
@property (copy, nonatomic, readonly, nullable) NSString *make;

/// The connected vehicle model, e.g. "Bronco", "Tundra", "Outback"
///
/// Added in Protocol Spec 5.4
@property (copy, nonatomic, readonly, nullable) NSString *model;

/// The connected vehicle trim, e.g. "ST"
///
/// Added in Protocol Spec 5.4
@property (copy, nonatomic, readonly, nullable) NSString *trim;

/// The connected vehicle model year, e.g. "2021"
///
/// Added in Protocol Spec 5.4
@property (copy, nonatomic, readonly, nullable) NSString *modelYear;

/// The connected vehicle module software version
///
/// Added in Protocol Spec 5.4
@property (copy, nonatomic, readonly, nullable) NSString *systemSoftwareVersion;

/// The connected vehicle module hardware version
///
/// Added in Protocol Spec 5.4
@property (copy, nonatomic, readonly, nullable) NSString *systemHardwareVersion;

/// Initialize a StartServiceACK Control Frame Payload
/// @param hashId A hash identifying the connection
/// @param mtu The size of a packet that can be sent over this connection without dividing it into separate packets
/// @param authToken A cloud app authorization token
/// @param protocolVersion The version of the protocol this connection runs over
/// @param secondaryTransports Array of available secondary transports
/// @param audioServiceTransports Array of transports the audio service may travel on
/// @param videoServiceTransports Array of transports the video service may travel on
/// @param make The connected vehicle make, e.g. "Ford", "Toyota", or "Subaru"
/// @param model The connected vehicle model, e.g. "Bronco", "Tundra", "Outback"
/// @param trim The connected vehicle trim, e.g. "ST"
/// @param modelYear The connected vehicle model year, e.g. "2021"
/// @param systemSoftwareVersion The connected vehicle module software version
/// @param systemHardwareVersion The connected vehicle module hardware version
- (instancetype)initWithHashId:(int32_t)hashId mtu:(int64_t)mtu authToken:(nullable NSString *)authToken protocolVersion:(nullable NSString *)protocolVersion secondaryTransports:(nullable NSArray<NSString *> *)secondaryTransports audioServiceTransports:(nullable NSArray<NSNumber *> *)audioServiceTransports videoServiceTransports:(nullable NSArray<NSNumber *> *)videoServiceTransports make:(nullable NSString *)make model:(nullable NSString *)model trim:(nullable NSString *)trim modelYear:(nullable NSString *)modelYear systemSoftwareVersion:(nullable NSString *)systemSoftwareVersion systemHardwareVersion:(nullable NSString *)systemHardwareVersion;

@end

NS_ASSUME_NONNULL_END
