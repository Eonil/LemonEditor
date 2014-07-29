
//
//  LMPropertyBGImageVC.m
//  IUEditor
//
//  Created by JD on 4/5/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMPropertyBGImageVC.h"
#import "IUImage.h"

@interface LMPropertyBGImageVC ()

@property (weak) IBOutlet NSComboBox *imageNameComboBox;
@property (weak) IBOutlet NSTextField *xPositionTF;
@property (weak) IBOutlet NSTextField *yPositionTF;

@property (weak) IBOutlet NSSegmentedControl *sizeSegementControl;

@property (weak) IBOutlet NSButton *repeatBtn;
@property (weak) IBOutlet NSButton *fitButton;
@property (weak) IBOutlet NSSegmentedControl *positionHSegmentedControl;
@property (weak) IBOutlet NSSegmentedControl *positionVSegmentedControl;
@property (weak) IBOutlet NSButton *digitPositionBtn;


@property BOOL fullSize;

@end

@implementation LMPropertyBGImageVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadView];
    }
    return self;
}

- (void)setController:(IUController *)controller{
    _controller = controller;

    NSDictionary *bgEnableBindingOption = [NSDictionary
                                           dictionaryWithObjects:@[NSIsNotNilTransformerName]
                                           forKeys:@[NSValueTransformerNameBindingOption]];

    NSDictionary *noRepeatBindingOption = [NSDictionary
                                           dictionaryWithObjects:@[[NSNumber numberWithBool:NO], NSNegateBooleanTransformerName]
                                           forKeys:@[NSRaisesForNotApplicableKeysBindingOption, NSValueTransformerNameBindingOption]];
    
#pragma mark - image
    
    
    [_imageNameComboBox bind:NSContentBinding toObject:self withKeyPath:@"resourceManager.imageFiles" options:IUBindingDictNotRaisesApplicable];
    [_imageNameComboBox bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"imageName"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    _imageNameComboBox.delegate = self;
    
    [_fitButton bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagWidthUnit] options:IUBindingNegationAndNotRaise];
    [_fitButton bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagHeightUnit] options:IUBindingNegationAndNotRaise];
    [_fitButton bind:@"enabled3" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasWidth"] options:IUBindingDictNotRaisesApplicable];
    [_fitButton bind:@"enabled4" toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"hasHeight"] options:IUBindingDictNotRaisesApplicable];
    
    
    
#pragma mark - size, repeat
    
    [_sizeSegementControl bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGSize] options:IUBindingDictNotRaisesApplicable];
    [_sizeSegementControl bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagImage] options:bgEnableBindingOption];
    
    [_repeatBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGRepeat] options:noRepeatBindingOption];
    
    [_repeatBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagImage] options:bgEnableBindingOption];
    [_repeatBtn bind:@"enabled2" toObject:self withKeyPath:@"fullSize" options:IUBindingNegationAndNotRaise];

    
    
    [self addObserver:self forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGSize] options:0 context:@"size"];

    
#pragma mark - position
    
    [_positionHSegmentedControl bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGHPosition] options:IUBindingDictNotRaisesApplicable];
    [_positionVSegmentedControl bind:NSSelectedIndexBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGVPosition] options:IUBindingDictNotRaisesApplicable];
    
    [_digitPositionBtn bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGEnableDigitPosition] options:IUBindingDictNotRaisesApplicable];
    
    [_digitPositionBtn bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagImage] options:bgEnableBindingOption];
    [_digitPositionBtn bind:@"enabled2" toObject:self withKeyPath:@"fullSize" options:IUBindingNegationAndNotRaise];
    
    [_xPositionTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGXPosition] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    [_yPositionTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGYPosition] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    

    
#pragma mark - enable position
    //position Segement 1
    [_positionHSegmentedControl bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagImage] options:bgEnableBindingOption];
    [_positionVSegmentedControl bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagImage] options:bgEnableBindingOption];

    [_positionHSegmentedControl bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGEnableDigitPosition] options:IUBindingNegationAndNotRaise];
    [_positionVSegmentedControl bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGEnableDigitPosition] options:IUBindingNegationAndNotRaise];
    
    [_positionHSegmentedControl bind:@"enabled3" toObject:self withKeyPath:@"fullSize" options:IUBindingNegationAndNotRaise];
    [_positionVSegmentedControl bind:@"enabled3" toObject:self withKeyPath:@"fullSize" options:IUBindingNegationAndNotRaise];

    //position TF
    [_xPositionTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagImage] options:bgEnableBindingOption];
    [_yPositionTF bind:NSEnabledBinding toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagImage] options:bgEnableBindingOption];
    
    [_xPositionTF bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGEnableDigitPosition] options:IUBindingDictNotRaisesApplicable];
    [_yPositionTF bind:@"enabled2" toObject:self withKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGEnableDigitPosition] options:IUBindingDictNotRaisesApplicable];
    
    [_xPositionTF bind:@"enabled3" toObject:self withKeyPath:@"fullSize" options:IUBindingNegationAndNotRaise];
    [_yPositionTF bind:@"enabled3" toObject:self withKeyPath:@"fullSize" options:IUBindingNegationAndNotRaise];
    
    


    
}

- (void)dealloc{
    if (_controller) {
        [self removeObserver:self forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGSize]];
    }
    [JDLogUtil log:IULogDealloc string:@"LMPropertyBGImage"];
}


-(void)sizeContextDidChange:(NSDictionary *)dictionary{
    IUBGSizeType selectedtype = (IUBGSizeType)[_sizeSegementControl selectedSegment];
    if(selectedtype == IUBGSizeTypeFull){
        [self setValue:@(1) forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGVPosition]];
        [self setValue:@(1) forKeyPath:[_controller keyPathFromControllerToCSSTag:IUCSSTagBGHPosition]];
        self.fullSize = YES;
    }
    else{
        self.fullSize = NO;
    }
}

#pragma mark - combobox

- (void)controlTextDidChange:(NSNotification *)obj{
    for (IUImage *image in self.controller.selectedObjects) {
        if ([image isKindOfClass:[IUImage class]]) {
            id value = [_imageNameComboBox stringValue];
            [image setImageName:value];
        }
    }
}

- (void)comboBoxSelectionDidChange:(NSNotification *)notification{
    for (IUImage *image in self.controller.selectedObjects) {
        if ([image isKindOfClass:[IUImage class]]) {
            id value = [_imageNameComboBox objectValueOfSelectedItem];
            [image setImageName:value];
        }
    }
}

#pragma mark - IBAction


- (IBAction)performFitToImage:(id)sender { // Fit to Image button function
    NSAssert(_resourceManager, @"");

    //image filename
    NSString *filename = _imageNameComboBox.stringValue;
    if(filename == nil || filename.length == 0){
        return;
    }

    NSInteger   height;
    NSInteger   width;
    
    //get image size
    // when file is empty, image fit doesn't make any difference.
    if([filename isHTTPURL]){
        //setting size to IU
        NSArray *selectedObjects = self.controller.selectedObjects;
        for (IUBox *box in selectedObjects) {
            width =  [[box.delegate callWebScriptMethod:@"getImageWidth" withArguments:@[filename]] integerValue];
            height =  [[box.delegate callWebScriptMethod:@"getImageHeight" withArguments:@[filename]] integerValue];
        }
    }
    else if(filename != nil){
    //getting path
        IUResourceFile *file = [_resourceManager resourceFileWithName:filename];
        NSString *path = file.absolutePath;

        if (file == nil) {
            
            path = [[NSBundle mainBundle] pathForImageResource:[filename lastPathComponent]];
        }
        
        NSArray * imageReps = [NSBitmapImageRep imageRepsWithContentsOfFile:path];
        
        width = 0;
        height = 0;
        
        for (NSImageRep * imageRep in imageReps) {
            if ([imageRep pixelsWide] > width){
                width = [imageRep pixelsWide];
            }
            if ([imageRep pixelsHigh] > height){
                height = [imageRep pixelsHigh];
            }
        }
    }
    
    
    //setting size to IU
    NSArray *selectedObjects = self.controller.selectedObjects;
    
    for (IUBox *box in selectedObjects) {
        [box.css setValue:@(width) forTag:IUCSSTagWidth];
        [box.css setValue:@(height) forTag:IUCSSTagHeight];
        [box updateCSSForEditViewPort];
    }
}

@end
