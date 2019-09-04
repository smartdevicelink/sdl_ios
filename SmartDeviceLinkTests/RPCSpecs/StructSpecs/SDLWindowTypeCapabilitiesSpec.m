//
//  SDLWindowTypeCapabilitiesSpec.m
//  SmartDeviceLinkTests

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRPCParameterNames.h"
#import "SDLWindowTypeCapabilities.h"
#import "SDLWindowType.h"

QuickSpecBegin(SDLWindowTypeCapabilitiesSpec)

describe(@"Getter/Setter Tests", ^ {
    
    it(@"Should get correctly when initialized DESIGNATED", ^ {
        SDLWindowTypeCapabilities* testStruct = [[SDLWindowTypeCapabilities alloc] initWithType:SDLWindowTypeMain maximumNumberOfWindows:4];
        expect(testStruct.type).to(equal(SDLWindowTypeMain));
        expect(testStruct.maximumNumberOfWindows).to(equal(@4));
    });

});

QuickSpecEnd
