//
//  SDLSetAppIconSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSetAppIcon.h"
#import "SDLNames.h"

QuickSpecBegin(SDLSetAppIconSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSetAppIcon* testRequest = [[SDLSetAppIcon alloc] init];
        
        testRequest.syncFileName = @"A/File/Name";
        
        expect(testRequest.syncFileName).to(equal(@"A/File/Name"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLNameRequest:
                                                           @{SDLNameParameters:
                                                                 @{SDLNameSyncFileName:@"A/File/Name"},
                                                             SDLNameOperationName:SDLNameSetAppIcon}} mutableCopy];
        SDLSetAppIcon* testRequest = [[SDLSetAppIcon alloc] initWithDictionary:dict];
        
        expect(testRequest.syncFileName).to(equal(@"A/File/Name"));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSetAppIcon* testRequest = [[SDLSetAppIcon alloc] init];
        
        expect(testRequest.syncFileName).to(beNil());
    });
});

QuickSpecEnd
