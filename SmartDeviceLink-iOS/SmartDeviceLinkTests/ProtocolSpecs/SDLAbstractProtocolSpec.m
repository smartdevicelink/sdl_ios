//
//  SDLAbstractProtocolSpec.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLAbstractProtocol.h"
#import "SDLProtocolListener.h"

QuickSpecBegin(SDLAbstractProtocolSpec)

describe(@"OnTransportConnected Tests", ^ {
    it(@"Should invoke the correct method", ^ {
        id delegateMock = OCMProtocolMock(@protocol(SDLProtocolListener));
        
        SDLAbstractProtocol* abstractProtocol = [[SDLAbstractProtocol alloc] init];
        [abstractProtocol.protocolDelegateTable addObject:delegateMock];
        
        __block BOOL verified = NO;
        [[[delegateMock stub] andDo:^(NSInvocation* invocation) {verified = YES;}] onProtocolOpened];
        
        [abstractProtocol onTransportConnected];
        
        //Verifications don't work with Nimble at this point
        //OCMVerify([delegateMock onProtocolOpened]);
        
        //Workaround for now
        expect(@(verified)).to(beTruthy());
    });
});

describe(@"OnTransportDisconnected Tests", ^ {
    it(@"Should invoke the correct method", ^ {
        id delegateMock = OCMProtocolMock(@protocol(SDLProtocolListener));
        
        SDLAbstractProtocol* abstractProtocol = [[SDLAbstractProtocol alloc] init];
        [abstractProtocol.protocolDelegateTable addObject:delegateMock];
        
        __block BOOL verified = NO;
        [[[delegateMock stub] andDo:^(NSInvocation* invocation) {verified = YES;}] onProtocolClosed];
            
        [abstractProtocol onTransportDisconnected];
        
        //Verifications don't work with Nimble at this point
        //OCMVerify([delegateMock onProtocolClosed]);
        
        //Workaround for now
        expect(@(verified)).to(beTruthy());
    });
});

QuickSpecEnd
