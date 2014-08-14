//
//  LMPropertyOverflowVC.m
//  IUEditor
//
//  Created by G on 2014. 6. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyDisplayVC.h"
#import "IUBox.h"
#import "IUCSS.h"

@interface LMPropertyDisplayVC ()
@property (weak) IBOutlet NSPopUpButton *overflowPopupBtn;
@property (weak) IBOutlet NSButton *displayHideBtn;
@property (weak) IBOutlet NSSlider *opacitySlider;
@property (weak) IBOutlet NSTextField *opacityTF;

@end

@implementation LMPropertyDisplayVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadView];
    }
    return self;
}

- (void)setController:(IUController *)controller{
    _controller = controller;
    [controller addObserver:self forKeyPath:@"selection" options:0 context:nil];

    [_overflowPopupBtn bind:NSSelectedIndexBinding toObject:self withKeyPath:@"self.selection.overflowType" options:IUBindingDictNotRaisesApplicable];
    [_overflowPopupBtn bind:NSEnabledBinding toObject:self withKeyPath:@"self.selection.canChangeOverflow" options:IUBindingDictNotRaisesApplicable];
    /*
    [_displayHideBtn bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.canChangeOverflow." stringByAppendingString:IUCSSTagDisplayIsHidden] options:IUBindingDictNotRaisesApplicable];
    
    NSDictionary *numberBinding =  @{NSContinuouslyUpdatesValueBindingOption:@(YES),NSRaisesForNotApplicableKeysBindingOption:@(NO),NSValueTransformerNameBindingOption:@"JDNilToHundredTransformer"};
    
    [_opacityTF bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.canChangeOverflow."  stringByAppendingString:IUCSSTagOpacity] options:numberBinding];
    [_opacitySlider bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.canChangeOverflow."  stringByAppendingString:IUCSSTagOpacity] options:numberBinding];
     */
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"selection"]) {
        self.selection = _controller.selection;
    }
}



@end
