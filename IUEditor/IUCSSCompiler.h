//
//  IUCSSCompiler.h
//  IUEditor
//
//  Created by jd on 2014. 8. 4..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUBox.h"
#import "IUCompiler.h"

typedef enum _IUTarget{
    IUTargetEditor = 1,
    IUTargetOutput = 2,
    IUTargetBoth = 3,
} IUTarget;

@interface IUCSSCode : NSObject
- (NSDictionary*)tagDictionaryWithIdentifierForTarget:(IUTarget)unit viewport:(int)viewport;
- (NSArray*)allViewports;
@end

@interface IUCSSCompiler : NSObject
- (id)initWithResourceManager:(IUResourceManager*)resourceManager;
- (IUCSSCode*)cssCodeForIU:(IUBox*)iu;

@property IUCompileRule    rule;
@end
