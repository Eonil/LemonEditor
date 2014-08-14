//
//  LMPropertyWPMenuVC.m
//  IUEditor
//
//  Created by jd on 2014. 7. 17..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMPropertyWPMenuVC.h"

@interface LMPropertyWPMenuVC ()
@property (weak) IBOutlet NSComboBox *menuCountCB;

@end

@implementation LMPropertyWPMenuVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    [_menuCountCB setDelegate:self];
}

- (void)comboBoxSelectionDidChange:(NSNotification *)notification{
    NSString *v = [[_menuCountCB selectedCell] stringValue];
    [self setValue:v forIUProperty:@"itemCount"];
}

- (void)controlTextDidChange:(NSNotification *)obj{
    NSString *v = [_menuCountCB stringValue];
    [self setValue:v forIUProperty:@"itemCount"];
}

@end
