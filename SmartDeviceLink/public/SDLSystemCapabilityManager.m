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
#import "SDLDriverDistractionCapability.h"
#import "SDLError.h"
#import "SDLGenericResponse.h"
#import "SDLGetSystemCapability.h"
#import "SDLGetSystemCapabilityResponse.h"
#import "SDLGlobals.h"
#import "SDLHMICapabilities.h"
#import "SDLImageField+ScreenManagerExtensions.h"
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
#import "SDLTextField+ScreenManagerExtensions.h"
#import "SDLTextFieldName.h"
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
@property (nullable, strong, nonatomic, readwrite) SDLDriverDistractionCapability *driverDistractionCapability;

@property (nullable, strong, nonatomic) NSMutableDictionary<SDLServiceID, SDLAppServiceCapability *> *appServicesCapabilitiesDictionary;

@property (assign, nonatomic, readwrite) BOOL supportsSubscriptions;
@property (strong, nonatomic) NSMutableDictionary<SDLSystemCapabilityType, NSMutableArray<SDLSystemCapabilityObserver *> *> *capabilityObservers;
@property (strong, nonatomic) NSMutableDictionary<SDLSystemCapabilityType, NSNumber<SDLBool> *> *subscriptionStatus;

@property (assign, nonatomic) BOOL shouldConvertDeprecatedDisplayCapabilities;
@property (strong, nonatomic) SDLHMILevel currentHMILevel;

@property (copy, nonatomic) dispatch_queue_t readWriteQueue;

@end

@implementation SDLSystemCapabilityManager

#pragma mark - Lifecycle

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)manager {
    self = [super init];
    if (!self) {
        return nil;
    }

    if (@available(iOS 10.0, *)) {
        _readWriteQueue = dispatch_queue_create_with_target("com.sdl.systemCapabilityManager.readWriteQueue", DISPATCH_QUEUE_SERIAL, [SDLGlobals sharedGlobals].sdlProcessingQueue);
    } else {
        _readWriteQueue = [SDLGlobals sharedGlobals].sdlProcessingQueue;
    }

    _connectionManager = manager;
    _shouldConvertDeprecatedDisplayCapabilities = YES;
    _appServicesCapabilitiesDictionary = [NSMutableDictionary dictionary];

    _capabilityObservers = [NSMutableDictionary dictionary];
    _subscriptionStatus = [NSMutableDictionary dictionary];

    _currentHMILevel = SDLHMILevelNone;

    [self sdl_registerForNotifications];

    return self;
}

- (void)start { }

/**
 *  Resets the capabilities when a transport session is closed.
 */
- (void)stop {
    SDLLogD(@"System Capability manager stopped");
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        self.displayCapabilities = nil;
        self.displays = nil;
        self.hmiCapabilities = nil;
        self.softButtonCapabilities = nil;
        self.buttonCapabilities = nil;
        self.presetBankCapabilities = nil;
        self.hmiZoneCapabilities = nil;
        self.speechCapabilities = nil;
        self.prerecordedSpeechCapabilities = nil;
        self.vrCapability = NO;
        self.audioPassThruCapabilities = nil;
        self.pcmStreamCapability = nil;
        self.navigationCapability = nil;
        self.phoneCapability = nil;
        self.videoStreamingCapability = nil;
        self.remoteControlCapability = nil;
        self.seatLocationCapability = nil;
        self.driverDistractionCapability = nil;

        self.supportsSubscriptions = NO;

        self.appServicesCapabilitiesDictionary = [NSMutableDictionary dictionary];
        [self.capabilityObservers removeAllObjects];
        [self.subscriptionStatus removeAllObjects];

        self.currentHMILevel = SDLHMILevelNone;
        self.shouldConvertDeprecatedDisplayCapabilities = YES;
    }];
}

#pragma mark - Getters

- (BOOL)supportsSubscriptions {
    return [[SDLGlobals sharedGlobals].rpcVersion isGreaterThanOrEqualToVersion:[SDLVersion versionWithString:@"5.1.0"]];
}

- (nullable SDLAppServicesCapabilities *)appServicesCapabilities {
    if (self.appServicesCapabilitiesDictionary.count == 0) { return nil; }

    return [[SDLAppServicesCapabilities alloc] initWithAppServices:self.appServicesCapabilitiesDictionary.allValues];
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

#pragma mark Convert Deprecated to New

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
/// Convert the capabilities from a `RegisterAppInterfaceResponse` into a new-style `DisplayCapability` for the main display.
/// @param rpc The `RegisterAppInterfaceResponse` RPC
- (NSArray<SDLDisplayCapability *> *)sdl_createDisplayCapabilityListFromRegisterResponse:(SDLRegisterAppInterfaceResponse *)rpc {
    return [self sdl_createDisplayCapabilityListFromDeprecatedDisplayCapabilities:rpc.displayCapabilities buttons:rpc.buttonCapabilities softButtons:rpc.softButtonCapabilities];
}

- (NSArray<SDLDisplayCapability *> *)sdl_createDisplayCapabilityListFromSetDisplayLayoutResponse:(SDLSetDisplayLayoutResponse *)rpc {
    return [self sdl_createDisplayCapabilityListFromDeprecatedDisplayCapabilities:rpc.displayCapabilities buttons:rpc.buttonCapabilities softButtons:rpc.softButtonCapabilities];
}
#pragma clang diagnostic pop

/// Creates a "new-style" display capability from the "old-style" `SDLDisplayCapabilities` object and other "old-style" objects that were returned in `RegisterAppInterfaceResponse` and `SetDisplayLayoutResponse`
/// @param display The old-style `SDLDisplayCapabilities` object to convert
/// @param buttons The old-style `SDLButtonCapabilities` object to convert
/// @param softButtons The old-style `SDLSoftButtonCapabilities` to convert
- (NSArray<SDLDisplayCapability *> *)sdl_createDisplayCapabilityListFromDeprecatedDisplayCapabilities:(SDLDisplayCapabilities *)display buttons:(NSArray<SDLButtonCapabilities *> *)buttons softButtons:(NSArray<SDLSoftButtonCapabilities *> *)softButtons {
    SDLLogV(@"Creating display capability from deprecated display capabilities");
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
        defaultWindowCapability.textFields = [SDLTextField allTextFields];
        defaultWindowCapability.imageFields = [SDLImageField allImageFields];
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

#pragma mark Convert New to Deprecated

/// Update the internal deprecated display capability methods with new values based on the current value of the default main window capability and the primary display
- (void)sdl_updateDeprecatedDisplayCapabilities {
    SDLLogV(@"Updating deprecated capabilities from default main window capabilities");
    SDLWindowCapability *defaultMainWindowCapabilities = self.defaultMainWindowCapability;
    if (self.displays.count == 0) {
        return;
    }
    
    // Create the deprecated capabilities for backward compatibility if developers try to access them
    SDLDisplayCapabilities *convertedCapabilities = [[SDLDisplayCapabilities alloc] init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    convertedCapabilities.displayType = SDLDisplayTypeGeneric; // deprecated but it is mandatory
#pragma clang diagnostic pop
    convertedCapabilities.displayName = self.displays.firstObject.displayName;
    convertedCapabilities.textFields = [defaultMainWindowCapabilities.textFields copy];
    convertedCapabilities.imageFields = [defaultMainWindowCapabilities.imageFields copy];
    convertedCapabilities.templatesAvailable = [defaultMainWindowCapabilities.templatesAvailable copy];
    convertedCapabilities.numCustomPresetsAvailable = [defaultMainWindowCapabilities.numCustomPresetsAvailable copy];
    convertedCapabilities.mediaClockFormats = @[]; // mandatory field but allows empty array
    convertedCapabilities.graphicSupported = @([defaultMainWindowCapabilities.imageTypeSupported containsObject:SDLImageTypeDynamic]);

    self.displayCapabilities = convertedCapabilities;
    self.buttonCapabilities = defaultMainWindowCapabilities.buttonCapabilities;
    self.softButtonCapabilities = defaultMainWindowCapabilities.softButtonCapabilities;
}

#pragma mark - System Capability Updates

- (BOOL)isCapabilitySupported:(SDLSystemCapabilityType)type {
    if ([self sdl_cachedCapabilityForType:type] != nil) {
        return YES;
    } else if ([type isEqualToEnum:SDLSystemCapabilityTypePhoneCall]) {
        return self.hmiCapabilities.phoneCall.boolValue;
    } else if ([type isEqualToEnum:SDLSystemCapabilityTypeNavigation]) {
        return self.hmiCapabilities.navigation.boolValue;
    } else if ([type isEqualToEnum:SDLSystemCapabilityTypeDisplays]) {
        return self.hmiCapabilities.displays.boolValue;
    } else if ([type isEqualToEnum:SDLSystemCapabilityTypeRemoteControl]) {
        return self.hmiCapabilities.remoteControl.boolValue;
    } else if ([type isEqualToEnum:SDLSystemCapabilityTypeSeatLocation]) {
        return self.hmiCapabilities.seatLocation.boolValue;
    } else if ([type isEqualToEnum:SDLSystemCapabilityTypeDriverDistraction]) {
        return self.hmiCapabilities.driverDistraction.boolValue;
    } else if ([type isEqualToEnum:SDLSystemCapabilityTypeAppServices]) {
        //This is a corner case that the param was not available in 5.1.0, but the app services feature was available. We have to say it's available because we don't know.
        if ([[SDLGlobals sharedGlobals].rpcVersion isEqualToVersion:[SDLVersion versionWithString:@"5.1.0"]]) {
            return YES;
        }

        return self.hmiCapabilities.appServices.boolValue;
    } else if ([type isEqualToEnum:SDLSystemCapabilityTypeVideoStreaming]) {
        if ([[SDLGlobals sharedGlobals].rpcVersion isGreaterThanOrEqualToVersion:[SDLVersion versionWithString:@"3.0.0"]] && [[SDLGlobals sharedGlobals].rpcVersion isLessThanOrEqualToVersion:[SDLVersion versionWithString:@"4.4.0"]]) {
            // This was before the system capability feature was added so check if graphics are supported instead using the deprecated display capabilities
            return self.displayCapabilities.graphicSupported.boolValue;
        }

        return self.hmiCapabilities.videoStreaming.boolValue;
    } else {
        return NO;
    }


    return NO;
}

- (nullable SDLSystemCapability *)sdl_cachedCapabilityForType:(SDLSystemCapabilityType)type {
    if ([type isEqualToEnum:SDLSystemCapabilityTypePhoneCall] && self.phoneCapability != nil) {
        return [[SDLSystemCapability alloc] initWithPhoneCapability:self.phoneCapability];
    } else if ([type isEqualToEnum:SDLSystemCapabilityTypeNavigation] && self.navigationCapability != nil) {
        return [[SDLSystemCapability alloc] initWithNavigationCapability:self.navigationCapability];
    } else if ([type isEqualToEnum:SDLSystemCapabilityTypeAppServices] && self.appServicesCapabilities != nil) {
        return [[SDLSystemCapability alloc] initWithAppServicesCapabilities:self.appServicesCapabilities];
    } else if ([type isEqualToEnum:SDLSystemCapabilityTypeDisplays] && self.displays != nil) {
        return [[SDLSystemCapability alloc] initWithDisplayCapabilities:self.displays];
    } else if ([type isEqualToEnum:SDLSystemCapabilityTypeSeatLocation] && self.seatLocationCapability != nil) {
        return [[SDLSystemCapability alloc] initWithSeatLocationCapability:self.seatLocationCapability];
    } else if ([type isEqualToEnum:SDLSystemCapabilityTypeDriverDistraction] && self.driverDistractionCapability != nil) {
        return [[SDLSystemCapability alloc] initWithDriverDistractionCapability:self.driverDistractionCapability];
    } else if ([type isEqualToEnum:SDLSystemCapabilityTypeRemoteControl] && self.remoteControlCapability != nil) {
        return [[SDLSystemCapability alloc] initWithRemoteControlCapability:self.remoteControlCapability];
    } else if ([type isEqualToEnum:SDLSystemCapabilityTypeVideoStreaming] && self.videoStreamingCapability != nil) {
        return [[SDLSystemCapability alloc] initWithVideoStreamingCapability:self.videoStreamingCapability];
    } else {
        return nil;
    }
}

- (void)updateCapabilityType:(SDLSystemCapabilityType)type completionHandler:(SDLUpdateCapabilityHandler)handler {
    SDLLogV(@"Updating capability type: %@", type);
    if ([self.currentHMILevel isEqualToEnum:SDLHMILevelNone] && ![type isEqualToEnum:SDLSystemCapabilityTypeDisplays]) {
        SDLLogE(@"Attempted to update type: %@ in HMI level NONE, which is not allowed. Please wait until you are in HMI BACKGROUND, LIMITED, or FULL before attempting to update any SystemCapabilityType DISPLAYS.", type);
        return handler([NSError sdl_systemCapabilityManager_cannotUpdateInHMINONE], self);
    } else if ([type isEqualToEnum:SDLSystemCapabilityTypeDisplays]) {
        SDLLogE(@"Attempted to update type DISPLAYS, which is not allowed. You are always subscribed to displays, please either pull the cached data directly or subscribe for updates to DISPLAYS.");
        return handler([NSError sdl_systemCapabilityManager_cannotUpdateTypeDISPLAYS], self);
    }

    // If we support subscriptions and we're already subscribed
    if (self.supportsSubscriptions && [self.subscriptionStatus[type] isEqualToNumber:@YES]) {
        // Just return the cached data because we get `onSystemCapability` callbacks
        handler(nil, self);
    } else {
        // Go and get the actual data
        __weak typeof(self) weakself = self;
        [self sdl_sendGetSystemCapabilityWithType:type subscribe:nil completionHandler:^(SDLSystemCapability * _Nonnull capability, BOOL subscribed, NSError * _Nonnull error) {
            handler(error, weakself);
        }];
    }
}

# pragma mark Subscribing

/// Sends a GetSystemCapability and sends back the response
/// @param type The type to get
/// @param subscribe Whether to change the subscription status. YES to subscribe, NO to unsubscribe, nil to keep whatever the current state is
/// @param handler The handler to be returned
- (void)sdl_sendGetSystemCapabilityWithType:(SDLSystemCapabilityType)type subscribe:(nullable NSNumber<SDLBool> *)subscribe completionHandler:(nullable SDLCapabilityUpdateWithErrorHandler)handler {
    SDLLogV(@"Sending GetSystemCapability with type: %@, subscribe: %@", type, subscribe);
    SDLGetSystemCapability *getSystemCapability = [[SDLGetSystemCapability alloc] initWithType:type];
    getSystemCapability.subscribe = subscribe;

    __weak typeof(self) weakself = self;
    [self.connectionManager sendConnectionRequest:getSystemCapability withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (![response isKindOfClass:[SDLGetSystemCapabilityResponse class]]) {
            SDLLogE(@"GetSystemCapability failed, type: %@, did not return a GetSystemCapability response", type);
            if (handler == nil) { return; }
            handler(nil, NO, [NSError sdl_systemCapabilityManager_moduleDoesNotSupportSystemCapabilities]);
            return;
        }

        if (response.success.boolValue == false) {
            SDLLogE(@"GetSystemCapability failed, type: %@, error: %@", type, error);
            if (handler == nil) { return; }
            handler(nil, NO, error);
            return;
        }

        SDLGetSystemCapabilityResponse *getSystemCapabilityResponse = (SDLGetSystemCapabilityResponse *)response;
        SDLLogD(@"GetSystemCapability response succeeded, type: %@, response: %@", type, getSystemCapabilityResponse);

        if (![weakself.subscriptionStatus[type] isEqualToNumber:subscribe] && weakself.supportsSubscriptions) {
            [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
                weakself.subscriptionStatus[type] = subscribe;
            }];
        }

        [weakself sdl_saveSystemCapability:getSystemCapabilityResponse.systemCapability error:error completionHandler:handler];
    }];
}

#pragma mark Saving Capability Responses

/**
 Saves a system capability. All system capabilities will update with the full object except for app services. For app services only the updated app service capabilities will be included in the `SystemCapability` sent from Core. The cached `appServicesCapabilities` will be updated with the new `appService` data.

 @param systemCapability The system capability to be saved
 @param handler The handler to be called when the save completes
 @return Whether or not the save occurred. This can be `NO` if the new system capability is equivalent to the old capability.
 */
- (BOOL)sdl_saveSystemCapability:(nullable SDLSystemCapability *)systemCapability error:(nullable NSError *)error completionHandler:(nullable SDLCapabilityUpdateWithErrorHandler)handler {
    SDLLogV(@"Saving system capability type: %@", systemCapability);

    SDLSystemCapabilityType systemCapabilityType = systemCapability.systemCapabilityType;

    if ([systemCapabilityType isEqualToEnum:SDLSystemCapabilityTypePhoneCall]) {
        if ([self.phoneCapability isEqual:systemCapability.phoneCapability]) {
            [self sdl_callObserversForUpdate:systemCapability error:error handler:handler];
            return NO;
        }
        self.phoneCapability = systemCapability.phoneCapability;
    } else if ([systemCapabilityType isEqualToEnum:SDLSystemCapabilityTypeNavigation]) {
        if ([self.navigationCapability isEqual:systemCapability.navigationCapability]) {
            [self sdl_callObserversForUpdate:systemCapability error:error handler:handler];
            return NO;
        }
        self.navigationCapability = systemCapability.navigationCapability;
    } else if ([systemCapabilityType isEqualToEnum:SDLSystemCapabilityTypeRemoteControl]) {
        if ([self.remoteControlCapability isEqual:systemCapability.remoteControlCapability]) {
            [self sdl_callObserversForUpdate:systemCapability error:error handler:handler];
            return NO;
        }
        self.remoteControlCapability = systemCapability.remoteControlCapability;
    } else if ([systemCapabilityType isEqualToEnum:SDLSystemCapabilityTypeSeatLocation]) {
        if ([self.seatLocationCapability isEqual:systemCapability.seatLocationCapability]) {
            [self sdl_callObserversForUpdate:systemCapability error:error handler:handler];
            return NO;
        }
        self.seatLocationCapability = systemCapability.seatLocationCapability;
    } else if ([systemCapabilityType isEqualToEnum:SDLSystemCapabilityTypeDriverDistraction]) {
        if ([self.driverDistractionCapability isEqual:systemCapability.driverDistractionCapability]) {
            [self sdl_callObserversForUpdate:systemCapability error:error handler:handler];
            return NO;
        }
        self.driverDistractionCapability = systemCapability.driverDistractionCapability;
    } else if ([systemCapabilityType isEqualToEnum:SDLSystemCapabilityTypeVideoStreaming]) {
        if ([self.videoStreamingCapability isEqual:systemCapability.videoStreamingCapability]) {
            [self sdl_callObserversForUpdate:systemCapability error:error handler:handler];
            return NO;
        }
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

    [self sdl_callObserversForUpdate:systemCapability error:error handler:handler];
    return YES;
}

#pragma mark Merge Capability Deltas

- (void)sdl_saveAppServicesCapabilitiesUpdate:(SDLAppServicesCapabilities *)newCapabilities {
    SDLLogV(@"Saving app services capability update with new capabilities: %@", newCapabilities);
    for (SDLAppServiceCapability *capability in newCapabilities.appServices) {
        // If the capability has been removed, delete the saved capability; otherwise just update with the new capability
        SDLAppServiceCapability *newCapability = [capability.updateReason isEqualToEnum:SDLServiceUpdateRemoved] ? nil : capability;
        [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
            self.appServicesCapabilitiesDictionary[capability.updatedAppServiceRecord.serviceID] = newCapability;
        }];
    }
}

/// Save a new new-style `DisplayCapability` update (only contains the delta) that was received by merging it with the existing version.
/// @param newCapabilities The new `DisplayCapability` update delta.
- (void)sdl_saveDisplayCapabilityListUpdate:(NSArray<SDLDisplayCapability *> *)newCapabilities {
    NSArray<SDLDisplayCapability *> *oldCapabilities = self.displays;
    SDLLogV(@"Saving display capability update with new capabilities: %@", newCapabilities);

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
                // Replace the old window caps with new ones
                copyWindowCapabilities[i] = newWindow;
                oldFound = true;
                break;
            }
        }

        if (!oldFound) {
            // This is a new unknown window
            [copyWindowCapabilities addObject:newWindow];
        }
    }

    // replace the window capabilities array with the merged one.
    newDefaultDisplayCapabilities.windowCapabilities = [copyWindowCapabilities copy];
    self.displays = @[newDefaultDisplayCapabilities];
    [self sdl_updateDeprecatedDisplayCapabilities];
}

#pragma mark - Manager Subscriptions

#pragma mark Subscribing

- (nullable id<NSObject>)subscribeToCapabilityType:(SDLSystemCapabilityType)type withBlock:(SDLCapabilityUpdateHandler)block {
    SDLLogD(@"Subscribing to capability type: %@ with a handler (DEPRECATED)", type);
    SDLSystemCapabilityObserver *observerObject = [[SDLSystemCapabilityObserver alloc] initWithObserver:[[NSObject alloc] init] block:block];

    id<NSObject> subscribedObserver = [self sdl_subscribeToCapabilityType:type observerObject:observerObject];
    return subscribedObserver;
}

- (nullable id<NSObject>)subscribeToCapabilityType:(SDLSystemCapabilityType)type withUpdateHandler:(SDLCapabilityUpdateWithErrorHandler)handler {
    SDLLogD(@"Subscribing to capability type: %@ with a handler", type);
    SDLSystemCapabilityObserver *observerObject = [[SDLSystemCapabilityObserver alloc] initWithObserver:[[NSObject alloc] init] updateHandler:handler];

    id<NSObject> subscribedObserver = [self sdl_subscribeToCapabilityType:type observerObject:observerObject];
    return subscribedObserver;
}

- (BOOL)subscribeToCapabilityType:(SDLSystemCapabilityType)type withObserver:(id<NSObject>)observer selector:(SEL)selector {
    SDLLogD(@"Subscribing to capability type: %@, with observer: %@, selector: %@", type, observer, NSStringFromSelector(selector));
    NSUInteger numberOfParametersInSelector = [NSStringFromSelector(selector) componentsSeparatedByString:@":"].count - 1;
    if (numberOfParametersInSelector > 3) {
        SDLLogE(@"Attempted to subscribe to a capability using a selector that contains more than 3 parameters.");
        return NO;
    }

    if (observer == nil) {
        SDLLogE(@"Attempted to subscribe to type: %@ with a selector on a *nil* observer, which will always fail.", type);
        return NO;
    }

    SDLSystemCapabilityObserver *observerObject = [[SDLSystemCapabilityObserver alloc] initWithObserver:observer selector:selector];

    id<NSObject> subscribedObserver = [self sdl_subscribeToCapabilityType:type observerObject:observerObject];
    return subscribedObserver == nil ? NO : YES;
}

/// Helper method for subscribing to a system capability type
/// @param type The SystemCapabilityType that will be subscribed
/// @param observerObject An object that can be used to unsubscribe the block. If nil, the subscription was not succesful.
/// @return The observer if the subscription was succesful; nil if not.
- (nullable id<NSObject>)sdl_subscribeToCapabilityType:(SDLSystemCapabilityType)type observerObject:(SDLSystemCapabilityObserver *)observerObject {
    if ([self.currentHMILevel isEqualToEnum:SDLHMILevelNone] && ![type isEqualToEnum:SDLSystemCapabilityTypeDisplays]) {
        SDLLogE(@"Attempted to subscribe to type: %@ in HMI level NONE, which is not allowed. Please wait until you are in HMI BACKGROUND, LIMITED, or FULL before attempting to subscribe to any SystemCapabilityType other than DISPLAYS.", type);
        [self sdl_invokeObserver:observerObject withCapabilityType:type capability:nil error:[NSError sdl_systemCapabilityManager_cannotUpdateInHMINONE]];
        return nil;
    }

    if (self.capabilityObservers[type] == nil) {
        SDLLogD(@"This is the first subscription to capability type: %@, sending a GetSystemCapability with subscribe true", type);

        [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
            self.capabilityObservers[type] = [NSMutableArray arrayWithObject:observerObject];
        }];

        // We don't want to send this for the displays type because that's automatically subscribed
        if (![type isEqualToEnum:SDLSystemCapabilityTypeDisplays]) {
            [self sdl_sendGetSystemCapabilityWithType:type subscribe:@YES completionHandler:nil];
        } else {
            // If we're not calling the GSC RPC we should invoke the observer with the cached data
            [self sdl_invokeObserver:observerObject withCapabilityType:type capability:[self sdl_cachedCapabilityForType:type] error:nil];
        }
    } else {
        // Store the observer and call it immediately with the cached value
        [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
            [self.capabilityObservers[type] addObject:observerObject];
        }];

        [self sdl_invokeObserver:observerObject withCapabilityType:type capability:[self sdl_cachedCapabilityForType:type] error:nil];
    }

    return observerObject.observer;
}

#pragma mark Unubscribing

- (void)unsubscribeFromCapabilityType:(SDLSystemCapabilityType)type withObserver:(id)observer {
    SDLLogD(@"Unsubscribing from capability type: %@", type);
    for (SDLSystemCapabilityObserver *capabilityObserver in self.capabilityObservers[type]) {
        if ([observer isEqual:capabilityObserver.observer] && self.capabilityObservers[type] != nil) {
            [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
                [self.capabilityObservers[type] removeObject:capabilityObserver];
            }];

            [self sdl_removeNilObserversAndUnsubscribeIfNecessary];
            break;
        }
    }
}

- (void)sdl_removeNilObserversAndUnsubscribeIfNecessary {
    SDLLogV(@"Checking for nil observers and removing them, then checking for subscriptions we don't need and unsubscribing.");
    // Loop through our observers
    for (SDLSystemCapabilityType key in self.capabilityObservers.allKeys) {
        for (SDLSystemCapabilityObserver *observer in self.capabilityObservers[key]) {
            [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
                // If an observer object is nil, remove it
                if (observer.observer == nil) {
                    [self.capabilityObservers[key] removeObject:observer];
                }

                // If we no longer have any observers for that type, remove the array
                if (self.capabilityObservers[key].count == 0) {
                    [self.capabilityObservers removeObjectForKey:key];
                }
            }];
        }
    }

    // If we don't support subscriptions, we don't want to unsubscribe by sending an RPC below
    if (!self.supportsSubscriptions) {
        return;
    }

    // Loop through our subscription statuses, check if we're subscribed. If we are, and we do not have observers for that type, and that type is not DISPLAYS, then unsubscribe.
    for (SDLSystemCapabilityType type in self.subscriptionStatus.allKeys) {
        if ([self.subscriptionStatus[type] isEqualToNumber:@YES]
            && self.capabilityObservers[type] == nil
            && ![type isEqualToEnum:SDLSystemCapabilityTypeDisplays]) {
            SDLLogD(@"Removing the last subscription to type %@, sending a GetSystemCapability with subscribe false (will unsubscribe)", type);
            [self sdl_sendGetSystemCapabilityWithType:type subscribe:@NO completionHandler:nil];
        }
    }
}

#pragma mark Notifying Subscribers

/// Calls all observers of a capability type with an updated capability
/// @param capability The new capability update
/// @param handler The update handler to call, if one exists after the observers are called
- (void)sdl_callObserversForUpdate:(nullable SDLSystemCapability *)capability error:(nullable NSError *)error handler:(nullable SDLCapabilityUpdateWithErrorHandler)handler {
    SDLSystemCapabilityType type = capability.systemCapabilityType;
    SDLLogV(@"Calling observers for type: %@ with update: %@", type, capability);

    [self sdl_removeNilObserversAndUnsubscribeIfNecessary];

    for (SDLSystemCapabilityObserver *observer in self.capabilityObservers[type]) {
        [self sdl_invokeObserver:observer withCapabilityType:type capability:capability error:error];
    }

    if (handler == nil) { return; }
    handler(capability, self.subscriptionStatus[type].boolValue, error);
}

- (void)sdl_invokeObserver:(SDLSystemCapabilityObserver *)observer withCapabilityType:(SDLSystemCapabilityType)type capability:(nullable SDLSystemCapability *)capability error:(nullable NSError *)error {
    BOOL subscribed = self.subscriptionStatus[type].boolValue || [type isEqualToEnum:SDLSystemCapabilityTypeDisplays];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (observer.block != nil) {
        observer.block(capability);
#pragma clang diagnostic pop
    } else if (observer.updateBlock != nil) {
        observer.updateBlock(capability, subscribed, error);
    } else {
        if (![observer.observer respondsToSelector:observer.selector]) {
            @throw [NSException sdl_invalidSystemCapabilitySelectorExceptionWithSelector:observer.selector];
        }

        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[(NSObject *)observer.observer methodSignatureForSelector:observer.selector]];
        [invocation setSelector:observer.selector];
        [invocation setTarget:observer.observer];

        NSUInteger numberOfParametersInSelector = [NSStringFromSelector(observer.selector) componentsSeparatedByString:@":"].count - 1;
        if (numberOfParametersInSelector >= 1) {
            [invocation setArgument:&capability atIndex:2];
        }
        if (numberOfParametersInSelector >= 2) {
            [invocation setArgument:&error atIndex:3];
        }
        if (numberOfParametersInSelector >= 3) {
            [invocation setArgument:&subscribed atIndex:4];
        }
        if (numberOfParametersInSelector >= 4) {
            @throw [NSException sdl_invalidSystemCapabilitySelectorExceptionWithSelector:observer.selector];
        }

        [invocation invoke];
    }
}

#pragma mark - Notifications

/// Registers for notifications and responses from Core
- (void)sdl_registerForNotifications {
    SDLLogV(@"Registering for notifications");
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

    SDLLogV(@"Received RegisterAppInterface response, filled out display and other capabilities");

    // Call the observers in case the new display capability list is created from deprecated types
    SDLSystemCapability *systemCapability = [[SDLSystemCapability alloc] initWithDisplayCapabilities:self.displays];
    [self sdl_callObserversForUpdate:systemCapability error:nil handler:nil];
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

    // If we've received a display capability update then we should not convert our deprecated display capabilities and we should just return
    if (!self.shouldConvertDeprecatedDisplayCapabilities) { return; }

    self.displayCapabilities = response.displayCapabilities;
    self.buttonCapabilities = response.buttonCapabilities;
    self.softButtonCapabilities = response.softButtonCapabilities;
    self.presetBankCapabilities = response.presetBankCapabilities;

    self.displays = [self sdl_createDisplayCapabilityListFromSetDisplayLayoutResponse:response];

    SDLLogV(@"Received SetDisplayLayout response, filled out display and other capabilities");

    // Call the observers in case the new display capability list is created from deprecated types
    SDLSystemCapability *systemCapability = [[SDLSystemCapability alloc] initWithDisplayCapabilities:self.displays];
    [self sdl_callObserversForUpdate:systemCapability error:nil handler:nil];
}

/**
 *  Called when an `OnSystemCapabilityUpdated` notification is received from Core. The updated system capabilty is saved.
 *
 *  @param notification The `OnSystemCapabilityUpdated` notification received from Core
 */
- (void)sdl_systemCapabilityUpdatedNotification:(SDLRPCNotificationNotification *)notification {
    SDLOnSystemCapabilityUpdated *systemCapabilityUpdatedNotification = (SDLOnSystemCapabilityUpdated *)notification.notification;
    SDLLogV(@"Received OnSystemCapability update for type %@", systemCapabilityUpdatedNotification.systemCapability.systemCapabilityType);

    [self sdl_saveSystemCapability:systemCapabilityUpdatedNotification.systemCapability error:nil completionHandler:nil];
}

- (void)sdl_hmiStatusNotification:(SDLRPCNotificationNotification *)notification {
    SDLOnHMIStatus *onHMIStatus = (SDLOnHMIStatus *)notification.notification;
    self.currentHMILevel = onHMIStatus.hmiLevel;
}


#pragma mark Getters

- (NSMutableDictionary<SDLSystemCapabilityType, NSMutableArray<SDLSystemCapabilityObserver *> *> *)capabilityObservers {
    __block NSMutableDictionary<SDLSystemCapabilityType, NSMutableArray<SDLSystemCapabilityObserver *> *> *dict = nil;
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        dict = self->_capabilityObservers;
    }];

    return dict;
}

- (NSMutableDictionary<SDLSystemCapabilityType, NSNumber<SDLBool> *> *)subscriptionStatus {
    __block NSMutableDictionary<SDLSystemCapabilityType, NSNumber<SDLBool> *> *dict = nil;
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        dict = self->_subscriptionStatus;
    }];

    return dict;
}

- (nullable NSMutableDictionary<SDLServiceID, SDLAppServiceCapability *> *)appServicesCapabilitiesDictionary {
    __block NSMutableDictionary<SDLServiceID, SDLAppServiceCapability *> *dict = nil;
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        dict = self->_appServicesCapabilitiesDictionary;
    }];

    return dict;
}

@end

NS_ASSUME_NONNULL_END
