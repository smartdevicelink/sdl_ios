//
//  SDLListFilesResponseSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/29/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLListFilesResponse.h"
#import "SDLNames.h"

QuickSpecBegin(SDLListFilesResponseSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLListFilesResponse* testResponse = [[SDLListFilesResponse alloc] init];
        
        testResponse.filenames = [@[@"Music/music.mp3", @"Documents/document.txt", @"Downloads/format.exe"] mutableCopy];
        testResponse.spaceAvailable = @500000000;
        
        expect(testResponse.filenames).to(equal([@[@"Music/music.mp3", @"Documents/document.txt", @"Downloads/format.exe"] mutableCopy]));
        expect(testResponse.spaceAvailable).to(equal(@500000000));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_response:
                                           @{NAMES_parameters:
                                                 @{NAMES_filenames:[@[@"Music/music.mp3", @"Documents/document.txt", @"Downloads/format.exe"] mutableCopy],
                                                   NAMES_spaceAvailable:@500000000},
                                             NAMES_operation_name:NAMES_ListFiles}} mutableCopy];
        SDLListFilesResponse* testResponse = [[SDLListFilesResponse alloc] initWithDictionary:dict];
        
        expect(testResponse.filenames).to(equal([@[@"Music/music.mp3", @"Documents/document.txt", @"Downloads/format.exe"] mutableCopy]));
        expect(testResponse.spaceAvailable).to(equal(@500000000));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLListFilesResponse* testResponse = [[SDLListFilesResponse alloc] init];
        
        expect(testResponse.filenames).to(beNil());
        expect(testResponse.spaceAvailable).to(beNil());
    });
});

QuickSpecEnd