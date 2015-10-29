#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLFile.h"
#import "SDLFileType.h"


QuickSpecBegin(SDLFileSpec)

describe(@"SDLFile", ^{
    __block SDLFile *testFile = nil;
    
    context(@"when created with data", ^{
        __block NSData *testData = nil;
        __block NSString *testName = nil;
        __block SDLFileType *testFileType = nil;
        __block BOOL testPersistence = NO;
        
        context(@"using test data 1", ^{
            testName = @"Example Name";
            testData = [@"Example Data" dataUsingEncoding:NSUTF8StringEncoding];
            testFileType = [SDLFileType AUDIO_MP3];
            testPersistence = YES;
            
            beforeEach(^{
                testFile = [[SDLFile alloc] initWithData:testData name:testName type:testFileType];
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
        });
        
        context(@"using test data 1", ^{
            beforeEach(^{
                testName = @"Second Name";
                testData = [@"Second piece of data" dataUsingEncoding:NSUTF8StringEncoding];
                testFileType = [SDLFileType BINARY];
                testPersistence = YES;
                
                testFile = [[SDLFile alloc] initWithData:testData name:testName type:testFileType];
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
        });
    });
    
    context(@"when created with a file", ^{
        __block NSString *testFilePath = nil;
        __block NSString *testFileName = nil;
        
        context(@"when created with a bad file path", ^{
            beforeEach(^{
                NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
                testFilePath = [testBundle pathForResource:@"imageThatDoesNotExist" ofType:@"jpg"];
                
                testFile = [[SDLFile alloc] initWithFileAtPath:testFilePath];
            });
            
            it(@"should be nil", ^{
                expect(testFile).to(beNil());
            });
        });
        
        context(@"when created with a good file path", ^{
            beforeEach(^{
                NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
                testFilePath = [testBundle pathForResource:@"testImageJPG" ofType:@"jpg"];
                
                testFile = [[SDLFile alloc] initWithFileAtPath:testFilePath];
            });
            
            it(@"should correctly store data", ^{
                expect(testFile.data).to(equal([NSData dataWithContentsOfFile:testFilePath]));
            });
            
            it(@"should correctly store name", ^{
                expect(testFile.name).to(equal([[NSFileManager defaultManager] displayNameAtPath:testFilePath]));
            });
            
            it(@"should correctly store file type", ^{
                expect(testFile.fileType).to(equal([SDLFileType GRAPHIC_JPEG]));
            });
        });
        
        describe(@"it should recognize file of type", ^{
            context(@"jpg", ^{
                beforeEach(^{
                    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
                    testFilePath = [testBundle pathForResource:@"testImageJPG" ofType:@"jpg"];
                    
                    testFile = [[SDLFile alloc] initWithFileAtPath:testFilePath];
                });
                
                it(@"should properly interpret file type", ^{
                    expect(testFile.fileType).to(equal([SDLFileType GRAPHIC_JPEG]));
                });
            });
            
            context(@"jpeg", ^{
                beforeEach(^{
                    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
                    testFilePath = [testBundle pathForResource:@"testImageJPEG" ofType:@"jpeg"];
                    
                    testFile = [[SDLFile alloc] initWithFileAtPath:testFilePath];
                });
                
                it(@"should properly interpret file type", ^{
                    expect(testFile.fileType).to(equal([SDLFileType GRAPHIC_JPEG]));
                });
            });
            
            context(@"png", ^{
                beforeEach(^{
                    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
                    testFilePath = [testBundle pathForResource:@"testImagePNG" ofType:@"png"];
                    
                    testFile = [[SDLFile alloc] initWithFileAtPath:testFilePath];
                });
                
                it(@"should properly interpret file type", ^{
                    expect(testFile.fileType).to(equal([SDLFileType GRAPHIC_PNG]));
                });
            });
            
            context(@"bmp", ^{
                beforeEach(^{
                    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
                    testFilePath = [testBundle pathForResource:@"testImageBMP" ofType:@"bmp"];
                    
                    testFile = [[SDLFile alloc] initWithFileAtPath:testFilePath];
                });
                
                it(@"should properly interpret file type", ^{
                    expect(testFile.fileType).to(equal([SDLFileType GRAPHIC_BMP]));
                });
            });
            
            // TODO: Audio tests
            
            context(@"json", ^{
                beforeEach(^{
                    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
                    testFilePath = [testBundle pathForResource:@"testFileJSON" ofType:@"json"];
                    
                    testFile = [[SDLFile alloc] initWithFileAtPath:testFilePath];
                });
                
                it(@"should properly interpret file type", ^{
                    expect(testFile.fileType).to(equal([SDLFileType JSON]));
                });
            });
            
            context(@"binary", ^{
                beforeEach(^{
                    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
                    testFilePath = [testBundle pathForResource:@"testImageTIFF" ofType:@"tiff"];
                    
                    testFile = [[SDLFile alloc] initWithFileAtPath:testFilePath];
                });
                
                it(@"should properly interpret file type", ^{
                    expect(testFile.fileType).to(equal([SDLFileType BINARY]));
                });
            });
        });
    });
});

QuickSpecEnd
