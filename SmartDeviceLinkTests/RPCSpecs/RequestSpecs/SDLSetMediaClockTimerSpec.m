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

describe(@"SetMediaClocktimer Spec", ^ {
    __block NSTimeInterval testTime1Interval = 32887;
    __block NSTimeInterval testTime2Interval = 3723;
    __block SDLStartTime *time1 = [[SDLStartTime alloc] initWithHours:9 minutes:8 seconds:7];
    __block SDLStartTime *time2 = [[SDLStartTime alloc] initWithHours:1 minutes:2 seconds:3];
    __block SDLUpdateMode testUpdateMode = SDLUpdateModeCountUp;
    __block SDLAudioStreamingIndicator testIndicator = SDLAudioStreamingIndicatorPlayPause;

    describe(@"when initialized", ^{
        it(@"should properly initialize with initWithDictionary:", ^{
            NSMutableDictionary* dict = [@{SDLNameRequest:
                                               @{SDLNameParameters:
                                                     @{SDLNameStartTime:time1,
                                                       SDLNameEndTime:time2,
                                                       SDLNameUpdateMode:testUpdateMode,
                                                       SDLNameAudioStreamingIndicator:testIndicator
                                                       },
                                                 SDLNameOperationName:SDLNameSetMediaClockTimer}} mutableCopy];
            SDLSetMediaClockTimer* testRequest = [[SDLSetMediaClockTimer alloc] initWithDictionary:dict];

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
        });

        it(@"should properly initialize with countUpWithStartTimeInterval:endTimeInterval:playPauseIndicator:", ^{
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer countUpFromStartTimeInterval:testTime1Interval toEndTimeInterval:testTime2Interval playPauseIndicator:testIndicator];

            expect(testRequest.startTime).to(equal(time1));
            expect(testRequest.endTime).to(equal(time2));
            expect(testRequest.updateMode).to(equal(SDLUpdateModeCountUp));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
        });

        it(@"should properly initialize with countUpWithStartTime:endTime:playPauseIndicator:", ^{
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer countUpFromStartTime:time1 toEndTime:time2 playPauseIndicator:testIndicator];

            expect(testRequest.startTime).to(equal(time1));
            expect(testRequest.endTime).to(equal(time2));
            expect(testRequest.updateMode).to(equal(SDLUpdateModeCountUp));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
        });

        it(@"should properly initialize with countUpWithStartTimeInterval:endTimeInterval:playPauseIndicator:", ^{
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer countDownFromStartTimeInterval:testTime1Interval toEndTimeInterval:testTime2Interval playPauseIndicator:testIndicator];

            expect(testRequest.startTime).to(equal(time1));
            expect(testRequest.endTime).to(equal(time2));
            expect(testRequest.updateMode).to(equal(SDLUpdateModeCountDown));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
        });

        it(@"should properly initialize with countDownWithStartTime:endTime:playPauseIndicator:", ^{
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer countDownFromStartTime:time1 toEndTime:time2 playPauseIndicator:testIndicator];

            expect(testRequest.startTime).to(equal(time1));
            expect(testRequest.endTime).to(equal(time2));
            expect(testRequest.updateMode).to(equal(SDLUpdateModeCountDown));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
        });

        it(@"should properly initialize with pauseWithPlayPauseIndicator", ^{
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
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer resumeWithPlayPauseIndicator:testIndicator];

            expect(testRequest.startTime).to(beNil());
            expect(testRequest.endTime).to(beNil());
            expect(testRequest.updateMode).to(equal(SDLUpdateModeResume));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
        });

        it(@"should properly initialize with clearWithPlayPauseIndicator:", ^{
            SDLSetMediaClockTimer *testRequest = [SDLSetMediaClockTimer clearWithPlayPauseIndicator:testIndicator];

            expect(testRequest.startTime).to(beNil());
            expect(testRequest.endTime).to(beNil());
            expect(testRequest.updateMode).to(equal(SDLUpdateModeClear));
            expect(testRequest.audioStreamingIndicator).to(equal(testIndicator));
        });

        it(@"should properly initialize with initWithUpdateMode:startTime:endTime:playPauseIndicator:", ^{
            SDLSetMediaClockTimer *testRequest = [[SDLSetMediaClockTimer alloc] initWithUpdateMode:testUpdateMode startTime:time1 endTime:time2 playPauseIndicator:testIndicator];

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
        
        expect(testRequest.startTime).to(equal(time1));
        expect(testRequest.endTime).to(equal(time2));
        expect(testRequest.updateMode).to(equal(SDLUpdateModeCountUp));
        expect(testRequest.audioStreamingIndicator).to(equal(SDLAudioStreamingIndicatorPlayPause));
    });
});

QuickSpecEnd
