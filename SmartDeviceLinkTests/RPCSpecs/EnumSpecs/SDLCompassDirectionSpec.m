//
//  SDLCompassDirectionSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLCompassDirection.h"

QuickSpecBegin(SDLCompassDirectionSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLCompassDirectionNorth).to(equal(@"NORTH"));
        expect(SDLCompassDirectionNorthwest).to(equal(@"NORTHWEST"));
        expect(SDLCompassDirectionWest).to(equal(@"WEST"));
        expect(SDLCompassDirectionSouthwest).to(equal(@"SOUTHWEST"));
        expect(SDLCompassDirectionSouth).to(equal(@"SOUTH"));
        expect(SDLCompassDirectionSoutheast).to(equal(@"SOUTHEAST"));
        expect(SDLCompassDirectionEast).to(equal(@"EAST"));
        expect(SDLCompassDirectionNortheast).to(equal(@"NORTHEAST"));
    });
});

QuickSpecEnd
