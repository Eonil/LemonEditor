//
//  LMServerWC.h
//  IUEditor
//
//  Created by jd on 2014. 7. 28..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "IUProject.h"
#import "JDShellUtil.h"
#import "JDSyncUtil.h"


@interface LMServerWC : NSWindowController <JDShellUtilPipeDelegate, JDSyncUtilDeleagate>

@property (weak) id notificationSender;

- (void)setProject:(IUProject *)project;
- (IUProject *)project;
- (IUServerInfo*)serverInfo;

- (IBAction)download:(id)sender;
- (IBAction)upload:(id)sender;
- (IBAction)serverRestart:(id)sender;

@end
