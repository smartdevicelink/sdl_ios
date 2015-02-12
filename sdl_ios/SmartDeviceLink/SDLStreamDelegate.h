//
//  SDLStreamDelegate.h
//  AppLink
//
//  Copyright (c) 2014 SDL. All rights reserved.
//

#import <Foundation/Foundation.h>

// Convenience typedefs
typedef void (^SDLStreamOpenHandler)(NSStream *stream);
typedef void (^SDLStreamHasBytesHandler)(NSInputStream *istream);
typedef void (^SDLStreamHasSpaceHandler)(NSOutputStream *ostream);
typedef void (^SDLStreamErrorHandler)(NSStream *stream);
typedef void (^SDLStreamEndHandler)(NSStream *stream);



@interface SDLStreamDelegate : NSObject<NSStreamDelegate>

@property (nonatomic, copy) SDLStreamOpenHandler streamOpenHandler;
@property (nonatomic, copy) SDLStreamHasBytesHandler streamHasBytesHandler;
@property (nonatomic, copy) SDLStreamHasSpaceHandler streamHasSpaceHandler;
@property (nonatomic, copy) SDLStreamErrorHandler streamErrorHandler;
@property (nonatomic, copy) SDLStreamEndHandler streamEndHandler;

@end
