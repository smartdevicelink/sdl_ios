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

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (copy, nonatomic, nullable) SDLUpdateCapabilityHandler systemCapabilityHandler;

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
@property (nullable, strong, nonatomic, readwrite) SDLAppServicesCapabilities *appServicesCapabilities;
@property (nullable, strong, nonatomic, readwrite) SDLNavigationCapability *navigationCapability;
@property (nullable, strong, nonatomic, readwrite) SDLPhoneCapability *phoneCapability;
@property (nullable, strong, nonatomic, readwrite) SDLVideoStreamingCapability *videoStreamingCapability;
@property (nullable, strong, nonatomic, readwrite) SDLRemoteControlCapabilities *remoteControlCapability;

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

    [self sdl_registerForNotifications];    

    return self;
}

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
    _appServicesCapabilities = nil;

    _isFirstHMILevelFull = NO;
}


#pragma mark - Notifications

-(void)sdl_registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_registerResponse:) name:SDLDidReceiveRegisterAppInterfaceResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_displayLayoutResponse:) name:SDLDidReceiveSetDisplayLayoutResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_systemCapabilityResponse:) name:SDLDidReceiveGetSystemCapabilitiesResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_systemCapabilityUpdatedNotification:) name:SDLDidReceiveSystemCapabilityUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiStatusNotification:) name:SDLDidChangeHMIStatusNotification object:nil];
}

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

- (void)sdl_displayLayoutResponse:(SDLRPCResponseNotification *)notification {
    SDLSetDisplayLayoutResponse *response = (SDLSetDisplayLayoutResponse *)notification.response;
    if (!response.success.boolValue) { return; }

    self.displayCapabilities = response.displayCapabilities;
    self.buttonCapabilities = response.buttonCapabilities;
    self.softButtonCapabilities = response.softButtonCapabilities;
    self.presetBankCapabilities = response.presetBankCapabilities;
}

- (void)sdl_systemCapabilityResponse:(SDLRPCResponseNotification *)notification {
    SDLGetSystemCapabilityResponse *response = (SDLGetSystemCapabilityResponse *)notification.response;
    if (!response.success.boolValue) { return; }

    SDLSystemCapability *systemCapabilityResponse = ((SDLGetSystemCapabilityResponse *)response).systemCapability;

    [self sdl_saveSystemCapability:systemCapabilityResponse];

    if (self.systemCapabilityHandler == nil) { return; }
    self.systemCapabilityHandler(nil, self);
}

- (void)sdl_systemCapabilityUpdatedNotification:(SDLRPCNotificationNotification *)notification {
    SDLOnSystemCapabilityUpdated *systemCapabilityUpdatedNotification = (SDLOnSystemCapabilityUpdated *)notification.notification;
    [self sdl_saveSystemCapability:systemCapabilityUpdatedNotification.systemCapability];

    // TODO: double check that this isn't going to break anything
    if (self.systemCapabilityHandler == nil) { return; }
    self.systemCapabilityHandler(nil, self);
}

- (void)sdl_saveSystemCapability:(SDLSystemCapability *)systemCapability {
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
        if (!self.appServicesCapabilities) {
            self.appServicesCapabilities = systemCapability.appServicesCapabilities;
        }

        NSMutableDictionary *cachedCapabilities = [NSMutableDictionary dictionary];
        for (unsigned long i = 0; i < self.appServicesCapabilities.appServices.count; i += 1) {
            SDLAppServiceRecord *record = self.appServicesCapabilities.appServices[i].updatedAppServiceRecord;
            cachedCapabilities[record.serviceID] = record;
        }

        for (unsigned long i = 0; i < systemCapability.appServicesCapabilities.appServices.count; i += 1) {
            SDLAppServiceRecord *updatedRecord = systemCapability.appServicesCapabilities.appServices[i].updatedAppServiceRecord;
            cachedCapabilities[updatedRecord.serviceID] = updatedRecord;
        }

        self.appServicesCapabilities.appServices = [cachedCapabilities allValues];
    } else {
        SDLLogW(@"Received response for unknown System Capability Type: %@", systemCapabilityType);
    }
}

- (void)sdl_hmiStatusNotification:(SDLRPCNotificationNotification *)notification {
    SDLOnHMIStatus *hmiStatus = (SDLOnHMIStatus *)notification.notification;

    // On first hmi level of `FULL` send the `GetSystemCapability` subscription
    if (!self.isFirstHMILevelFull && hmiStatus.hmiLevel == SDLHMILevelFull) {
        self.isFirstHMILevelFull = YES;

        NSArray<SDLSystemCapabilityType> *allSystemCapabilityTypes = @[SDLSystemCapabilityTypeAppServices, SDLSystemCapabilityTypeNavigation, SDLSystemCapabilityTypePhoneCall, SDLSystemCapabilityTypeVideoStreaming, SDLSystemCapabilityTypeRemoteControl];

        NSMutableArray<SDLGetSystemCapability *> *test = [NSMutableArray array];
        for (unsigned long i = 0; i < allSystemCapabilityTypes.count; i += 1) {
            SDLGetSystemCapability *getSystemCapability = [[SDLGetSystemCapability alloc] initWithType:allSystemCapabilityTypes[i] subscribe:true];
            [test addObject:getSystemCapability];
        }

        [self.connectionManager sendRequests:test progressHandler:^(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
            SDLGetSystemCapabilityResponse *getSystemCapabilityResponse = (SDLGetSystemCapabilityResponse *)response;
            // TODO: make sure this actually returns data
            [self sdl_saveSystemCapability:getSystemCapabilityResponse.systemCapability];
        } completionHandler:^(BOOL success) {
            // TODO - not sure if we need this
        }];
    }
}

#pragma mark - Capability Request

- (void)updateCapabilityType:(SDLSystemCapabilityType)type completionHandler:(SDLUpdateCapabilityHandler)handler {
    self.systemCapabilityHandler = handler;

    SDLVersion *onSystemCapabilityNotificationRPCVersion = [SDLVersion versionWithString:@"5.1.0"];
    SDLVersion *headUnitRPCVersion = SDLGlobals.sharedGlobals.rpcVersion;
    if ([headUnitRPCVersion isGreaterThanOrEqualToVersion:onSystemCapabilityNotificationRPCVersion]) {
        // Just return the cached data
        if (self.systemCapabilityHandler == nil) { return; }
        self.systemCapabilityHandler(nil, self);
    }

    SDLGetSystemCapability *getSystemCapability = [[SDLGetSystemCapability alloc] initWithType:type];
    [self.connectionManager sendConnectionRequest:getSystemCapability withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) { return; }
        // An error is returned if the request was unsuccessful or a Generic Response is returned
        handler(error, self);
    }];
}

@end

NS_ASSUME_NONNULL_END
