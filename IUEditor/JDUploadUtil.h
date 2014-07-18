//
//  JDFTPModule.h
//  IUEditor
//
//  Created by jd on 2014. 7. 17..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JDUploadUtilDeleagate <NSObject>

@required
- (void)uploadUtilReceivedStdOutput:(NSString*)aMessage;
- (void)uploadUtilReceivedStdError:(NSString*)aMessage;
- (void)uploadFinished:(int)terminationStatus;

@end


typedef enum _JDNetworkProtocol{
    JDSCP,
    JDGit,
} JDNetworkProtocol;

@interface JDUploadUtil : NSObject

@property id <JDUploadUtilDeleagate> delegate;

@property NSString *host;
@property NSString *user;
@property NSString *password;
@property NSString *localDirectory;
@property NSString *remoteDirectory;

@property JDNetworkProtocol protocol;

- (BOOL)upload;
- (BOOL)download;
- (BOOL)isUploading;

@end
