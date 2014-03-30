//
//  IUMaster.h
//  IUEditor
//
//  Created by jd on 3/31/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUDocument.h"

@class IUHeader;

@interface IUMaster : IUDocument

@property  IUHeader    *header;
@property  (readonly)  NSArray     *bodyParts;

@end
