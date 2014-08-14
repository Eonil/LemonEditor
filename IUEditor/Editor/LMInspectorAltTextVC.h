//
//  LMInspectorAltTextVC.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 6. 24..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"

@interface LMInspectorAltTextVC : NSViewController

@property (nonatomic, weak) IUController      *controller;
@property (weak) id selection;

@end
