//
//  SDLNavigationServiceData.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/22/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLNavigationServiceData.h"

#import "NSMutableDictionary+Store.h"
#import "SDLDateTime.h"
#import "SDLLocationDetails.h"
#import "SDLNames.h"
#import "SDLNavigationInstruction.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLNavigationServiceData

- (instancetype)initWithTimestamp:(SDLDateTime *)timestamp origin:(nullable SDLLocationDetails *)origin destination:(nullable SDLLocationDetails *)destination destinationETA:(nullable SDLDateTime *)destinationETA instructions:(nullable NSArray<SDLNavigationInstruction *> *)instructions nextInstructionETA:(nullable SDLDateTime *)nextInstructionETA nextInstructionDistance:(float)nextInstructionDistance nextInstructionDistanceScale:(float)nextInstructionDistanceScale prompt:(nullable NSString *)prompt {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.timestamp = timestamp;
    self.origin = origin;
    self.destination = destination;
    self.destinationETA = destinationETA;
    self.instructions = instructions;
    self.nextInstructionETA = nextInstructionETA;
    self.nextInstructionDistance = @(nextInstructionDistance);
    self.nextInstructionDistanceScale = @(nextInstructionDistanceScale);
    self.prompt = prompt;

    return self;
}

- (void)setTimestamp:(SDLDateTime *)timestamp {
    [store sdl_setObject:timestamp forName:SDLNameTimeStamp];
}

- (SDLDateTime *)timestamp {
    return [store sdl_objectForName:SDLNameTimeStamp ofClass:SDLDateTime.class];
}

- (void)setOrigin:(nullable SDLLocationDetails *)origin {
    [store sdl_setObject:origin forName:SDLNameOrigin];
}

- (nullable SDLLocationDetails *)origin {
    return [store sdl_objectForName:SDLNameOrigin ofClass:SDLLocationDetails.class];
}

- (void)setDestination:(nullable SDLLocationDetails *)destination {
    [store sdl_setObject:destination forName:SDLNameDestination];
}

- (nullable SDLLocationDetails *)destination {
    return [store sdl_objectForName:SDLNameDestination ofClass:SDLLocationDetails.class];
}

- (void)setDestinationETA:(nullable SDLDateTime *)destinationETA {
    [store sdl_setObject:destinationETA forName:SDLNameDestinationETA];
}

- (nullable SDLDateTime *)destinationETA {
    return [store sdl_objectForName:SDLNameDestinationETA ofClass:SDLDateTime.class];
}

- (void)setInstructions:(nullable NSArray<SDLNavigationInstruction *> *)instructions {
    [store sdl_setObject:instructions forName:SDLNameInstructions];
}

- (nullable NSArray<SDLNavigationInstruction *> *)instructions {
    return [store sdl_objectsForName:SDLNameInstructions ofClass:SDLNavigationInstruction.class];
}

- (void)setNextInstructionETA:(nullable SDLDateTime *)nextInstructionETA {
    [store sdl_setObject:nextInstructionETA forName:SDLNameNextInstructionETA];
}

- (nullable SDLDateTime *)nextInstructionETA {
    return [store sdl_objectForName:SDLNameNextInstructionETA ofClass:SDLDateTime.class];
}

- (void)setNextInstructionDistance:(nullable NSNumber<SDLFloat> *)nextInstructionDistance {
    [store sdl_setObject:nextInstructionDistance forName:SDLNameNextInstructionDistance];
}

- (nullable NSNumber<SDLFloat> *)nextInstructionDistance {
    return [store sdl_objectForName:SDLNameNextInstructionDistance];
}

- (void)setNextInstructionDistanceScale:(nullable NSNumber<SDLFloat> *)nextInstructionDistanceScale {
    [store sdl_setObject:nextInstructionDistanceScale forName:SDLNameNextInstructionDistanceScale];
}

- (nullable NSNumber<SDLFloat> *)nextInstructionDistanceScale {
    return [store sdl_objectForName:SDLNameNextInstructionDistanceScale];
}

- (void)setPrompt:(nullable NSString *)prompt {
    [store sdl_setObject:prompt forName:SDLNamePrompt];
}

- (nullable NSString *)prompt {
    return [store sdl_objectForName:SDLNamePrompt];
}

@end

NS_ASSUME_NONNULL_END
