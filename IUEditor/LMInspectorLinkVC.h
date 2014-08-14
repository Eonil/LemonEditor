//
//  LMPropertyIUBoxVC.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"

@interface LMInspectorLinkVC : NSViewController <NSTextFieldDelegate>

@property (weak) id selection;
@property (nonatomic) IUController      *controller;
- (void)setProject:(IUProject*)project;

@end
