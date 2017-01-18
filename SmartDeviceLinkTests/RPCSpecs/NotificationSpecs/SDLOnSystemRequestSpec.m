//
//  SDLOnSystemRequestSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLFileType.h"
#import "SDLNames.h"
#import "SDLOnSystemRequest.h"
#import "SDLRequestType.h"


QuickSpecBegin(SDLOnSystemRequestSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnSystemRequest* testNotification = [[SDLOnSystemRequest alloc] init];
        
        testNotification.requestType = SDLRequestTypeFileResume;
        testNotification.url = [@[@"www.google.com"] mutableCopy];
        testNotification.timeout = @52345;
        testNotification.fileType = SDLFileTypePNG;
        testNotification.offset = @2532678684;
        testNotification.length = @50000000000;
        
        expect(testNotification.requestType).to(equal(SDLRequestTypeFileResume));
        expect(testNotification.url).to(equal([@[@"www.google.com"] mutableCopy]));
        expect(testNotification.timeout).to(equal(@52345));
        expect(testNotification.fileType).to(equal(SDLFileTypePNG));
        expect(testNotification.offset).to(equal(@2532678684));
        expect(testNotification.length).to(equal(@50000000000));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameNotification:
                                           @{SDLNameParameters:
                                                 @{SDLNameRequestType:SDLRequestTypeFileResume,
                                                   SDLNameURL:[@[@"www.google.com"] mutableCopy],
                                                   SDLNameTimeout:@52345,
                                                   SDLNameFileType:SDLFileTypePNG,
                                                   SDLNameOffset:@2532678684,
                                                   SDLNameLength:@50000000000},
                                             SDLNameOperationName:SDLNameOnSystemRequest}} mutableCopy];
        SDLOnSystemRequest* testNotification = [[SDLOnSystemRequest alloc] initWithDictionary:dict];
        
        expect(testNotification.requestType).to(equal(SDLRequestTypeFileResume));
        expect(testNotification.url).to(equal([@[@"www.google.com"] mutableCopy]));
        expect(testNotification.timeout).to(equal(@52345));
        expect(testNotification.fileType).to(equal(SDLFileTypePNG));
        expect(testNotification.offset).to(equal(@2532678684));
        expect(testNotification.length).to(equal(@50000000000));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnSystemRequest* testNotification = [[SDLOnSystemRequest alloc] init];
        
        expect(testNotification.requestType).to(beNil());
        expect(testNotification.url).to(beNil());
        expect(testNotification.timeout).to(beNil());
        expect(testNotification.fileType).to(beNil());
        expect(testNotification.offset).to(beNil());
        expect(testNotification.length).to(beNil());
    });
});

QuickSpecEnd
