//
//  SDLStateMachine.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/30/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLState.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLState ()

@property (copy, nonatomic, readwrite) NSString *name;

@end


@implementation SDLState

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _name = name;
    
    return self;
}


- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    SDLState *stateObject = (SDLState *)object;
    
    if (![self.name isEqualToString:stateObject.name]) {
        return NO;
    }
    
    return YES;
}

@end

NS_ASSUME_NONNULL_END
