//
//  WPComment.m
//  IUEditor
//
//  Created by jd on 9/2/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "WPCommentCollection.h"

#import "WPCommentAvator.h"
#import "WPCommentID.h"
#import "WPCommentContent.h"
#import "WPCommentDate.h"
#import "WPCommentEditLink.h"
#import "WPCommentReplyBtn.h"
#import "WPCommentReplySaying.h"
#import "PGForm.h"
#import "PGSubmitButton.h"

@interface WPCommentCollection()

@property (nonatomic) WPCommentAvator *avatar;
@property (nonatomic) WPCommentID *cID;
@property (nonatomic) IUBox *saying;
@property (nonatomic) WPCommentContent *content;
@end

@implementation WPCommentCollection

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if (self) {
        _avatar = [[WPCommentAvator alloc] initWithProject:project options:options];
        [self addIU:_avatar error:nil];
        
        _cID = [[WPCommentID alloc] initWithProject:project options:options];
        [self addIU:_cID error:nil];
        
        _saying = [[WPCommentID alloc] initWithProject:project options:options];
        [self addIU:_saying error:nil];

        _content = [[WPCommentContent alloc] initWithProject:project options:options];
        [self addIU:_content error:nil];
        
        WPCommentDate *date = [[WPCommentDate alloc] initWithProject:project options:options];
        [self addIU:date error:nil];
        
        
        /* WPCommentForm */
        
        
    }
    return self;
}

- (NSString*)prefixCode{
    return @"<?php\
    $args = array(\
    // args here\
    );\
    \
    $comments_query = new WP_Comment_Query;\
    $comments = $comments_query->query( $args );\
    // Comment Loop\
    if ( $comments ) {\
    foreach ( $comments as $comment ) {\
    ";
}

- (BOOL)shouldCompileChildrenForOutput{
    return YES; //default is YES
}

- (NSString*)postfixCode{
    return @"<?\
            }\
        } else {\
        echo 'No comments found.';\
    }\
    ?>";
}


@end
