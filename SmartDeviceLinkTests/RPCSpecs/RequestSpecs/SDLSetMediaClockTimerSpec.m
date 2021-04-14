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
    __block SDLSeekStreamingIndicator *forwardSeekTest;
    __block SDLSeekStreamingIndicator *backSeekTest;

    beforeEach(^{
        forwardSeekTest = [[SDLSeekStreamingIndicator alloc] initWithType:SDLSeekIndicatorTypeTrack];
        backSeekTest = [[SDLSeekStreamingIndicator alloc] initWithType:SDLSeekIndicatorTypeTrack];
    });

    describe(@"when initialized", ^{
        it(@"should properly initialize with initWithDictionary:", ^{
            NSDictionary *dict = @{SDLRPCParameterNameRequest:
                                       @{SDLRPCParameterNameParameters:
                                             @{SDLRPCParameterNameStartTime:time1,
                                               SDLRPCParameterNameEndTime:time2,
                                               SDLRPCParameterNameUpdateMode:testUpdateMode,
                                               SDLRPCParameterNameAudioStreamingIndicator:testIndicator,
                                               SDLRPCParameterNameForwardSeekIndicator:forwardSeekTest,
                                               SDLRPCParameterNameBackSeekIndicator:backSeekTest
                                             },
                                         SDLRPCParameterNameOperationName:SDLRPCFunctionNameSetMediaClockTimer}
            };
            SDLSetMediaClockTimer *testRequest = [[SDLSetMediaClockTimer alloc] initWithDictionary:dict];

            expect(testRequest.startTime).to(equal(time1));
            expect(testRequest.endTime).to(equal(time2));
            expect(testRequest.updateMode).to(equal(testUpdateMode));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
            expect(testRequest.forwardSeekIndicator).to(equal(forwardSeekTest));
            expect(testRequest.backSeekIndicator).to(equal(backSeekTest));
        });

        it(@"should properly initialize with init", ^{
            SDLSetMediaClockTimer* testRequest = [[SDLSetMediaClockTimer alloc] init];

            expect(testRequest.startTime).to(beNil());
            expect(testRequest.endTime).to(beNil());
            expect(testRequest.updateMode).to(beNil());
            expect(testRequest.audioStreamingIndicator).to(beNil());
            expect(testRequest.forwardSeekIndicator).to(beNil());
            expect(testRequest.backSeekIndicator).to(beNil());
            expect(testRequest.countRate).to(beNil());
        });

        it(@"should properly initialize with initWithUpdateMode:startTime:endTime:audioStreamingIndicator:forwardSeekIndicator:backSeekIndicator:countRate:", ^{
            SDLSetMediaClockTimer* testRequest = [[SDLSetMediaClockTimer alloc] initWithUpdateMode:testUpdateMode startTime:time1 endTime:time2 audioStreamingIndicator:testIndicator forwardSeekIndicator:forwardSeekTest backSeekIndicator:backSeekTest countRate:@(testCountRate)];

            expect(testRequest.startTime).to(equal(time1));
            expect(testRequest.endTime).to(equal(time2));
            expect(testRequest.updateMode).to(equal(SDLUpdateModeCountUp));
            expect(testRequest.audioStreamingIndicator).to(equal(SDLAudioStreamingIndicatorPlayPause));
            expect(testRequest.forwardSeekIndicator).to(equal(forwardSeekTest));
            expect(testRequest.backSeekIndicator).to(equal(backSeekTest));
            expect(testRequest.countRate).to(equal(testCountRate));
        });

        it(@"should properly initialize with countUpFromStartTimeInterval:toEndTimeInterval:playPauseIndicator:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer countUpFromStartTimeInterval:testTime1Interval toEndTimeInterval:testTime2Interval playPauseIndicator:testIndicator];
#pragma clang diagnostic pop

            expect(testRequest.startTime).to(equal(time1));
            expect(testRequest.endTime).to(equal(time2));
            expect(testRequest.updateMode).to(equal(SDLUpdateModeCountUp));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
            expect(testRequest.forwardSeekIndicator).to(beNil());
            expect(testRequest.backSeekIndicator).to(beNil());
            expect(testRequest.countRate).to(beNil());
        });

        it(@"should properly initialize with countUpFromStartTimeInterval:toEndTimeInterval:playPauseIndicator:forwardSeekIndicator:backSeekIndicator:countRate:", ^{
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer countUpFromStartTimeInterval:testTime1Interval toEndTimeInterval:testTime2Interval playPauseIndicator:testIndicator forwardSeekIndicator:forwardSeekTest backSeekIndicator:backSeekTest countRate:@(testCountRate)];

            expect(testRequest.startTime).to(equal(time1));
            expect(testRequest.endTime).to(equal(time2));
            expect(testRequest.updateMode).to(equal(SDLUpdateModeCountUp));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
            expect(testRequest.forwardSeekIndicator).to(equal(forwardSeekTest));
            expect(testRequest.backSeekIndicator).to(equal(backSeekTest));
            expect(testRequest.countRate).to(equal(testCountRate));
        });

        it(@"should properly initialize with countUpFromStartTime:toEndTime:playPauseIndicator:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer countUpFromStartTime:time1 toEndTime:time2 playPauseIndicator:testIndicator];
#pragma clang diagnostic pop

            expect(testRequest.startTime).to(equal(time1));
            expect(testRequest.endTime).to(equal(time2));
            expect(testRequest.updateMode).to(equal(SDLUpdateModeCountUp));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
            expect(testRequest.forwardSeekIndicator).to(beNil());
            expect(testRequest.backSeekIndicator).to(beNil());
            expect(testRequest.countRate).to(beNil());
        });

        it(@"should properly initialize with countUpFromStartTime:toEndTime:playPauseIndicator:forwardSeekIndicator:backSeekIndicator:countRate:", ^{
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer countUpFromStartTime:time1 toEndTime:time2 playPauseIndicator:testIndicator forwardSeekIndicator:forwardSeekTest backSeekIndicator:backSeekTest countRate:@(testCountRate)];

            expect(testRequest.startTime).to(equal(time1));
            expect(testRequest.endTime).to(equal(time2));
            expect(testRequest.updateMode).to(equal(SDLUpdateModeCountUp));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
            expect(testRequest.forwardSeekIndicator).to(equal(forwardSeekTest));
            expect(testRequest.backSeekIndicator).to(equal(backSeekTest));
            expect(testRequest.countRate).to(equal(testCountRate));
        });

        it(@"should properly initialize with countDownFromStartTimeInterval:toEndTimeInterval:playPauseIndicator:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer countDownFromStartTimeInterval:testTime1Interval toEndTimeInterval:testTime2Interval playPauseIndicator:testIndicator];
#pragma clang diagnostic pop

            expect(testRequest.startTime).to(equal(time1));
            expect(testRequest.endTime).to(equal(time2));
            expect(testRequest.updateMode).to(equal(SDLUpdateModeCountDown));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
            expect(testRequest.forwardSeekIndicator).to(beNil());
            expect(testRequest.backSeekIndicator).to(beNil());
            expect(testRequest.countRate).to(beNil());
        });

        it(@"should properly initialize with countDownFromStartTimeInterval:toEndTimeInterval:playPauseIndicator:forwardSeekIndicator:backSeekIndicator:countRate:", ^{
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer countDownFromStartTimeInterval:testTime1Interval toEndTimeInterval:testTime2Interval playPauseIndicator:testIndicator forwardSeekIndicator:forwardSeekTest backSeekIndicator:backSeekTest countRate:@(testCountRate)];

            expect(testRequest.startTime).to(equal(time1));
            expect(testRequest.endTime).to(equal(time2));
            expect(testRequest.updateMode).to(equal(SDLUpdateModeCountDown));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
            expect(testRequest.forwardSeekIndicator).to(equal(forwardSeekTest));
            expect(testRequest.backSeekIndicator).to(equal(backSeekTest));
            expect(testRequest.countRate).to(equal(testCountRate));
        });

        it(@"should properly initialize with countDownFromStartTime:toEndTime:playPauseIndicator:", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer countDownFromStartTime:time1 toEndTime:time2 playPauseIndicator:testIndicator];
#pragma clang diagnostic pop

            expect(testRequest.startTime).to(equal(time1));
            expect(testRequest.endTime).to(equal(time2));
            expect(testRequest.updateMode).to(equal(SDLUpdateModeCountDown));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
            expect(testRequest.forwardSeekIndicator).to(beNil());
            expect(testRequest.backSeekIndicator).to(beNil());
            expect(testRequest.countRate).to(beNil());
        });

        it(@"should properly initialize with countDownFromStartTime:toEndTime:playPauseIndicator:forwardSeekIndicator:backSeekIndicator:countRate:", ^{
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer countDownFromStartTime:time1 toEndTime:time2 playPauseIndicator:testIndicator forwardSeekIndicator:forwardSeekTest backSeekIndicator:backSeekTest countRate:@(testCountRate)];

            expect(testRequest.startTime).to(equal(time1));
            expect(testRequest.endTime).to(equal(time2));
            expect(testRequest.updateMode).to(equal(SDLUpdateModeCountDown));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
            expect(testRequest.forwardSeekIndicator).to(equal(forwardSeekTest));
            expect(testRequest.backSeekIndicator).to(equal(backSeekTest));
            expect(testRequest.countRate).to(equal(testCountRate));
        });

        it(@"should properly initialize with pauseWithPlayPauseIndicator:", ^{
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer pauseWithPlayPauseIndicator:testIndicator];

            expect(testRequest.startTime).to(beNil());
            expect(testRequest.endTime).to(beNil());
            expect(testRequest.updateMode).to(equal(SDLUpdateModePause));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
        });

        it(@"should properly initialize with updatePauseWithNewStartTimeInterval:endTimeInterval:playPauseIndicator:", ^{
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer updatePauseWithNewStartTimeInterval:testTime1Interval endTimeInterval:testTime2Interval playPauseIndicator:testIndicator];

            expect(testRequest.startTime).to(equal(time1));
            expect(testRequest.endTime).to(equal(time2));
            expect(testRequest.updateMode).to(equal(SDLUpdateModePause));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
        });

        it(@"should properly initialize with updatePauseWithNewStartTime:endTime:playPauseIndicator:", ^{
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer updatePauseWithNewStartTime:time1 endTime:time2 playPauseIndicator:testIndicator];

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
            expect(testRequest.countRate).to(beNil());
        });

        it(@"should properly initialize with resumeWithPlayPauseIndicator:forwardSeekIndicator:backSeekIndicator:countRate:", ^{
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer resumeWithPlayPauseIndicator:testIndicator forwardSeekIndicator:forwardSeekTest backSeekIndicator:backSeekTest countRate:@(testCountRate)];

            expect(testRequest.startTime).to(beNil());
            expect(testRequest.endTime).to(beNil());
            expect(testRequest.updateMode).to(equal(SDLUpdateModeResume));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
            expect(testRequest.forwardSeekIndicator).to(equal(forwardSeekTest));
            expect(testRequest.backSeekIndicator).to(equal(backSeekTest));
            expect(testRequest.forwardSeekIndicator).to(equal(forwardSeekTest));
            expect(testRequest.backSeekIndicator).to(equal(backSeekTest));
            expect(testRequest.countRate).to(equal(testCountRate));
        });

        it(@"should properly initialize with clearWithPlayPauseIndicator:", ^{
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer clearWithPlayPauseIndicator:testIndicator];

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
        testRequest.forwardSeekIndicator = forwardSeekTest;
        testRequest.backSeekIndicator = backSeekTest;
        testRequest.countRate = @(testCountRate);
        
        expect(testRequest.startTime).to(equal(time1));
        expect(testRequest.endTime).to(equal(time2));
        expect(testRequest.updateMode).to(equal(SDLUpdateModeCountUp));
        expect(testRequest.audioStreamingIndicator).to(equal(SDLAudioStreamingIndicatorPlayPause));
        expect(testRequest.forwardSeekIndicator).to(equal(forwardSeekTest));
        expect(testRequest.backSeekIndicator).to(equal(backSeekTest));
        expect(testRequest.countRate).to(equal(testCountRate));
    });
});

QuickSpecEnd
