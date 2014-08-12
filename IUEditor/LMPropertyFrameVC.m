//
//  LMPropertyVC.m
//  IUEditor
//
//  Created by jd on 4/3/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMPropertyFrameVC.h"
#import "IUBox.h"
#import "IUCSS.h"
#import "LMHelpWC.h"
#import "IUPageContent.h"

@interface LMPropertyFrameVC ()

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

@property (nonatomic) BOOL enablePercentH, enablePosition;


- (IBAction)helpMenu:(id)sender;


@end

@implementation LMPropertyFrameVC{
    LMHelpWC *helpWC;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _enablePercentH = YES;
        _enablePosition = YES;
        [self loadView];
    }
    return self;
}


- (void)setController:(IUController *)controller{
    _controller = controller;
    //observing
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMQSelect:) name:IUNotificationMQSelected object:nil];

    [self addObserver:self forKeyPath:@"controller.selectedObjects"
              options:0 context:nil];


    //binding
    NSDictionary *percentHiddeBindingOption = [NSDictionary
                                            dictionaryWithObjects:@[[NSNumber numberWithBool:NO], NSNegateBooleanTransformerName]
                                            forKeys:@[NSRaisesForNotApplicableKeysBindingOption, NSValueTransformerNameBindingOption]];

    [self addObserver:self forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagPixelX] options:0 context:nil];
    [self addObserver:self forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagPixelY] options:0 context:nil];
    [self addObserver:self forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagPixelWidth] options:0 context:nil];
    [self addObserver:self forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagPixelHeight] options:0 context:nil];
    [self addObserver:self forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagPercentX] options:0 context:nil];
    [self addObserver:self forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagPercentY] options:0 context:nil];
    [self addObserver:self forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagPercentWidth] options:0 context:nil];
    [self addObserver:self forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagPercentHeight] options:0 context:nil];
    
    [_xTF bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagXUnitIsPercent] options:IUBindingDictNotRaisesApplicable];
    [_xStepper bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagXUnitIsPercent] options:IUBindingDictNotRaisesApplicable];
    [_pxTF bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagXUnitIsPercent] options:percentHiddeBindingOption];
    [_pxStepper bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagXUnitIsPercent] options:percentHiddeBindingOption];
    
    [_yTF bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagYUnitIsPercent] options:IUBindingDictNotRaisesApplicable];
    [_yStepper bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagYUnitIsPercent] options:IUBindingDictNotRaisesApplicable];
    [_pyTF bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagYUnitIsPercent] options:percentHiddeBindingOption];
    [_pyStepper bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagYUnitIsPercent] options:percentHiddeBindingOption];
    
    [_wTF bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagWidthUnitIsPercent] options:IUBindingDictNotRaisesApplicable];
    [_wStepper bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagWidthUnitIsPercent] options:IUBindingDictNotRaisesApplicable];
    [_pwTF bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagWidthUnitIsPercent] options:percentHiddeBindingOption];
    [_pwStepper bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagWidthUnitIsPercent] options:percentHiddeBindingOption];
    
    [_hTF bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHeightUnitIsPercent] options:IUBindingDictNotRaisesApplicable];
    [_hStepper bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHeightUnitIsPercent] options:IUBindingDictNotRaisesApplicable];
    [_phTF bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHeightUnitIsPercent] options:percentHiddeBindingOption];
    [_phStepper bind:NSHiddenBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHeightUnitIsPercent] options:percentHiddeBindingOption];


    
    [_xUnitBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagXUnitIsPercent] options:IUBindingDictNotRaisesApplicable];
    [_yUnitBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagYUnitIsPercent] options:IUBindingDictNotRaisesApplicable];
    [_wUnitBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagWidthUnitIsPercent] options:IUBindingDictNotRaisesApplicable];
    [_hUnitBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHeightUnitIsPercent] options:IUBindingDictNotRaisesApplicable];
    
    [_positionPopupBtn bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"positionType"] options:IUBindingDictNotRaisesApplicable];
    [_centerBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"enableCenter"] options:IUBindingDictNotRaisesApplicable];
    

    //enabled option 1
    [_xTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasX"] options:IUBindingDictNotRaisesApplicable];
    [_yTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasY"] options:IUBindingDictNotRaisesApplicable];
    [_wTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasWidth"] options:IUBindingDictNotRaisesApplicable];
    [_hTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasHeight"] options:IUBindingDictNotRaisesApplicable];
    
    [_pxTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasX"] options:IUBindingDictNotRaisesApplicable];
    [_pyTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasY"] options:IUBindingDictNotRaisesApplicable];
    [_pwTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasWidth"] options:IUBindingDictNotRaisesApplicable];
    [_phTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasHeight"] options:IUBindingDictNotRaisesApplicable];
    
    [_xUnitBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasX"] options:IUBindingDictNotRaisesApplicable];
    [_yUnitBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasY"] options:IUBindingDictNotRaisesApplicable];
    [_wUnitBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasWidth"] options:IUBindingDictNotRaisesApplicable];
    [_hUnitBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasHeight"] options:IUBindingDictNotRaisesApplicable];
    
    [_xStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasX"] options:IUBindingDictNotRaisesApplicable];
    [_yStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasY"] options:IUBindingDictNotRaisesApplicable];
    [_wStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasWidth"] options:IUBindingDictNotRaisesApplicable];
    [_hStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasHeight"] options:IUBindingDictNotRaisesApplicable];
    
    [_pxStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasX"] options:IUBindingDictNotRaisesApplicable];
    [_pyStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasY"] options:IUBindingDictNotRaisesApplicable];
    [_pwStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasWidth"] options:IUBindingDictNotRaisesApplicable];
    [_phStepper bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasHeight"] options:IUBindingDictNotRaisesApplicable];

    
    [_positionPopupBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangePositionType"] options:IUBindingDictNotRaisesApplicable];
    [_centerBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeCenter"] options:IUBindingDictNotRaisesApplicable];

    
    //enabled option 2
    
    [_xTF bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeXByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_yTF bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeYByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_wTF bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeWidthByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_hTF bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeHeightByUserInput"] options:IUBindingDictNotRaisesApplicable];
    
    [_pxTF bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeXByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_pyTF bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeYByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_pwTF bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeWidthByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_phTF bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeHeightByUserInput"] options:IUBindingDictNotRaisesApplicable];
    
    [_xUnitBtn bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeXByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_yUnitBtn bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeYByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_wUnitBtn bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeWidthByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_hUnitBtn bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeHeightByUserInput"] options:IUBindingDictNotRaisesApplicable];
    
    [_xStepper bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeXByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_yStepper bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeYByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_wStepper bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeWidthByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_hStepper bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeHeightByUserInput"] options:IUBindingDictNotRaisesApplicable];

    [_pxStepper bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeXByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_pyStepper bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeYByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_pwStepper bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeWidthByUserInput"] options:IUBindingDictNotRaisesApplicable];
    [_phStepper bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"canChangeHeightByUserInput"] options:IUBindingDictNotRaisesApplicable];
    
    [_positionPopupBtn bind:@"enabled2" toObject:self withKeyPath:@"enablePosition" options:IUBindingDictNotRaisesApplicable];

    
    
    //enabled option 3
    NSDictionary *bindingOption = [NSDictionary
                     dictionaryWithObjects:@[[NSNumber numberWithBool:NO], NSNegateBooleanTransformerName]
                     forKeys:@[NSRaisesForNotApplicableKeysBindingOption, NSValueTransformerNameBindingOption]];
    
    [_xTF bind:@"enabled3" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"center"] options:bindingOption];
    [_pxTF bind:@"enabled3" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"center"] options:bindingOption];
    [_xUnitBtn bind:@"enabled3" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"center"] options:bindingOption];
    [_xStepper bind:@"enabled3" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"center"] options:bindingOption];
    [_pxStepper bind:@"enabled3" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"center"] options:bindingOption];

    [_hUnitBtn bind:@"enabled3" toObject:self withKeyPath:@"enablePercentH" options:IUBindingDictNotRaisesApplicable];
}

- (void)dealloc{
    if (_controller) {
        NSArray *removeObservers = @[[_controller keyPathFromControllerToCSSTag:IUCSSTagPixelX],
                                     [_controller keyPathFromControllerToCSSTag:IUCSSTagPixelY],
                                     [_controller keyPathFromControllerToCSSTag:IUCSSTagPixelWidth],
                                     [_controller keyPathFromControllerToCSSTag:IUCSSTagPixelHeight],
                                     [_controller keyPathFromControllerToCSSTag:IUCSSTagPercentX],
                                     [_controller keyPathFromControllerToCSSTag:IUCSSTagPercentY],
                                     [_controller keyPathFromControllerToCSSTag:IUCSSTagPercentWidth],
                                     [_controller keyPathFromControllerToCSSTag:IUCSSTagPercentHeight],
                                     @"controller.selectedObjects"];
        
        [self removeObserver:self forKeyPaths:removeObservers];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:IUNotificationMQSelected object:nil];
    }
    [JDLogUtil log:IULogDealloc string:@"LMPropertyFrameVC"];
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
    else {
        NSAssert(0, @"");
    }
}

- (void)checkForIUPageContent{
    BOOL isPageContentChildren = NO;
    for (IUBox *iu in _controller.selectedObjects) {
        if([iu.parent isKindOfClass:[IUPageContent class]]){
            isPageContentChildren = YES;
            break;
        }
    }

    self.enablePercentH = !isPageContentChildren;
}

- (void)setValueForTag:(IUCSSTag)tag toTextfield:(NSTextField*)textfield toStepper:(NSStepper *)stepper{
    id value = [self valueForKeyPath:[_controller keyPathFromControllerToCSSTag:tag]];
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
    
    return YES;
}
- (IBAction)clickStepper:(id)sender {
    IUCSSTag tag;

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
}

- (void)setCSSFrameValue:(id)value forTag:(IUCSSTag)tag{
    for (IUBox *iu in _controller.selectedObjects) {
        [iu startDragSession];
    }
    if (value == nil || ((NSString *)value).length==0 || [value isEqualToString:@"-"]) {
        for (IUBox *box in _controller.selectedObjects) {
            [box.css eradicateTag:tag];
        }
    }
    else {
        [self setValue:value forKeyPath:[_controller keyPathFromControllerToCSSTag:tag]];
    }
    for (IUBox *iu in _controller.selectedObjects) {
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
