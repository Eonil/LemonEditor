//
//  IUDjangoProject.m
//  IUEditor
//
//  Created by jd on 4/25/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUDjangoProject.h"
#import "IUPage.h"
#import "IUBackground.h"
#import "IUClass.h"
#import "IUSheetGroup.h"

@implementation IUDjangoProject

- (id)init{
    self = [super init];
    return self;
}

- (id)initWithCreation:(NSDictionary *)options error:(NSError *__autoreleasing *)error{
    self = [super initWithCreation:options error:error];
    if(self){
        _port = 8000;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    /* version control code */
    IUEditorVersion = [aDecoder decodeIntForKey:@"IUEditorVersion"];
    _port = [aDecoder decodeIntForKey:@"_port"];
    if (IUEditorVersion < 1) {
        _buildPath = @"$IUFileDirectory/templates";
        _buildResourcePath = @"$IUFileDirectory/templates/resource";
    }
    IUEditorVersion = 1;
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    [super encodeWithCoder:encoder];
    [encoder encodeInteger:_port forKey:@"_port"];
}

- (BOOL)runnable{
    return YES;
}

@end
