//
//  LMPropertyIUTextViewVC.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 5. 5..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"
#import "LMIUPropertyVC.h"

@interface LMPropertyIUTextViewVC : NSViewController <IUPropertyDoubleClickReceiver>

@property (weak, nonatomic) IUController *controller;


@end
