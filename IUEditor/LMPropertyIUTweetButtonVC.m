//
//  LMPropertyIUTweetButtonVC.m
//  IUEditor
//
//  Created by seungmi on 2014. 8. 5..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUTweetButtonVC.h"

@interface LMPropertyIUTweetButtonVC ()

@property (weak) IBOutlet NSTextField *urlTF;
@property (weak) IBOutlet NSPopUpButton *countTypePopupButton;
@property (weak) IBOutlet NSMatrix *sizeMatrix;
@property (weak) IBOutlet NSTextField *tweetTextTF;
@property (weak) IBOutlet NSMenuItem *verticalMenuItem;

@end

@implementation LMPropertyIUTweetButtonVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    [_urlTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"urlToTweet"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_sizeMatrix bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"sizeType"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_tweetTextTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"tweetText"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];

    
    [_countTypePopupButton bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"countType"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_verticalMenuItem bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableLargeVertical"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];

}

@end
