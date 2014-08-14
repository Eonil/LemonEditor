//
//  LMPropertyBGColorVC.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 17..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMAppearanceColorVC.h"

@interface LMAppearanceColorVC ()

@property (weak) IBOutlet NSColorWell *bgColorWell;
@property (weak) IBOutlet NSColorWell *bgGradientStartColorWell;
@property (weak) IBOutlet NSColorWell *bgGradientEndColorWell;
@property (weak) IBOutlet NSButton *enableGradientBtn;

@end

@implementation LMAppearanceColorVC

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
    [NSColor setIgnoresAlpha:NO];

    [_bgColorWell bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBGColor] options:IUBindingDictNotRaisesApplicable];
    
    //gradient
    [_enableGradientBtn bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBGGradient] options:IUBindingDictNotRaisesApplicable];
    
    [_bgGradientStartColorWell bind:NSEnabledBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBGGradient] options:IUBindingDictNotRaisesApplicable];
    [_bgGradientEndColorWell bind:NSEnabledBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBGGradient] options:IUBindingDictNotRaisesApplicable];
    
    [_bgGradientStartColorWell bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBGGradientStartColor] options:IUBindingDictNotRaisesApplicable];
    [_bgGradientEndColorWell bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBGGradientEndColor] options:IUBindingDictNotRaisesApplicable];


}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    self.selection = _controller.selection;
}

- (void)makeClearColor:(id)sender{
    [self setValue:[NSColor clearColor] forKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBGColor]];
}
- (IBAction)clickEnableGradient:(id)sender {
    if([_enableGradientBtn state]){
        id currentColor = [self valueForKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBGColor]];
        [self setValue:currentColor forKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBGGradientStartColor]];
        [self setValue:currentColor forKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBGGradientEndColor]];

    }
    else{
        [_bgGradientStartColorWell deactivate];
        [_bgGradientEndColorWell deactivate];
    }
}

@end
