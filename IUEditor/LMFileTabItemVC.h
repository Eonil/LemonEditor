//
//  LMFileTabVC.h
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 17..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUSheetGroup.h"

@interface LMTabBox : NSBox

@property (weak) IBOutlet  id delegate;

@end

@interface LMFileTabItemVC : NSViewController

@property (weak) id delegate;
@property (weak) IBOutlet NSBox *fileBox;
@property (weak) IBOutlet NSButton *fileNameBtn;
@property (weak) IUSheet *sheet;

- (void)setDeselectColor;
- (void)setSelectColor;
@end
