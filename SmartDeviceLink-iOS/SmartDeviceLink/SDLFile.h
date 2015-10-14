//
//  SDLFile.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/14/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDLFile : NSObject

@property (assign, nonatomic, readonly, getter=isPersistent) BOOL persistent;
@property (copy, nonatomic, readonly) NSString *fileName;

- (instancetype)initWithFileAtPath:(NSString *)path;
- (instancetype)initWithFileAtURL:(NSURL *)url;

- (instancetype)initWithPersistentFileAtPath:(NSString *)path;
- (instancetype)initWithPersistentFileAtURL:(NSURL *)url;

@end
