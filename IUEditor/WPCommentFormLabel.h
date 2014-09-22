//
//  WPCommentFormLabel.h
//  IUEditor
//
//  Created by jd on 9/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUBox.h"
#import "IUProtocols.h"
#import "WPCommentForm.h"

@interface WPCommentFormLabel : IUBox <IUSampleHTMLProtocol, IUCodeProtocol>

@property (nonatomic) WPCommentFormType formType;

@end
