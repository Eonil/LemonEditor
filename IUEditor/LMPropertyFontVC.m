//
//  LMPropertyTextVC.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 17..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyFontVC.h"
#import "IUCSS.h"
#import "IUText.h"
#import "LMFontController.h"
#import "PGTextField.h"
#import "PGTextView.h"
#import "PGSubmitButton.h"
#import "IUMenuItem.h"

@interface LMPropertyFontVC ()

@property (weak) IBOutlet NSComboBox *fontB;
@property (weak) IBOutlet NSComboBox *fontSizeComboBox;
@property (weak) IBOutlet NSColorWell *fontColorWell;

@property (weak) IBOutlet NSSegmentedControl *fontStyleB;
@property (weak) IBOutlet NSSegmentedControl *textAlignB;
@property (weak) IBOutlet NSComboBox *lineHeightB;
@property (weak) IBOutlet NSComboBox *letterSpacingComboBox;

@property (weak) IBOutlet NSButton *autoHeightBtn;

@property (weak) LMFontController *fontController;
@property (strong) IBOutlet NSDictionaryController *fontListDC;

@property NSArray *fontDefaultSizes;
@property NSArray *fontDefaultLetterSpacing;
@end

@implementation LMPropertyFontVC{
    NSString *currentFontName;
    NSUInteger currentFontSize;
    NSArray *observingList;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        currentFontName = @"Arial";
        currentFontSize = 12;
        self.fontDefaultSizes = @[@(6), @(8), @(9), @(10), @(11), @(12),
                                  @(14), @(18), @(21), @(24), @(30), @(36), @(48), @(60), @(72)];
        self.fontDefaultLetterSpacing = @[@(0), @(-2.0), @(-1.0), @(0.5), @(1.0), @(2.0)];
        [self loadView];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"selection"]) {
        self.selection = _controller.selection;
    }
}

- (void)setController:(IUController *)controller{
    _controller = controller;
    [controller addObserver:self forKeyPath:@"selection" options:0 context:nil];
    [_textAlignB bind:NSSelectedIndexBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagTextAlign] options:IUBindingDictNotRaisesApplicable];
    [_autoHeightBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"lineHeightAuto"] options:IUBindingDictNotRaisesApplicable];
    
    //observing for undo
    observingList = @[[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagFontName],
                      [@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagFontWeight],
                      [@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagFontStyle],
                      [@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagTextDecoration],
                      [@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagFontSize],
                      [@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagLineHeight],
                      [_controller keyPathFromControllerToProperty:@"shouldCompileFontInfo"],
                      @"controller.selectedObjects",
                      ];
    
    [self addObserver:self forKeyPaths:observingList options:0 context:@"font"];

    
    _fontController = [LMFontController sharedFontController];
    [_fontListDC bind:NSContentDictionaryBinding toObject:_fontController withKeyPath:@"fontDict" options:nil];
    [_fontB bind:NSContentBinding toObject:_fontListDC withKeyPath:@"arrangedObjects.key" options:IUBindingDictNotRaisesApplicable];
    
#if CURRENT_TEXT_VERSION < TEXT_SELECTION_VERSION
    [_fontColorWell bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagFontColor] options:IUBindingDictNotRaisesApplicable];
#endif 
    
    //combobox delegate
    _fontB.delegate = self;
    _fontSizeComboBox.delegate = self;
    _fontSizeComboBox.dataSource = self;
    _lineHeightB.delegate = self;
    _letterSpacingComboBox.delegate = self;
    _letterSpacingComboBox.dataSource = self;
    
}

- (void)dealloc{
    [self removeObserver:self forKeyPaths:observingList];
}


- (BOOL)isSelectedObjectText{
    BOOL isText = YES;
    
    
    for(IUBox *box in _controller.selectedObjects){
#if CURRENT_TEXT_VERSION >= TEXT_SELECTION_VERSION
        if([box isKindOfClass:[IUText class]] == NO){
            isText = NO;
            break;
        }
#else
        if([box isMemberOfClass:[IUBox class]] == NO){
            isText = NO;
            break;
        }
#endif
        
    }
    return isText;
}

- (BOOL)isSelectedObjectFontType{
    BOOL isTextType = YES;
    
    
    if(_controller.selectedObjects.count < 1){
        return NO;
    }
    
    for(IUBox *box in _controller.selectedObjects){
        if ([box shouldCompileFontInfo] == NO) {
            isTextType = NO;
            break;
        }
    }
    return isTextType;
}

#if CURRENT_TEXT_VERSION > TEXT_SELECTION_VERSION

- (void)unbindTextSpecificProperty{
    if([_fontB infoForBinding:NSValueBinding]){
        [_fontB unbind:NSValueBinding];
    }
    if([_fontSizeComboBox infoForBinding:NSValueBinding]){
        [_fontSizeComboBox unbind:NSValueBinding];
    }
    /*
     if([_fontSizeB infoForBinding:NSValueBinding]){
     [_fontSizeB unbind:NSValueBinding];
     }
     if([_fontSizeStepper infoForBinding:NSValueBinding]){
     [_fontSizeStepper unbind:NSValueBinding];
     }
     */
    if([_fontColorWell infoForBinding:NSValueBinding]){
        [_fontColorWell unbind:NSValueBinding];
    }
}

- (void)selectionContextDidChange:(NSDictionary *)change{
    
    [self unbindTextSpecificProperty];
    
    if([self isSelectedObjectText]){
        [_fontStyleB setEnabled:YES];

        [_fontB bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.textController." stringByAppendingString:@"fontName"] options:IUBindingDictNotRaisesApplicable];
        [_fontSizeComboBox bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.textController." stringByAppendingString:@"fontSize"] options:IUBindingDictNotRaisesApplicable];
        [_fontColorWell bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.textController." stringByAppendingString:@"fontColor"] options:IUBindingDictNotRaisesApplicable];
        
        
        if([[_controller selectedObjects] count] ==1 ){
            BOOL weight = ((IUText *)_controller.selection).textController.bold;
            [_fontStyleB setSelected:weight forSegment:0];
            
            BOOL italic = ((IUText *)_controller.selection).textController.italic;
            [_fontStyleB setSelected:italic forSegment:1];
            
            BOOL underline = ((IUText *)_controller.selection).textController.underline;
            [_fontStyleB setSelected:underline forSegment:2];
        }

    }
    else{
        //not text - text field / text view
        [_fontStyleB setEnabled:NO];

        [_fontB bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagFontName] options:IUBindingDictNotRaisesApplicable];
        [_fontSizeComboBox bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagFontSize] options:IUBindingDictNotRaisesApplicable];
        [_fontColorWell bind:NSValueBinding toObject:self withKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagFontColor] options:IUBindingDictNotRaisesApplicable];
        
    }

}

- (IBAction)fontDecoBPressed:(id)sender {
    
    BOOL value;
    value = [sender isSelectedForSegment:0];
    [self setValue:@(value) forKeyPath:[@"self.selection.textController." stringByAppendingString:@"bold"]];
    
    value = [sender isSelectedForSegment:1];
    [self setValue:@(value) forKeyPath:[@"self.selection.textController." stringByAppendingString:@"italic"]];
    
    value = [sender isSelectedForSegment:2];
    [self setValue:@(value) forKeyPath:[@"self.selection.textController." stringByAppendingString:@"underline"]];
    
}

#else
- (void)fontContextDidChange:(NSDictionary *)change{
    
    if([self isSelectedObjectFontType]){
        
        if([self isSelectedObjectText]){
            [_fontStyleB setEnabled:YES];
            if([[_controller selectedObjects] count] ==1 ){
                BOOL weight = [[self valueForTag:IUCSSTagFontWeight] boolValue];
                [_fontStyleB setSelected:weight forSegment:0];

                BOOL italic = [[self valueForTag:IUCSSTagFontStyle] boolValue];
                [_fontStyleB setSelected:italic forSegment:1];
                
                BOOL underline = [[self valueForTag:IUCSSTagTextDecoration] boolValue];
                [_fontStyleB setSelected:underline forSegment:2];
            }
        }
        else{
            [_fontStyleB setEnabled:NO];
        }
        
        
        
        //set font name
        NSString *iuFontName = [self valueForTag:IUCSSTagFontName];
        if(iuFontName == nil){
            iuFontName = currentFontName;
            [self setValue:currentFontName forKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagFontName]];
        }
        if(iuFontName == NSMultipleValuesMarker){
            NSString *placeholder = [NSString stringWithValueMarker:NSMultipleValuesMarker];
            [[_fontB cell] setPlaceholderString:placeholder];
            [_fontB setStringValue:@""];
        }
        else{
            [[_fontB cell] setPlaceholderString:@""];
            [_fontB setStringValue:iuFontName];
        }
        
        
        //set Font size
        if([self valueForTag:IUCSSTagFontSize] == nil){
            [self setValue:@(currentFontSize) forKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagFontSize]];
        }
        
        else if([self valueForTag:IUCSSTagFontSize] == NSMultipleValuesMarker){
            NSString *placeholder = [NSString stringWithValueMarker:NSMultipleValuesMarker];
            [[_fontSizeComboBox cell] setPlaceholderString:placeholder];
            [_fontSizeComboBox setStringValue:@""];
            
        }
        else{
            NSUInteger iuFontSize = [[self valueForTag:IUCSSTagFontSize] integerValue];
            [[_fontSizeComboBox cell] setPlaceholderString:@""];
            [_fontSizeComboBox setStringValue:[NSString stringWithFormat:@"%ld", iuFontSize]];
        }
        
        //set LetterSpacing
        if([self valueForTag:IUCSSTagTextLetterSpacing] == NSMultipleValuesMarker){
            NSString *placeholder = [NSString stringWithValueMarker:NSMultipleValuesMarker];
            [[_letterSpacingComboBox cell] setPlaceholderString:placeholder];
            [_letterSpacingComboBox setStringValue:@""];
            
        }
        else{
            CGFloat letterSpacing = [[self valueForTag:IUCSSTagTextLetterSpacing] floatValue];
            [[_letterSpacingComboBox cell] setPlaceholderString:@""];
            [_letterSpacingComboBox setStringValue:[NSString stringWithFormat:@"%.1f", letterSpacing]];
        }
        
        //set fontHeight
        if([self valueForTag:IUCSSTagLineHeight] == NSMultipleValuesMarker){
            NSString *placeholder = [NSString stringWithValueMarker:NSMultipleValuesMarker];
            [[_lineHeightB cell] setPlaceholderString:placeholder];
            [_lineHeightB setStringValue:@""];
        }
        else{
            CGFloat lineheight = [[self valueForTag:IUCSSTagLineHeight] floatValue];
            [[_lineHeightB cell] setPlaceholderString:@""];
            [_lineHeightB setStringValue:[NSString stringWithFormat:@"%.1f", lineheight]];
        }
        
        //enable font type box
        [_fontB setEnabled:YES];
        [_fontSizeComboBox setEnabled:YES];
        [_fontSizeComboBox setEditable:YES];
        [_fontColorWell setEnabled:YES];
        [_lineHeightB setEnabled:YES];
        [_lineHeightB setEditable:YES];
        [_textAlignB setEnabled:YES];
        [_letterSpacingComboBox setEditable:YES];
        [_letterSpacingComboBox setEnabled:YES];

    }
    else{
        //disable font type box
        [_fontB setEnabled:NO];
        [_fontSizeComboBox setEnabled:NO];
        [_fontSizeComboBox setEditable:NO];
        [_fontColorWell setEnabled:NO];
        [_lineHeightB setEnabled:NO];
        [_lineHeightB setEditable:NO];
        [_textAlignB setEnabled:NO];
        [_fontStyleB setEnabled:NO];
        [_letterSpacingComboBox setEditable:NO];
        [_letterSpacingComboBox setEnabled:NO];

    }
    
}

- (id)valueForTag:(IUCSSTag)tag
{
    id value = [self valueForKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:tag]];
    if(value == nil || value == NSNoSelectionMarker){
        return nil;
    }
    return value;
                
}


- (void)comboBoxSelectionDidChange:(NSNotification *)notification{
    NSComboBox *currentComboBox = notification.object;
    if([currentComboBox isEqualTo:_fontB]){
        [self updateFontName:[_fontB objectValueOfSelectedItem]];
    }
    else if([currentComboBox isEqualTo:_fontSizeComboBox]){
        NSInteger index = [_fontSizeComboBox indexOfSelectedItem];
        NSInteger size = [[_fontDefaultSizes objectAtIndex:index] integerValue];
        [self updateFontSize:size];
    }
    else if([currentComboBox isEqualTo:_letterSpacingComboBox]){
        NSInteger index = [_letterSpacingComboBox indexOfSelectedItem];
        CGFloat spacing = [[_fontDefaultLetterSpacing objectAtIndex:index] floatValue];
        [self updateLetterSpacing:spacing];
    }
    else if([currentComboBox isEqualTo:_lineHeightB]){
        [self updateLineHeight:[[_lineHeightB objectValueOfSelectedItem] floatValue]];
    }
}

- (void)updateFontName:(NSString *)fontName{
    currentFontName = fontName;
    [self setValue:currentFontName forKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagFontName]];
}

- (void)updateFontSize:(NSInteger)fontSize{
    currentFontSize = fontSize;
    [self setValue:@(currentFontSize) forKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagFontSize]];
}

- (void)updateLetterSpacing:(CGFloat)sapcing{
    [self setValue:@(sapcing) forKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagTextLetterSpacing]];

}

- (void)updateLineHeight:(CGFloat)lineHeightStr{
    [self setValue:@(lineHeightStr) forKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagLineHeight]];
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor{
    if([control isEqualTo:_fontB]){
        [self updateFontName:[fieldEditor string]];
    }
    else if([control isEqualTo:_fontSizeComboBox]){
        NSInteger fontSize = [[fieldEditor string] integerValue];
        if(fontSize == 0 ){
            [self updateFontSize:1];
            [_fontSizeComboBox setStringValue:@"1"];
            [JDUIUtil hudAlert:@"Font Size can't be Zero" second:2];
            return NO;
        }
        [self updateFontSize:fontSize];
    }
    else if([control isEqualTo:_letterSpacingComboBox]){
        CGFloat letterSpacing = [[fieldEditor string] floatValue];
        [self updateLetterSpacing:letterSpacing];
    }
    else if([control isEqualTo:_lineHeightB]){
        [self updateLineHeight:[[fieldEditor string] floatValue]];
    }
    return YES;
}



- (BOOL)control:(NSControl *)control didFailToFormatString:(NSString *)string errorDescription:(NSString *)error{

    if([control isEqualTo:_fontSizeComboBox] || [control isEqualTo:_letterSpacingComboBox]){
        NSString *digit = [string stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
        if(digit){
            [control setStringValue:digit];
        }
    }

    return YES;
}


- (IBAction)fontDecoBPressed:(id)sender {
    
    BOOL value;
    value = [sender isSelectedForSegment:0];
    [self setValue:@(value) forKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagFontWeight]];
    
    value = [sender isSelectedForSegment:1];
    [self setValue:@(value) forKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagFontStyle]];
    
    value = [sender isSelectedForSegment:2];
    [self setValue:@(value) forKeyPath:[@"self.selection.css.assembledTagDictionary." stringByAppendingString:IUCSSTagTextDecoration]];
    
}

#endif





#pragma mark -
#pragma mark combobox dataSource

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox{
    if([aComboBox isEqualTo:_fontSizeComboBox]){
        return _fontDefaultSizes.count;
    }
    else if([aComboBox isEqualTo:_letterSpacingComboBox]){
        return _fontDefaultLetterSpacing.count;
    }
    
    return 0;
}
- (id)comboBox:(NSComboBox *)categoryCombo objectValueForItemAtIndex:(NSInteger)row {
    if([categoryCombo isEqualTo:_fontSizeComboBox]){
        return [_fontDefaultSizes objectAtIndex:row];
    }
    else if([categoryCombo isEqualTo:_letterSpacingComboBox]){
        return [_fontDefaultLetterSpacing objectAtIndex:row];
    }

    return nil;
}

@end
