//
//  LMProjectPropertyWC.m
//  IUEditor
//
//  Created by seungmi on 2014. 7. 16..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMProjectPropertyWC.h"


@interface LMProjectPropertyWC ()
@property (weak)  IUProject *project;

@property (weak) IBOutlet NSComboBox *faviconComboBox;
@property (weak) IBOutlet NSTextField *authorTF;

@end

@implementation LMProjectPropertyWC{
}
- (id)initWithWindowNibName:(NSString *)windowNibName withIUProject:(IUProject *)project{
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        _project = project;
    }
    return self;

}

- (void)windowDidLoad
{
    [super windowDidLoad];
    NSAssert(_project, @"should have project");
        
    [_authorTF bind:NSValueBinding toObject:self withKeyPath:@"project.author" options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    
    [_faviconComboBox bind:NSContentBinding toObject:self withKeyPath:@"project.resourceManager.imageFiles" options:IUBindingDictNotRaisesApplicable];
    [_faviconComboBox bind:NSValueBinding toObject:self withKeyPath:@"project.favicon" options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
}

- (IBAction)pressOKBtn:(id)sender {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];
    [self close];
}

@end
