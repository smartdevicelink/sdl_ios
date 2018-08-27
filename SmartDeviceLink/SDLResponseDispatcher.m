//
//  SDLResponseDispatcher.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/8/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLResponseDispatcher.h"

#import "NSMutableDictionary+SafeRemove.h"
#import "SDLAddCommand.h"
#import "SDLAlert.h"
#import "SDLButtonName.h"
#import "SDLDeleteCommand.h"
#import "SDLDeleteCommandResponse.h"
#import "SDLError.h"
#import "SDLLogMacros.h"
#import "SDLOnAudioPassThru.h"
#import "SDLOnButtonEvent.h"
#import "SDLOnButtonPress.h"
#import "SDLOnCommand.h"
#import "SDLPerformAudioPassThru.h"
#import "SDLPerformAudioPassThruResponse.h"
#import "SDLRPCResponse.h"
#import "SDLResult.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLScrollableMessage.h"
#import "SDLShow.h"
#import "SDLSoftButton.h"
#import "SDLSubscribeButton.h"
#import "SDLUnsubscribeButton.h"
#import "SDLUnsubscribeButtonResponse.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLResponseDispatcher ()

@property (strong, nonatomic, readwrite, nullable) SDLAudioPassThruHandler audioPassThruHandler;

@end


@implementation SDLResponseDispatcher

- (instancetype)init {
    return [self initWithNotificationDispatcher:nil];
}

- (instancetype)initWithNotificationDispatcher:(nullable id)dispatcher {
    self = [super init];
    if (!self) {
        return nil;
    }

    _rpcResponseHandlerMap = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:NSMapTableCopyIn];
    _rpcRequestDictionary = [NSMutableDictionary dictionary];
    _commandHandlerMap = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:NSMapTableCopyIn];
    _buttonHandlerMap = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:NSMapTableCopyIn];
    _customButtonHandlerMap = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn valueOptions:NSMapTableCopyIn];

    // Responses
    for (SDLNotificationName responseName in [SDLNotificationConstants allResponseNames]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_runHandlersForResponse:) name:responseName object:dispatcher];
    }

    // Buttons
    for (SDLNotificationName buttonNotificationName in [SDLNotificationConstants allButtonEventNotifications]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_runHandlerForButton:) name:buttonNotificationName object:dispatcher];
    }

    // Commands
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_runHandlerForCommand:) name:SDLDidReceiveCommandNotification object:dispatcher];
    
    // Audio Pass Thru
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_runHandlerForAudioPassThru:) name:SDLDidReceiveAudioPassThruNotification object:dispatcher];

    return self;
}


#pragma mark - Storage

- (void)storeRequest:(SDLRPCRequest *)request handler:(nullable SDLResponseHandler)handler {
    NSNumber *correlationId = request.correlationID;

    // Check for RPCs that require an extra handler
    if ([request isKindOfClass:[SDLAddCommand class]]) {
        SDLAddCommand *addCommand = (SDLAddCommand *)request;
        if (!addCommand.cmdID) {
            @throw [NSException sdl_missingIdException];
        }
        if (addCommand.handler) {
            self.commandHandlerMap[addCommand.cmdID] = addCommand.handler;
        }
    } else if ([request isKindOfClass:[SDLSubscribeButton class]]) {
        // Convert SDLButtonName to NSString, since it doesn't conform to <NSCopying>
        SDLSubscribeButton *subscribeButton = (SDLSubscribeButton *)request;
        SDLButtonName buttonName = subscribeButton.buttonName;
        if (!buttonName) {
            @throw [NSException sdl_missingIdException];
        }
        if (subscribeButton.handler) {
            self.buttonHandlerMap[buttonName] = subscribeButton.handler;
        }
    } else if ([request isKindOfClass:[SDLAlert class]]) {
        SDLAlert *alert = (SDLAlert *)request;
        [self sdl_addToCustomButtonHandlerMap:alert.softButtons];
    } else if ([request isKindOfClass:[SDLScrollableMessage class]]) {
        SDLScrollableMessage *scrollableMessage = (SDLScrollableMessage *)request;
        [self sdl_addToCustomButtonHandlerMap:scrollableMessage.softButtons];
    } else if ([request isKindOfClass:[SDLShow class]]) {
        SDLShow *show = (SDLShow *)request;
        [self sdl_addToCustomButtonHandlerMap:show.softButtons];
    } else if ([request isKindOfClass:[SDLPerformAudioPassThru class]]) {
        SDLPerformAudioPassThru *performAudioPassThru = (SDLPerformAudioPassThru *)request;
        self.audioPassThruHandler = performAudioPassThru.audioDataHandler;
    }

    // Always store the request, it's needed in some cases whether or not there was a handler (e.g. DeleteCommand).
    self.rpcRequestDictionary[correlationId] = request;
    if (handler) {
        self.rpcResponseHandlerMap[correlationId] = handler;
    }
}

- (void)clear {
    // When we get disconnected we have to delete all existing responseHandlers as they are not valid anymore
    for (SDLRPCCorrelationId *correlationID in self.rpcResponseHandlerMap.dictionaryRepresentation) {
        SDLResponseHandler responseHandler = self.rpcResponseHandlerMap[correlationID];
        responseHandler(self.rpcRequestDictionary[correlationID], nil, [NSError sdl_lifecycle_notConnectedError]);
    }
    [self.rpcRequestDictionary removeAllObjects];
    [self.rpcResponseHandlerMap removeAllObjects];
    [self.commandHandlerMap removeAllObjects];
    [self.buttonHandlerMap removeAllObjects];
    [self.customButtonHandlerMap removeAllObjects];
    _audioPassThruHandler = nil;
}

- (void)sdl_addToCustomButtonHandlerMap:(NSArray<SDLSoftButton *> *)softButtons {
    for (SDLSoftButton *sb in softButtons) {
        if (!sb.softButtonID) {
            @throw [NSException sdl_missingIdException];
        }
        if (sb.handler) {
            self.customButtonHandlerMap[sb.softButtonID] = sb.handler;
        }
    }
}


#pragma mark - Notification Handler

// Called by notifications
- (void)sdl_runHandlersForResponse:(SDLRPCResponseNotification *)notification {
    if (![notification isResponseKindOfClass:[SDLRPCResponse class]]) {
        return;
    }

    __kindof SDLRPCResponse *response = notification.response;

    NSError *error = nil;
    if (![response.success boolValue]) {
        error = [NSError sdl_lifecycle_rpcErrorWithDescription:response.resultCode andReason:response.info];
    }

    // Find the appropriate request completion handler, remove the request and response handler
    SDLResponseHandler handler = self.rpcResponseHandlerMap[response.correlationID];
    SDLRPCRequest *request = self.rpcRequestDictionary[response.correlationID];
    [self.rpcRequestDictionary safeRemoveObjectForKey:response.correlationID];
    [self.rpcResponseHandlerMap safeRemoveObjectForKey:response.correlationID];

    // Run the response handler
    if (handler) {
        if (!response.success.boolValue) {
            SDLLogW(@"Request failed: %@, response: %@, error: %@", request, response, error);
        }
        handler(request, response, error);
    }

    // If we errored on the response, the delete / unsubscribe was unsuccessful
    if (error) {
        return;
    }

    // If it's a DeleteCommand, UnsubscribeButton, or PerformAudioPassThru we need to remove handlers for the corresponding RPCs
    if ([response isKindOfClass:[SDLDeleteCommandResponse class]]) {
        SDLDeleteCommand *deleteCommandRequest = (SDLDeleteCommand *)request;
        NSNumber *deleteCommandId = deleteCommandRequest.cmdID;
        [self.commandHandlerMap safeRemoveObjectForKey:deleteCommandId];
    } else if ([response isKindOfClass:[SDLUnsubscribeButtonResponse class]]) {
        SDLUnsubscribeButton *unsubscribeButtonRequest = (SDLUnsubscribeButton *)request;
        SDLButtonName unsubscribeButtonName = unsubscribeButtonRequest.buttonName;
        [self.buttonHandlerMap safeRemoveObjectForKey:unsubscribeButtonName];
    } else if ([response isKindOfClass:[SDLPerformAudioPassThruResponse class]]) {
        _audioPassThruHandler = nil;
    }
}

#pragma mark Command

- (void)sdl_runHandlerForCommand:(SDLRPCNotificationNotification *)notification {
    SDLOnCommand *onCommandNotification = notification.notification;
    SDLRPCCommandNotificationHandler handler = self.commandHandlerMap[onCommandNotification.cmdID];

    if (handler) {
        handler(onCommandNotification);
    }
}

#pragma mark Button

- (void)sdl_runHandlerForButton:(SDLRPCNotificationNotification *)notification {
    __kindof SDLRPCNotification *rpcNotification = notification.notification;

    SDLRPCButtonNotificationHandler handler = nil;
    SDLButtonName name = nil;
    NSNumber *customID = nil;

    if ([rpcNotification isMemberOfClass:[SDLOnButtonEvent class]]) {
        name = ((SDLOnButtonEvent *)rpcNotification).buttonName;
        customID = ((SDLOnButtonEvent *)rpcNotification).customButtonID;
    } else if ([rpcNotification isMemberOfClass:[SDLOnButtonPress class]]) {
        name = ((SDLOnButtonPress *)rpcNotification).buttonName;
        customID = ((SDLOnButtonPress *)rpcNotification).customButtonID;
    }

    if ([name isEqualToEnum:SDLButtonNameCustomButton]) {
        handler = self.customButtonHandlerMap[customID];
    } else {
        handler = self.buttonHandlerMap[name];
    }

    if (handler) {
        if ([rpcNotification isMemberOfClass:[SDLOnButtonEvent class]]) {
            handler(nil, rpcNotification);
        } else if ([rpcNotification isMemberOfClass:[SDLOnButtonPress class]]) {
            handler(rpcNotification, nil);
        }
    }
}
    
#pragma mark Audio Pass Thru
    
- (void)sdl_runHandlerForAudioPassThru:(SDLRPCNotificationNotification *)notification {
    SDLOnAudioPassThru *onAudioPassThruNotification = notification.notification;
    
    if (self.audioPassThruHandler) {
        self.audioPassThruHandler(onAudioPassThruNotification.bulkData);
    }
}

@end

NS_ASSUME_NONNULL_END
