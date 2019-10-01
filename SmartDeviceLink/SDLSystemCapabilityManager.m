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
#import "SDLDisplayCapabilities.h"
#import "SDLDisplayCapability.h"
#import "SDLError.h"
#import "SDLGenericResponse.h"
#import "SDLGetSystemCapability.h"
#import "SDLGetSystemCapabilityResponse.h"
#import "SDLGlobals.h"
#import "SDLLogMacros.h"
#import "SDLNavigationCapability.h"
#import "SDLNotificationConstants.h"
#import "SDLOnHMIStatus.h"
#import "SDLOnSystemCapabilityUpdated.h"
#import "SDLPhoneCapability.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLPredefinedWindows.h"
#import "SDLRemoteControlCapabilities.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLSeatLocationCapability.h"
#import "SDLSetDisplayLayoutResponse.h"
#import "SDLSystemCapability.h"
#import "SDLSystemCapabilityObserver.h"
#import "SDLVersion.h"
#import "SDLVideoStreamingCapability.h"
#import "SDLWindowCapability.h"
#import "SDLWindowTypeCapabilities.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLSystemCapabilityManager ()

typedef NSString * SDLServiceID;

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;

@property (nullable, strong, nonatomic, readwrite) NSArray<SDLDisplayCapability *> *displays;
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
@property (nullable, strong, nonatomic, readwrite) SDLSeatLocationCapability *seatLocationCapability;

@property (nullable, strong, nonatomic) NSMutableDictionary<SDLServiceID, SDLAppServiceCapability *> *appServicesCapabilitiesDictionary;

@property (assign, nonatomic, readwrite) BOOL supportsSubscriptions;
@property (strong, nonatomic) NSMutableDictionary<SDLSystemCapabilityType, NSMutableArray<SDLSystemCapabilityObserver *> *> *capabilityObservers;

@property (nullable, strong, nonatomic) SDLSystemCapability *lastReceivedCapability;

@property (assign, nonatomic) BOOL isFirstHMILevelFull;

@property (assign, nonatomic) BOOL shouldConvertDeprecatedDisplayCapabilities;

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
    _shouldConvertDeprecatedDisplayCapabilities = YES;
    _appServicesCapabilitiesDictionary = [NSMutableDictionary dictionary];

    _capabilityObservers = [NSMutableDictionary dictionary];
    for (SDLSystemCapabilityType capabilityType in [self.class sdl_systemCapabilityTypes]) {
        _capabilityObservers[capabilityType] = [NSMutableArray array];
    }

    [self sdl_registerForNotifications];    

    return self;
}

- (void)start {
    SDLVersion *onSystemCapabilityNotificationRPCVersion = [SDLVersion versionWithString:@"5.1.0"];
    SDLVersion *headUnitRPCVersion = SDLGlobals.sharedGlobals.rpcVersion;
    if ([headUnitRPCVersion isGreaterThanOrEqualToVersion:onSystemCapabilityNotificationRPCVersion]) {
        _supportsSubscriptions = YES;
    }
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
    _seatLocationCapability = nil;
    _appServicesCapabilitiesDictionary = [NSMutableDictionary dictionary];

    _supportsSubscriptions = NO;
    for (SDLSystemCapabilityType capabilityType in [self.class sdl_systemCapabilityTypes]) {
        _capabilityObservers[capabilityType] = [NSMutableArray array];
    }

    _isFirstHMILevelFull = NO;
    _shouldConvertDeprecatedDisplayCapabilities = YES;
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
- (void)sdl_registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_registerResponse:) name:SDLDidReceiveRegisterAppInterfaceResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_displayLayoutResponse:) name:SDLDidReceiveSetDisplayLayoutResponse object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_systemCapabilityUpdatedNotification:) name:SDLDidReceiveSystemCapabilityUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_systemCapabilityResponseNotification:) name:SDLDidReceiveGetSystemCapabilitiesResponse object:nil];
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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    self.displayCapabilities = response.displayCapabilities;
    self.softButtonCapabilities = response.softButtonCapabilities;
    self.buttonCapabilities = response.buttonCapabilities;
    self.presetBankCapabilities = response.presetBankCapabilities;
#pragma clang diagnostic pop

    self.hmiCapabilities = response.hmiCapabilities;
    self.hmiZoneCapabilities = response.hmiZoneCapabilities;
    self.speechCapabilities = response.speechCapabilities;
    self.prerecordedSpeechCapabilities = response.prerecordedSpeech;
    self.vrCapability = (response.vrCapabilities.count > 0 && [response.vrCapabilities.firstObject isEqualToEnum:SDLVRCapabilitiesText]) ? YES : NO;
    self.audioPassThruCapabilities = response.audioPassThruCapabilities;
    self.pcmStreamCapability = response.pcmStreamCapabilities;
    
    self.shouldConvertDeprecatedDisplayCapabilities = YES;
    self.displays = [self sdl_createDisplayCapabilityListFromRegisterResponse:response];
    
    // call the observers in case the new display capability list is created from deprecated types
    SDLSystemCapability *systemCapability = [[SDLSystemCapability alloc] initWithDisplayCapabilities:self.displays];
    [self sdl_callSaveHandlerForCapability:systemCapability andReturnWithValue:YES handler:nil];
}

/**
 *  Called when a `SetDisplayLayoutResponse` response is received from Core. If the template was set successfully, the the new capabilities for the template are saved.
 *
 *  @param notification The `SetDisplayLayoutResponse` response received from Core
 */
- (void)sdl_displayLayoutResponse:(SDLRPCResponseNotification *)notification {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    SDLSetDisplayLayoutResponse *response = (SDLSetDisplayLayoutResponse *)notification.response;
#pragma clang diagnostic pop
    if (!response.success.boolValue) { return; }
    
    self.displayCapabilities = response.displayCapabilities;
    self.buttonCapabilities = response.buttonCapabilities;
    self.softButtonCapabilities = response.softButtonCapabilities;
    self.presetBankCapabilities = response.presetBankCapabilities;
    
    self.displays = [self sdl_createDisplayCapabilityListFromSetDisplayLayoutResponse:response];

    // call the observers in case the new display capability list is created from deprecated types
    SDLSystemCapability *systemCapability = [[SDLSystemCapability alloc] initWithDisplayCapabilities:self.displays];
    [self sdl_callSaveHandlerForCapability:systemCapability andReturnWithValue:YES handler:nil];
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
 Called with a `GetSystemCapabilityResponse` notification is received from core. The updated system capability is saved.

 @param notification The `GetSystemCapabilityResponse` notification received from Core
 */
- (void)sdl_systemCapabilityResponseNotification:(SDLRPCResponseNotification *)notification {
    SDLGetSystemCapabilityResponse *systemCapabilityResponse = (SDLGetSystemCapabilityResponse *)notification.response;
    [self sdl_saveSystemCapability:systemCapabilityResponse.systemCapability completionHandler:nil];
}

/**
 *  Called when an `OnHMIStatus` notification is received from Core. The first time the `hmiLevel` is `FULL` attempt to subscribe to system capabilty updates.
 *
 *  @param notification The `OnHMIStatus` notification received from Core
 */
- (void)sdl_hmiStatusNotification:(SDLRPCNotificationNotification *)notification {
    SDLOnHMIStatus *hmiStatus = (SDLOnHMIStatus *)notification.notification;
    
    if (hmiStatus.windowID != nil && hmiStatus.windowID.integerValue != SDLPredefinedWindowsDefaultWindow) {
        return;
    }
    
    if (self.isFirstHMILevelFull || ![hmiStatus.hmiLevel isEqualToEnum:SDLHMILevelFull]) {
        return;
    }

    self.isFirstHMILevelFull = YES;
    [self sdl_subscribeToSystemCapabilityUpdates];
}

#pragma mark - Window And Display Capabilities

- (nullable SDLWindowCapability *)windowCapabilityWithWindowID:(NSUInteger)windowID {
    NSArray<SDLDisplayCapability *> *capabilities = self.displays;
    if (capabilities == nil || capabilities.count == 0) {
        return nil;
    }

    SDLDisplayCapability *mainDisplay = capabilities.firstObject;
    for (SDLWindowCapability *windowCapability in mainDisplay.windowCapabilities) {
        NSUInteger currentWindowID = windowCapability.windowID != nil ? windowCapability.windowID.unsignedIntegerValue : SDLPredefinedWindowsDefaultWindow;
        if (currentWindowID == windowID) {
            return windowCapability;
        }
    }
    return nil;
}

- (nullable SDLWindowCapability *)defaultMainWindowCapability {
    return [self windowCapabilityWithWindowID:SDLPredefinedWindowsDefaultWindow];
}

- (NSArray<SDLDisplayCapability *> *)sdl_createDisplayCapabilityListFromDeprecatedDisplayCapabilities:(SDLDisplayCapabilities *)display buttons:(NSArray<SDLButtonCapabilities *> *)buttons softButtons:(NSArray<SDLSoftButtonCapabilities *> *)softButtons {
    // Based on deprecated Display capabilities we don't know if widgets are supported. The default MAIN window is the only window we know is supported, so it's the only one we will expose.
    SDLWindowTypeCapabilities *windowTypeCapabilities = [[SDLWindowTypeCapabilities alloc] initWithType:SDLWindowTypeMain maximumNumberOfWindows:1];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    NSString *displayName = display.displayName ?: display.displayType;
#pragma clang diagnostic pop
    SDLDisplayCapability *displayCapability = [[SDLDisplayCapability alloc] initWithDisplayName:displayName];
    displayCapability.windowTypeSupported = @[windowTypeCapabilities];
    
    // Create a window capability object for the default MAIN window
    SDLWindowCapability *defaultWindowCapability = [[SDLWindowCapability alloc] init];
    defaultWindowCapability.windowID = @(SDLPredefinedWindowsDefaultWindow);
    defaultWindowCapability.buttonCapabilities = [buttons copy];
    defaultWindowCapability.softButtonCapabilities = [softButtons copy];
    
    // return if display capabilities don't exist.
    if (display == nil) {
        displayCapability.windowCapabilities = @[defaultWindowCapability];
        return @[displayCapability];
    }
    
    // Copy all available display capability properties
    defaultWindowCapability.templatesAvailable = [display.templatesAvailable copy];
    defaultWindowCapability.numCustomPresetsAvailable = [display.numCustomPresetsAvailable copy];
    defaultWindowCapability.textFields = [display.textFields copy];
    defaultWindowCapability.imageFields = [display.imageFields copy];
    
    
    /*
     The description from the mobile API to "graphicSupported:
     > The display's persistent screen supports referencing a static or dynamic image.
     For backward compatibility (AppLink 2.0) static image type is always presented
     */
    if (display.graphicSupported.boolValue) {
        defaultWindowCapability.imageTypeSupported = @[SDLImageTypeStatic, SDLImageTypeDynamic];
    } else {
        defaultWindowCapability.imageTypeSupported = @[SDLImageTypeStatic];
    }
    
    displayCapability.windowCapabilities = @[defaultWindowCapability];
    return @[displayCapability];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
- (NSArray<SDLDisplayCapability *> *)sdl_createDisplayCapabilityListFromRegisterResponse:(SDLRegisterAppInterfaceResponse *)rpc {
    return [self sdl_createDisplayCapabilityListFromDeprecatedDisplayCapabilities:rpc.displayCapabilities buttons:rpc.buttonCapabilities softButtons:rpc.softButtonCapabilities];
}

- (NSArray<SDLDisplayCapability *> *)sdl_createDisplayCapabilityListFromSetDisplayLayoutResponse:(SDLSetDisplayLayoutResponse *)rpc {
    return [self sdl_createDisplayCapabilityListFromDeprecatedDisplayCapabilities:rpc.displayCapabilities buttons:rpc.buttonCapabilities softButtons:rpc.softButtonCapabilities];
}
#pragma clang diagnostic pop

- (SDLDisplayCapabilities *)sdl_createDeprecatedDisplayCapabilitiesWithDisplayName:(NSString *)displayName windowCapability:(SDLWindowCapability *)windowCapability {
    SDLDisplayCapabilities *convertedCapabilities = [[SDLDisplayCapabilities alloc] init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    convertedCapabilities.displayType = SDLDisplayTypeGeneric; //deprecated but it is mandatory...
#pragma clang diagnostic pop
    convertedCapabilities.displayName = displayName;
    convertedCapabilities.textFields = [windowCapability.textFields copy];
    convertedCapabilities.imageFields = [windowCapability.imageFields copy];
    convertedCapabilities.templatesAvailable = [windowCapability.templatesAvailable copy];
    convertedCapabilities.numCustomPresetsAvailable = [windowCapability.numCustomPresetsAvailable copy];
    convertedCapabilities.mediaClockFormats = @[]; // mandatory field but allows empty array
    convertedCapabilities.graphicSupported = @([windowCapability.imageTypeSupported containsObject:SDLImageTypeDynamic]);
    
    return convertedCapabilities;
}

- (void)sdl_updateDeprecatedDisplayCapabilities {
    SDLWindowCapability *defaultMainWindowCapabilities = self.defaultMainWindowCapability;
    NSArray<SDLDisplayCapability *> *displayCapabilityList = self.displays;
    
    if (displayCapabilityList == nil || displayCapabilityList.count == 0) {
        return;
    }
    
    // Create the deprecated capabilities for backward compatibility if developers try to access them
    self.displayCapabilities = [self sdl_createDeprecatedDisplayCapabilitiesWithDisplayName:self.displays.firstObject.displayName windowCapability:defaultMainWindowCapabilities];
    self.buttonCapabilities = defaultMainWindowCapabilities.buttonCapabilities;
    self.softButtonCapabilities = defaultMainWindowCapabilities.softButtonCapabilities;
}

- (void)sdl_saveDisplayCapabilityListUpdate:(NSArray<SDLDisplayCapability *> *)newCapabilities {
    NSArray<SDLDisplayCapability *> *oldCapabilities = self.displays;
    
    if (oldCapabilities == nil) {
        self.displays = newCapabilities;
        [self sdl_updateDeprecatedDisplayCapabilities];
        return;
    }
    
    SDLDisplayCapability *oldDefaultDisplayCapabilities = oldCapabilities.firstObject;
    NSMutableArray<SDLWindowCapability *> *copyWindowCapabilities = [oldDefaultDisplayCapabilities.windowCapabilities mutableCopy];
    
    SDLDisplayCapability *newDefaultDisplayCapabilities = newCapabilities.firstObject;
    NSArray<SDLWindowCapability *> *newWindowCapabilities = newDefaultDisplayCapabilities.windowCapabilities;
    
    for (SDLWindowCapability *newWindow in newWindowCapabilities) {
        BOOL oldFound = NO;
        for (NSUInteger i = 0; i < copyWindowCapabilities.count; i++) {
            SDLWindowCapability *oldWindow = copyWindowCapabilities[i];
            NSUInteger newWindowID = newWindow.windowID ? newWindow.windowID.unsignedIntegerValue : SDLPredefinedWindowsDefaultWindow;
            NSUInteger oldWindowID = oldWindow.windowID ? oldWindow.windowID.unsignedIntegerValue : SDLPredefinedWindowsDefaultWindow;
            if (newWindowID == oldWindowID) {
                copyWindowCapabilities[i] = newWindow; // replace the old window caps with new ones
                oldFound = true;
                break;
            }
        }
        
        if (!oldFound) {
            [copyWindowCapabilities addObject:newWindow]; // this is a new unknown window
        }
    }
    
    // replace the window capabilities array with the merged one.
    newDefaultDisplayCapabilities.windowCapabilities = [copyWindowCapabilities copy];
    self.displays = @[newDefaultDisplayCapabilities];
    [self sdl_updateDeprecatedDisplayCapabilities];
}

#pragma mark - System Capabilities

- (void)updateCapabilityType:(SDLSystemCapabilityType)type completionHandler:(SDLUpdateCapabilityHandler)handler {
    if (self.supportsSubscriptions) {
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
    return @[SDLSystemCapabilityTypeAppServices, SDLSystemCapabilityTypeNavigation, SDLSystemCapabilityTypePhoneCall, SDLSystemCapabilityTypeVideoStreaming, SDLSystemCapabilityTypeRemoteControl, SDLSystemCapabilityTypeDisplays, SDLSystemCapabilityTypeSeatLocation];
}

/**
 * Sends a subscribe request for all possible system capabilites. If connecting to Core versions 4.5+, the requested capability will be returned in the response. If connecting to Core versions 5.1+, the manager will received `OnSystemCapabilityUpdated` notifications when the capability updates if the subscription was successful.
 */
- (void)sdl_subscribeToSystemCapabilityUpdates {
    for (SDLSystemCapabilityType type in [self.class sdl_systemCapabilityTypes]) {
        SDLGetSystemCapability *getSystemCapability = [[SDLGetSystemCapability alloc] initWithType:type];
        if (self.supportsSubscriptions) {
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
    __weak typeof(self) weakSelf = self;
    [self.connectionManager sendConnectionRequest:getSystemCapability withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            // An error is returned if the request was unsuccessful or if a Generic Response was returned
            if (handler == nil) { return; }
            handler(error, weakSelf);
            return;
        }

        SDLGetSystemCapabilityResponse *getSystemCapabilityResponse = (SDLGetSystemCapabilityResponse *)response;
        [weakSelf sdl_saveSystemCapability:getSystemCapabilityResponse.systemCapability completionHandler:handler];
    }];
}

/**
 Saves a system capability. All system capabilities will update with the full object except for app services. For app services only the updated app service capabilities will be included in the `SystemCapability` sent from Core. The cached `appServicesCapabilities` will be updated with the new `appService` data.

 @param systemCapability The system capability to be saved
 @param handler The handler to be called when the save completes
 @return Whether or not the save occurred. This can be `NO` if the new system capability is equivalent to the old capability.
 */
- (BOOL)sdl_saveSystemCapability:(SDLSystemCapability *)systemCapability completionHandler:(nullable SDLUpdateCapabilityHandler)handler {
    if ([self.lastReceivedCapability isEqual:systemCapability]) {
        return [self sdl_callSaveHandlerForCapability:systemCapability andReturnWithValue:NO handler:handler];
    }
    self.lastReceivedCapability = systemCapability;

    SDLSystemCapabilityType systemCapabilityType = systemCapability.systemCapabilityType;

    if ([systemCapabilityType isEqualToEnum:SDLSystemCapabilityTypePhoneCall]) {
        if ([self.phoneCapability isEqual:systemCapability.phoneCapability]) { return [self sdl_callSaveHandlerForCapability:systemCapability andReturnWithValue:NO handler:handler]; }
        self.phoneCapability = systemCapability.phoneCapability;
    } else if ([systemCapabilityType isEqualToEnum:SDLSystemCapabilityTypeNavigation]) {
        if ([self.navigationCapability isEqual:systemCapability.navigationCapability]) { return [self sdl_callSaveHandlerForCapability:systemCapability andReturnWithValue:NO handler:handler]; }
        self.navigationCapability = systemCapability.navigationCapability;
    } else if ([systemCapabilityType isEqualToEnum:SDLSystemCapabilityTypeRemoteControl]) {
        if ([self.remoteControlCapability isEqual:systemCapability.remoteControlCapability]) { return [self sdl_callSaveHandlerForCapability:systemCapability andReturnWithValue:NO handler:handler]; }
        self.remoteControlCapability = systemCapability.remoteControlCapability;
    } else if ([systemCapabilityType isEqualToEnum:SDLSystemCapabilityTypeSeatLocation]) {
        if ([self.seatLocationCapability isEqual:systemCapability.seatLocationCapability]) { return [self sdl_callSaveHandlerForCapability:systemCapability andReturnWithValue:NO handler:handler]; }
        self.seatLocationCapability = systemCapability.seatLocationCapability;
    } else if ([systemCapabilityType isEqualToEnum:SDLSystemCapabilityTypeVideoStreaming]) {
        if ([self.videoStreamingCapability isEqual:systemCapability.videoStreamingCapability]) { return [self sdl_callSaveHandlerForCapability:systemCapability andReturnWithValue:NO handler:handler]; }
        self.videoStreamingCapability = systemCapability.videoStreamingCapability;
    } else if ([systemCapabilityType isEqualToEnum:SDLSystemCapabilityTypeAppServices]) {
        [self sdl_saveAppServicesCapabilitiesUpdate:systemCapability.appServicesCapabilities];
        systemCapability = [[SDLSystemCapability alloc] initWithAppServicesCapabilities:self.appServicesCapabilities];
    } else if ([systemCapabilityType isEqualToEnum:SDLSystemCapabilityTypeDisplays]) {
        self.shouldConvertDeprecatedDisplayCapabilities = NO;
        [self sdl_saveDisplayCapabilityListUpdate:systemCapability.displayCapabilities];
    } else {
        SDLLogW(@"Received response for unknown System Capability Type: %@", systemCapabilityType);
        return NO;
    }

    SDLLogD(@"Updated system capability manager with new data: %@", systemCapability);

    return [self sdl_callSaveHandlerForCapability:systemCapability andReturnWithValue:YES handler:handler];
}

- (BOOL)sdl_callSaveHandlerForCapability:(SDLSystemCapability *)capability andReturnWithValue:(BOOL)value handler:(nullable SDLUpdateCapabilityHandler)handler {
    for (SDLSystemCapabilityObserver *observer in self.capabilityObservers[capability.systemCapabilityType]) {
        if (observer.block != nil) {
            observer.block(capability);
        } else {
            NSUInteger numberOfParametersInSelector = [NSStringFromSelector(observer.selector) componentsSeparatedByString:@":"].count - 1;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            if (numberOfParametersInSelector == 0) {
                if ([observer.observer respondsToSelector:observer.selector]) {
                    [observer.observer performSelector:observer.selector];
                }
            } else if (numberOfParametersInSelector == 1) {
                if ([observer.observer respondsToSelector:observer.selector]) {
                    [observer.observer performSelector:observer.selector withObject:capability];
                }
            } else {
                @throw [NSException sdl_invalidSelectorExceptionWithSelector:observer.selector];
            }
#pragma clang diagnostic pop
        }
    }

    if (handler == nil) { return value; }
    handler(nil, self);

    return value;
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

#pragma mark - Subscriptions

- (nullable id<NSObject>)subscribeToCapabilityType:(SDLSystemCapabilityType)type withBlock:(SDLCapabilityUpdateHandler)block {
    if (!self.supportsSubscriptions) { return nil; }

    SDLSystemCapabilityObserver *observerObject = [[SDLSystemCapabilityObserver alloc] initWithObserver:[[NSObject alloc] init] block:block];
    [self.capabilityObservers[type] addObject:observerObject];

    return observerObject.observer;
}

- (BOOL)subscribeToCapabilityType:(SDLSystemCapabilityType)type withObserver:(id<NSObject>)observer selector:(SEL)selector {
    if (!self.supportsSubscriptions) { return NO; }

    NSUInteger numberOfParametersInSelector = [NSStringFromSelector(selector) componentsSeparatedByString:@":"].count - 1;
    if (numberOfParametersInSelector > 1) { return NO; }

    SDLSystemCapabilityObserver *observerObject = [[SDLSystemCapabilityObserver alloc] initWithObserver:observer selector:selector];
    [self.capabilityObservers[type] addObject:observerObject];

    return observerObject.observer;
}

- (void)unsubscribeFromCapabilityType:(SDLSystemCapabilityType)type withObserver:(id)observer {
    for (SDLSystemCapabilityObserver *capabilityObserver in self.capabilityObservers[type]) {
        if ([observer isEqual:capabilityObserver.observer]) {
            [self.capabilityObservers[type] removeObject:capabilityObserver];
            break;
        }
    }
}

@end

NS_ASSUME_NONNULL_END
