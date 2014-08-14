//
//  LMPropertyAnalyticsVC.m
//  IUEditor
//
//  Created by jw on 2014. 7. 22..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyAnalyticsVC.h"

@interface LMPropertyAnalyticsVC ()
@property (unsafe_unretained) IBOutlet NSTextView *googleCodeTV;


@end

@implementation LMPropertyAnalyticsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)setController:(IUController *)controller{
    _controller = controller;
    [_controller addObserver:self forKeyPath:@"selection" options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"selection"]) {
        self.selection = _controller.selection;
        return;
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



- (void)awakeFromNib{
    NSDictionary *bindingOption = [NSDictionary
                                   dictionaryWithObjects:@[[NSNumber numberWithBool:NO], [NSNumber numberWithBool:YES]]
                                   forKeys:@[NSRaisesForNotApplicableKeysBindingOption, NSContinuouslyUpdatesValueBindingOption]];
    
    
    [_googleCodeTV bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"googleCode"]  options:bindingOption];
    
}

@end
