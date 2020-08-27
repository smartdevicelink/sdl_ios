//
//  SDLFileWrapper.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 5/11/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLFileWrapper.h"

#import "SDLFile.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLFileWrapper

- (instancetype)initWithFile:(SDLFile *)file completionHandler:(SDLFileManagerUploadCompletionHandler)completionHandler {
    self = [super init];
    if (!self) {
        return nil;
    }

    _file = file;
    _completionHandler = completionHandler;

    return self;
}

+ (instancetype)wrapperWithFile:(SDLFile *)file completionHandler:(SDLFileManagerUploadCompletionHandler)completionHandler {
    return [[self alloc] initWithFile:file completionHandler:completionHandler];
}

@end

NS_ASSUME_NONNULL_END