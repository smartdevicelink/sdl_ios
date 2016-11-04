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
        
        testRequest.waypointType = SDLWaypointTypeAll;
        
        expect(testRequest.waypointType).to(equal(SDLWaypointTypeAll));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameRequest:
                                           @{SDLNameParameters:
                                                 @{SDLNameWaypointType:SDLWaypointTypeAll},
                                             SDLNameOperationName:SDLNameGetWaypoints}} mutableCopy];
        SDLGetWaypoints* testRequest = [[SDLGetWaypoints alloc] initWithDictionary:dict];
        
        expect(testRequest.waypointType).to(equal(SDLWaypointTypeAll));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLGetWaypoints* testRequest = [[SDLGetWaypoints alloc] init];
        
        expect(testRequest.waypointType).to(beNil());
    });
});

QuickSpecEnd
