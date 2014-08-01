//
//  LMPropertyIUMenuItemVC.m
//  IUEditor
//
//  Created by seungmi on 2014. 7. 31..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUMenuItemVC.h"

@interface LMPropertyIUMenuItemVC ()
@property (weak) IBOutlet NSTextField *countTF;
@property (weak) IBOutlet NSStepper *countStepper;
@property (weak) IBOutlet NSColorWell *bgColor;
@property (weak) IBOutlet NSColorWell *fontColor;

@property (weak) IBOutlet NSTextField *titleTF;

@end

@implementation LMPropertyIUMenuItemVC

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
    
    [_countStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasItemChildren"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_countTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasItemChildren"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_countTF bind:NSEditableBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasItemChildren"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    

    [_bgColor bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"bgActive"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_fontColor bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"fontActive"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    
    [_titleTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"text"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
}

@end
