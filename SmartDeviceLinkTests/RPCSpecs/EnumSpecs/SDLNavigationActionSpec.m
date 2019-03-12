//
//  SDLNavigationActionSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/22/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNavigationAction.h"

QuickSpecBegin(SDLNavigationActionSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLNavigationActionTurn).to(equal(@"TURN"));
        expect(SDLNavigationActionExit).to(equal(@"EXIT"));
        expect(SDLNavigationActionStay).to(equal(@"STAY"));
        expect(SDLNavigationActionMerge).to(equal(@"MERGE"));
        expect(SDLNavigationActionFerry).to(equal(@"FERRY"));
        expect(SDLNavigationActionCarShuttleTrain).to(equal(@"CAR_SHUTTLE_TRAIN"));
        expect(SDLNavigationActionWaypoint).to(equal(@"WAYPOINT"));
    });
});

QuickSpecEnd
