//
//  SDLStartTimeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLStartTime.h"
#import "SDLNames.h"

QuickSpecBegin(SDLStartTimeSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLStartTime* testStruct = [[SDLStartTime alloc] init];
        
        testStruct.hours = @22;
        testStruct.minutes = @39;
        testStruct.seconds = @11;
        
        expect(testStruct.hours).to(equal(@22));
        expect(testStruct.minutes).to(equal(@39));
        expect(testStruct.seconds).to(equal(@11));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_hours:@22,
                                       NAMES_minutes:@39,
                                       NAMES_seconds:@11} mutableCopy];
        SDLStartTime* testStruct = [[SDLStartTime alloc] initWithDictionary:dict];
        
        expect(testStruct.hours).to(equal(@22));
        expect(testStruct.minutes).to(equal(@39));
        expect(testStruct.seconds).to(equal(@11));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLStartTime* testStruct = [[SDLStartTime alloc] init];
        
        expect(testStruct.hours).to(beNil());
        expect(testStruct.minutes).to(beNil());
        expect(testStruct.seconds).to(beNil());
    });
});

QuickSpecEnd