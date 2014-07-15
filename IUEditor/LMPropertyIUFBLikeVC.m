//
//  LMPropertyIUFBLikeVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUFBLikeVC.h"

@interface LMPropertyIUFBLikeVC ()

@property (weak) IBOutlet NSTextField *likePageTF;
@property (weak) IBOutlet NSButton *friendFaceBtn;
@property (weak) IBOutlet NSPopUpButton *colorschemePopupBtn;

@end

@implementation LMPropertyIUFBLikeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    [_likePageTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"likePage"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_friendFaceBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"showFriendsFace"] options:IUBindingDictNotRaisesApplicable];

    [_colorschemePopupBtn bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"colorscheme"] options:IUBindingDictNotRaisesApplicable];

    //enable
    NSDictionary *enableBindingOption = [NSDictionary
                                         dictionaryWithObjects:@[[NSNumber numberWithBool:NO], NSIsNotNilTransformerName]
                                           forKeys:@[NSRaisesForNotApplicableKeysBindingOption, NSValueTransformerNameBindingOption]];

    [_friendFaceBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"likePage"] options:enableBindingOption];
    
}

@end
