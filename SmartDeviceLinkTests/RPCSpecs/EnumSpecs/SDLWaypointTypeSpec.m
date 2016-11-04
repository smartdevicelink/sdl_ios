//  SDLWaypointTypeSpec.m
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLWaypointType.h"

QuickSpecBegin(SDLWaypointTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLWaypointTypeAll).to(equal(@"ALL"));
        expect(SDLWaypointTypeDestination).to(equal(@"DESTINATION"));
    });
});

QuickSpecEnd
