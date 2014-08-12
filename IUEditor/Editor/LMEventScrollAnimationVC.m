//
//  LMPropertyScrollVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 6. 3..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMEventScrollAnimationVC.h"
#import "LMHelpPopover.h"
#import "IUBox.h"

@interface LMEventScrollAnimationVC ()

@property (weak) IBOutlet NSTextField *opacityMoveTF;
@property (weak) IBOutlet NSTextField *xPosMoveTF;


@end

@implementation LMEventScrollAnimationVC{
    NSArray *observingPaths;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    
    NSDictionary *numberBindingOption = @{NSContinuouslyUpdatesValueBindingOption: @(YES),
                           NSRaisesForNotApplicableKeysBindingOption:@(NO),
                           NSValueTransformerNameBindingOption:@"JDNilToZeroTransformer"};

    
    [_opacityMoveTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"opacityMove"] options:numberBindingOption];
    [_xPosMoveTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"xPosMove"] options:numberBindingOption];
    
    observingPaths =@[[_controller keyPathFromControllerToProperty:@"opacityMove"],
                      [_controller keyPathFromControllerToProperty:@"positionType"]];
    [self addObserver:self forKeyPaths:observingPaths options:0 context:nil];
}

- (void)dealloc{
    [self removeObserver:self forKeyPaths:observingPaths];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([[keyPath pathExtension] isEqualToString:@"opacityMove"]){
        id opacityMove = [self valueForKeyPath:[_controller keyPathFromControllerToProperty:@"opacityMove"]];
        NSArray *selectedObj = [_controller selectedObjects ];
        if ([opacityMove isKindOfClass:[NSNumber class]]) {
            if ([opacityMove floatValue] > 1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    for (IUBox *iu in selectedObj) {
                        iu.opacityMove = 1;
                    }
                });
            }
        }
    }
    else if([[keyPath pathExtension] isEqualToString:@"positionType"]){
        IUPositionType type = [[self valueForKeyPath:[_controller keyPathFromControllerToProperty:@"positionType"]] intValue];
        if(type == IUPositionTypeFloatLeft || type == IUPositionTypeFloatRight){
            [_opacityMoveTF setEditable:NO];
            [_opacityMoveTF setEnabled:NO];
            [_xPosMoveTF setEnabled:NO];
        }
        else{
            [_opacityMoveTF setEditable:YES];
            [_opacityMoveTF setEnabled:YES];
            [_xPosMoveTF setEnabled:YES];
        }
    }
    
}


- (IBAction)clickHelpButton:(NSButton *)sender {
    LMHelpPopover *popover = [LMHelpPopover sharedHelpPopover];
    [popover setType:LMPopoverTypeTextAndVideo];
    [popover setVideoName:@"EventScrollAnimation.mp4" title:@"Scroll Event" rtfFileName:nil];
    [popover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinXEdge];
}
@end
