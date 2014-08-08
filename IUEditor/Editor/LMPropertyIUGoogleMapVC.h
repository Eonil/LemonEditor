//
//  LMPropertyIUGoogleMapVC.h
//  IUEditor
//
//  Created by seungmi on 2014. 8. 7..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUResourceManager.h"
#import "IUController.h"


@interface LMPropertyIUGoogleMapVC : NSViewController

@property (nonatomic) IUController      *controller;
@property (strong) IUResourceManager     *resourceManager;


@end
