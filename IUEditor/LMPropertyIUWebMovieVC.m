//
//  LMPropertyIUWebMovieVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUWebMovieVC.h"

@interface LMPropertyIUWebMovieVC ()

@property (weak) IBOutlet NSTextField *webMovieSourceTF;
@property (weak) IBOutlet NSMatrix *autoplayMatrix;
@property (weak) IBOutlet NSButton *loopButton;

@end

@implementation LMPropertyIUWebMovieVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    
     [_webMovieSourceTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"movieLink"]  options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_autoplayMatrix bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"playType"]  options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
     [_loopButton bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableLoop"]  options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];

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

@end
