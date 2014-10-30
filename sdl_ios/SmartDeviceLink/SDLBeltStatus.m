//  SDLBeltStatus.m
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <SmartDeviceLink/SDLBeltStatus.h>

#import <SmartDeviceLink/SDLNames.h>

@implementation SDLBeltStatus

-(id) init {
    if (self = [super init]) {}
    return self;
}

-(id) initWithDictionary:(NSMutableDictionary*) dict {
    if (self = [super initWithDictionary:dict]) {}
    return self;
}

-(void) setDriverBeltDeployed:(SDLVehicleDataEventStatus*) driverBeltDeployed {
    [store setOrRemoveObject:driverBeltDeployed forKey:NAMES_driverBeltDeployed];
}

-(SDLVehicleDataEventStatus*) driverBeltDeployed {
    NSObject* obj = [store objectForKey:NAMES_driverBeltDeployed];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

-(void) setPassengerBeltDeployed:(SDLVehicleDataEventStatus*) passengerBeltDeployed {
    [store setOrRemoveObject:passengerBeltDeployed forKey:NAMES_passengerBeltDeployed];
}

-(SDLVehicleDataEventStatus*) passengerBeltDeployed {
    NSObject* obj = [store objectForKey:NAMES_passengerBeltDeployed];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

-(void) setPassengerBuckleBelted:(SDLVehicleDataEventStatus*) passengerBuckleBelted {
    [store setOrRemoveObject:passengerBuckleBelted forKey:NAMES_passengerBuckleBelted];
}

-(SDLVehicleDataEventStatus*) passengerBuckleBelted {
    NSObject* obj = [store objectForKey:NAMES_passengerBuckleBelted];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

-(void) setDriverBuckleBelted:(SDLVehicleDataEventStatus*) driverBuckleBelted {
    [store setOrRemoveObject:driverBuckleBelted forKey:NAMES_driverBuckleBelted];
}

-(SDLVehicleDataEventStatus*) driverBuckleBelted {
    NSObject* obj = [store objectForKey:NAMES_driverBuckleBelted];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

-(void) setLeftRow2BuckleBelted:(SDLVehicleDataEventStatus*) leftRow2BuckleBelted {
    [store setOrRemoveObject:leftRow2BuckleBelted forKey:NAMES_leftRow2BuckleBelted];
}

-(SDLVehicleDataEventStatus*) leftRow2BuckleBelted {
    NSObject* obj = [store objectForKey:NAMES_leftRow2BuckleBelted];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

-(void) setPassengerChildDetected:(SDLVehicleDataEventStatus*) passengerChildDetected {
    [store setOrRemoveObject:passengerChildDetected forKey:NAMES_passengerChildDetected];
}

-(SDLVehicleDataEventStatus*) passengerChildDetected {
    NSObject* obj = [store objectForKey:NAMES_passengerChildDetected];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

-(void) setRightRow2BuckleBelted:(SDLVehicleDataEventStatus*) rightRow2BuckleBelted {
    [store setOrRemoveObject:rightRow2BuckleBelted forKey:NAMES_rightRow2BuckleBelted];
}

-(SDLVehicleDataEventStatus*) rightRow2BuckleBelted {
    NSObject* obj = [store objectForKey:NAMES_rightRow2BuckleBelted];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

-(void) setMiddleRow2BuckleBelted:(SDLVehicleDataEventStatus*) middleRow2BuckleBelted {
    [store setOrRemoveObject:middleRow2BuckleBelted forKey:NAMES_middleRow2BuckleBelted];
}

-(SDLVehicleDataEventStatus*) middleRow2BuckleBelted {
    NSObject* obj = [store objectForKey:NAMES_middleRow2BuckleBelted];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

-(void) setMiddleRow3BuckleBelted:(SDLVehicleDataEventStatus*) middleRow3BuckleBelted {
    [store setOrRemoveObject:middleRow3BuckleBelted forKey:NAMES_middleRow3BuckleBelted];
}

-(SDLVehicleDataEventStatus*) middleRow3BuckleBelted {
    NSObject* obj = [store objectForKey:NAMES_middleRow3BuckleBelted];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

-(void) setLeftRow3BuckleBelted:(SDLVehicleDataEventStatus*) leftRow3BuckleBelted {
    [store setOrRemoveObject:leftRow3BuckleBelted forKey:NAMES_leftRow3BuckleBelted];
}

-(SDLVehicleDataEventStatus*) leftRow3BuckleBelted {
    NSObject* obj = [store objectForKey:NAMES_leftRow3BuckleBelted];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

-(void) setRightRow3BuckleBelted:(SDLVehicleDataEventStatus*) rightRow3BuckleBelted {
    [store setOrRemoveObject:rightRow3BuckleBelted forKey:NAMES_rightRow3BuckleBelted];
}

-(SDLVehicleDataEventStatus*) rightRow3BuckleBelted {
    NSObject* obj = [store objectForKey:NAMES_rightRow3BuckleBelted];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

-(void) setLeftRearInflatableBelted:(SDLVehicleDataEventStatus*) leftRearInflatableBelted {
    [store setOrRemoveObject:leftRearInflatableBelted forKey:NAMES_leftRearInflatableBelted];
}

-(SDLVehicleDataEventStatus*) leftRearInflatableBelted {
    NSObject* obj = [store objectForKey:NAMES_leftRearInflatableBelted];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

-(void) setRightRearInflatableBelted:(SDLVehicleDataEventStatus*) rightRearInflatableBelted {
    [store setOrRemoveObject:rightRearInflatableBelted forKey:NAMES_rightRearInflatableBelted];
}

-(SDLVehicleDataEventStatus*) rightRearInflatableBelted {
    NSObject* obj = [store objectForKey:NAMES_rightRearInflatableBelted];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

-(void) setMiddleRow1BeltDeployed:(SDLVehicleDataEventStatus*) middleRow1BeltDeployed {
    [store setOrRemoveObject:middleRow1BeltDeployed forKey:NAMES_middleRow1BeltDeployed];
}

-(SDLVehicleDataEventStatus*) middleRow1BeltDeployed {
    NSObject* obj = [store objectForKey:NAMES_middleRow1BeltDeployed];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

-(void) setMiddleRow1BuckleBelted:(SDLVehicleDataEventStatus*) middleRow1BuckleBelted {
    [store setOrRemoveObject:middleRow1BuckleBelted forKey:NAMES_middleRow1BuckleBelted];
}

-(SDLVehicleDataEventStatus*) middleRow1BuckleBelted {
    NSObject* obj = [store objectForKey:NAMES_middleRow1BuckleBelted];
    if ([obj isKindOfClass:SDLVehicleDataEventStatus.class]) {
        return (SDLVehicleDataEventStatus*)obj;
    } else {
        return [SDLVehicleDataEventStatus valueOf:(NSString*)obj];
    }
}

@end
