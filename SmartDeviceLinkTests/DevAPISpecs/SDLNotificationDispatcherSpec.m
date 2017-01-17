#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNotificationConstants.h"
#import "SDLNotificationDispatcher.h"


QuickSpecBegin(SDLNotificationDispatcherSpec)

describe(@"a notification dispatcher", ^{
    __block SDLNotificationDispatcher *testDispatcher = nil;
    
    beforeEach(^{
        testDispatcher = [[SDLNotificationDispatcher alloc] init];
    });
    
    it(@"should conform to SDLProxyListener", ^{
        expect(@([testDispatcher conformsToProtocol:@protocol(SDLProxyListener)])).to(beTruthy());
        
        expect(@([testDispatcher respondsToSelector:@selector(onOnDriverDistraction:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnHMIStatus:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onProxyClosed)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onProxyOpened)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onAddCommandResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onAddSubMenuResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onAlertManeuverResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onAlertResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onChangeRegistrationResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onCreateInteractionChoiceSetResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onDeleteCommandResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onDeleteInteractionChoiceSetResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onDeleteSubMenuResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onDiagnosticMessageResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onDialNumberResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onEncodedSyncPDataResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onEndAudioPassThruResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onError:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onGenericResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onGetDTCsResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onGetVehicleDataResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onGetWayPointsResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onReceivedLockScreenIcon:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnAppInterfaceUnregistered:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnAudioPassThru:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnButtonEvent:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnButtonPress:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnCommand:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnEncodedSyncPData:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnHashChange:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnLanguageChange:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnLockScreenNotification:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnSyncPData:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnSystemRequest:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnTBTClientState:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnTouchEvent:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnVehicleData:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnWayPointChange:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onPerformAudioPassThruResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onPerformInteractionResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onPutFileResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onReadDIDResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onRegisterAppInterfaceResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onResetGlobalPropertiesResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onScrollableMessageResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSendLocationResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSetAppIconResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSetDisplayLayoutResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSetGlobalPropertiesResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSetMediaClockTimerResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onShowConstantTBTResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onShowResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSliderResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSpeakResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSubscribeButtonResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSubscribeVehicleDataResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSubscribeWayPointsResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSyncPDataResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onUpdateTurnListResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onUnregisterAppInterfaceResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onUnsubscribeButtonResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onUnsubscribeVehicleDataResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onUnsubscribeWayPointsResponse:)])).to(beTruthy());
    });
    
    describe(@"when told to post a notification", ^{
        __block NSString *testNotificationName = nil;
        __block NSString *testUserInfo = nil;
        
        __block NSNotification *returnNotification = nil;
        
        beforeEach(^{
            testNotificationName = @"com.test.notification";
            testUserInfo = @"testuserinfo";
            
            [[NSNotificationCenter defaultCenter] addObserverForName:testNotificationName object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
                returnNotification = note;
            }];
            
            [testDispatcher postNotificationName:testNotificationName infoObject:testUserInfo];
        });
        
        it(@"should post", ^{
            expect(returnNotification.userInfo[SDLNotificationUserInfoObject]).toEventually(match(testUserInfo));
            expect(returnNotification.object).toEventually(equal(testDispatcher));
        });
    });
});

QuickSpecEnd
