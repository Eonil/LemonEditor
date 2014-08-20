//
//  LMPropertyVC.m
//  IUEditor
//
//  Created by jd on 4/3/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMAppearanceFrameVC.h"
#import "IUBox.h"
#import "IUCSS.h"
#import "LMHelpWC.h"
#import "IUPageContent.h"

@interface LMAppearanceFrameVC ()

//pixel TextField
@property (weak) IBOutlet NSTextField *xTF;
@property (weak) IBOutlet NSTextField *yTF;
@property (weak) IBOutlet NSTextField *wTF;
@property (weak) IBOutlet NSTextField *hTF;

//percent TextField
@property (weak) IBOutlet NSTextField *pxTF;
@property (weak) IBOutlet NSTextField *pyTF;
@property (weak) IBOutlet NSTextField *pwTF;
@property (weak) IBOutlet NSTextField *phTF;

//pixel stepper
@property (weak) IBOutlet NSStepper *xStepper;
@property (weak) IBOutlet NSStepper *yStepper;
@property (weak) IBOutlet NSStepper *wStepper;
@property (weak) IBOutlet NSStepper *hStepper;

//percent stepper
@property (weak) IBOutlet NSStepper *pxStepper;
@property (weak) IBOutlet NSStepper *pyStepper;
@property (weak) IBOutlet NSStepper *pwStepper;
@property (weak) IBOutlet NSStepper *phStepper;


@property (weak) IBOutlet NSButton *xUnitBtn;
@property (weak) IBOutlet NSButton *yUnitBtn;
@property (weak) IBOutlet NSButton *wUnitBtn;
@property (weak) IBOutlet NSButton *hUnitBtn;

@property (weak) IBOutlet NSButton *centerBtn;


@property (weak) IBOutlet NSButton *helpMenu;
@property (weak) IBOutlet NSPopUpButton *positionPopupBtn;

@property (nonatomic) BOOL enableVerticalPercent, enablePosition;


- (IBAction)helpMenu:(id)sender;


@end

@implementation LMAppearanceFrameVC{
    LMHelpWC *helpWC;
    BOOL enableObservation;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _enableVerticalPercent = YES;
        _enablePosition = YES;
        enableObservation = YES;
        [self loadView];
    }
    return self;
}


- (void)setController:(IUController *)controller{
    [super setController:controller];
    
    //observing
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMQSelect:) name:IUNotificationMQSelected object:nil];


    //binding
    NSDictionary *percentHiddeBindingOption = [NSDictionary
                                            dictionaryWithObjects:@[[NSNumber numberWithBool:NO], NSNegateBooleanTransformerName]
                                            forKeys:@[NSRaisesForNotApplicableKeysBindingOption, NSValueTransformerNameBindingOption]];
    
    [self addObserverForCSSTag:IUCSSTagPixelX options:0 context:nil];
    [self addObserverForCSSTag:IUCSSTagPixelY options:0 context:nil];
    [self addObserverForCSSTag:IUCSSTagPixelWidth options:0 context:nil];
    [self addObserverForCSSTag:IUCSSTagPixelHeight options:0 context:nil];
    [self addObserverForCSSTag:IUCSSTagPercentX options:0 context:nil];
    [self addObserverForCSSTag:IUCSSTagPercentY options:0 context:nil];
    [self addObserverForCSSTag:IUCSSTagPercentWidth options:0 context:nil];
    [self addObserverForCSSTag:IUCSSTagPercentHeight options:0 context:nil];
    
    [self outlet:_xTF bind:NSHiddenBinding cssTag:IUCSSTagXUnitIsPercent];
    [self outlet:_xStepper bind:NSHiddenBinding cssTag:IUCSSTagXUnitIsPercent];
    [self outlet:_pxTF bind:NSHiddenBinding cssTag:IUCSSTagXUnitIsPercent options:percentHiddeBindingOption];
    [self outlet:_pxStepper bind:NSHiddenBinding cssTag:IUCSSTagXUnitIsPercent options:percentHiddeBindingOption];

    [self outlet:_yTF bind:NSHiddenBinding cssTag:IUCSSTagYUnitIsPercent];
    [self outlet:_yStepper bind:NSHiddenBinding cssTag:IUCSSTagYUnitIsPercent];
    [self outlet:_pyTF bind:NSHiddenBinding cssTag:IUCSSTagYUnitIsPercent options:percentHiddeBindingOption];
    [self outlet:_pyStepper bind:NSHiddenBinding cssTag:IUCSSTagYUnitIsPercent options:percentHiddeBindingOption];

    [self outlet:_wTF bind:NSHiddenBinding cssTag:IUCSSTagWidthUnitIsPercent];
    [self outlet:_wStepper bind:NSHiddenBinding cssTag:IUCSSTagWidthUnitIsPercent];
    [self outlet:_pwTF bind:NSHiddenBinding cssTag:IUCSSTagWidthUnitIsPercent options:percentHiddeBindingOption];
    [self outlet:_pwStepper bind:NSHiddenBinding cssTag:IUCSSTagWidthUnitIsPercent options:percentHiddeBindingOption];
    
    [self outlet:_hTF bind:NSHiddenBinding cssTag:IUCSSTagHeightUnitIsPercent];
    [self outlet:_hStepper bind:NSHiddenBinding cssTag:IUCSSTagHeightUnitIsPercent];
    [self outlet:_phTF bind:NSHiddenBinding cssTag:IUCSSTagHeightUnitIsPercent options:percentHiddeBindingOption];
    [self outlet:_phStepper bind:NSHiddenBinding cssTag:IUCSSTagHeightUnitIsPercent options:percentHiddeBindingOption];
    
    
    [self outlet:_xUnitBtn bind:NSValueBinding cssTag:IUCSSTagXUnitIsPercent];
    [self outlet:_yUnitBtn bind:NSValueBinding cssTag:IUCSSTagYUnitIsPercent];
    [self outlet:_wUnitBtn bind:NSValueBinding cssTag:IUCSSTagWidthUnitIsPercent];
    [self outlet:_hUnitBtn bind:NSValueBinding cssTag:IUCSSTagHeightUnitIsPercent];
    
    [self outlet:_positionPopupBtn bind:NSSelectedIndexBinding property:@"positionType"];
    [self outlet:_centerBtn bind:NSValueBinding property:@"enableCenter"];

    //enabled option 1
    [self outlet:_xTF bind:NSEnabledBinding property:@"hasX"];
    [self outlet:_yTF bind:NSEnabledBinding property:@"hasY"];
    [self outlet:_wTF bind:NSEnabledBinding property:@"hasWidth"];
    [self outlet:_hTF bind:NSEnabledBinding property:@"hasHeight"];

    [self outlet:_pxTF bind:NSEnabledBinding property:@"hasX"];
    [self outlet:_pyTF bind:NSEnabledBinding property:@"hasY"];
    [self outlet:_pwTF bind:NSEnabledBinding property:@"hasWidth"];
    [self outlet:_phTF bind:NSEnabledBinding property:@"hasHeight"];

    [self outlet:_xUnitBtn bind:NSEnabledBinding property:@"hasX"];
    [self outlet:_yUnitBtn bind:NSEnabledBinding property:@"hasY"];
    [self outlet:_wUnitBtn bind:NSEnabledBinding property:@"hasWidth"];
    [self outlet:_hUnitBtn bind:NSEnabledBinding property:@"hasHeight"];

    [self outlet:_xStepper bind:NSEnabledBinding property:@"hasX"];
    [self outlet:_yStepper bind:NSEnabledBinding property:@"hasY"];
    [self outlet:_wStepper bind:NSEnabledBinding property:@"hasWidth"];
    [self outlet:_hStepper bind:NSEnabledBinding property:@"hasHeight"];

    [self outlet:_pxStepper bind:NSEnabledBinding property:@"hasX"];
    [self outlet:_pyStepper bind:NSEnabledBinding property:@"hasY"];
    [self outlet:_pwStepper bind:NSEnabledBinding property:@"hasWidth"];
    [self outlet:_phStepper bind:NSEnabledBinding property:@"hasHeight"];

    
    [self outlet:_positionPopupBtn bind:NSEnabledBinding property:@"canChangePositionType"];
    [self outlet:_centerBtn bind:NSEnabledBinding property:@"canChangeCenter"];

    
    //enabled option 2
    
    [self outlet:_xTF bind:@"enabled2" property:@"canChangeXByUserInput"];
    [self outlet:_yTF bind:@"enabled2" property:@"canChangeYByUserInput"];
    [self outlet:_wTF bind:@"enabled2" property:@"canChangeWidthByUserInput"];
    [self outlet:_hTF bind:@"enabled2" property:@"canChangeHeightByUserInput"];
    
    [self outlet:_pxTF bind:@"enabled2" property:@"canChangeXByUserInput"];
    [self outlet:_pyTF bind:@"enabled2" property:@"canChangeYByUserInput"];
    [self outlet:_pwTF bind:@"enabled2" property:@"canChangeWidthByUserInput"];
    [self outlet:_phTF bind:@"enabled2" property:@"canChangeHeightByUserInput"];
    
    [self outlet:_xUnitBtn bind:@"enabled2" property:@"canChangeXByUserInput"];
    [self outlet:_yUnitBtn bind:@"enabled2" property:@"canChangeYByUserInput"];
    [self outlet:_wUnitBtn bind:@"enabled2" property:@"canChangeWidthByUserInput"];
    [self outlet:_hUnitBtn bind:@"enabled2" property:@"canChangeHeightByUserInput"];
    
    [self outlet:_xStepper bind:@"enabled2" property:@"canChangeXByUserInput"];
    [self outlet:_yStepper bind:@"enabled2" property:@"canChangeYByUserInput"];
    [self outlet:_wStepper bind:@"enabled2" property:@"canChangeWidthByUserInput"];
    [self outlet:_hStepper bind:@"enabled2" property:@"canChangeHeightByUserInput"];
    
    [self outlet:_pxStepper bind:@"enabled2" property:@"canChangeXByUserInput"];
    [self outlet:_pyStepper bind:@"enabled2" property:@"canChangeYByUserInput"];
    [self outlet:_pwStepper bind:@"enabled2" property:@"canChangeWidthByUserInput"];
    [self outlet:_phStepper bind:@"enabled2" property:@"canChangeHeightByUserInput"];
    
    [_positionPopupBtn bind:@"enabled2" toObject:self withKeyPath:@"enablePosition" options:IUBindingDictNotRaisesApplicable];

    
    
    //enabled option 3
    
    [self outlet:_xTF bind:@"enabled3" property:@"center" options:IUBindingNegationAndNotRaise];
    [self outlet:_pxTF bind:@"enabled3" property:@"center" options:IUBindingNegationAndNotRaise];
    [self outlet:_xUnitBtn bind:@"enabled3" property:@"center" options:IUBindingNegationAndNotRaise];
    [self outlet:_xStepper bind:@"enabled3" property:@"center" options:IUBindingNegationAndNotRaise];
    [self outlet:_pxStepper bind:@"enabled3" property:@"center" options:IUBindingNegationAndNotRaise];
    
    [_yUnitBtn bind:@"enabled3" toObject:self withKeyPath:@"enableVerticalPercent" options:IUBindingDictNotRaisesApplicable];
    [_hUnitBtn bind:@"enabled3" toObject:self withKeyPath:@"enableVerticalPercent" options:IUBindingDictNotRaisesApplicable];
}

- (void)dealloc{
    NSArray *removeObservers = @[[self pathForCSSTag:IUCSSTagPixelX],
                                 [self pathForCSSTag:IUCSSTagPixelY],
                                 [self pathForCSSTag:IUCSSTagPixelWidth],
                                 [self pathForCSSTag:IUCSSTagPixelHeight],
                                 [self pathForCSSTag:IUCSSTagPercentX],
                                 [self pathForCSSTag:IUCSSTagPercentY],
                                 [self pathForCSSTag:IUCSSTagPercentWidth],
                                 [self pathForCSSTag:IUCSSTagPercentHeight]
                                 ];
    
    [self removeObserver:self forKeyPaths:removeObservers];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IUNotificationMQSelected object:nil]; 
    [JDLogUtil log:IULogDealloc string:@"LMAppearanceFrameVC"];
}

#pragma mark - MQSize

- (void)changeMQSelect:(NSNotification *)notification{
    NSInteger selectedSize = [[notification.userInfo valueForKey:IUNotificationMQSize] integerValue];
    NSInteger maxSize = [[notification.userInfo valueForKey:IUNotificationMQMaxSize] integerValue];
    if(selectedSize == maxSize){
        self.enablePosition = YES;
    }
    else{
        self.enablePosition = NO;
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    if(enableObservation){
        if ([[keyPath pathExtension] isSameTag:IUCSSTagPixelX]) {
            [self setValueForTag:IUCSSTagPixelX toTextfield:_xTF toStepper:_xStepper];
        }
        else if ([[keyPath pathExtension] isSameTag:IUCSSTagPixelY]) {
            [self setValueForTag:IUCSSTagPixelY toTextfield:_yTF toStepper:_yStepper];
        }
        else if ([[keyPath pathExtension] isSameTag:IUCSSTagPixelWidth]) {
            [self setValueForTag:IUCSSTagPixelWidth toTextfield:_wTF toStepper:_wStepper];
        }
        else if ([[keyPath pathExtension] isSameTag:IUCSSTagPixelHeight]) {
            [self setValueForTag:IUCSSTagPixelHeight toTextfield:_hTF toStepper:_hStepper];
        }
        else if ([[keyPath pathExtension] isSameTag:IUCSSTagPercentX]) {
            [self setValueForTag:IUCSSTagPercentX toTextfield:_pxTF toStepper:_pxStepper];
        }
        else if ([[keyPath pathExtension] isSameTag:IUCSSTagPercentY]) {
            [self setValueForTag:IUCSSTagPercentY toTextfield:_pyTF toStepper:_pyStepper];
        }
        else if ([[keyPath pathExtension] isSameTag:IUCSSTagPercentWidth]) {
            [self setValueForTag:IUCSSTagPercentWidth toTextfield:_pwTF toStepper:_pwStepper];
        }
        else if ([[keyPath pathExtension] isSameTag:IUCSSTagPercentHeight]) {
            [self setValueForTag:IUCSSTagPercentHeight toTextfield:_phTF toStepper:_phStepper];
        }
        else if ([keyPath isEqualToString:@"controller.selectedObjects"]){
            [self checkForIUPageContent];
        }
    }
}

//FIXME: editor js modify
- (void)checkForIUPageContent{
    BOOL isPageContentChildren = NO;
    for (IUBox *iu in self.controller.selectedObjects) {
        if([iu.parent isKindOfClass:[IUPageContent class]]){
            isPageContentChildren = YES;
            break;
        }
    }

    self.enableVerticalPercent = !isPageContentChildren;
}

- (void)setValueForTag:(IUCSSTag)tag toTextfield:(NSTextField*)textfield toStepper:(NSStepper *)stepper{
    id value = [self valueForCSSTag:tag];
    //default setting
    [[textfield cell] setPlaceholderString:@""];
   
    if (value == nil || value == NSNoSelectionMarker || value == NSMultipleValuesMarker || value == NSNotApplicableMarker){
        if(value){
            //placehoder setting
            NSString *placeholder = [NSString stringWithValueMarker:value];
            [[textfield cell] setPlaceholderString:placeholder];
            [textfield setStringValue:@""];

        }
        else{
            [textfield setStringValue:@"-"];
        }
        [stepper setEnabled:NO];
    }
    else{
        if(value && [value isEqual:textfield.stringValue] == NO){
            if([value isKindOfClass:[NSString class]]){
                [textfield setStringValue:value];
            }
            else{
                [textfield setStringValue:[value stringValue]];
            }
        }
        [stepper setEnabled:YES];
        [stepper setIntegerValue:[value integerValue]];
    }
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor{
    enableObservation = NO;
    IUCSSTag tag;
    if (control == _xTF) {
        tag = IUCSSTagPixelX;
    }
    else if (control == _pxTF) {
        tag = IUCSSTagPercentX;
    }
    else if (control == _yTF) {
        tag = IUCSSTagPixelY;
    }
    else if (control == _pyTF) {
        tag = IUCSSTagPercentY;
    }
    else if (control == _wTF) {
        tag = IUCSSTagPixelWidth;
    }
    else if (control == _pwTF) {
        tag = IUCSSTagPercentWidth;
    }
    else if (control == _hTF) {
        tag = IUCSSTagPixelHeight;
    }
    else if (control == _phTF) {
        tag = IUCSSTagPercentHeight;
    }
    
    [self setCSSFrameValue:[control stringValue] forTag:tag];
    enableObservation = YES;
    return YES;
}
- (IBAction)clickStepper:(id)sender {
    IUCSSTag tag;
    enableObservation = NO;

    if (sender == _xStepper) {
        tag = IUCSSTagPixelX;
    }
    else if (sender == _pxStepper) {
        tag = IUCSSTagPercentX;
    }
    else if (sender == _yStepper) {
        tag = IUCSSTagPixelY;
    }
    else if (sender == _pyStepper) {
        tag = IUCSSTagPercentY;
    }
    else if (sender == _wStepper) {
        tag = IUCSSTagPixelWidth;
    }
    else if (sender == _pwStepper) {
        tag = IUCSSTagPercentWidth;
    }
    else if (sender == _hStepper) {
        tag = IUCSSTagPixelHeight;
    }
    else if (sender == _phStepper) {
        tag = IUCSSTagPercentHeight;
    }
    
    [self setCSSFrameValue:[sender stringValue] forTag:tag];
    enableObservation = YES;

}

- (void)setCSSFrameValue:(id)value forTag:(IUCSSTag)tag{
    for (IUBox *iu in self.controller.selectedObjects) {
        [iu startDragSession];
    }

    id updateValue = value;
    if (value == nil || [value isEqualToString:@"-"]) {
        if([tag isEqualToString:IUCSSTagPixelHeight] || [tag isEqualToString:IUCSSTagPercentHeight]){
            [self setValueWithouUpdateCSS:@(1.0) forCSSTag:IUCSSTagLineHeight];
        }
        
        updateValue = nil;
    }
    [self setValueWithouUpdateCSS:updateValue forCSSTag:tag];
    for (IUBox *iu in self.controller.selectedObjects) {
        [iu endDragSession];
        [iu updateCSS];
    }

}

- (IBAction)helpMenu:(id)sender {
    NSLog(@"this is help menu");
    helpWC = [LMHelpWC sharedHelpWC];
    [helpWC showHelpDocumentWithKey:@"positionProperty"];
}

@end
