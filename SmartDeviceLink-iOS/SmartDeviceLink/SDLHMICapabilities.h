//
//  SDLHMICapabilities.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 3/31/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import <SmartDeviceLink/SmartDeviceLink.h>

@interface SDLHMICapabilities : SDLRPCStruct

-(instancetype) init;
-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;

/**
 Availability of build in Nav. True: Available, False: Not Available
 
 Boolean value. Optional.
 */
@property (copy, nonatomic) NSNumber *navigation;

/**
 Availability of build in phone. True: Available, False: Not Available
 
 Boolean value. Optional.
 */
@property (copy, nonatomic) NSNumber *phoneCall;

@end
