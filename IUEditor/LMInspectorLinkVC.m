//
//  LMPropertyIUBoxVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMInspectorLinkVC.h"
#import "IUSheetGroup.h"
#import "IUSheet.h"
#import "IUPage.h"
#import "IUProject.h"

@interface LMInspectorLinkVC ()
@property (weak) IBOutlet NSPopUpButton *pageLinkPopupButton;
@property (weak) IBOutlet NSPopUpButton *divLinkPB; //not use for alpha 0.2 version
@property (weak) IBOutlet NSButton *urlCheckButton;
@property (weak) IBOutlet NSTextField *urlTF;

@end

@implementation LMInspectorLinkVC{
    IUProject *_project;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        [self loadView];

    }
    return self;
}

- (void)awakeFromNib{
    [_divLinkPB setEnabled:NO];
    
    [self addObserver:self forKeyPath:@"controller.selectedObjects"
              options:0 context:@""];
}


- (void)setProject:(IUProject*)project{
    _project = project;
    [self updateLinkPopupButtonItems];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(structureChanged:) name:IUNotificationStructureDidChange object:project];
}


- (CalledByNoti)structureChanged:(NSNotification*)noti{
    NSDictionary *userInfo = noti.userInfo;
    if ([userInfo[IUNotificationStructureChangedIU] isKindOfClass:[IUPage class]]) {
        [self updateLinkPopupButtonItems];
    }
}
- (void)updateLinkPopupButtonItems{
    [_pageLinkPopupButton removeAllItems];
    for (IUPage *page in [_project pageDocuments]) {
        [_pageLinkPopupButton addItemWithTitle:page.name];
    }

}

- (void)setController:(IUController *)controller{
    NSAssert(_controller == nil, @"duplicated initialize" );
    _controller = controller;
    [self addObserver:self forKeyPath:[controller keyPathFromControllerToProperty:@"link"] options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if([keyPath isEqualToString:@"controller.selectedObjects"]){
        
        [_divLinkPB setEnabled:NO];
        [_urlCheckButton setState:0];
#pragma mark - set link
        id value = [self valueForKeyPath:[_controller keyPathFromControllerToProperty:@"link"]];
        
        if (value == NSNoSelectionMarker || value == nil) {
            [_pageLinkPopupButton setStringValue:@""];
            [_urlTF setStringValue:@""];

        }
        else if (value == NSMultipleValuesMarker) {
            [_pageLinkPopupButton setStringValue:@""];
            [_urlTF setStringValue:@""];
        }
        else {
            if([value isKindOfClass:[IUBox class]]){
                [_pageLinkPopupButton setStringValue:((IUBox *)value).name];
                [_urlCheckButton setState:0];
                [self updateDivLink:value];
            }
            else{
                [_urlCheckButton setState:1];
                [_urlTF setStringValue:value];
            }
        }
        [self updateLinkEnableState];
#pragma mark - set div link
        value = [self valueForKeyPath:[_controller keyPathFromControllerToProperty:@"divLink"]];

        if([value isKindOfClass:[IUBox class]]){
            [_divLinkPB selectItemWithTitle:((IUBox *)value).name];
        }
        else{
            [_divLinkPB selectItemAtIndex:0];
        }
    }
}

- (void)updateLinkEnableState{
    if([_urlCheckButton state] == 0){
        [_pageLinkPopupButton setEnabled:YES];
        [_urlTF setEnabled:NO];
    }
    else{
        [_pageLinkPopupButton setEnabled:NO];
        [_urlTF setEnabled:YES];
    }
}

#pragma mark - IBAction

- (IBAction)clickEnableURLCheckButton:(id)sender {
    [self updateLinkEnableState];
}

- (IBAction)clickLinkPopupButton:(id)sender {
    NSString *link = [_pageLinkPopupButton stringValue];
    if(_project){
        IUBox *box = [_project.identifierManager IUWithIdentifier:link];
        if(box){
            [self setValue:box forKeyPath:[_controller keyPathFromControllerToProperty:@"link"]];
            [self updateDivLink:(IUPage *)box];
        }
        
    }
    
}
- (IBAction)endURLLinkTF:(id)sender {
    NSString *link = [_urlTF stringValue];
    [self setValue:link forKeyPath:[_controller keyPathFromControllerToProperty:@"link"]];
    
}


#pragma mark - div link

- (void)updateDivLink:(IUPage *)page{
    assert([page isKindOfClass:[IUPage class]]);
    [_divLinkPB setEnabled:YES];
    [_divLinkPB removeAllItems];
    [_divLinkPB addItemWithTitle:@"None"];
    for(IUBox *box in page.allChildren){
        [_divLinkPB addItemWithTitle:box.name];
    }
    
    
}
- (IBAction)clickDivLinkPopupBtn:(id)sender {
    
    if([[_divLinkPB selectedItem] isEqualTo:[_divLinkPB itemAtIndex:0]]){
        [self setValue:nil forKeyPath:[_controller keyPathFromControllerToProperty:@"divLink"]];
        return;
    }
    
    NSString *link = [[_divLinkPB selectedItem] title];
    
    if(_project){
        IUBox *box = [_project.identifierManager IUWithIdentifier:link];
        if(box){
            [self setValue:box forKeyPath:[_controller keyPathFromControllerToProperty:@"divLink"]];
        }
    }
 
}

@end
