//
//  SDLProtocolHeaderSpec.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLProtocolHeader.h"
#import "SDLV1ProtocolHeader.h"
#import "SDLV2ProtocolHeader.h"
#import "SDLNames.h"

QuickSpecBegin(SDLProtocolHeaderSpec)

describe(@"HeaderForVersion Tests", ^ {
    it(@"Should return the correct header", ^ {
        expect([SDLProtocolHeader headerForVersion:1]).to(beAKindOf(SDLV1ProtocolHeader.class));
        expect([SDLProtocolHeader headerForVersion:2]).to(beAKindOf(SDLV2ProtocolHeader.class));
    });
    
    it(@"Should return latest version for unknown version", ^ {
        expect([SDLProtocolHeader headerForVersion:5]).to(raiseException().named(NSInvalidArgumentException));
    });
});

QuickSpecEnd