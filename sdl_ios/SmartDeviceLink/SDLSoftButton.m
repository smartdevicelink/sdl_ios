//  SDLSoftButton.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLSoftButton.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLSoftButton

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setType:(SDLSoftButtonType*) type {
    [store setOrRemoveObject:type forKey:NAMES_type];
}

-(SDLSoftButtonType*) type {
    NSObject* obj = [store objectForKey:NAMES_type];
    if ([obj isKindOfClass:SDLSoftButtonType.class]) {
        return (SDLSoftButtonType*)obj;
    } else {
        return [SDLSoftButtonType valueOf:(NSString*)obj];
    }
}

-(void) setText:(NSString*) text {
    [store setOrRemoveObject:text forKey:NAMES_text];
}

-(NSString*) text {
    return [store objectForKey:NAMES_text];
}

-(void) setImage:(SDLImage*) image {
    [store setOrRemoveObject:image forKey:NAMES_image];
}

-(SDLImage*) image {
    NSObject* obj = [store objectForKey:NAMES_image];
    if ([obj isKindOfClass:SDLImage.class]) {
        return (SDLImage*)obj;
    } else {
        return [[SDLImage alloc] initWithDictionary:(NSMutableDictionary*)obj];
    }
}

-(void) setIsHighlighted:(NSNumber*) isHighlighted {
    [store setOrRemoveObject:isHighlighted forKey:NAMES_isHighlighted];
}

-(NSNumber*) isHighlighted {
    return [store objectForKey:NAMES_isHighlighted];
}

-(void) setSoftButtonID:(NSNumber*) softButtonID {
    [store setOrRemoveObject:softButtonID forKey:NAMES_softButtonID];
}

-(NSNumber*) softButtonID {
    return [store objectForKey:NAMES_softButtonID];
}

-(void) setSystemAction:(SDLSystemAction*) systemAction {
    [store setOrRemoveObject:systemAction forKey:NAMES_systemAction];
}

-(SDLSystemAction*) systemAction {
    NSObject* obj = [store objectForKey:NAMES_systemAction];
    if ([obj isKindOfClass:SDLSystemAction.class]) {
        return (SDLSystemAction*)obj;
    } else {
        return [SDLSystemAction valueOf:(NSString*)obj];
    }
}

@end
