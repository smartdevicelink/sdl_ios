//
//  SDLCreateWindowSpec.m
//  SmartDeviceLinkTests

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLCreateWindow.h"
#import "SDLWindowType.h"
#import "SDLPredefinedWindows.h"

QuickSpecBegin(SDLCreateWindowSpec)

describe(@"Getter/Setter Tests", ^ {
    __block SDLWindowType testWindowType = nil;
    __block NSString *testAasociatedServiceType = nil;
    __block NSString *testWindowName = nil;
    __block SDLPredefinedWindows testWindowID;
    __block int testDuplicateUpdatesFromWindowID = 8;
    
    
    beforeEach(^{
        testWindowID = SDLPredefinedWindowsDefaultWindow;
        testWindowType = SDLWindowTypeMain;
        testAasociatedServiceType = @"SDLWINDOW";
        testWindowName = @"MAINWINDOW";
    });
    
    it(@"Should set and get correctly", ^ {
        SDLCreateWindow *testRPC = [[SDLCreateWindow alloc] init];
        testRPC.windowID = @(testWindowID);
        testRPC.windowName = testWindowName;
        testRPC.type = testWindowType;
        testRPC.associatedServiceType = testAasociatedServiceType;
        testRPC.duplicateUpdatesFromWindowID = @(testDuplicateUpdatesFromWindowID);
        
        expect(testRPC.windowID).to(equal(testWindowID));
        expect(testRPC.windowName).to(equal(testWindowName));
        expect(testRPC.type).to(equal(testWindowType));
        expect(testRPC.associatedServiceType).to(equal(testAasociatedServiceType));
        expect(testRPC.duplicateUpdatesFromWindowID).to(equal(testDuplicateUpdatesFromWindowID));
    });
    
    it(@"Should create correctrly", ^ {
        SDLCreateWindow *testRPC = [[SDLCreateWindow alloc] initWithId:(int)testWindowID windowName:testWindowName windowType:testWindowType];
        
        expect(testRPC.windowID).to(equal(testWindowID));
        expect(testRPC.windowName).to(equal(testWindowName));
        expect(testRPC.type).to(equal(testWindowType));
        expect(testRPC.associatedServiceType).to(beNil());
        expect(testRPC.duplicateUpdatesFromWindowID).to(beNil());
    });
    
    it(@"Should create correctrly", ^ {
        SDLCreateWindow *testRPC = [[SDLCreateWindow alloc] initWithId:(int)testWindowID windowName:testWindowName windowType:testWindowType associatedServiceType:testAasociatedServiceType duplicateUpdatesFromWindowID:testDuplicateUpdatesFromWindowID];
        
        expect(testRPC.windowID).to(equal(testWindowID));
        expect(testRPC.windowName).to(equal(testWindowName));
        expect(testRPC.type).to(equal(testWindowType));
        expect(testRPC.associatedServiceType).to(equal(testAasociatedServiceType));
        expect(testRPC.duplicateUpdatesFromWindowID).to(equal(testDuplicateUpdatesFromWindowID));
    });
    
});
QuickSpecEnd
