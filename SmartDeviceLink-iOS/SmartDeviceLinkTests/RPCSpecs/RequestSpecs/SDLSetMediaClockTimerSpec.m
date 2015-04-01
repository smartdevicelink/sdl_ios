//
//  SDLSetMediaClockTimerSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNames.h"
#import "SDLSetMediaClockTimer.h"
#import "SDLStartTime.h"
#import "SDLUpdateMode.h"


QuickSpecBegin(SDLSetMediaClockTimerSpec)

SDLStartTime* time1 = [[SDLStartTime alloc] init];
SDLStartTime* time2 = [[SDLStartTime alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSetMediaClockTimer* testRequest = [[SDLSetMediaClockTimer alloc] init];
        
        testRequest.startTime = time1;
        testRequest.endTime = time2;
        testRequest.updateMode = [SDLUpdateMode COUNTUP];
        
        expect(testRequest.startTime).to(equal(time1));
        expect(testRequest.endTime).to(equal(time2));
        expect(testRequest.updateMode).to(equal([SDLUpdateMode COUNTUP]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_startTime:time1,
                                                   NAMES_endTime:time2,
                                                   NAMES_updateMode:[SDLUpdateMode COUNTUP]},
                                             NAMES_operation_name:NAMES_SetMediaClockTimer}} mutableCopy];
        SDLSetMediaClockTimer* testRequest = [[SDLSetMediaClockTimer alloc] initWithDictionary:dict];
        
        expect(testRequest.startTime).to(equal(time1));
        expect(testRequest.endTime).to(equal(time2));
        expect(testRequest.updateMode).to(equal([SDLUpdateMode COUNTUP]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSetMediaClockTimer* testRequest = [[SDLSetMediaClockTimer alloc] init];
        
        expect(testRequest.startTime).to(beNil());
        expect(testRequest.endTime).to(beNil());
        expect(testRequest.updateMode).to(beNil());
    });
});

QuickSpecEnd