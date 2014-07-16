//
//  LMProjectPropertyWC.m
//  IUEditor
//
//  Created by seungmi on 2014. 7. 16..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMProjectPropertyWC.h"

static LMProjectPropertyWC *gProjectPropertyWC = nil;

@interface LMProjectPropertyWC ()
@property IUProject *project;

@end

@implementation LMProjectPropertyWC{
    IUProject *_project;
}
+ (LMProjectPropertyWC *)sharedProjectPropertyWC:(IUProject *)project{
    if(gProjectPropertyWC == nil){
        gProjectPropertyWC = [[LMProjectPropertyWC alloc] initWithWindowNibName:[LMProjectPropertyWC class].className];
    }
    gProjectPropertyWC
    return gProjectPropertyWC;
}

- (instancetype)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
