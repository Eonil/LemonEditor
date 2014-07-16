//
//  WPContentCollection.m
//  IUEditor
//
//  Created by jw on 7/15/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "WPArticle.h"
#import "WPArticleTitle.h"
#import "IUIdentifierManager.h"
#import "IUProject.h"

@implementation WPArticle{
}

- (NSString*)code{
    NSMutableString *code = [NSMutableString string];
    for (id<IUCodeProtocol> child in self.children) {
        [code appendString:[child code]];
    }
    return code;
}

- (void)setEnableTitle:(BOOL)enableTitle{
    _enableTitle = enableTitle;
    if (enableTitle) {
        [self.project.identifierManager resetUnconfirmedIUs];
        WPArticleTitle *title = [[WPArticleTitle alloc] initWithProject:self.project options:nil];
        [self addIU:title error:nil];
        [self confirmIdentifier];
        [[NSNotificationCenter defaultCenter] postNotificationName:IUNotificationStructureChangedIU object:self.project userInfo:@{IUNotificationStructureChangeType: IUNotificationStructureAdding, IUNotificationStructureChangedIU: title}];
    }
    else {
        for (IUBox *box in self.children) {
            if ([box isKindOfClass:[WPArticleTitle class]]) {
                [self removeIU:box];
            }
        }
    }
}

@end
