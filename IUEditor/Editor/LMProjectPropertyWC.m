//
//  LMProjectPropertyWC.m
//  IUEditor
//
//  Created by seungmi on 2014. 7. 16..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMProjectPropertyWC.h"


@interface LMProjectPropertyWC ()
@property  IUProject *project;

@property (weak) IBOutlet NSComboBox *faviconComboBox;
@property (weak) IBOutlet NSTextField *authorTF;


@property (weak) IBOutlet NSTextField *hostTF;
@property (weak) IBOutlet NSTextField *userTF;
@property (weak) IBOutlet NSTextField *passwordTF;
@property (weak) IBOutlet NSTextField *remoteTF;
@property (weak) IBOutlet NSTextField *localTF;

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

    [_hostTF bind:NSValueBinding toObject:_project.serverInfo withKeyPath:@"host" options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_userTF bind:NSValueBinding toObject:_project.serverInfo withKeyPath:@"user" options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_passwordTF bind:NSValueBinding toObject:_project.serverInfo withKeyPath:@"password" options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_localTF bind:NSValueBinding toObject:_project.serverInfo withKeyPath:@"localPath" options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_remoteTF bind:NSValueBinding toObject:_project.serverInfo withKeyPath:@"remotePath" options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];

    
}

- (IBAction)pressOKBtn:(id)sender {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];
    [self close];
}

@end
