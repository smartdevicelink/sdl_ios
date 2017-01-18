//  SDLGetWaypointsSpec.m
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLGetWaypoints.h"

#import "SDLNames.h"
#import "SDLWaypointType.h"

QuickSpecBegin(SDLGetWaypointsSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLGetWayPoints* testRequest = [[SDLGetWayPoints alloc] init];
        
        testRequest.waypointType = SDLWaypointTypeAll;
        
        expect(testRequest.waypointType).to(equal(SDLWaypointTypeAll));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameRequest:
                                           @{SDLNameParameters:
                                                 @{SDLNameWaypointType:SDLWaypointTypeAll},
                                             SDLNameOperationName:SDLNameGetWaypoints}} mutableCopy];
        SDLGetWayPoints* testRequest = [[SDLGetWayPoints alloc] initWithDictionary:dict];
        
        expect(testRequest.waypointType).to(equal(SDLWaypointTypeAll));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLGetWayPoints* testRequest = [[SDLGetWayPoints alloc] init];
        
        expect(testRequest.waypointType).to(beNil());
    });
});

QuickSpecEnd
