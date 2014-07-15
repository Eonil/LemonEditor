//
//  IUPHP.m
//  IUEditor
//
//  Created by jd on 2014. 7. 14..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUPHP.h"
#import "IUProject.h"

@implementation IUPHP

- (NSString*)innerHTML{
    return [self php];
}

-(NSString*)php{
    return [self.project.compiler editorPHP:self].string;
}

@end
