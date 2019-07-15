//
//  SDLCreateWindow.m
//  SmartDeviceLink
//
//  Created by cssoeutest1 on 15.07.19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLCreateWindow.h"
#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLCreateWindow

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameCreateWindow]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithId:(UInt32)windowId windowName:(NSString *)windowName windowType:(SDLWindowType *)windowType {
    
    self = [self init];
    if (!self) {
        return nil;
    }
    
    return self;
}

- (instancetype)initWithId:(UInt32)windowId windowName:(NSString *)windowName windowType:(SDLWindowType *)windowType associatedServiceType:(nullable NSString *)associatedServiceType {
    self = [self init];
    if (!self) {
        return nil;
    }
    
    return self;
    
}

- (instancetype)initWithId:(UInt32)windowId windowName:(NSString *)windowName windowType:(SDLWindowType *)windowType associatedServiceType:(nullable NSString *)associatedServiceType duplicateUpdatesFromWindowID:(UInt32)duplicateUpdatesFromWindowID {
    
    self = [self init];
    if (!self) {
        return nil;
    }
    
    return self;
    
}

#pragma mark - Getters / Setters

- (void)setWindowID:(NSNumber<SDLInt> *)windowID {
    [self.parameters sdl_setObject:windowID forName:SDLRPCParameterNameWindowId];
}

- (NSNumber<SDLInt> *)windowID {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameCommandId ofClass:NSNumber.class error:&error];
}




//- (NSNumber<SDLInt> *)cmdID {
//    NSError *error = nil;
//    return [self.parameters sdl_objectForName:SDLRPCParameterNameCommandId ofClass:NSNumber.class error:&error];
//}



@end

NS_ASSUME_NONNULL_END
