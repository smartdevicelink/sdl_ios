//  SDLVrHelpItem.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLVrHelpItem.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLVrHelpItem

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
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

-(void) setPosition:(NSNumber*) position {
    [store setOrRemoveObject:position forKey:NAMES_position];
}

-(NSNumber*) position {
    return [store objectForKey:NAMES_position];
}

@end
