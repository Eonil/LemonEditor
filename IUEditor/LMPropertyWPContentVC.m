//
//  LMPropertyWPContentVC.m
//  IUEditor
//
//  Created by jw on 7/15/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMPropertyWPContentVC.h"

@interface LMPropertyWPContentVC ()
@property (weak) IBOutlet NSButton *dateB;
@property (weak) IBOutlet NSButton *timeB;
@property (weak) IBOutlet NSButton *categoryB;
@property (weak) IBOutlet NSButton *tagB;
@property (weak) IBOutlet NSMatrix *contentMTX;

@end

@implementation LMPropertyWPContentVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    [_dateB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableDate"] options:IUBindingDictNotRaisesApplicable];
    [_timeB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableTime"] options:IUBindingDictNotRaisesApplicable];
    [_categoryB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableCategory"] options:IUBindingDictNotRaisesApplicable];
    [_tagB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableTag"] options:IUBindingDictNotRaisesApplicable];
  //  [_contentMTX bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"contentType"] options:IUBindingDictNotRaisesApplicable];
}



@end
