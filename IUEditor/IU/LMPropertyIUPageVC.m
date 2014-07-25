//
//  LMPropertyIUPageVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 5. 12..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUPageVC.h"
#import "IUPage.h"

@interface LMPropertyIUPageVC ()

@property (weak) IBOutlet NSTextField *metaImageTF;

@property (weak) IBOutlet NSTextField *titleTF;
@property (weak) IBOutlet NSTextField *keywordsTF;
@property (unsafe_unretained) IBOutlet NSTextView *descriptionTV;
@property (unsafe_unretained) IBOutlet NSTextView *extraCodeTF;

@end

@implementation LMPropertyIUPageVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadView];
    }
    return self;
}

-(void)setController:(IUController *)controller{
    
    _controller = controller;
    
    [_titleTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"title"]  options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_keywordsTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"keywords"]  options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    
    [_extraCodeTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"extraCode"]  options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    
    [_metaImageTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"image"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];


    NSDictionary *bindingOption = [NSDictionary
                                   dictionaryWithObjects:@[[NSNumber numberWithBool:NO], [NSNumber numberWithBool:YES]]
                                   forKeys:@[NSRaisesForNotApplicableKeysBindingOption, NSContinuouslyUpdatesValueBindingOption]];

    
    [_descriptionTV bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"desc"]  options:bindingOption];

   
}

@end
