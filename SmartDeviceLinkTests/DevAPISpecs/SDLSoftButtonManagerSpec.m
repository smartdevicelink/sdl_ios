#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLArtwork.h"
#import "SDLFileManager.h"
#import "SDLSoftButtonManager.h"
#import "SDLSoftButtonObject.h"
#import "SDLSoftButtonState.h"
#import "TestConnectionManager.h"

QuickSpecBegin(SDLSoftButtonManagerSpec)

describe(@"a soft button manager", ^{
    __block SDLSoftButtonManager *testManager = nil;

    __block SDLFileManager *testFileManager = nil;
    __block TestConnectionManager *testConnectionManager = nil;

    __block SDLSoftButtonObject *testObject1 = nil;
    __block NSString *object1Name = @"O1 Name";
    __block NSString *object1State1Name = @"O1S1 Name";
    __block NSString *object1State2Name = @"O1S2 Name";
    __block NSString *object1State1Text = @"O1S1 Text";
    __block NSString *object1State2Text = @"O1S2 Text";
    __block SDLSoftButtonState *object1State1 = [[SDLSoftButtonState alloc] initWithStateName:object1State1Name text:object1State1Text artwork:nil];
    __block SDLSoftButtonState *object1State2 = [[SDLSoftButtonState alloc] initWithStateName:object1State2Name text:object1State2Text artwork:nil];

    __block SDLSoftButtonObject *testObject2 = nil;
    __block NSString *object2Name = @"O2 Name";
    __block NSString *object2State1Name = @"O2S1 Name";
    __block NSString *object2State1Text = @"O2S1 Text";
    __block NSString *object2State1ArtworkName = @"O2S1 Artwork";
    __block SDLArtwork *object2State1Art = [[SDLArtwork alloc] initWithData:[@"TestData" dataUsingEncoding:NSUTF8StringEncoding] name:object2State1ArtworkName fileExtension:@"png" persistent:YES];
    __block SDLSoftButtonState *object2State1 = [[SDLSoftButtonState alloc] initWithStateName:object2State1Name text:object2State1Text artwork:object2State1Art];

    beforeEach(^{
        testFileManager = OCMClassMock([SDLFileManager class]);
        testConnectionManager = [[TestConnectionManager alloc] init];

        testManager = [[SDLSoftButtonManager alloc] initWithConnectionManager:testConnectionManager fileManager:testFileManager];

        testObject1 = [[SDLSoftButtonObject alloc] initWithName:object1Name states:@[object1State1, object1State2] initialStateName:object1State1Name handler:nil];
        testObject2 = [[SDLSoftButtonObject alloc] initWithName:object2Name state:object2State1 handler:nil];
    });

    it(@"should set soft buttons correctly", ^{
        testManager.softButtonObjects = @[testObject1, testObject2];
    });
});

QuickSpecEnd
