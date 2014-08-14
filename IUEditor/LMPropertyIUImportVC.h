//
//  LMPropertyIURenderVC.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"

@interface LMPropertyIUImportVC : NSViewController

@property (nonatomic, weak) IUController      *controller;
@property (weak) id selection;

@property (weak) IUSheet *selectedClass;

- (void)setProject:(IUProject*)project;

@end
