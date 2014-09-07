//
//  WPCommentForm.h
//  IUEditor
//
//  Created by jd on 9/3/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUBox.h"

typedef enum _WPCommentFormType {
    WPCommentFormTypeName,
    WPCommentFormTypeEmail,
    WPCommentFormTypeWebsite,
}WPCommentFormType;

@interface WPCommentForm : IUBox
@end
