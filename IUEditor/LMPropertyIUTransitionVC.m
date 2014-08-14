//
//  LMPropertyIUTransitionVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUTransitionVC.h"

@interface LMPropertyIUTransitionVC ()
@property (weak) IBOutlet NSPopUpButton *eventB;
@property (weak) IBOutlet NSPopUpButton *animationB;
@property (weak) IBOutlet NSTextField *durationTF;

@property NSArray *typeArray;

@end

@implementation LMPropertyIUTransitionVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
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

- (void)setController:(IUController *)controller{
    _controller = controller;
    [_controller addObserver:self forKeyPath:@"selection" options:0 context:nil];
}

- (void)awakeFromNib{
    [_eventB bind:NSSelectedValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"eventType"] options:IUBindingDictNotRaisesApplicable];
    [_animationB bind:NSSelectedValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"animation"] options:IUBindingDictNotRaisesApplicable];
    [_durationTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"animationDuration"] options:IUBindingDictNotRaisesApplicable];

    _typeArray = [IUEvent visibleTypeArray];
    
    [_animationB bind:NSContentBinding toObject:self withKeyPath:@"typeArray" options:IUBindingDictNotRaisesApplicable];
}

@end
