//
//  LMInspectorAltTextVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 6. 24..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMInspectorAltTextVC.h"

@interface LMInspectorAltTextVC ()

@property (weak) IBOutlet NSTextField *altTextTF;

@end

@implementation LMInspectorAltTextVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    [_altTextTF bind:@"value" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"altText"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];

}
@end
