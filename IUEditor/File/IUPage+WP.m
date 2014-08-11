//
//  IUPage+WP.m
//  IUEditor
//
//  Created by jd on 8/10/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUPage+WP.h"

@implementation IUPage (WP)

-(void)WPInitializeAsHome{
    [self removeAllIU];
}

-(void)WPInitializeAs404{
    [self removeAllIU];
}

-(void)WPInitializeAsIndex{
    [self removeAllIU];
}

-(void)WPInitializeAsPage{
    [self removeAllIU];
}

-(void)WPInitializeAsCategory{
    [self removeAllIU];
}


@end
