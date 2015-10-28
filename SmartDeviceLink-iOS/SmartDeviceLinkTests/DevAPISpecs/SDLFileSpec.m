#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLFile.h"
#import "SDLFileType.h"


QuickSpecBegin(SDLFileSpec)

describe(@"SDLFile", ^{
    context(@"when created with data", ^{
        __block SDLFile *testFile = nil;
        
        __block NSData *testData = nil;
        __block NSString *testName = nil;
        __block SDLFileType *testFileType = nil;
        __block BOOL testPersistence = NO;
        
        context(@"using test data 1", ^{
            beforeEach(^{
                testName = @"Example Name";
                testData = [@"Example Data" dataUsingEncoding:NSUTF8StringEncoding];
                testFileType = [SDLFileType AUDIO_MP3];
                testPersistence = YES;
                
                testFile = [[SDLFile alloc] initWithData:testData name:testName type:testFileType persistent:testPersistence];
            });
            
            it(@"should correctly store data", ^{
                expect(testFile.data).to(equal(testData));
            });
            
            it(@"should correctly store name", ^{
                expect(testFile.name).to(equal(testName));
            });
            
            it(@"should correctly store file type", ^{
                expect(testFile.fileType).to(equal(testFileType));
            });
            
            it(@"should correctly store persistence", ^{
                expect(@(testFile.persistent)).to(equal(@(testPersistence)));
            });
        });
        
        context(@"using test data 1", ^{
            beforeEach(^{
                testName = @"Second Name";
                testData = [@"Second piece of data" dataUsingEncoding:NSUTF8StringEncoding];
                testFileType = [SDLFileType BINARY];
                testPersistence = YES;
                
                testFile = [[SDLFile alloc] initWithData:testData name:testName type:testFileType persistent:testPersistence];
            });
            
            it(@"should correctly store data", ^{
                expect(testFile.data).to(equal(testData));
            });
            
            it(@"should correctly store name", ^{
                expect(testFile.name).to(equal(testName));
            });
            
            it(@"should correctly store file type", ^{
                expect(testFile.fileType).to(equal(testFileType));
            });
            
            it(@"should correctly store persistence", ^{
                expect(@(testFile.persistent)).to(equal(@(testPersistence)));
            });
        });
    });
    
    xcontext(@"when created with a file", ^{
        
    });
});

QuickSpecEnd
