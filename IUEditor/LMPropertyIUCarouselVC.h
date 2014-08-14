//
//  LMPropertyIUcarousel.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 18..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"
#import "IUResourceManager.h"


@interface LMPropertyIUCarouselVC : NSViewController <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (nonatomic) IUController      *controller;
@property (nonatomic) IUResourceManager     *resourceManager;
@property (weak) id selection;

@property (nonatomic) NSArray *imageArray;

- (void)prepareDealloc;

@end
