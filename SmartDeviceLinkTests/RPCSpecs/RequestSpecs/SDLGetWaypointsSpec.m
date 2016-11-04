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
        SDLGetWaypoints* testRequest = [[SDLGetWaypoints alloc] init];
        
        testRequest.waypointType = [SDLWaypointType ALL];
        
        expect(testRequest.waypointType).to(equal([SDLWaypointType ALL]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_waypointType:[SDLWaypointType ALL]},
                                             NAMES_operation_name:NAMES_GetWaypoints}} mutableCopy];
        SDLGetWaypoints* testRequest = [[SDLGetWaypoints alloc] initWithDictionary:dict];
        
        expect(testRequest.waypointType).to(equal([SDLWaypointType ALL]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLGetWaypoints* testRequest = [[SDLGetWaypoints alloc] init];
        
        expect(testRequest.waypointType).to(beNil());
    });
});

QuickSpecEnd
