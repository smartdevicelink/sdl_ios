//
//  SDLSystemCapabilityManager.m
//  SmartDeviceLink
//
//  Created by Nicole on 3/26/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLSystemCapabilityManager.h"

#import "SDLAppServiceCapability.h"
#import "SDLAppServiceRecord.h"
#import "SDLAppServicesCapabilities.h"
#import "SDLConnectionManagerType.h"
#import "SDLGenericResponse.h"
#import "SDLGetSystemCapability.h"
#import "SDLGetSystemCapabilityResponse.h"
#import "SDLGlobals.h"
#import "SDLLogMacros.h"
#import "SDLNotificationConstants.h"
#import "SDLOnHMIStatus.h"
#import "SDLOnSystemCapabilityUpdated.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLSetDisplayLayoutResponse.h"
#import "SDLSystemCapability.h"
#import "SDLVersion.h"
#import "SDLVideoStreamingCapability.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLSystemCapabilityManager ()

typedef NSString * SDLServiceID;

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;

@property (nullable, strong, nonatomic, readwrite) SDLDisplayCapabilities *displayCapabilities;
@property (nullable, strong, nonatomic, readwrite) SDLHMICapabilities *hmiCapabilities;
@property (nullable, copy, nonatomic, readwrite) NSArray<SDLSoftButtonCapabilities *> *softButtonCapabilities;
@property (nullable, copy, nonatomic, readwrite) NSArray<SDLButtonCapabilities *> *buttonCapabilities;
@property (nullable, strong, nonatomic, readwrite) SDLPresetBankCapabilities *presetBankCapabilities;
@property (nullable, copy, nonatomic, readwrite) NSArray<SDLHMIZoneCapabilities> *hmiZoneCapabilities;
@property (nullable, copy, nonatomic, readwrite) NSArray<SDLSpeechCapabilities> *speechCapabilities;
@property (nullable, copy, nonatomic, readwrite) NSArray<SDLPrerecordedSpeech> *prerecordedSpeechCapabilities;
@property (nonatomic, assign, readwrite) BOOL vrCapability;
@property (nullable, copy, nonatomic, readwrite) NSArray<SDLAudioPassThruCapabilities *> *audioPassThruCapabilities;
@property (nullable, strong, nonatomic, readwrite) SDLAudioPassThruCapabilities *pcmStreamCapability;
@property (nullable, strong, nonatomic, readwrite) SDLNavigationCapability *navigationCapability;
@property (nullable, strong, nonatomic, readwrite) SDLPhoneCapability *phoneCapability;
@property (nullable, strong, nonatomic, readwrite) SDLVideoStreamingCapability *videoStreamingCapability;
@property (nullable, strong, nonatomic, readwrite) SDLRemoteControlCapabilities *remoteControlCapability;

@property (nullable, strong, nonatomic) NSMutableDictionary<SDLServiceID, SDLAppServiceCapability *> *appServicesCapabilitiesDictionary;

@property (assign, nonatomic) BOOL isFirstHMILevelFull;

@end

@implementation SDLSystemCapabilityManager

#pragma mark - Lifecycle

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)manager {
    self = [super init];
    if (!self) {
        return nil;
    }

    _connectionManager = manager;
    _isFirstHMILevelFull = NO;
    _appServicesCapabilitiesDictionary = [NSMutableDictionary dictionary];

    [self sdl_registerForNotifications];    

    return self;
}

/**
 *  Resets the capabilities when a transport session is closed.
 */
- (void)stop {
    SDLLogD(@"System Capability manager stopped");
    _displayCapabilities = nil;
    _hmiCapabilities = nil;
    _softButtonCapabilities = nil;
    _buttonCapabilities = nil;
    _presetBankCapabilities = nil;
    _hmiZoneCapabilities = nil;
    _speechCapabilities = nil;
    _prerecordedSpeechCapabilities = nil;
    _vrCapability = NO;
    _audioPassThruCapabilities = nil;
    _pcmStreamCapability = nil;
    _navigationCapability = nil;
    _phoneCapability = nil;
    _videoStreamingCapability = nil;
    _remoteControlCapability = nil;
    _appServicesCapabilitiesDictionary = [NSMutableDictionary dictionary];

    _isFirstHMILevelFull = NO;
}

#pragma mark - Getters

- (nullable SDLAppServicesCapabilities *)appServicesCapabilities {
    if (self.appServicesCapabilitiesDictionary.count == 0) { return nil; }

    return [[SDLAppServicesCapabilities alloc] initWithAppServices:self.appServicesCapabilitiesDictionary.allValues];
}

#pragma mark - Notifications

/**
 *  Registers for notifications and responses from Core
 */
-(void)sdl_registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_registerResponse:) name:SDLDidReceiveRegisterAppInterfaceResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_displayLayoutResponse:) name:SDLDidReceiveSetDisplayLayoutResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_systemCapabilityUpdatedNotification:) name:SDLDidReceiveSystemCapabilityUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiStatusNotification:) name:SDLDidChangeHMIStatusNotification object:nil];
}

/**
 *  Called when a `RegisterAppInterfaceResponse` response is received from Core. The head unit capabilities are saved.
 *
 *  @param notification The `RegisterAppInterfaceResponse` response received from Core
 */
- (void)sdl_registerResponse:(SDLRPCResponseNotification *)notification {
    SDLRegisterAppInterfaceResponse *response = (SDLRegisterAppInterfaceResponse *)notification.response;
    if (!response.success.boolValue) { return; }

    self.displayCapabilities = response.displayCapabilities;
    self.hmiCapabilities = response.hmiCapabilities;
    self.softButtonCapabilities = response.softButtonCapabilities;
    self.buttonCapabilities = response.buttonCapabilities;
    self.presetBankCapabilities = response.presetBankCapabilities;
    self.hmiZoneCapabilities = response.hmiZoneCapabilities;
    self.speechCapabilities = response.speechCapabilities;
    self.prerecordedSpeechCapabilities = response.prerecordedSpeech;
    self.vrCapability = (response.vrCapabilities.count > 0 && [response.vrCapabilities.firstObject isEqualToEnum:SDLVRCapabilitiesText]) ? YES : NO;
    self.audioPassThruCapabilities = response.audioPassThruCapabilities;
    self.pcmStreamCapability = response.pcmStreamCapabilities;
}

/**
 *  Called when a `SetDisplayLayoutResponse` response is received from Core. If the template was set successfully, the the new capabilities for the template are saved.
 *
 *  @param notification The `SetDisplayLayoutResponse` response received from Core
 */
- (void)sdl_displayLayoutResponse:(SDLRPCResponseNotification *)notification {
    SDLSetDisplayLayoutResponse *response = (SDLSetDisplayLayoutResponse *)notification.response;
    if (!response.success.boolValue) { return; }

    self.displayCapabilities = response.displayCapabilities;
    self.buttonCapabilities = response.buttonCapabilities;
    self.softButtonCapabilities = response.softButtonCapabilities;
    self.presetBankCapabilities = response.presetBankCapabilities;
}

/**
 *  Called when an `OnSystemCapabilityUpdated` notification is received from Core. The updated system capabilty is saved.
 *
 *  @param notification The `OnSystemCapabilityUpdated` notification received from Core
 */
- (void)sdl_systemCapabilityUpdatedNotification:(SDLRPCNotificationNotification *)notification {
    SDLOnSystemCapabilityUpdated *systemCapabilityUpdatedNotification = (SDLOnSystemCapabilityUpdated *)notification.notification;
    [self sdl_saveSystemCapability:systemCapabilityUpdatedNotification.systemCapability completionHandler:nil];
}

/**
 *  Called when an `OnHMIStatus` notification is received from Core. The first time the `hmiLevel` is `FULL` attempt to subscribe to system capabilty updates.
 *
 *  @param notification The `OnHMIStatus` notification received from Core
 */
- (void)sdl_hmiStatusNotification:(SDLRPCNotificationNotification *)notification {
    SDLOnHMIStatus *hmiStatus = (SDLOnHMIStatus *)notification.notification;
    if (self.isFirstHMILevelFull || ![hmiStatus.hmiLevel isEqualToEnum:SDLHMILevelFull]) {
        return;
    }

    self.isFirstHMILevelFull = YES;
    [self sdl_subscribeToSystemCapabilityUpdates];
}

#pragma mark - System Capabilities

- (void)updateCapabilityType:(SDLSystemCapabilityType)type completionHandler:(SDLUpdateCapabilityHandler)handler {
    SDLVersion *onSystemCapabilityNotificationRPCVersion = [SDLVersion versionWithString:@"5.1.0"];
    SDLVersion *headUnitRPCVersion = SDLGlobals.sharedGlobals.rpcVersion;
    if ([headUnitRPCVersion isGreaterThanOrEqualToVersion:onSystemCapabilityNotificationRPCVersion]) {
        // Just return the cached data because we get `onSystemCapability` callbacks
        handler(nil, self);
    } else {
        // Go and get the actual data
        SDLGetSystemCapability *getSystemCapability = [[SDLGetSystemCapability alloc] initWithType:type];
        [self sdl_sendGetSystemCapability:getSystemCapability completionHandler:handler];
    }
}

/**
 *  A list of all possible system capability types.
 *
 *  @return An array of all possible system capability types
 */
+ (NSArray<SDLSystemCapabilityType> *)sdl_systemCapabilityTypes {
    return @[SDLSystemCapabilityTypeAppServices, SDLSystemCapabilityTypeNavigation, SDLSystemCapabilityTypePhoneCall, SDLSystemCapabilityTypeVideoStreaming, SDLSystemCapabilityTypeRemoteControl];
}

/**
 * Sends a subscribe request for all possible system capabilites. If connecting to Core versions 4.5+, the requested capability will be returned in the response. If connecting to Core versions 5.1+, the manager will received `OnSystemCapabilityUpdated` notifications when the capability updates if the subscription was successful.
 */
- (void)sdl_subscribeToSystemCapabilityUpdates {
    for (SDLSystemCapabilityType type in [self.class sdl_systemCapabilityTypes]) {
        SDLGetSystemCapability *getSystemCapability = [[SDLGetSystemCapability alloc] initWithType:type];
        SDLVersion *onSystemCapabilityNotificationRPCVersion = [SDLVersion versionWithString:@"5.1.0"];
        SDLVersion *headUnitRPCVersion = SDLGlobals.sharedGlobals.rpcVersion;
        if ([headUnitRPCVersion isGreaterThanOrEqualToVersion:onSystemCapabilityNotificationRPCVersion]) {
            getSystemCapability.subscribe = @YES;
        }

        [self sdl_sendGetSystemCapability:getSystemCapability completionHandler:nil];
    }
}

/**
 *  Sends a `GetSystemCapability` to Core and handles the response by saving the returned data and notifying the subscriber.
 *
 *  @param getSystemCapability The `GetSystemCapability` request to send
 */
- (void)sdl_sendGetSystemCapability:(SDLGetSystemCapability *)getSystemCapability completionHandler:(nullable SDLUpdateCapabilityHandler)handler {
    [self.connectionManager sendConnectionRequest:getSystemCapability withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            // An error is returned if the request was unsuccessful or if a Generic Response was returned
            if (handler == nil) { return; }
            handler(error, self);
            return;
        }

        SDLGetSystemCapabilityResponse *getSystemCapabilityResponse = (SDLGetSystemCapabilityResponse *)response;
        if (!getSystemCapabilityResponse.success.boolValue) { return; }
        [self sdl_saveSystemCapability:getSystemCapabilityResponse.systemCapability completionHandler:handler];
    }];
}

/**
 *  Saves a system capability. All system capabilities will update with the full object except for app services. For app services only the updated app service capabilities will be included in the `SystemCapability` sent from Core. The cached `appServicesCapabilities` will be updated with the new `appService` data.
 *
 *  @param systemCapability The system capability
 */
- (void)sdl_saveSystemCapability:(SDLSystemCapability *)systemCapability completionHandler:(nullable SDLUpdateCapabilityHandler)handler {
    SDLSystemCapabilityType systemCapabilityType = systemCapability.systemCapabilityType;

    if ([systemCapabilityType isEqualToEnum:SDLSystemCapabilityTypePhoneCall]) {
        self.phoneCapability = systemCapability.phoneCapability;
    } else if ([systemCapabilityType isEqualToEnum:SDLSystemCapabilityTypeNavigation]) {
        self.navigationCapability = systemCapability.navigationCapability;
    } else if ([systemCapabilityType isEqualToEnum:SDLSystemCapabilityTypeRemoteControl]) {
        self.remoteControlCapability = systemCapability.remoteControlCapability;
    } else if ([systemCapabilityType isEqualToEnum:SDLSystemCapabilityTypeVideoStreaming]) {
        self.videoStreamingCapability = systemCapability.videoStreamingCapability;
    } else if ([systemCapabilityType isEqualToEnum:SDLSystemCapabilityTypeAppServices]) {
        [self sdl_saveAppServicesCapabilitiesUpdate:systemCapability.appServicesCapabilities];
    } else {
        SDLLogW(@"Received response for unknown System Capability Type: %@", systemCapabilityType);
        return;
    }

    SDLLogD(@"Updated system capability manager with new data: %@", systemCapability);

    if (handler == nil) { return; }
    handler(nil, self);
}

- (void)sdl_saveAppServicesCapabilitiesUpdate:(SDLAppServicesCapabilities *)newCapabilities {
    for (SDLAppServiceCapability *capability in newCapabilities.appServices) {
        if (capability.updateReason == nil) {
            // First update, new capability
            self.appServicesCapabilitiesDictionary[capability.updatedAppServiceRecord.serviceID] = capability;
        } else if ([capability.updateReason isEqualToEnum:SDLServiceUpdateRemoved]) {
            self.appServicesCapabilitiesDictionary[capability.updatedAppServiceRecord.serviceID] = nil;
        } else {
            // Everything else involves adding or updating the existing service record
            self.appServicesCapabilitiesDictionary[capability.updatedAppServiceRecord.serviceID] = capability;
        }
    }
}

@end

NS_ASSUME_NONNULL_END
