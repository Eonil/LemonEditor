//
//  LMPropertyVC.h
//  IUEditor
//
//  Created by jd on 4/3/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"


@interface LMAppearanceFrameVC : NSViewController <NSTextFieldDelegate>

@property (weak, nonatomic) IUController *controller;
@property (weak) id selection;

@end