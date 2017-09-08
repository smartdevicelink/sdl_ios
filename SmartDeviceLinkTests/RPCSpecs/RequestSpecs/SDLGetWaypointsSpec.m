//  SDLGetWaypointsSpec.m
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLGetWaypoints.h"

#import "SDLNames.h"
#import "SDLWayPointType.h"

QuickSpecBegin(SDLGetWaypointsSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLGetWayPoints* testRequest = [[SDLGetWayPoints alloc] init];
        
        testRequest.waypointType = SDLWayPointTypeAll;
        
        expect(testRequest.waypointType).to(equal(SDLWayPointTypeAll));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameRequest:
                                           @{SDLNameParameters:
                                                 @{SDLNameWayPointType:SDLWayPointTypeAll},
                                             SDLNameOperationName:SDLNameGetWayPoints}} mutableCopy];
        SDLGetWayPoints* testRequest = [[SDLGetWayPoints alloc] initWithDictionary:dict];
        
        expect(testRequest.waypointType).to(equal(SDLWayPointTypeAll));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLGetWayPoints* testRequest = [[SDLGetWayPoints alloc] init];
        
        expect(testRequest.waypointType).to(beNil());
    });
});

QuickSpecEnd
