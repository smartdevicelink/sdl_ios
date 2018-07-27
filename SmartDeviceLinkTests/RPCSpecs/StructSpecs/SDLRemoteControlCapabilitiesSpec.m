//
//  SDLRemoteControlCapabilitiesSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRemoteControlCapabilities.h"
#import "SDLClimateControlCapabilities.h"
#import "SDLRadioControlCapabilities.h"
#import "SDLSeatControlCapabilities.h"
#import "SDLButtonCapabilities.h"
#import "SDLNames.h"

QuickSpecBegin(SDLRemoteControlCapabilitiesSpec)

__block SDLClimateControlCapabilities* someClimateControlCapabilities = [[SDLClimateControlCapabilities alloc] init];
__block SDLRadioControlCapabilities* someRadioControlCapabilities = [[SDLRadioControlCapabilities alloc] init];
__block SDLButtonCapabilities* someButtonControlCapabilities = [[SDLButtonCapabilities alloc] init];
__block SDLSeatControlCapabilities* someSeatControlCapabilities = [[SDLSeatControlCapabilities alloc] init];



describe(@"Initialization tests", ^{
    it(@"should properly initialize init", ^{
        SDLRemoteControlCapabilities* testStruct = [[SDLRemoteControlCapabilities alloc] init];

        expect(testStruct.seatControlCapabilities).to(beNil());
        expect(testStruct.climateControlCapabilities).to(beNil());
        expect(testStruct.radioControlCapabilities).to(beNil());
        expect(testStruct.buttonCapabilities).to(beNil());
    });
    
    it(@"should properly initialize initWithDictionary", ^{
        
        NSMutableDictionary* dict = [@{SDLNameClimateControlCapabilities : [@[someClimateControlCapabilities] copy],
                                       SDLNameRadioControlCapabilities :[@[someRadioControlCapabilities] copy],
                                       SDLNameButtonCapabilities :[@[someButtonControlCapabilities] copy],
                                       SDLNameSeatControlCapabilities:[@[someSeatControlCapabilities]copy]
                                       } mutableCopy];
        SDLRemoteControlCapabilities* testStruct = [[SDLRemoteControlCapabilities alloc] initWithDictionary:dict];

        expect(testStruct.seatControlCapabilities).to(equal([@[someSeatControlCapabilities] copy]));
        expect(testStruct.climateControlCapabilities).to(equal([@[someClimateControlCapabilities] copy]));
        expect(testStruct.radioControlCapabilities).to(equal([@[someRadioControlCapabilities] copy]));
        expect(testStruct.buttonCapabilities).to(equal([@[someButtonControlCapabilities] copy]));
    });
    
    it(@"Should set and get correctly", ^{
        SDLRemoteControlCapabilities* testStruct = [[SDLRemoteControlCapabilities alloc] init];

        testStruct.seatControlCapabilities = ([@[someSeatControlCapabilities] copy]);
        testStruct.climateControlCapabilities = ([@[someClimateControlCapabilities] copy]);
        testStruct.radioControlCapabilities = [@[someRadioControlCapabilities] copy];
        testStruct.buttonCapabilities = [@[someButtonControlCapabilities] copy];

        expect(testStruct.seatControlCapabilities).to(equal([@[someSeatControlCapabilities] copy]));
        expect(testStruct.climateControlCapabilities).to(equal(([@[someClimateControlCapabilities] copy])));
        expect(testStruct.radioControlCapabilities).to(equal([@[someRadioControlCapabilities] copy]));
        expect(testStruct.buttonCapabilities).to(equal([@[someButtonControlCapabilities] copy]));
    });

    it(@"Should get correctly when initialized with climateControlCapabilities and other RemoteControlCapabilities parameters", ^ {
        SDLRemoteControlCapabilities* testStruct = [[SDLRemoteControlCapabilities alloc] initWithClimateControlCapabilities:[@[someClimateControlCapabilities] copy] radioControlCapabilities:[@[someRadioControlCapabilities] copy] buttonCapabilities:[@[someButtonControlCapabilities] copy]];

        expect(testStruct.seatControlCapabilities).to(beNil());
        expect(testStruct.climateControlCapabilities).to(equal(([@[someClimateControlCapabilities] copy])));
        expect(testStruct.radioControlCapabilities).to(equal([@[someRadioControlCapabilities] copy]));
        expect(testStruct.buttonCapabilities).to(equal([@[someButtonControlCapabilities] copy]));
    });

    it(@"Should get correctly when initialized with climateControlCapabilities and other RemoteControlCapabilities parameters", ^ {
        SDLRemoteControlCapabilities* testStruct = [[SDLRemoteControlCapabilities alloc] initWithClimateControlCapabilities:[@[someClimateControlCapabilities] copy] radioControlCapabilities:[@[someRadioControlCapabilities] copy] buttonCapabilities:[@[someButtonControlCapabilities] copy] seatControlCapabilities:[@[someSeatControlCapabilities] copy]];

        expect(testStruct.seatControlCapabilities).to(equal([@[someSeatControlCapabilities] copy]));
        expect(testStruct.climateControlCapabilities).to(equal(([@[someClimateControlCapabilities] copy])));
        expect(testStruct.radioControlCapabilities).to(equal([@[someRadioControlCapabilities] copy]));
        expect(testStruct.buttonCapabilities).to(equal([@[someButtonControlCapabilities] copy]));
    });
});

QuickSpecEnd
