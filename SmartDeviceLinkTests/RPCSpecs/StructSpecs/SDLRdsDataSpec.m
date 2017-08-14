//
//  SDLRdsDataSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRdsData.h"
#import "SDLNames.h"

QuickSpecBegin(SDLRdsDataSpec)

describe(@"Initialization tests", ^{
    
    it(@"should properly initialize init", ^{
        SDLRdsData* testStruct = [[SDLRdsData alloc] init];
        

        expect(testStruct.PS).to(beNil());
        expect(testStruct.RT).to(beNil());
        expect(testStruct.CT).to(beNil());
        expect(testStruct.PI).to(beNil());
        expect(testStruct.PTY).to(beNil());
        expect(testStruct.TP).to(beNil());
        expect(testStruct.TA).to(beNil());
        expect(testStruct.REG).to(beNil());
    });
    
    it(@"should properly initialize initWithDictionary", ^{
        
        NSMutableDictionary* dict = [@{SDLNamePS : @"ps",
                                       SDLNameRT : @"rt",
                                       SDLNameCT : @"2017-07-25T19:20:30-5:00",
                                       SDLNamePI : @"pi",
                                       SDLNamePTY : @5,
                                       SDLNameTP : @NO,
                                       SDLNameTA : @YES,
                                       SDLNameREG : @"reg"} mutableCopy];
        SDLRdsData* testStruct = [[SDLRdsData alloc] initWithDictionary:dict];
        
        expect(testStruct.PS).to(equal(@"ps"));
        expect(testStruct.RT).to(equal(@"rt"));
        expect(testStruct.CT).to(equal(@"2017-07-25T19:20:30-5:00"));
        expect(testStruct.PI).to(equal(@"pi"));
        expect(testStruct.PTY).to(equal(@5));
        expect(testStruct.TP).to(equal(@NO));
        expect(testStruct.TA).to(equal(@YES));
        expect(testStruct.REG).to(equal(@"reg"));
    });
    
    it(@"Should set and get correctly", ^{
        SDLRdsData* testStruct = [[SDLRdsData alloc] init];
        
        testStruct.PS = @"ps";
        testStruct.RT = @"rt";
        testStruct.CT = @"2017-07-25T19:20:30-5:00";
        testStruct.PI = @"pi";
        testStruct.PTY = @5;
        testStruct.TP = @NO;
        testStruct.TA = @YES;
        testStruct.REG = @"reg";
        
        expect(testStruct.PS).to(equal(@"ps"));
        expect(testStruct.RT).to(equal(@"rt"));
        expect(testStruct.CT).to(equal(@"2017-07-25T19:20:30-5:00"));
        expect(testStruct.PI).to(equal(@"pi"));
        expect(testStruct.PTY).to(equal(@5));
        expect(testStruct.TP).to(equal(@NO));
        expect(testStruct.TA).to(equal(@YES));
        expect(testStruct.REG).to(equal(@"reg"));
    });
});

QuickSpecEnd
