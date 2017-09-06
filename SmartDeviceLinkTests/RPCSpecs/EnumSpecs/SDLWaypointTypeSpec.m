//  SDLWayPointTypeSpec.m
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLWayPointType.h"

QuickSpecBegin(SDLWayPointTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLWayPointTypeAll).to(equal(@"ALL"));
        expect(SDLWayPointTypeDestination).to(equal(@"DESTINATION"));
    });
});

QuickSpecEnd
