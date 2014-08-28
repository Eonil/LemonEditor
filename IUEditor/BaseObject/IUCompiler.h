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


@class IUCSSCode;

static NSString * IUCompilerTagOption = @"tag";

@class IUSheet;
@class IUResourceManager;
@class IUWordpressProject;

typedef enum _IUCompileRule{
    IUCompileRuleDefault,
    IUCompileRuleDjango,
    IUCompileRuleWordpress,
    IUCompileRulePresentation,
}IUCompileRule;

@interface IUCompiler : NSObject

@property (weak, nonatomic) IUResourceManager *resourceManager;
@property (nonatomic) IUCompileRule    rule;
//meta source
- (JDCode *)wordpressMetaDataSource:(IUWordpressProject *)project;

//build source
- (NSString *)outputCSSSource:(IUSheet*)document mqSizeArray:(NSArray *)mqSizeArray;
- (NSString*)outputHTMLSource:(IUSheet*)document;
- (JDCode *)outputHTML:(IUBox *)iu;

//editor source
- (NSString *)editorSource:(IUSheet*)document mqSizeArray:(NSArray *)mqSizeArray;
- (JDCode * )editorHTML:(IUBox*)iu;


#pragma mark manage JS source
- (JDCode *)outputJSInitializeSource:(IUSheet *)document;

#pragma mark clipart
- (NSArray *)outputClipArtArray:(IUSheet *)document;

//css code
- (IUCSSCode*)cssCodeForIU:(IUBox*)iu;
@end