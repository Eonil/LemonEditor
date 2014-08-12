//
//  WPContentCollection.m
//  IUEditor
//
//  Created by jw on 7/15/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "WPArticle.h"
#import "WPArticleTitle.h"
#import "WPArticleDate.h"
#import "WPArticleBody.h"

#import "IUIdentifierManager.h"
#import "IUProject.h"

@implementation WPArticle{
}

- (BOOL)canChangeWidthByUserInput{
    return NO;
}

- (BOOL)canChangeXByUserInput{
    return NO;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    @try {
        _enableTitle = [aDecoder decodeBoolForKey:@"enableTitle"];
        _enableBody = [aDecoder decodeBoolForKey:@"enableBody"];
        _enableDate = [aDecoder decodeBoolForKey:@"enableDate"];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeBool:_enableTitle forKey:@"enableTitle"];
    [aCoder encodeBool:_enableBody forKey:@"enableBody"];
    [aCoder encodeBool:_enableDate forKey:@"enableDate"];
}

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    self.positionType = IUPositionTypeRelative;
    [self.css eradicateTag:IUCSSTagPixelHeight];
    [self.css setValue:@(100) forTag:IUCSSTagPercentWidth];
    [self.css setValue:@(YES) forTag:IUCSSTagWidthUnitIsPercent];
    [self.css setValue:[NSColor colorWithWhite:200.f/256.f alpha:1] forTag:IUCSSTagBGColor];
    [self setEnableTitle:YES];
    [self setEnableDate:YES];
    [self setEnableBody:YES];
    
    return self;
}

- (void)setEnableTitle:(BOOL)enableTitle{
    _enableTitle = enableTitle;
    if (enableTitle) {
        [self.project.identifierManager resetUnconfirmedIUs];
        WPArticleTitle *title = [[WPArticleTitle alloc] initWithProject:self.project options:nil];
        [self addIU:title error:nil];
        [self confirmIdentifier];
    }
    else {
        for (IUBox *box in self.children) {
            if ([box isKindOfClass:[WPArticleTitle class]]) {
                [self removeIU:box];
            }
        }
    }
}

- (void)setEnableDate:(BOOL)enableDate{
    _enableDate = enableDate;
    if (enableDate) {
        [self.project.identifierManager resetUnconfirmedIUs];
        WPArticleDate *date = [[WPArticleDate alloc] initWithProject:self.project options:nil];
        [self addIU:date error:nil];
        [self confirmIdentifier];
    }
    else {
        for (IUBox *box in self.children) {
            if ([box isKindOfClass:[WPArticleDate class]]) {
                [self removeIU:box];
            }
        }
    }
}

- (void)setEnableBody:(BOOL)enableBody{
    _enableBody = enableBody;
    if (enableBody) {
        [self.project.identifierManager resetUnconfirmedIUs];
        WPArticleBody *body = [[WPArticleBody alloc] initWithProject:self.project options:nil];
        [self addIU:body error:nil];
        [self confirmIdentifier];
    }
    else {
        for (IUBox *box in self.children) {
            if ([box isKindOfClass:[WPArticleBody class]]) {
                [self removeIU:box];
            }
        }
    }}


@end
