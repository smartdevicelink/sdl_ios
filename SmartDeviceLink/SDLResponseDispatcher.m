//
//  SDLResponseDispatcher.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/8/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLResponseDispatcher.h"

#import "NSMutableArray+Safe.h"
#import "NSMutableDictionary+SafeRemove.h"
#import "SDLAddCommand.h"
#import "SDLAlert.h"
#import "SDLButtonName.h"
#import "SDLDeleteCommand.h"
#import "SDLDeleteCommandResponse.h"
#import "SDLError.h"
#import "SDLGlobals.h"
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

@property (copy, nonatomic) dispatch_queue_t readWriteQueue;

@property (strong, nonatomic, readwrite) NSMapTable<SDLRPCCorrelationId *, SDLResponseHandler> *rpcResponseHandlerMap;
@property (strong, nonatomic, readwrite) NSMutableDictionary<SDLRPCCorrelationId *, SDLRPCRequest *> *rpcRequestDictionary;
@property (strong, nonatomic, readwrite) NSMapTable<SDLAddCommandCommandId *, SDLRPCCommandNotificationHandler> *commandHandlerMap;
@property (strong, nonatomic, readwrite) NSMapTable<SDLSubscribeButtonName *, SDLRPCButtonNotificationHandler> *buttonHandlerMap;
@property (strong, nonatomic, readwrite) NSMapTable<SDLSoftButtonId *, SDLRPCButtonNotificationHandler> *customButtonHandlerMap;
@property (strong, nonatomic, readwrite, nullable) SDLAudioPassThruHandler audioPassThruHandler;

@end


// https://www.objc.io/issues/2-concurrency/low-level-concurrency-apis/#multiple-readers-single-writer
@implementation SDLResponseDispatcher

- (instancetype)init {
    return [self initWithNotificationDispatcher:nil];
}

- (instancetype)initWithNotificationDispatcher:(nullable id)dispatcher {
    self = [super init];
    if (!self) {
        return nil;
    }

    if (@available(iOS 10.0, *)) {
        _readWriteQueue = dispatch_queue_create_with_target("com.sdl.lifecycle.responseDispatcher", DISPATCH_QUEUE_SERIAL, [SDLGlobals sharedGlobals].sdlProcessingQueue);
    } else {
        _readWriteQueue = [SDLGlobals sharedGlobals].sdlProcessingQueue;
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
    __weak typeof(self) weakself = self;
    NSNumber *correlationId = request.correlationID;

    // Check for RPCs that require an extra handler
    if ([request isKindOfClass:[SDLAddCommand class]]) {
        SDLAddCommand *addCommand = (SDLAddCommand *)request;
        if (addCommand.cmdID == nil) {
            @throw [NSException sdl_missingIdException];
        }
        if (addCommand.handler != nil) {
            [self sdl_runAsyncOnQueue:^{
                __strong typeof(weakself) strongself = weakself;
                strongself->_commandHandlerMap[addCommand.cmdID] = addCommand.handler;
            }];
        }
    } else if ([request isKindOfClass:[SDLSubscribeButton class]]) {
        // Convert SDLButtonName to NSString, since it doesn't conform to <NSCopying>
        SDLSubscribeButton *subscribeButton = (SDLSubscribeButton *)request;
        SDLButtonName buttonName = subscribeButton.buttonName;
        if (buttonName == nil) {
            @throw [NSException sdl_missingIdException];
        }
        if (subscribeButton.handler != nil) {
           [self sdl_runAsyncOnQueue:^{
                __strong typeof(weakself) strongself = weakself;
                strongself->_buttonHandlerMap[buttonName] = subscribeButton.handler;
            }];
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

        [self sdl_runAsyncOnQueue:^{
            __strong typeof(weakself) strongself = weakself;
            strongself->_audioPassThruHandler = performAudioPassThru.audioDataHandler;
        }];
    }

    // Always store the request, it's needed in some cases whether or not there was a handler (e.g. DeleteCommand).
    [self sdl_runAsyncOnQueue:^{
        __strong typeof(weakself) strongself = weakself;

        strongself->_rpcRequestDictionary[correlationId] = request;
        if (handler != nil) {
            strongself->_rpcResponseHandlerMap[correlationId] = handler;
        }
    }];
}

- (void)clear {
    __weak typeof(self) weakself = self;

    __block NSArray<SDLResponseHandler> *handlers = nil;
    __block NSArray<SDLRPCRequest *> *requests = nil;
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        __strong typeof(weakself) strongself = weakself;
        NSMutableArray *handlerArray = [NSMutableArray array];
        NSMutableArray *requestArray = [NSMutableArray array];

        // When we get disconnected we have to delete all existing responseHandlers as they are not valid anymore
        for (SDLRPCCorrelationId *correlationID in strongself->_rpcResponseHandlerMap.dictionaryRepresentation) {
            SDLResponseHandler responseHandler = strongself->_rpcResponseHandlerMap[correlationID];
            SDLRPCRequest *request = strongself->_rpcRequestDictionary[correlationID];

            if (responseHandler != NULL) {
                [handlerArray addObject:responseHandler];
                [requestArray addObject:request];
            }
        }

        handlers = [handlerArray copy];
        requests = [requestArray copy];
    }];

    for (NSUInteger i = 0; i < handlers.count; i++) {
        SDLResponseHandler responseHandler = handlers[i];
        SDLRPCRequest *request = requests[i];

        responseHandler(request, nil, [NSError sdl_lifecycle_notConnectedError]);
    }

    [self sdl_runAsyncOnQueue:^{
        __strong typeof(weakself) strongself = weakself;

        [strongself->_rpcRequestDictionary removeAllObjects];
        [strongself->_rpcResponseHandlerMap removeAllObjects];
        [strongself->_commandHandlerMap removeAllObjects];
        [strongself->_buttonHandlerMap removeAllObjects];
        [strongself->_customButtonHandlerMap removeAllObjects];
        strongself->_audioPassThruHandler = nil;
    }];
}

- (void)sdl_addToCustomButtonHandlerMap:(NSArray<SDLSoftButton *> *)softButtons {
    __weak typeof(self) weakself = self;
    for (SDLSoftButton *sb in softButtons) {
        if (sb.softButtonID == nil) {
            @throw [NSException sdl_missingIdException];
        }

        if (sb.handler != nil) {
            [self sdl_runAsyncOnQueue:^{
                __strong typeof(weakself) strongself = weakself;
                strongself->_customButtonHandlerMap[sb.softButtonID] = sb.handler;
            }];
        }
    }
}


#pragma mark - Notification Handler

// Called by notifications
- (void)sdl_runHandlersForResponse:(SDLRPCResponseNotification *)notification {
    __weak typeof(self) weakself = self;
    if (![notification isResponseKindOfClass:[SDLRPCResponse class]]) {
        return;
    }

    __kindof SDLRPCResponse *response = notification.response;

    NSError *error = nil;
    if (!response.success.boolValue) {
        error = [NSError sdl_lifecycle_rpcErrorWithDescription:response.resultCode andReason:response.info];
    }

    __block SDLResponseHandler handler = nil;
    __block SDLRPCRequest *request = nil;
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        handler = self->_rpcResponseHandlerMap[response.correlationID];
        request = self->_rpcRequestDictionary[response.correlationID];
    }];

    // Find the appropriate request completion handler, remove the request and response handler
    [self sdl_runAsyncOnQueue:^{
        __strong typeof(weakself) strongself = weakself;
        [strongself->_rpcRequestDictionary safeRemoveObjectForKey:response.correlationID];
        [strongself->_rpcResponseHandlerMap safeRemoveObjectForKey:response.correlationID];

        // If we errored on the response, the delete / unsubscribe was unsuccessful
        if (error == nil) {
            // If it's a DeleteCommand, UnsubscribeButton, or PerformAudioPassThru we need to remove handlers for the corresponding RPCs
            if ([response isKindOfClass:[SDLDeleteCommandResponse class]]) {
                SDLDeleteCommand *deleteCommandRequest = (SDLDeleteCommand *)request;
                NSNumber *deleteCommandId = deleteCommandRequest.cmdID;
                [strongself->_commandHandlerMap safeRemoveObjectForKey:deleteCommandId];
            } else if ([response isKindOfClass:[SDLUnsubscribeButtonResponse class]]) {
                SDLUnsubscribeButton *unsubscribeButtonRequest = (SDLUnsubscribeButton *)request;
                SDLButtonName unsubscribeButtonName = unsubscribeButtonRequest.buttonName;
                [strongself->_buttonHandlerMap safeRemoveObjectForKey:unsubscribeButtonName];
            } else if ([response isKindOfClass:[SDLPerformAudioPassThruResponse class]]) {
                strongself->_audioPassThruHandler = nil;
            }
        }

        dispatch_async([SDLGlobals sharedGlobals].sdlProcessingQueue, ^{
            // Run the response handler
            if (handler) {
                if (!response.success.boolValue) {
                    SDLLogW(@"Request failed: %@, response: %@, error: %@", request, response, error);
                }
                handler(request, response, error);
            }
        });
    }];
}

#pragma mark Command

- (void)sdl_runHandlerForCommand:(SDLRPCNotificationNotification *)notification {
    SDLOnCommand *onCommandNotification = notification.notification;

    SDLRPCCommandNotificationHandler handler = self.commandHandlerMap[onCommandNotification.cmdID];
    if (handler != nil) {
        handler(onCommandNotification);
    }
}

#pragma mark Button

- (void)sdl_runHandlerForButton:(SDLRPCNotificationNotification *)notification {
    __kindof SDLRPCNotification *rpcNotification = notification.notification;
    SDLButtonName name = nil;
    NSNumber *customID = nil;

    if ([rpcNotification isMemberOfClass:[SDLOnButtonEvent class]]) {
        name = ((SDLOnButtonEvent *)rpcNotification).buttonName;
        customID = ((SDLOnButtonEvent *)rpcNotification).customButtonID;
    } else if ([rpcNotification isMemberOfClass:[SDLOnButtonPress class]]) {
        name = ((SDLOnButtonPress *)rpcNotification).buttonName;
        customID = ((SDLOnButtonPress *)rpcNotification).customButtonID;
    } else {
        return;
    }

    SDLRPCButtonNotificationHandler handler = nil;
    if ([name isEqualToEnum:SDLButtonNameCustomButton]) {
        // Custom buttons
        handler = self.customButtonHandlerMap[customID];
    } else {
        // Static buttons
        handler = self.buttonHandlerMap[name];
    }

    if (handler == nil) {
        return;
    }

    if ([rpcNotification isMemberOfClass:[SDLOnButtonEvent class]]) {
        handler(nil, rpcNotification);
    } else if ([rpcNotification isMemberOfClass:[SDLOnButtonPress class]]) {
        handler(rpcNotification, nil);
    }
}
    
#pragma mark Audio Pass Thru
    
- (void)sdl_runHandlerForAudioPassThru:(SDLRPCNotificationNotification *)notification {
    SDLOnAudioPassThru *onAudioPassThruNotification = notification.notification;

    SDLAudioPassThruHandler handler = self.audioPassThruHandler;
    if (handler != nil) {
        handler(onAudioPassThruNotification.bulkData);
    }
}

#pragma mark Utilities

- (void)sdl_runAsyncOnQueue:(void (^)(void))block {
    if (dispatch_get_specific(SDLProcessingQueueName) != nil) {
        block();
    } else {
        dispatch_async(self.readWriteQueue, block);
    }
}

#pragma mark Getters

- (NSMapTable<SDLRPCCorrelationId *, SDLResponseHandler> *)rpcResponseHandlerMap {
    __block NSMapTable<SDLRPCCorrelationId *, SDLResponseHandler> *map = nil;
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        map = self->_rpcResponseHandlerMap;
    }];

    return map;
}

- (NSMutableDictionary<SDLRPCCorrelationId *, SDLRPCRequest *> *)rpcRequestDictionary {
    __block NSMutableDictionary<SDLRPCCorrelationId *, SDLRPCRequest *> *dict = nil;
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        dict = self->_rpcRequestDictionary;
    }];

    return dict;
}

- (NSMapTable<SDLAddCommandCommandId *, SDLRPCCommandNotificationHandler> *)commandHandlerMap {
    __block NSMapTable<SDLAddCommandCommandId *, SDLRPCCommandNotificationHandler> *map = nil;
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        map = self->_commandHandlerMap;
    }];

    return map;
}

- (NSMapTable<SDLSubscribeButtonName *, SDLRPCButtonNotificationHandler> *)buttonHandlerMap {
    __block NSMapTable<SDLSubscribeButtonName *, SDLRPCButtonNotificationHandler> *map = nil;
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        map = self->_buttonHandlerMap;
    }];

    return map;
}

- (NSMapTable<SDLSoftButtonId *, SDLRPCButtonNotificationHandler> *)customButtonHandlerMap {
    __block NSMapTable<SDLSoftButtonId *, SDLRPCButtonNotificationHandler> *map = nil;
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        map = self->_customButtonHandlerMap;
    }];

    return map;
}

- (nullable SDLAudioPassThruHandler)audioPassThruHandler {
    __block SDLAudioPassThruHandler audioPassThruHandler = nil;
    [SDLGlobals runSyncOnSerialSubQueue:self.readWriteQueue block:^{
        audioPassThruHandler = self->_audioPassThruHandler;
    }];

    return audioPassThruHandler;
}

@end

NS_ASSUME_NONNULL_END
