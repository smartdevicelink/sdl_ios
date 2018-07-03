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
        testRequest.updateMode = SDLUpdateModeCountUp;
        testRequest.enableSeek = @YES;
        
        expect(testRequest.startTime).to(equal(time1));
        expect(testRequest.endTime).to(equal(time2));
        expect(testRequest.updateMode).to(equal(SDLUpdateModeCountUp));
        expect(testRequest.enableSeek).to(beTrue());
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameRequest:
                                           @{SDLNameParameters:
                                                 @{SDLNameStartTime:time1,
                                                   SDLNameEndTime:time2,
                                                   SDLNameUpdateMode:SDLUpdateModeCountUp,
                                                   SDLNameEnableSeek: @YES,
                                                   },
                                             SDLNameOperationName:SDLNameSetMediaClockTimer}} mutableCopy];
        SDLSetMediaClockTimer* testRequest = [[SDLSetMediaClockTimer alloc] initWithDictionary:dict];
        
        expect(testRequest.startTime).to(equal(time1));
        expect(testRequest.endTime).to(equal(time2));
        expect(testRequest.updateMode).to(equal(SDLUpdateModeCountUp));
        expect(testRequest.enableSeek).to(beTrue());
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSetMediaClockTimer* testRequest = [[SDLSetMediaClockTimer alloc] init];
        
        expect(testRequest.startTime).to(beNil());
        expect(testRequest.endTime).to(beNil());
        expect(testRequest.updateMode).to(beNil());
        expect(testRequest.enableSeek).to(beNil());
    });
});

QuickSpecEnd
