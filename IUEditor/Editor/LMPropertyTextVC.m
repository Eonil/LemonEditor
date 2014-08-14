//
//  LMPropertyTextVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 6. 20..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyTextVC.h"

@interface LMPropertyTextVC ()

@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (weak) IBOutlet NSMatrix *textTypeMatrix;


@end

@implementation LMPropertyTextVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    NSDictionary *bindingOption = [NSDictionary
                                   dictionaryWithObjects:@[[NSNumber numberWithBool:NO], [NSNumber numberWithBool:YES]]
                                   forKeys:@[NSRaisesForNotApplicableKeysBindingOption, NSContinuouslyUpdatesValueBindingOption]];

    [_textView bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"text"] options:bindingOption];

    [_textTypeMatrix bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"textType"] options:IUBindingDictNotRaisesApplicable];

    
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

- (void)performFocus:(NSNotification *)noti{
    [self.view.window makeFirstResponder:_textView];
}

@end
