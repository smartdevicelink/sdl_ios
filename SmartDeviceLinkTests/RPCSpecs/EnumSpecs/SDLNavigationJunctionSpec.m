//
//  SDLNavigationJunctionSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/22/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

@import Quick;
@import Nimble;

#import "SDLNavigationJunction.h"

QuickSpecBegin(SDLNavigationJunctionSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLNavigationJunctionRegular).to(equal(@"REGULAR"));
        expect(SDLNavigationJunctionBifurcation).to(equal(@"BIFURCATION"));
        expect(SDLNavigationJunctionMultiCarriageway).to(equal(@"MULTI_CARRIAGEWAY"));
        expect(SDLNavigationJunctionRoundabout).to(equal(@"ROUNDABOUT"));
        expect(SDLNavigationJunctionTraversableRoundabout).to(equal(@"TRAVERSABLE_ROUNDABOUT"));
        expect(SDLNavigationJunctionJughandle).to(equal(@"JUGHANDLE"));
        expect(SDLNavigationJunctionAllWayYield).to(equal(@"ALL_WAY_YIELD"));
        expect(SDLNavigationJunctionTurnAround).to(equal(@"TURN_AROUND"));
    });
});

QuickSpecEnd


