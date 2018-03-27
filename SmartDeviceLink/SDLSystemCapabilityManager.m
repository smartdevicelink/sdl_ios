//
//  SDLSystemCapabilityManager.m
//  SmartDeviceLink
//
//  Created by Nicole on 3/26/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLSystemCapabilityManager.h"

#import "SDLNotificationConstants.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCResponseNotification.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLSystemCapabilityManager ()

@property (strong, nonatomic, readwrite, nullable) SDLDisplayCapabilities *displayCapabilities;
@property (strong, nonatomic, readwrite) SDLHMICapabilities *hmiCapabilities;
@property (copy, nonatomic, readwrite, nullable) NSArray<SDLSoftButtonCapabilities *> *softButtonCapabilities;
@property (copy, nonatomic, readwrite) NSArray<SDLButtonCapabilities *> *buttonCapabilities;
@property (strong, nonatomic, readwrite) SDLPresetBankCapabilities *presetBankCapabilities;
@property (copy, nonatomic, readwrite) NSArray<SDLHMIZoneCapabilities> *hmiZoneCapabilities;
@property (copy, nonatomic, readwrite) NSArray<SDLSpeechCapabilities> *speechCapabilities;
@property (copy, nonatomic, readwrite) NSArray<SDLPrerecordedSpeech> *prerecordedSpeech;
@property (copy, nonatomic, readwrite, nullable) NSArray<SDLVRCapabilities> *vrCapabilities;
@property (copy, nonatomic, readwrite) NSArray<SDLAudioPassThruCapabilities *> *audioPassThruCapabilities;
@property (copy, nonatomic, readwrite) NSArray<SDLAudioPassThruCapabilities *> *pcmStreamCapabilities;
@property (strong, nonatomic, readwrite) SDLNavigationCapability *navigationCapability;
@property (strong, nonatomic, readwrite) SDLPhoneCapability *phoneCapability;
@property (strong, nonatomic, readwrite) SDLVideoStreamingCapability *videoStreamingCapability;
@property (strong, nonatomic, readwrite) SDLRemoteControlCapabilities *remoteControlCapability;

@end

@implementation SDLSystemCapabilityManager

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    [self sdl_registerForNotifications];

    return self;
}

-(void)sdl_registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_registerResponse:) name:SDLDidReceiveRegisterAppInterfaceResponse object:nil];
}

- (void)sdl_registerResponse:(SDLRPCResponseNotification *)notification {
    SDLRegisterAppInterfaceResponse *response = (SDLRegisterAppInterfaceResponse *)notification.response;
    self.displayCapabilities = response.displayCapabilities;
    self.hmiCapabilities = response.hmiCapabilities;
    self.softButtonCapabilities = response.softButtonCapabilities;
    self.buttonCapabilities = response.buttonCapabilities;
    self.presetBankCapabilities = response.presetBankCapabilities;
    self.hmiZoneCapabilities = response.hmiZoneCapabilities;
    self.speechCapabilities = response.speechCapabilities;
    self.prerecordedSpeech = response.prerecordedSpeech;
    self.vrCapabilities = response.vrCapabilities;
    self.audioPassThruCapabilities = response.audioPassThruCapabilities;
    self.pcmStreamCapabilities = @[response.pcmStreamCapabilities];
}


#pragma mark - Capability Type

- (void)updateCapabilityType:(SDLSystemCapabilityType)type completionHandler:(SDLUpdateCapabilityHandler)handler {

}

@end

NS_ASSUME_NONNULL_END
