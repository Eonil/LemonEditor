//
//  LMPropertyApperenceVC.m
//  IUEditor
//
//  Created by jd on 4/10/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMPropertyBorderVC.h"
#import "JDTransformer.h"

@interface LMPropertyBorderVC ()

@property (weak) IBOutlet NSTextField *borderTF;
@property (weak) IBOutlet NSTextField *borderTopTF;
@property (weak) IBOutlet NSTextField *borderRightTF;
@property (weak) IBOutlet NSTextField *borderLeftTF;
@property (weak) IBOutlet NSTextField *borderBottomTF;

@property (weak) IBOutlet NSStepper *borderStepper;
@property (weak) IBOutlet NSStepper *borderTopStepper;
@property (weak) IBOutlet NSStepper *borderBottomStepper;
@property (weak) IBOutlet NSStepper *borderLeftStepper;
@property (weak) IBOutlet NSStepper *borderRightStepper;

@property (weak) IBOutlet NSColorWell *borderColorWell;
@property (weak) IBOutlet NSColorWell *borderTopColorWell;
@property (weak) IBOutlet NSColorWell *borderLeftColorWell;
@property (weak) IBOutlet NSColorWell *borderRightColorWell;
@property (weak) IBOutlet NSColorWell *borderBottomColorWell;

@property (weak) IBOutlet NSTextField *borderRadiusTF;
@property (weak) IBOutlet NSTextField *borderRadiusTopLeftTF;
@property (weak) IBOutlet NSTextField *borderRadiusTopRightTF;
@property (weak) IBOutlet NSTextField *borderRadiusBottomLeftTF;
@property (weak) IBOutlet NSTextField *borderRadiusBottomRightTF;

@property (weak) IBOutlet NSStepper *borderRadiusStepper;
@property (weak) IBOutlet NSStepper *borderRadiusTopLeftStepper;
@property (weak) IBOutlet NSStepper *borderRadiusTopRightStepper;
@property (weak) IBOutlet NSStepper *borderRadiusBottomLeftStepper;
@property (weak) IBOutlet NSStepper *borderRadiusBottomRightStepper;

@end



@implementation LMPropertyBorderVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadView];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    self.selection = _controller.selection;
}

- (void)setController:(IUController *)controller{
    _controller = controller;
    [_controller addObserver:self forKeyPath:@"selection" options:0 context:nil];
    NSDictionary *bindingOption = @{NSRaisesForNotApplicableKeysBindingOption: @(YES), NSValueTransformerNameBindingOption:@"JDNilToZeroTransformer", NSContinuouslyUpdatesValueBindingOption: @(YES)};
 
    [_borderColorWell bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderColor] options:IUBindingDictNotRaisesApplicable];
    [_borderTopColorWell bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderTopColor]  options:IUBindingDictNotRaisesApplicable];
    [_borderLeftColorWell bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderLeftColor] options:IUBindingDictNotRaisesApplicable];
    [_borderRightColorWell bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderRightColor] options:IUBindingDictNotRaisesApplicable];
    [_borderBottomColorWell bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderBottomColor] options:IUBindingDictNotRaisesApplicable];
    
    [_borderTF bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderWidth] options:bindingOption];
    [_borderTopTF bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderTopWidth] options:bindingOption];
    [_borderBottomTF bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderBottomWidth] options:bindingOption];
    [_borderLeftTF bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderLeftWidth] options:bindingOption];
    [_borderRightTF bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderRightWidth] options:bindingOption];
    
    
    [_borderStepper bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderWidth] options:bindingOption];
    [_borderTopStepper bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderTopWidth] options:bindingOption];
    [_borderBottomStepper bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderBottomWidth] options:bindingOption];
    [_borderLeftStepper bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderLeftWidth] options:bindingOption];
    [_borderRightStepper bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderRightWidth] options:bindingOption];
    
    [_borderRadiusTF bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderRadius] options:bindingOption];
    [_borderRadiusTopLeftTF bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderRadiusTopLeft] options:bindingOption];
    [_borderRadiusTopRightTF bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderRadiusTopRight] options:bindingOption];
    [_borderRadiusBottomLeftTF bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderRadiusBottomLeft] options:bindingOption];
    [_borderRadiusBottomRightTF bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderRadiusBottomRight] options:bindingOption];

    [_borderRadiusStepper bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderRadius] options:bindingOption];
    [_borderRadiusTopLeftStepper bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderRadiusTopLeft] options:bindingOption];
    [_borderRadiusTopRightStepper bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderRadiusTopRight] options:bindingOption];
    [_borderRadiusBottomLeftStepper bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderRadiusBottomLeft] options:bindingOption];
    [_borderRadiusBottomRightStepper bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderRadiusBottomRight] options:bindingOption];

}
- (IBAction)clickBorderColorWell:(id)sender {
    id selectedColor = [_borderColorWell color];
    
    [self setValue:selectedColor forKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderTopColor]];
    [self setValue:selectedColor forKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderBottomColor]];
    [self setValue:selectedColor forKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderLeftColor]];
    [self setValue:selectedColor forKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderRightColor]];

    

}
- (IBAction)clickBorderTotalSize:(id)sender {
    int selectedSize;
    if([sender isKindOfClass:[NSTextField class]]){
        selectedSize = [_borderTF intValue];
        [_borderStepper setIntValue:selectedSize];
    }
    else{
        selectedSize = [_borderStepper intValue];
        [_borderTF setIntValue:selectedSize];
    }
    
    [self setValue:[NSNumber numberWithInt:selectedSize] forKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderTopWidth]];
    [self setValue:[NSNumber numberWithInt:selectedSize] forKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderBottomWidth]];
    [self setValue:[NSNumber numberWithInt:selectedSize] forKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderLeftWidth]];
    [self setValue:[NSNumber numberWithInt:selectedSize] forKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderRightWidth]];
    
}

- (IBAction)clickBorderRadiusTotalSize:(id)sender {
    int selectedSize;
    if([sender isKindOfClass:[NSTextField class]]){
        selectedSize = [_borderRadiusTF intValue];
        [_borderRadiusStepper setIntValue:selectedSize];
    }
    else{
        selectedSize = [_borderRadiusStepper intValue];
        [_borderRadiusTF setIntValue:selectedSize];
    }
    
    [self setValue:[NSNumber numberWithInt:selectedSize] forKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderRadiusTopLeft]];
    [self setValue:[NSNumber numberWithInt:selectedSize] forKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderRadiusTopRight]];
    [self setValue:[NSNumber numberWithInt:selectedSize] forKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderRadiusBottomLeft]];
    [self setValue:[NSNumber numberWithInt:selectedSize] forKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagBorderRadiusBottomRight]];

}

@end