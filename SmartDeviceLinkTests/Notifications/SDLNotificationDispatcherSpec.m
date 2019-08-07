#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAddCommand.h"
#import "SDLAddCommandResponse.h"
#import "SDLNotificationConstants.h"
#import "SDLNotificationDispatcher.h"
#import "SDLOnCommand.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCRequestNotification.h"
#import "SDLRPCResponseNotification.h"

QuickSpecBegin(SDLNotificationDispatcherSpec)

describe(@"a notification dispatcher", ^{
    __block SDLNotificationDispatcher *testDispatcher = nil;
    
    beforeEach(^{
        testDispatcher = [[SDLNotificationDispatcher alloc] init];
    });

    it(@"should conform to SDLProxyListener", ^{
        expect(@([testDispatcher conformsToProtocol:@protocol(SDLProxyListener)])).to(beTruthy());

        // Responses
        expect(@([testDispatcher respondsToSelector:@selector(onOnDriverDistraction:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnHMIStatus:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onProxyClosed)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onProxyOpened)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onAddCommandResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onAddSubMenuResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onAlertManeuverResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onAlertResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onButtonPressResponse:)])).to(beTruthy());
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
        expect(@([testDispatcher respondsToSelector:@selector(onGetAppServiceDataResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onGetDTCsResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onGetFileResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onGetInteriorVehicleDataResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onGetSystemCapabilityResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onGetVehicleDataResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onGetWayPointsResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onReceivedLockScreenIcon:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onPerformAppServiceInteractionResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onPerformAudioPassThruResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onPerformInteractionResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onPublishAppServiceResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onPutFileResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onReadDIDResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onRegisterAppInterfaceResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onResetGlobalPropertiesResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onScrollableMessageResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSendHapticDataResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSendLocationResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSetAppIconResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSetDisplayLayoutResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSetGlobalPropertiesResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSetInteriorVehicleDataResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSetMediaClockTimerResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onShowConstantTBTResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onShowResponse:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onShowAppMenuResponse:)])).to(beTruthy());
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

        // Requests
        expect(@([testDispatcher respondsToSelector:@selector(onAddCommand:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onAddSubMenu:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onAlert:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onAlertManeuver:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onButtonPress:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onChangeRegistration:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onCreateInteractionChoiceSet:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onDeleteCommand:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onDeleteFile:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onDeleteInteractionChoiceSet:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onDeleteSubMenu:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onDiagnosticMessage:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onDialNumber:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onEncodedSyncPData:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onEndAudioPassThru:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onGetAppServiceData:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onGetDTCs:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onGetFile:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onGetInteriorVehicleData:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onGetSystemCapability:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onGetVehicleData:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onGetWayPoints:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onListFiles:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onPerformAppServiceInteraction:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onPerformAudioPassThru:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onPerformInteraction:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onPublishAppService:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onPutFile:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onReadDID:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onRegisterAppInterface:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onResetGlobalProperties:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onScrollableMessage:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSendHapticData:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSendLocation:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSetAppIcon:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSetDisplayLayout:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSetGlobalProperties:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSetInteriorVehicleData:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSetMediaClockTimer:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onShow:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onShowAppMenu:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onShowConstantTBT:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSlider:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSpeak:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSubscribeButton:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSubscribeVehicleData:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSubscribeWayPoints:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSyncPData:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onSystemRequest:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onUnregisterAppInterface:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onUnsubscribeButton:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onUnsubscribeVehicleData:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onUnsubscribeWayPoints:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onUpdateTurnList:)])).to(beTruthy());

        // Notifications
        expect(@([testDispatcher respondsToSelector:@selector(onOnAppInterfaceUnregistered:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnAppServiceData:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnAudioPassThru:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnButtonEvent:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnButtonPress:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnCommand:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnEncodedSyncPData:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnHashChange:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnLanguageChange:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnLockScreenNotification:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnRCStatus:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnSyncPData:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnSystemCapabilityUpdated:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnSystemRequest:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnTBTClientState:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnTouchEvent:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnVehicleData:)])).to(beTruthy());
        expect(@([testDispatcher respondsToSelector:@selector(onOnWayPointChange:)])).to(beTruthy());
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

    describe(@"when told to post a response", ^{
        __block NSString *testNotificationName = nil;
        __block SDLAddCommandResponse *testResponse = nil;
        __block SDLRPCResponseNotification *testNotification = nil;

        beforeEach(^{
            testNotificationName = SDLDidReceiveAddCommandResponse;
            testResponse = [[SDLAddCommandResponse alloc] init];

            [[NSNotificationCenter defaultCenter] addObserverForName:testNotificationName object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
                SDLRPCResponseNotification *requestNotification = (SDLRPCResponseNotification *)note;
                testNotification = requestNotification;
            }];

            [testDispatcher postRPCResponseNotification:testNotificationName response:testResponse];
        });

        it(@"should successfully post a response", ^{
            expect(testNotification.name).toEventually(equal(testNotificationName));
            expect(testNotification.response).toEventually(equal(testResponse));
            expect(testNotification.object).toEventually(equal(testDispatcher));
        });
    });

    describe(@"when told to post a request", ^{
        __block NSString *testNotificationName = nil;
        __block SDLAddCommand *testRequest = nil;
        __block SDLRPCRequestNotification *testNotification = nil;

        beforeEach(^{
            testNotificationName = SDLDidReceiveAddCommandRequest;
            testRequest = [[SDLAddCommand alloc] init];

            [[NSNotificationCenter defaultCenter] addObserverForName:testNotificationName object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
                SDLRPCRequestNotification *requestNotification = (SDLRPCRequestNotification *)note;
                testNotification = requestNotification;
            }];

            [testDispatcher postRPCRequestNotification:testNotificationName request:testRequest];
        });

        it(@"should successfully post a request", ^{
            expect(testNotification.name).toEventually(equal(testNotificationName));
            expect(testNotification.request).toEventually(equal(testRequest));
            expect(testNotification.object).toEventually(equal(testDispatcher));
        });
    });

    describe(@"when told to post a notification", ^{
        __block NSString *testNotificationName = nil;
        __block SDLOnCommand *testNotificationRequest = nil;
        __block SDLRPCNotificationNotification *testNotification = nil;

        beforeEach(^{
            testNotificationName = SDLDidReceiveCommandNotification;
            testNotificationRequest = [[SDLOnCommand alloc] init];

            [[NSNotificationCenter defaultCenter] addObserverForName:testNotificationName object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
                SDLRPCNotificationNotification *requestNotification = (SDLRPCNotificationNotification *)note;
                testNotification = requestNotification;
            }];

            [testDispatcher postRPCNotificationNotification:testNotificationName notification:testNotificationRequest];
        });

        it(@"should successfully post a notification", ^{
            expect(testNotification.name).toEventually(equal(testNotificationName));
            expect(testNotification.notification).toEventually(equal(testNotificationRequest));
            expect(testNotification.object).toEventually(equal(testDispatcher));
        });
    });
});

QuickSpecEnd
