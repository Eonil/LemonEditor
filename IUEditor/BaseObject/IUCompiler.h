//
//  IUCompiler.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUBox.h"
#import "IUCarousel.h"
#import "IUCompilerResourceSource.h"
#import "JDCode.h"
#import "IUResourceManager.h"

static NSString * IUCompilerTagOption = @"tag";

@class IUSheet;
@class IUResourceManager;

typedef enum _IUCompileRule{
    IUCompileRuleDefault,
    IUCompileRuleDjango,
    IUCompileRuleWordpress,
}IUCompileRule;

@interface IUCompiler : NSObject

@property IUResourceManager *resourceManager;
@property IUCompileRule    rule;

//build source
- (NSString *)outputSource:(IUSheet*)document mqSizeArray:(NSArray *)mqSizeArray;
- (JDCode *)outputHTML:(IUBox *)iu;

//editor source
- (NSString *)editorSource:(IUSheet*)document mqSizeArray:(NSArray *)mqSizeArray;
- (JDCode * )editorHTML:(IUBox*)iu;

//editor string
- (NSString *)CSSCodeFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)CSSContentWithIdentifier:(NSString *)identifier ofIU:(IUBox *)iu width:(NSInteger)width isEdit:(BOOL)isEdit;

#pragma mark manage JS source
-(NSString *)outputJSInitializeSource:(IUSheet *)document;

#pragma mark PHP
-(JDCode *)outputPHP:(IUBox *)iu;
-(JDCode *)editorPHP:(IUBox *)iu;


@end