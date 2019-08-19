//
//  SDLDeleteWindowSpec.m
//  SmartDeviceLinkTests

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDeleteWindow.h"

QuickSpecBegin(SDLDeleteWindowSpec)


describe(@"Getter/Setter Tests", ^ {
    __block int testWindowID = 4;
    
    it(@"Should set and get correctly", ^ {
        SDLDeleteWindow *testRPC = [[SDLDeleteWindow alloc] init];
        testRPC.windowID = @(testWindowID);
        
        expect(testRPC.windowID).to(equal(testWindowID));
    });
    
    it(@"Should create correctrly", ^ {
        SDLDeleteWindow *testRPC = [[SDLDeleteWindow alloc] initWithId:testWindowID];
        
        expect(testRPC.windowID).to(equal(testWindowID));
    });
    
    
});

QuickSpecEnd
