//
//  LMPropertyBGImageVC.h
//  IUEditor
//
//  Created by JD on 4/5/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUResourceManager.h"
#import "IUController.h"
#import "JDOutlineCellView.h"

@interface LMPropertyBGImageVC : NSViewController <NSComboBoxDelegate>

@property (weak) IUController      *controller;
@property (weak) IUResourceManager     *resourceManager;


@property (weak) id content;
@end