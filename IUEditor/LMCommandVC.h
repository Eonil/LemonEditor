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

@interface LMCommandVC : NSViewController <JDShellUtilPipeDelegate>

@property (weak, nonatomic) IUSheetController      *docController;
- (IBAction)toggleRecording:(id)sender;
- (IBAction)stopServer:(id)sender;

- (void)prepareDealloc;
@end