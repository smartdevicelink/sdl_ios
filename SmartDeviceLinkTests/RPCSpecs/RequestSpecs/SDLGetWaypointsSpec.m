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
        
        testRequest.waypointType = [SDLWaypointType ALL];
        
        expect(testRequest.waypointType).to(equal([SDLWaypointType ALL]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_waypointType:[SDLWaypointType ALL]},
                                             NAMES_operation_name:NAMES_GetWaypoints}} mutableCopy];
        SDLGetWayPoints* testRequest = [[SDLGetWayPoints alloc] initWithDictionary:dict];
        
        expect(testRequest.waypointType).to(equal([SDLWaypointType ALL]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLGetWayPoints* testRequest = [[SDLGetWayPoints alloc] init];
        
        expect(testRequest.waypointType).to(beNil());
    });
});

QuickSpecEnd
