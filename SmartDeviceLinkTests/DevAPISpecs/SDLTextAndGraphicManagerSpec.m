#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLFileManager.h"
#import "SDLTextAndGraphicManager.h"
#import "TestConnectionManager.h"

QuickSpecBegin(SDLTextAndGraphicManagerSpec)

describe(@"text and graphic manager", ^{
    __block SDLTextAndGraphicManager *testManager = nil;
    __block TestConnectionManager *mockConnectionManager = [[TestConnectionManager alloc] init];
    __block SDLFileManager *mockFileManager = OCMClassMock([SDLFileManager class]);

    beforeEach(^{
        testManager = [[SDLTextAndGraphicManager alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager];
    });
});

QuickSpecEnd
