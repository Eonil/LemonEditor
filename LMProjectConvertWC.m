//
//  LMProjectConvertWC.m
//  IUEditor
//
//  Created by jd on 5/28/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "LMProjectConvertWC.h"
#import "IUDjangoProject.h"
#import "IUProjectController.h"

#import "LMStartNewDjangoVC.h"
#import "LMStartNewDefaultVC.h"
#import "LMStartNewWPVC.h"

@interface LMProjectConvertWC ()
@property (weak) IBOutlet NSView *mainV;
@property (weak) IBOutlet NSButton *convertB;
@property (nonatomic) NSInteger selectedIndex;
@end

@implementation LMProjectConvertWC{
    __weak IBOutlet NSSegmentedControl *segControl;
    __weak IUProject *project;
    
    LMStartNewDefaultVC *newDefaultVC;
    LMStartNewDjangoVC  *newDjangoVC;
    LMStartNewWPVC      *newWPVC;
    

}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        
    }
    return self;
}

- (void)awakeFromNib{
    newDefaultVC = [[LMStartNewDefaultVC alloc] initWithNibName:@"LMStartNewDefaultVC" bundle:nil];
    newDefaultVC.nextB = self.convertB;

    newDjangoVC = [[LMStartNewDjangoVC alloc] initWithNibName:@"LMStartNewDjangoVC" bundle:nil];
    newDjangoVC.nextB = self.convertB;
    
    newWPVC = [[LMStartNewWPVC alloc] initWithNibName:@"LMStartNewWPVC" bundle:nil];
    newWPVC.nextB = self.convertB;
}


- (void)setCurrentProject:(IUProject *)currentProject{
    project = currentProject;
    //load nib
    [self window];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    [newDjangoVC.view removeFromSuperview];
    [newWPVC.view removeFromSuperview];
    [newDefaultVC.view removeFromSuperview];

    switch (selectedIndex) {
        case 0:
        {
            [self.mainV addSubview:newDefaultVC.view];
            [newDefaultVC show];
        }
        break;
        case 1:
        {
            [self.mainV addSubview:newWPVC.view];
            [newWPVC show];
            break;
        }
        case 2:
        {
            [self.mainV addSubview:newDjangoVC.view];
            [newDjangoVC show];
        }
        default:
        break;
    }
}


@end
