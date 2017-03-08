//
//  SDLStreamDelegate.h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// Convenience typedefs
typedef void (^SDLStreamOpenHandler)(NSStream *stream);
typedef void (^SDLStreamHasBytesHandler)(NSInputStream *istream);
typedef void (^SDLStreamHasSpaceHandler)(NSOutputStream *ostream);
typedef void (^SDLStreamErrorHandler)(NSStream *stream);
typedef void (^SDLStreamEndHandler)(NSStream *stream);


@interface SDLStreamDelegate : NSObject <NSStreamDelegate>

@property (nullable, nonatomic, copy) SDLStreamOpenHandler streamOpenHandler;
@property (nullable, nonatomic, copy) SDLStreamHasBytesHandler streamHasBytesHandler;
@property (nullable, nonatomic, copy) SDLStreamHasSpaceHandler streamHasSpaceHandler;
@property (nullable, nonatomic, copy) SDLStreamErrorHandler streamErrorHandler;
@property (nullable, nonatomic, copy) SDLStreamEndHandler streamEndHandler;

@end

NS_ASSUME_NONNULL_END
