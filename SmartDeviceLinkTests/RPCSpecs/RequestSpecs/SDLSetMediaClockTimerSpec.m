//
//  SDLSetMediaClockTimerSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSetMediaClockTimer.h"
#import "SDLStartTime.h"
#import "SDLUpdateMode.h"


QuickSpecBegin(SDLSetMediaClockTimerSpec)

describe(@"SetMediaClocktimer Spec", ^ {
    __block NSTimeInterval testTime1Interval = 32887;
    __block NSTimeInterval testTime2Interval = 3723;
    __block float testCountRate = 1423.0;
    __block SDLStartTime *time1 = [[SDLStartTime alloc] initWithHours:9 minutes:8 seconds:7];
    __block SDLStartTime *time2 = [[SDLStartTime alloc] initWithHours:1 minutes:2 seconds:3];
    __block SDLUpdateMode testUpdateMode = SDLUpdateModeCountUp;
    __block SDLAudioStreamingIndicator testIndicator = SDLAudioStreamingIndicatorPlayPause;

    describe(@"when initialized", ^{
        it(@"should properly initialize with initWithDictionary:", ^{
            NSDictionary *dict = @{SDLRPCParameterNameRequest:
                                       @{SDLRPCParameterNameParameters:
                                             @{SDLRPCParameterNameStartTime:time1,
                                               SDLRPCParameterNameEndTime:time2,
                                               SDLRPCParameterNameUpdateMode:testUpdateMode,
                                               SDLRPCParameterNameAudioStreamingIndicator:testIndicator
                                             },
                                         SDLRPCParameterNameOperationName:SDLRPCFunctionNameSetMediaClockTimer}
            };
            SDLSetMediaClockTimer *testRequest = [[SDLSetMediaClockTimer alloc] initWithDictionary:dict];

            expect(testRequest.startTime).to(equal(time1));
            expect(testRequest.endTime).to(equal(time2));
            expect(testRequest.updateMode).to(equal(testUpdateMode));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
        });

        it(@"should properly initialize with init", ^{
            SDLSetMediaClockTimer* testRequest = [[SDLSetMediaClockTimer alloc] init];

            expect(testRequest.startTime).to(beNil());
            expect(testRequest.endTime).to(beNil());
            expect(testRequest.updateMode).to(beNil());
            expect(testRequest.audioStreamingIndicator).to(beNil());
            expect(testRequest.countRate).to(beNil());
        });

        it(@"should properly initialize with initWithUpdateMode:startTime:endTime:audioStreamingIndicator:countRate:", ^{
            SDLSetMediaClockTimer* testRequest = [[SDLSetMediaClockTimer alloc] initWithUpdateMode:testUpdateMode startTime:time1 endTime:time2 audioStreamingIndicator:testIndicator countRate:@(testCountRate)];

            expect(testRequest.startTime).to(equal(time1));
            expect(testRequest.endTime).to(equal(time2));
            expect(testRequest.updateMode).to(equal(SDLUpdateModeCountUp));
            expect(testRequest.audioStreamingIndicator).to(equal(SDLAudioStreamingIndicatorPlayPause));
            expect(testRequest.countRate).to(equal(testCountRate));
        });

        it(@"should properly initialize with countUpWithStartTimeInterval:endTimeInterval:playPauseIndicator:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer countUpFromStartTimeInterval:testTime1Interval toEndTimeInterval:testTime2Interval playPauseIndicator:testIndicator];
#pragma clang diagnostic pop

            expect(testRequest.startTime).to(equal(time1));
            expect(testRequest.endTime).to(equal(time2));
            expect(testRequest.updateMode).to(equal(SDLUpdateModeCountUp));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
        });

        it(@"should properly initialize with countUpWithStartTime:endTime:playPauseIndicator:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer countUpFromStartTime:time1 toEndTime:time2 playPauseIndicator:testIndicator];
#pragma clang diagnostic pop

            expect(testRequest.startTime).to(equal(time1));
            expect(testRequest.endTime).to(equal(time2));
            expect(testRequest.updateMode).to(equal(SDLUpdateModeCountUp));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
        });

        it(@"should properly initialize with countUpWithStartTimeInterval:endTimeInterval:playPauseIndicator:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer countDownFromStartTimeInterval:testTime1Interval toEndTimeInterval:testTime2Interval playPauseIndicator:testIndicator];
#pragma clang diagnostic pop

            expect(testRequest.startTime).to(equal(time1));
            expect(testRequest.endTime).to(equal(time2));
            expect(testRequest.updateMode).to(equal(SDLUpdateModeCountDown));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
        });

        it(@"should properly initialize with countDownWithStartTime:endTime:playPauseIndicator:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer countDownFromStartTime:time1 toEndTime:time2 playPauseIndicator:testIndicator];
#pragma clang diagnostic pop

            expect(testRequest.startTime).to(equal(time1));
            expect(testRequest.endTime).to(equal(time2));
            expect(testRequest.updateMode).to(equal(SDLUpdateModeCountDown));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
        });

        it(@"should properly initialize with pauseWithPlayPauseIndicator", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer pauseWithPlayPauseIndicator:testIndicator];
#pragma clang diagnostic pop

            expect(testRequest.startTime).to(beNil());
            expect(testRequest.endTime).to(beNil());
            expect(testRequest.updateMode).to(equal(SDLUpdateModePause));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
        });

        it(@"should properly initialize with updatePauseWithNewStartTimeInterval:endTimeInterval:playPauseIndicator:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer updatePauseWithNewStartTimeInterval:testTime1Interval endTimeInterval:testTime2Interval playPauseIndicator:testIndicator];
#pragma clang diagnostic pop

            expect(testRequest.startTime).to(equal(time1));
            expect(testRequest.endTime).to(equal(time2));
            expect(testRequest.updateMode).to(equal(SDLUpdateModePause));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
        });

        it(@"should properly initialize with updatePauseWithNewStartTime:endTime:playPauseIndicator:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer updatePauseWithNewStartTime:time1 endTime:time2 playPauseIndicator:testIndicator];
#pragma clang diagnostic pop

            expect(testRequest.startTime).to(equal(time1));
            expect(testRequest.endTime).to(equal(time2));
            expect(testRequest.updateMode).to(equal(SDLUpdateModePause));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
        });

        it(@"should properly initialize with resumeWithPlayPauseIndicator:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer resumeWithPlayPauseIndicator:testIndicator];
#pragma clang diagnostic pop

            expect(testRequest.startTime).to(beNil());
            expect(testRequest.endTime).to(beNil());
            expect(testRequest.updateMode).to(equal(SDLUpdateModeResume));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
        });

        it(@"should properly initialize with clearWithPlayPauseIndicator:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer clearWithPlayPauseIndicator:testIndicator];
#pragma clang diagnostic pop

            expect(testRequest.startTime).to(beNil());
            expect(testRequest.endTime).to(beNil());
            expect(testRequest.updateMode).to(equal(SDLUpdateModeClear));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
        });

        it(@"should properly initialize with initWithUpdateMode:startTime:endTime:playPauseIndicator:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLSetMediaClockTimer *testRequest = [[SDLSetMediaClockTimer alloc] initWithUpdateMode:testUpdateMode startTime:time1 endTime:time2 playPauseIndicator:testIndicator];
#pragma clang diagnostic pop

            expect(testRequest.startTime).to(equal(time1));
            expect(testRequest.endTime).to(equal(time2));
            expect(testRequest.updateMode).to(equal(testUpdateMode));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
        });
    });

    it(@"Should set and get correctly", ^ {
        SDLSetMediaClockTimer* testRequest = [[SDLSetMediaClockTimer alloc] init];
        
        testRequest.startTime = time1;
        testRequest.endTime = time2;
        testRequest.updateMode = SDLUpdateModeCountUp;
        testRequest.audioStreamingIndicator = SDLAudioStreamingIndicatorPlayPause;
        testRequest.countRate = @(testCountRate);
        
        expect(testRequest.startTime).to(equal(time1));
        expect(testRequest.endTime).to(equal(time2));
        expect(testRequest.updateMode).to(equal(SDLUpdateModeCountUp));
        expect(testRequest.audioStreamingIndicator).to(equal(SDLAudioStreamingIndicatorPlayPause));
        expect(testRequest.countRate).to(equal(testCountRate));
    });
});

QuickSpecEnd
