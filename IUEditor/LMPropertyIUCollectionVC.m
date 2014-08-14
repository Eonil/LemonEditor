//
//  LMPropertyIUCollectionVC.m
//  IUEditor
//
//  Created by jd on 4/29/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMPropertyIUCollectionVC.h"
#import "IUProject.h"

@interface LMPropertyIUCollectionVC ()

@property (weak) IBOutlet NSTextField *variableTF;

@property (weak) IBOutlet NSPopUpButton *mqPopupButton;
@property (weak) IBOutlet NSTextField *itemCountTF;
@property (weak) IBOutlet NSStepper *itemCountStepper;

@end

@implementation LMPropertyIUCollectionVC{
    IUProject *_project;
    NSInteger selectedSize, maxSize;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self loadView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectMQSize:) name:IUNotificationMQSelected object:nil];
    }
    return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"selection"]) {
        self.selection = _controller.selection;
        [self updateCount];
    }
    else if( [[keyPath pathExtension] isEqualToString:@"defaultItemCount"]){
        [self updateCount];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



- (void)setController:(IUController *)controller{
    _controller = controller;
    [_controller addObserver:self forKeyPath:@"selection" options:0 context:nil];
    

    [_variableTF bind:NSValueBinding toObject:self withKeyPath:[_controller keyPathFromControllerToProperty:@"collectionVariable"] options:IUBindingDictNotRaisesApplicableAndContinuousUpdate];
    
    
    //observing
    [_controller addObserver:self forKeyPath:[_controller keyPathFromControllerToProperty:@"defaultItemCount"]
              options:0 context:nil];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_controller removeObserver:self forKeyPath:[_controller keyPathFromControllerToProperty:@"defaultItemCount"]];
    [_controller removeObserver:self forKeyPath:@"selection"];
}

- (void)setProject:(IUProject*)project{
    _project = project;
}



- (void)selectMQSize:(NSNotification *)notification{
    selectedSize = [[notification.userInfo objectForKey:IUNotificationMQSize] integerValue];
    maxSize = [[notification.userInfo objectForKey:IUNotificationMQMaxSize] integerValue];
 
    [self updateCount];
}

- (void)updateCount{
    
    id value = [self valueForKeyPath:[_controller keyPathFromControllerToProperty:@"defaultItemCount"]];
    if(value == NSMultipleValuesMarker || value == NSNotApplicableMarker || value == NSNoSelectionMarker){
        [_itemCountTF setStringValue:@""];
        [[_itemCountTF cell] setPlaceholderString:[NSString stringWithValueMarker:value]];
        return;
    }
    NSInteger defaultCount = [value integerValue];
    BOOL isToBeSetPlaceHolder;
    NSInteger selectedCount= -1;

    
    if(selectedSize == maxSize){
        isToBeSetPlaceHolder = NO;
        selectedCount = defaultCount;
    }
    else{
        //responsiveSetting 검사후에 없으면 default로 넣음.
        NSArray *responsiveSetting = [self valueForKeyPath:[_controller keyPathFromControllerToProperty:@"responsiveSetting"]];
        
        for(NSDictionary *dict in responsiveSetting){
            NSInteger width = [[dict objectForKey:@"width"] integerValue];
            if(width == selectedSize){
                selectedCount = [[dict objectForKey:@"count"] integerValue];
                break;
            }
        }
        
        //found responsive count
        if(selectedCount >=0){
            isToBeSetPlaceHolder = NO;
        }
        //there is no responsive count, set to default count
        else{
            isToBeSetPlaceHolder = YES;
        }
    }
    
    if(isToBeSetPlaceHolder){
        [_itemCountTF setStringValue:@""];
        [[_itemCountTF cell] setPlaceholderString:[NSString stringWithFormat:@"%ld", defaultCount]];
        [_itemCountStepper setIntegerValue:defaultCount];

    }
    else{
        [_itemCountTF setStringValue:[NSString stringWithFormat:@"%ld", selectedCount]];
        [[_itemCountTF cell] setPlaceholderString:@""];
        [_itemCountStepper setIntegerValue:selectedCount];

    }


}

#pragma mark -
- (IBAction)clickCountStepper:(id)sender {
    NSInteger count = [_itemCountStepper integerValue];
    [self setItemCount:count];
}
- (IBAction)clickItemCountTF:(id)sender {
    
    NSInteger count = [_itemCountTF integerValue];
    [self setItemCount:count];
}

- (void)setItemCount:(NSInteger)count{
    if(selectedSize == maxSize){
        [self setValue:@(count) forKeyPath:[_controller keyPathFromControllerToProperty:@"defaultItemCount"]];
    }
    else{
        NSMutableArray *responsiveSetting = [[self valueForKeyPath:[_controller keyPathFromControllerToProperty:@"responsiveSetting"]] mutableCopy];

        NSDictionary *selectedDict;
        for(NSDictionary *dict in responsiveSetting){
            NSInteger width = [[dict objectForKey:@"width"] integerValue];
            if(width == selectedSize){
                selectedDict = dict;
                break;
            }
        }
        if(selectedDict){
            [responsiveSetting removeObject:selectedDict];
        }
        [responsiveSetting addObject:@{@"width":@(selectedSize), @"count":@(count)}];
        
        [self setValue:responsiveSetting forKeyPath:[_controller keyPathFromControllerToProperty:@"responsiveSetting"]];

    }
    [self updateCount];
}


@end
