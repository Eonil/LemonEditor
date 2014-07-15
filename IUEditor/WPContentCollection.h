//
//  WPContentCollection.h
//  IUEditor
//
//  Created by jw on 7/15/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUPHP.h"

@interface WPContentCollection : IUPHP

@property (nonatomic) BOOL enableDate,enableTime;
@property (nonatomic) BOOL enableCategory, enableTag;
@property (nonatomic) NSInteger selectedContentType;

@end
