//
//  LMPropertyWPArticleVC
//  IUEditor
//
//  Created by jw on 7/15/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMPropertyWPArticleVC.h"

@interface LMPropertyWPArticleVC ()
@property (weak) IBOutlet NSButton *titleB;
@property (weak) IBOutlet NSButton *dateB;
@property (weak) IBOutlet NSButton *bodyB;

@end

@implementation LMPropertyWPArticleVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    [_titleB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableTitle"] options:IUBindingDictNotRaisesApplicable];
    [_dateB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableDate"] options:IUBindingDictNotRaisesApplicable];
    [_bodyB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableBody"] options:IUBindingDictNotRaisesApplicable];

    /*
    [_dateB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableDate"] options:IUBindingDictNotRaisesApplicable];
    [_timeB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableTime"] options:IUBindingDictNotRaisesApplicable];
    [_categoryB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableCategory"] options:IUBindingDictNotRaisesApplicable];
    [_tagB bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableTag"] options:IUBindingDictNotRaisesApplicable];
  //  [_contentMTX bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"contentType"] options:IUBindingDictNotRaisesApplicable];
     */
}



@end
