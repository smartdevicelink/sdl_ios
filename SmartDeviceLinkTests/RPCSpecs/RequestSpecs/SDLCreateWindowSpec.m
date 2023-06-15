//
//  SDLCreateWindowSpec.m
//  SmartDeviceLinkTests

@import Quick;
@import Nimble;

#import "SDLCreateWindow.h"
#import "SDLWindowType.h"
#import "SDLPredefinedWindows.h"

QuickSpecBegin(SDLCreateWindowSpec)

describe(@"Getter/Setter Tests", ^ {
    __block SDLWindowType testWindowType = nil;
    __block NSString *testAssociatedServiceType = nil;
    __block NSString *testWindowName = nil;
    __block SDLPredefinedWindows testWindowID;
    __block NSUInteger testDuplicateUpdatesFromWindowID = 8;
    
    
    beforeEach(^{
        testWindowID = SDLPredefinedWindowsDefaultWindow;
        testWindowType = SDLWindowTypeMain;
        testAssociatedServiceType = @"SDLWINDOW";
        testWindowName = @"MAINWINDOW";
    });
    
    it(@"Should set and get correctly", ^ {
        SDLCreateWindow *testRPC = [[SDLCreateWindow alloc] init];
        testRPC.windowID = @(testWindowID);
        testRPC.windowName = testWindowName;
        testRPC.type = testWindowType;
        testRPC.associatedServiceType = testAssociatedServiceType;
        testRPC.duplicateUpdatesFromWindowID = @(testDuplicateUpdatesFromWindowID);
        
        expect(testRPC.windowID).to(equal(testWindowID));
        expect(testRPC.windowName).to(equal(testWindowName));
        expect(testRPC.type).to(equal(testWindowType));
        expect(testRPC.associatedServiceType).to(equal(testAssociatedServiceType));
        expect(testRPC.duplicateUpdatesFromWindowID).to(equal(testDuplicateUpdatesFromWindowID));
    });
    
    it(@"Should create correctrly", ^ {
        SDLCreateWindow *testRPC = [[SDLCreateWindow alloc] initWithId: (int)testWindowID windowName:testWindowName windowType:testWindowType];
        
        expect(testRPC.windowID).to(equal(testWindowID));
        expect(testRPC.windowName).to(equal(testWindowName));
        expect(testRPC.type).to(equal(testWindowType));
        expect(testRPC.associatedServiceType).to(beNil());
        expect(testRPC.duplicateUpdatesFromWindowID).to(beNil());
    });
    
    it(@"Should create correctrly", ^ {
        SDLCreateWindow *testRPC = [[SDLCreateWindow alloc] initWithId:(int)testWindowID windowName:testWindowName windowType:testWindowType associatedServiceType:testAssociatedServiceType duplicateUpdatesFromWindowID:testDuplicateUpdatesFromWindowID];
        
        expect(testRPC.windowID).to(equal(testWindowID));
        expect(testRPC.windowName).to(equal(testWindowName));
        expect(testRPC.type).to(equal(testWindowType));
        expect(testRPC.associatedServiceType).to(equal(testAssociatedServiceType));
        expect(testRPC.duplicateUpdatesFromWindowID).to(equal(testDuplicateUpdatesFromWindowID));
    });
    
});
QuickSpecEnd
