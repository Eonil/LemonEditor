//
//  LMCommandVC.h
//  IUEditor
//
//  Created by jd on 5/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUCompiler.h"
#import "IUSheetController.h"
#import "JDShellUtil.h"
#import "JDSyncUtil.h"

@interface LMCommandVC : NSViewController <JDShellUtilPipeDelegate, JDSyncUtilDeleagate>

@property (weak) IUSheetController      *docController;
- (IBAction)toggleRecording:(id)sender;
- (IBAction)stopServer:(id)sender;
- (IBAction)upload:(id)sender;
- (IBAction)download:(id)sender;
- (IBAction)serverRestart:(id)sender;

- (void)unbindAllBinding;
@end