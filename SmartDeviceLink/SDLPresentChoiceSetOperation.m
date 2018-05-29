//
//  SDLPresentChoiceSetOperation.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/24/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLPresentChoiceSetOperation.h"

#import "SDLChoiceCell.h"
#import "SDLChoiceSet.h"
#import "SDLConnectionManagerType.h"
#import "SDLPerformInteraction.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLChoiceCell()

@property (assign, nonatomic) UInt16 choiceId;

@end

@interface SDLPresentChoiceSetOperation()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (strong, nonatomic) SDLChoiceSet *choiceSet;
@property (strong, nonatomic) SDLInteractionMode presentationMode;
@property (weak, nonatomic) id<SDLKeyboardDelegate> keyboardDelegate;

@property (strong, nonatomic, readonly) SDLPerformInteraction *performInteraction;
@property (strong, nonatomic, readonly) SDLLayoutMode layoutMode;
@property (strong, nonatomic, readonly) NSArray<NSNumber<SDLInt> *> *choiceIds;

@property (copy, nonatomic, nullable) NSError *internalError;

@end

@implementation SDLPresentChoiceSetOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager choiceSet:(SDLChoiceSet *)choiceSet mode:(SDLInteractionMode)mode keyboardDelegate:(nullable id<SDLKeyboardDelegate>)keyboardDelegate {
    self = [super init];
    if (!self) { return self; }

    _connectionManager = connectionManager;
    _choiceSet = choiceSet;


    return self;
}

- (void)start {
    [super start];

    [self sdl_presentChoiceSet];
}

- (void)sdl_presentChoiceSet {
    [self.connectionManager sendConnectionRequest:self.performInteraction withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        self.internalError = error;
        [self finishOperation];
    }];
}

- (SDLPerformInteraction *)performInteraction {
    SDLPerformInteraction *performInteraction = [[SDLPerformInteraction alloc] init];
    performInteraction.interactionMode = self.presentationMode;
    performInteraction.initialText = self.choiceSet.title;
    performInteraction.initialPrompt = self.choiceSet.initialPrompt;
    performInteraction.helpPrompt = self.choiceSet.helpPrompt;
    performInteraction.timeoutPrompt = self.choiceSet.timeoutPrompt;
    performInteraction.vrHelp = self.choiceSet.helpList;
    performInteraction.timeout = @((NSUInteger)(self.choiceSet.timeout * 1000));
    performInteraction.interactionLayout = self.layoutMode;
    performInteraction.interactionChoiceSetIDList = self.choiceIds;

    return performInteraction;
}

- (SDLLayoutMode)layoutMode {
    switch (self.choiceSet.layout) {
        case SDLChoiceSetLayoutList:
            return self.keyboardDelegate ? SDLLayoutModeListWithSearch : SDLLayoutModeListOnly;
        case SDLChoiceSetLayoutTiles:
            return self.keyboardDelegate ? SDLLayoutModeIconWithSearch : SDLLayoutModeIconOnly;
    }
}

- (NSArray<NSNumber<SDLInt> *> *)choiceIds {
    NSMutableArray<NSNumber<SDLInt> *> *choiceIds = [NSMutableArray arrayWithCapacity:self.choiceSet.choices.count];
    for (SDLChoiceCell *cell in self.choiceSet.choices) {
        [choiceIds addObject:@(cell.choiceId)];
    }

    return [choiceIds copy];
}

#pragma mark - Property Overrides

- (nullable NSString *)name {
    return @"com.sdl.choicesetmanager.presentChoiceSet";
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

- (nullable NSError *)error {
    return self.internalError;
}

@end

NS_ASSUME_NONNULL_END
