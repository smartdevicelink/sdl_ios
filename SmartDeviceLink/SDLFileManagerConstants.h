//
//  SDLFileManagerConstants.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 5/11/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLRPCRequest.h"
#import "SDLRPCResponse.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString SDLFileName;

/**
 *  A completion handler called after a response from Core to a upload request.
 *
 *  @param success              Whether or not the upload was successful
 *  @param bytesAvailable       The amount of space left for files on Core
 *  @param error                The error that occurred during the request if one occurred, nil if no error occured
 */
typedef void (^SDLFileManagerUploadCompletionHandler)(BOOL success, NSUInteger bytesAvailable, NSError *__nullable error);

/**
 *  A completion handler called after a set of upload requests has completed.
 *
 *  @param error                The userInfo dictionary property, of type <SDLFileName: NSError>, contains information on all failed uploads. The key is the name of the file that did not upload properly, the value is an error describing what went wrong on that particular upload attempt. If all files are uploaded successfully, nil is returned
 */
typedef void(^SDLFileManagerMultiUploadCompletionHandler)(NSError *__nullable error);

/**
 *  In a multiple request send, a handler called after each response from Core to a upload request.
 *
 *  @param fileName             The name of the file that received a response from SDL Core
 *  @param uploadPercentage     The percentage of uploaded data. The upload percentage is calculated as the total file size of all attempted file uploads (regardless of the successfulness of the upload) divided by the sum of the data in all the files
 *  @param error                The error that occurred during the request if one occurred, nil if no error occured
 *  @return                     Return NO to cancel any requests that have not yet been sent. Return YES to continue sending requests
 */
typedef BOOL (^SDLFileManagerMultiUploadProgressHandler)(SDLFileName *fileName, float uploadPercentage, NSError *__nullable error);

/**
 *  A completion handler called after a response from Core to a delete request.
 *
 *  @param success              Whether or not the delete was successful
 *  @param bytesAvailable       The amount of space left for files on Core
 *  @param error                The error that occurred during the request if one occurred, nil if no error occured
 */
typedef void (^SDLFileManagerDeleteCompletionHandler)(BOOL success, NSUInteger bytesAvailable, NSError *__nullable error);

/**
 *  A completion handler called after a set of delete requests has completed.
 *
 *  @param error                The userInfo dictionary property, of type <SDLFileName: NSError>, will return information on all failed deletes. The key is the name of the file that did not delete properly, the value is an error describing what went wrong on that particular delete attempt. If all files are deleted successfully, nil is returned
 */
typedef void(^SDLFileManagerMultiDeleteCompletionHandler)(NSError *__nullable error);

/**
 *  A completion handler called after response from Core to a list files request.
 *
 *  @param success              Whether or not the list files request was successful
 *  @param bytesAvailable       The amount of space available for files on Core
 *  @param fileNames            The names of the files stored on SDL Core
 *  @param error                The error that occurred during the request if one occurred, nil if no error occured
 */
typedef void (^SDLFileManagerListFilesCompletionHandler)(BOOL success, NSUInteger bytesAvailable, NSArray<NSString *> *fileNames, NSError *__nullable error);

/**
 *  A completion handler called after a response from Core to a artwork upload request.
 *
 *  @param success             Whether or not the upload was successful
 *  @param artworkName         The unique identifier for the uploaded file.
 *  @param bytesAvailable      The amount of space left for files on Core
 *  @param error               The error that occurred during the request if one occurred, nil if not
 */
typedef void (^SDLFileManagerUploadArtworkCompletionHandler)(BOOL success, NSString *artworkName, NSUInteger bytesAvailable, NSError *__nullable error);

/**
 *  A completion handler called after a set of upload artwork requests has completed.
 *
 *  @param artworkNames         The names of the artwork files successfully uploaded to the remote
 *  @param error                The userInfo dictionary property, of type <NSString: NSError>, contains information on all failed uploads. The key is the name of the artwork that did not upload properly, the value is an error describing what went wrong on that particular upload attempt. If all artworks are uploaded successfully, nil is returned
 */
typedef void (^SDLFileManagerMultiUploadArtworkCompletionHandler)(NSArray<NSString *> *artworkNames, NSError *__nullable error);

/**
 *  In a multiple request send, a handler called after each response from Core to an artwork upload request.
 *
 *  @param artworkName      The unique identifier for the uploaded file
 *  @param uploadPercentage The percentage of uploaded data. The upload percentage is calculated as the total file size of all attempted artwork uploads (regardless of the successfulness of the upload) divided by the sum of the data in all the files
 *  @param error            The error that occurred during the upload request if one occurred, nil if no error occured
 *
 *  @return                 Return NO to cancel any artworks that have not yet been sent. Return YES to continue sending artworks
 */
typedef BOOL (^SDLFileManagerMultiUploadArtworkProgressHandler)(NSString *artworkName, float uploadPercentage, NSError *__nullable error);

NS_ASSUME_NONNULL_END
