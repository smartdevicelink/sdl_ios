#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLTextAndGraphicManager.h"
#import "SDLScreenManager.h"
#import "SDLSoftButtonManager.h"
#import "TestConnectionManager.h"

@interface SDLScreenManager()

@property (strong, nonatomic) SDLTextAndGraphicManager *textAndGraphicManager;
@property (strong, nonatomic) SDLSoftButtonManager *softButtonManager;

@end

QuickSpecBegin(SDLScreenManagerSpec)

describe(@"screen manager", ^{
    __block TestConnectionManager *mockConnectionManager = [[TestConnectionManager alloc] init];
    __block SDLFileManager *mockFileManager = OCMClassMock([SDLFileManager class]);
    __block SDLTextAndGraphicManager *mockTextAndGraphicManager = OCMClassMock([SDLTextAndGraphicManager class]);
    __block SDLSoftButtonManager *mockSoftButtonManager = OCMClassMock([SDLSoftButtonManager class]);
    __block SDLScreenManager *testScreenManager = nil;

    beforeEach(^{
        testScreenManager = [[SDLScreenManager alloc] initWithConnectionManager:testConnectionManager fileManager:mockFileManager];
        testScreenManager.textAndGraphicManager = mockTextAndGraphicManager;
        testScreenManager.softButtonManager = mockSoftButtonManager;
    });
});

QuickSpecEnd
