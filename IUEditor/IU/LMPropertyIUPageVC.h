//
//  LMPropertyIUPageVC.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 5. 12..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"
#import "IUResourceManager.h"


@interface LMPropertyIUPageVC : NSViewController

@property (nonatomic) IUController      *controller;
@property (weak) id selection;

@end
