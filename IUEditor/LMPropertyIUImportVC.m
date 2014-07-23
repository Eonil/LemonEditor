//
//  LMPropertyIURenderVC.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUImportVC.h"
#import "IUSheetGroup.h"
#import "IUClass.h"
#import "IUImport.h"
#import "IUProject.h"

@interface LMPropertyIUImportVC ()
@property (weak) IBOutlet NSPopUpButton *prototypeB;
@end

@implementation LMPropertyIUImportVC {
    IUProject *_project;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadView];
    }
    return self;
}

- (void)awakeFromNib{
    [self addObserver:self forKeyPath:@"controller.selectedObjects"
              options:0 context:@"selection"];
    

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IUNotificationStructureDidChange object:_project];
    [self removeObserver:self forKeyPath:@"controller.selectedObjects" context:@"selection"];
    [self removeObserver:self forKeyPath:[_controller keyPathFromControllerToProperty:@"prototypeClass"]];
}

- (void)structureChanged:(NSNotification*)noti{
    [_prototypeB removeAllItems];
    [_prototypeB addItemWithTitle:@"None"];
    [_prototypeB addItemsWithTitles:[[_project classSheets] valueForKey:@"name"]];
}

- (void)setController:(IUController *)controller{
    _controller = controller;
    [self addObserver:self forKeyPath:[_controller keyPathFromControllerToProperty:@"prototypeClass"] options:0 context:nil];
}


- (void)setProject:(IUProject*)project{
    _project = project;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(structureChanged:) name:IUNotificationStructureDidChange object:project];
    [self structureChanged:nil];
}


- (IBAction)performPrototypeChange:(NSPopUpButton *)sender {
    IUClass *class = [[_project classSheets] objectWithKey:@"name" value:sender.selectedItem.title];
    NSArray *selectedIUs = _controller.selectedObjects;
    for (IUImport *iu in selectedIUs) {
        NSAssert([iu isKindOfClass:[IUImport class]], @"");
        iu.prototypeClass = class;
    }
}

- (void)selectionContextDidChange:(NSDictionary *)change{
    id protoType = [self valueForKeyPath:[_controller keyPathFromControllerToProperty:@"prototypeClass"]];
    
    if(protoType == nil || protoType == NSNoSelectionMarker
       || protoType == NSMultipleValuesMarker || protoType == NSNotApplicableMarker){
        [_prototypeB selectItemWithTitle:@"None"];
    }
    else if(protoType){
        [_prototypeB selectItemWithTitle:((IUClass *)protoType).name];
    }
}



@end