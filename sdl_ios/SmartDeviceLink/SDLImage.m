//  SDLImage.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLImage.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLImage

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setValue:(NSString*) value {
    if (value != nil) {
        [store setObject:value forKey:NAMES_value];
    } else {
        [store removeObjectForKey:NAMES_value];
    }
}

-(NSString*) value {
    return [store objectForKey:NAMES_value];
}

-(void) setImageType:(SDLImageType*) imageType {
    if (imageType != nil) {
        [store setObject:imageType forKey:NAMES_imageType];
    } else {
        [store removeObjectForKey:NAMES_imageType];
    }
}

-(SDLImageType*) imageType {
    NSObject* obj = [store objectForKey:NAMES_imageType];
    if ([obj isKindOfClass:SDLImageType.class]) {
        return (SDLImageType*)obj;
    } else {
        return [SDLImageType valueOf:(NSString*)obj];
    }
}

@end
