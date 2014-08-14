//
//  LMPropertyIUMovieVC.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"
#import "IUResourceManager.h"

@interface LMPropertyIUMovieVC : NSViewController <NSComboBoxDelegate>

@property (nonatomic, weak) IUResourceManager *resourceManager;
@property (nonatomic, weak) IUController      *controller;
@property (weak) id selection;


@end
