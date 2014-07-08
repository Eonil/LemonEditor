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
-(NSString*)CSSContentFromAttributes:(NSDictionary*)cssTagDictionary ofClass:(IUBox*)obj isHover:(BOOL)isHover isDefaultWidth:(BOOL)isDefaultWidth isEdit:(BOOL)isEdit;
- (NSString *)fontCSSContentFromAttributes:(NSDictionary*)attributeDict;

//carousel dict & string
- (NSDictionary *)cssDictionaryForIUCarousel:(IUCarousel *)iu;
- (JDCode *)cssContentForIUCarouselPager:(IUCarousel *)iu hover:(BOOL)hover;
- (NSString *)cssContentForIUCarouselArrow:(IUCarousel *)iu hover:(BOOL)hover location:(IUCarouselArrow)location carouselHeight:(NSInteger)height;

#pragma mark manage JS source
-(NSString *)outputJSArgs:(IUBox *)iu;
-(NSString *)outputJSInitializeSource:(IUSheet *)document;
@end