//
//  LMPropertyProgrammingType2VC.m
//  IUEditor
//
//  Created by jd on 6/13/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMPropertyProgrammingType2VC.h"

@interface LMPropertyProgrammingType2VC ()
@property (weak) IBOutlet NSTextField *contentTF;

@property (weak) IBOutlet NSTextField *ellipsisTF;
@property (weak) IBOutlet NSStepper *ellipsisStepper;
@property (weak) IBOutlet NSTextField *visibleTF;

@end

@implementation LMPropertyProgrammingType2VC{
    IUProject *_project;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadView];
    }
    return self;
}

- (void)setController:(IUController *)controller{
    _controller = controller;
    
    [_visibleTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"pgVisibleConditionVariable"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    
    [_contentTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"pgContentVariable"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    
    NSDictionary *enableBinding = @{NSRaisesForNotApplicableKeysBindingOption:@(NO),NSValueTransformerNameBindingOption:@"JDNilToZeroTransformer"};

//    [_ellipsisTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"pgContentVariable"] options:enableBinding];
//    [_ellipsisTF bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasText"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    
//    [_ellipsisStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"pgContentVariable"] options:enableBinding];
//    [_ellipsisStepper bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasText"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    
    [_ellipsisTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagEllipsis] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_ellipsisStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagEllipsis] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];

}

@end
