//  SDLVehicleType.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLVehicleType.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLVehicleType

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setMake:(NSString*) make {
    [store setOrRemoveObject:make forKey:NAMES_make];
}

-(NSString*) make {
    return [store objectForKey:NAMES_make];
}

-(void) setModel:(NSString*) model {
    [store setOrRemoveObject:model forKey:NAMES_model];
}

-(NSString*) model {
    return [store objectForKey:NAMES_model];
}

-(void) setModelYear:(NSString*) modelYear {
    [store setOrRemoveObject:modelYear forKey:NAMES_modelYear];
}

-(NSString*) modelYear {
    return [store objectForKey:NAMES_modelYear];
}

-(void) setTrim:(NSString*) trim {
    [store setOrRemoveObject:trim forKey:NAMES_trim];
}

-(NSString*) trim {
    return [store objectForKey:NAMES_trim];
}

@end
