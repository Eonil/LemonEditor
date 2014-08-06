//
//  LMPropertyIUMenuBarVC.m
//  IUEditor
//
//  Created by seungmi on 2014. 7. 31..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUMenuBarVC.h"

@interface LMPropertyIUMenuBarVC ()
@property (weak) IBOutlet NSTextField *countTF;
@property (weak) IBOutlet NSStepper *countStepper;
@property (weak) IBOutlet NSSegmentedControl *alignControl;

@property (weak) IBOutlet NSTextField *mobileTitleTF;
@property (weak) IBOutlet NSColorWell *mobileTitleColor;
@property (weak) IBOutlet NSColorWell *mobileIconColor;

@end

@implementation LMPropertyIUMenuBarVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}


- (void)awakeFromNib{


    [_countStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"count"] options:IUBindingDictNumberAndNotRaisesApplicable];
    [_countTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"count"] options:IUBindingDictNumberAndNotRaisesApplicable];
    
    [_alignControl bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"align"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    
    
    [_mobileTitleTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"mobileTitle"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    
    [_mobileTitleColor bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"mobileTitleColor"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_mobileIconColor bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"iconColor"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    
    

}

@end
