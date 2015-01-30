//  SDLDeviceInfo.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLDeviceInfo.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLDeviceInfo

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setHardware:(NSString*) hardware {
    [store setOrRemoveObject:hardware forKey:NAMES_hardware];
}

-(NSString*) hardware {
    return [store objectForKey:NAMES_hardware];
}

-(void) setFirmwareRev:(NSString*) firmwareRev {
    [store setOrRemoveObject:firmwareRev forKey:NAMES_firmwareRev];
}

-(NSString*) firmwareRev {
    return [store objectForKey:NAMES_firmwareRev];
}

-(void) setOs:(NSString*) os {
    [store setOrRemoveObject:os forKey:NAMES_os];
}

-(NSString*) os {
    return [store objectForKey:NAMES_os];
}

-(void) setOsVersion:(NSString*) osVersion {
    [store setOrRemoveObject:osVersion forKey:NAMES_osVersion];
}

-(NSString*) osVersion {
    return [store objectForKey:NAMES_osVersion];
}

-(void) setCarrier:(NSString*) carrier {
    [store setOrRemoveObject:carrier forKey:NAMES_carrier];
}

-(NSString*) carrier {
    return [store objectForKey:NAMES_carrier];
}

-(void) setMaxNumberRFCOMMPorts:(NSNumber*) maxNumberRFCOMMPorts {
    [store setOrRemoveObject:maxNumberRFCOMMPorts forKey:NAMES_maxNumberRFCOMMPorts];
}

-(NSNumber*) maxNumberRFCOMMPorts {
    return [store objectForKey:NAMES_maxNumberRFCOMMPorts];
}

@end
