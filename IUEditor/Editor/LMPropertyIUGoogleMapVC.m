//
//  LMPropertyIUGoogleMapVC.m
//  IUEditor
//
//  Created by seungmi on 2014. 8. 7..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyIUGoogleMapVC.h"
#import "IUGoogleMap.h"

@interface LMPropertyIUGoogleMapVC ()


//default setting
@property (weak) IBOutlet NSTextField *longTF;
@property (weak) IBOutlet NSTextField *latTF;
@property (weak) IBOutlet NSTextField *zoomLevelTF;
@property (weak) IBOutlet NSStepper *zoomLevelStepper;
@property (weak) IBOutlet NSButton *mapControlBtn;
@property (weak) IBOutlet NSButton *PanControlBtn;
@property (weak) IBOutlet NSButton *zoomControlBtn;

//marker
@property (weak) IBOutlet NSButton *enableMarkerBtn;
@property (weak) IBOutlet NSComboBox *markerIconComboBox;
@property (weak) IBOutlet NSTextField *markTitleTF;

//style
@property (weak) IBOutlet NSColorWell *waterColor;
@property (weak) IBOutlet NSColorWell *roadColor;
@property (weak) IBOutlet NSColorWell *landscapeColor;
@property (weak) IBOutlet NSColorWell *poiColor;

@end

@implementation LMPropertyIUGoogleMapVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{

    
    [_longTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"longitude"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_latTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"latitude"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    
    [_zoomLevelTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"zoomLevel"] options:IUBindingDictNumberAndNotRaisesApplicable];
    [_zoomLevelStepper bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"zoomLevel"] options:IUBindingDictNumberAndNotRaisesApplicable];
    
    [_mapControlBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"mapControl"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_PanControlBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"panControl"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_zoomControlBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"zoomControl"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    
    [_enableMarkerBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableMarkerIcon"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    
    //marker Icon
    [_markerIconComboBox bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableMarkerIcon"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_markTitleTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"markerTitle"]  options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_markerIconComboBox bind:NSContentBinding toObject:self withKeyPath:@"resourceManager.imageFiles" options:IUBindingDictNotRaisesApplicable];
    [_markerIconComboBox bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"markerIconName"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];

    
    
    //style
    [_waterColor bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"water"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_roadColor bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"road"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_landscapeColor bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"landscape"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_poiColor bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"poi"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
 
}

#pragma mark - combobox

- (void)controlTextDidChange:(NSNotification *)obj{
    for (IUGoogleMap *map in self.controller.selectedObjects) {
        id value = [_markerIconComboBox stringValue];
        [map setMarkerIconName:value];
    }
}

- (void)comboBoxSelectionDidChange:(NSNotification *)notification{
    for (IUGoogleMap *map in self.controller.selectedObjects) {
        id value = [_markerIconComboBox objectValueOfSelectedItem];
        [map setMarkerIconName:value];
    }
}

@end
