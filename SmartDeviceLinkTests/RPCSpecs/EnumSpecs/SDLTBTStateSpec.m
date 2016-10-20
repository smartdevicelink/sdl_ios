//
//  SDLTBTStateSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLTBTState.h"

QuickSpecBegin(SDLTBTStateSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLTBTStateRouteUpdateRequest).to(equal(@"ROUTE_UPDATE_REQUEST"));
        expect(SDLTBTStateRouteAccepted).to(equal(@"ROUTE_ACCEPTED"));
        expect(SDLTBTStateRouteRefused).to(equal(@"ROUTE_REFUSED"));
        expect(SDLTBTStateRouteCancelled).to(equal(@"ROUTE_CANCELLED"));
        expect(SDLTBTStateETARequest).to(equal(@"ETA_REQUEST"));
        expect(SDLTBTStateNextTurnRequest).to(equal(@"NEXT_TURN_REQUEST"));
        expect(SDLTBTStateRouteStatusRequest).to(equal(@"ROUTE_STATUS_REQUEST"));
        expect(SDLTBTStateRouteSummaryRequest).to(equal(@"ROUTE_SUMMARY_REQUEST"));
        expect(SDLTBTStateTripStatusRequest).to(equal(@"TRIP_STATUS_REQUEST"));
        expect(SDLTBTStateRouteUpdateRequestTimeout).to(equal(@"ROUTE_UPDATE_REQUEST_TIMEOUT"));
    });
});

QuickSpecEnd
