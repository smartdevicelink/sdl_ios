//
//  SDLSystemCapabilityManager.m
//  SmartDeviceLink
//
//  Created by Nicole on 3/26/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLSystemCapabilityManager.h"

#import "SDLConnectionManagerType.h"
#import "SDLGenericResponse.h"
#import "SDLGetSystemCapability.h"
#import "SDLGetSystemCapabilityResponse.h"
#import "SDLLogMacros.h"
#import "SDLNotificationConstants.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCResponseNotification.h"
#import "SDLSetDisplayLayoutResponse.h"
#import "SDLSystemCapability.h"
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
@property (nullable, strong, nonatomic, readwrite) SDLNavigationCapability *navigationCapability;
@property (nullable, strong, nonatomic, readwrite) SDLPhoneCapability *phoneCapability;
@property (nullable, strong, nonatomic, readwrite) SDLVideoStreamingCapability *videoStreamingCapability;
@property (nullable, strong, nonatomic, readwrite) SDLRemoteControlCapabilities *remoteControlCapability;

@end

@implementation SDLSystemCapabilityManager

#pragma mark - Lifecycle

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)manager {
    self = [super init];
    if (!self) {
        return nil;
    }

    _connectionManager = manager;
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
}


#pragma mark - Notifications

-(void)sdl_registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_registerResponse:) name:SDLDidReceiveRegisterAppInterfaceResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_displayLayoutResponse:) name:SDLDidReceiveSetDisplayLayoutResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_systemCapabilityResponse:) name:SDLDidReceiveGetSystemCapabilitiesResponse object:nil];
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
    self.vrCapability = (response.vrCapabilities.count > 0 && response.vrCapabilities.firstObject == SDLVRCapabilitiesText) ? YES : NO;
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
    SDLSystemCapabilityType systemCapabilityType = systemCapabilityResponse.systemCapabilityType;

    if ([systemCapabilityType isEqualToEnum:SDLSystemCapabilityTypePhoneCall]) {
        self.phoneCapability = systemCapabilityResponse.phoneCapability;
    } else if ([systemCapabilityType isEqualToEnum:SDLSystemCapabilityTypeNavigation]) {
        self.navigationCapability = systemCapabilityResponse.navigationCapability;
    } else if ([systemCapabilityType isEqualToEnum:SDLSystemCapabilityTypeRemoteControl]) {
        self.remoteControlCapability = systemCapabilityResponse.remoteControlCapability;
    } else if ([systemCapabilityType isEqualToEnum:SDLSystemCapabilityTypeVideoStreaming]) {
        self.videoStreamingCapability = systemCapabilityResponse.videoStreamingCapability;
    } else {
        SDLLogW(@"Received response for unknown System Capability Type: %@", systemCapabilityType);
    }

    if (self.systemCapabilityHandler == nil) { return; }
    self.systemCapabilityHandler(nil, self);
}

#pragma mark - Capability Request

- (void)updateCapabilityType:(SDLSystemCapabilityType)type completionHandler:(SDLUpdateCapabilityHandler)handler {
    self.systemCapabilityHandler = handler;
    SDLGetSystemCapability *getSystemCapability = [[SDLGetSystemCapability alloc] initWithType:type];
    [self.connectionManager sendConnectionRequest:getSystemCapability withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) { return; }
        // An error is returned if the request was unsuccessful or a Generic Response is returned
        handler(error, self);
    }];
}

@end

NS_ASSUME_NONNULL_END
