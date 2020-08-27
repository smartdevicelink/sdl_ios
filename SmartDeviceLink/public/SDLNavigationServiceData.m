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
#import "SDLRPCParameterNames.h"
#import "SDLNavigationInstruction.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLNavigationServiceData

- (instancetype)initWithTimestamp:(SDLDateTime *)timestamp {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.timestamp = timestamp;

    return self;
}

- (instancetype)initWithTimestamp:(SDLDateTime *)timestamp origin:(nullable SDLLocationDetails *)origin destination:(nullable SDLLocationDetails *)destination destinationETA:(nullable SDLDateTime *)destinationETA instructions:(nullable NSArray<SDLNavigationInstruction *> *)instructions nextInstructionETA:(nullable SDLDateTime *)nextInstructionETA nextInstructionDistance:(float)nextInstructionDistance nextInstructionDistanceScale:(float)nextInstructionDistanceScale prompt:(nullable NSString *)prompt {
    self = [self initWithTimestamp:timestamp];
    if (!self) {
        return nil;
    }

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
    [self.store sdl_setObject:timestamp forName:SDLRPCParameterNameTimeStamp];
}

- (SDLDateTime *)timestamp {
    return [self.store sdl_objectForName:SDLRPCParameterNameTimeStamp ofClass:SDLDateTime.class error:nil];
}

- (void)setOrigin:(nullable SDLLocationDetails *)origin {
    [self.store sdl_setObject:origin forName:SDLRPCParameterNameOrigin];
}

- (nullable SDLLocationDetails *)origin {
    return [self.store sdl_objectForName:SDLRPCParameterNameOrigin ofClass:SDLLocationDetails.class error:nil];
}

- (void)setDestination:(nullable SDLLocationDetails *)destination {
    [self.store sdl_setObject:destination forName:SDLRPCParameterNameDestination];
}

- (nullable SDLLocationDetails *)destination {
    return [self.store sdl_objectForName:SDLRPCParameterNameDestination ofClass:SDLLocationDetails.class error:nil];
}

- (void)setDestinationETA:(nullable SDLDateTime *)destinationETA {
    [self.store sdl_setObject:destinationETA forName:SDLRPCParameterNameDestinationETA];
}

- (nullable SDLDateTime *)destinationETA {
    return [self.store sdl_objectForName:SDLRPCParameterNameDestinationETA ofClass:SDLDateTime.class error:nil];
}

- (void)setInstructions:(nullable NSArray<SDLNavigationInstruction *> *)instructions {
    [self.store sdl_setObject:instructions forName:SDLRPCParameterNameInstructions];
}

- (nullable NSArray<SDLNavigationInstruction *> *)instructions {
    return [self.store sdl_objectsForName:SDLRPCParameterNameInstructions ofClass:SDLNavigationInstruction.class error:nil];
}

- (void)setNextInstructionETA:(nullable SDLDateTime *)nextInstructionETA {
    [self.store sdl_setObject:nextInstructionETA forName:SDLRPCParameterNameNextInstructionETA];
}

- (nullable SDLDateTime *)nextInstructionETA {
    return [self.store sdl_objectForName:SDLRPCParameterNameNextInstructionETA ofClass:SDLDateTime.class error:nil];
}

- (void)setNextInstructionDistance:(nullable NSNumber<SDLFloat> *)nextInstructionDistance {
    [self.store sdl_setObject:nextInstructionDistance forName:SDLRPCParameterNameNextInstructionDistance];
}

- (nullable NSNumber<SDLFloat> *)nextInstructionDistance {
    return [self.store sdl_objectForName:SDLRPCParameterNameNextInstructionDistance ofClass:NSNumber.class error:nil];
}

- (void)setNextInstructionDistanceScale:(nullable NSNumber<SDLFloat> *)nextInstructionDistanceScale {
    [self.store sdl_setObject:nextInstructionDistanceScale forName:SDLRPCParameterNameNextInstructionDistanceScale];
}

- (nullable NSNumber<SDLFloat> *)nextInstructionDistanceScale {
    return [self.store sdl_objectForName:SDLRPCParameterNameNextInstructionDistanceScale ofClass:NSNumber.class error:nil];
}

- (void)setPrompt:(nullable NSString *)prompt {
    [self.store sdl_setObject:prompt forName:SDLRPCParameterNamePrompt];
}

- (nullable NSString *)prompt {
    return [self.store sdl_objectForName:SDLRPCParameterNamePrompt ofClass:NSString.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
