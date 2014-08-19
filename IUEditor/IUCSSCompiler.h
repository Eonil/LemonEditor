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
- (NSDictionary*)stringTagDictionaryWithIdentifierForEditorViewport:(int)viewport;
- (NSDictionary*)stringTagDictionaryWithIdentifierForOutputViewport:(int)viewport;
- (NSArray*)allViewports;
@end


@interface IUCSSCompiler : NSObject
- (id)initWithResourceManager:(IUResourceManager*)resourceManager;
- (IUCSSCode*)cssCodeForIU:(IUBox*)iu;

@property IUCompileRule    rule;
@end


/**
 Generator category for subclassing
 */

typedef enum _IUUnit{
    IUUnitNone,
    IUUnitPixel,
    IUUnitPercent,
} IUUnit;

@interface IUCSSCode(Generator)

- (void)setInsertingTarget:(IUTarget)target;
- (void)setInsertingViewPort:(int)viewport;
- (int)insertingViewPort;
- (void)setInsertingIdentifier:(NSString *)identifier;
- (void)setInsertingIdentifiers:(NSArray *)identifiers;


- (NSString*)valueForTag:(NSString*)tag identifier:(NSString*)identifier largerThanViewport:(int)viewport target:(IUTarget)target;
- (NSString*)valueForTag:(NSString*)tag identifier:(NSString*)identifier viewport:(int)viewport target:(IUTarget)target;

/**
 insert css tag to receiver
 */

- (void)insertTag:(NSString*)tag color:(NSColor*)colorValue;
- (void)insertTag:(NSString*)tag string:(NSString*)stringValue;
- (void)insertTag:(NSString*)tag string:(NSString*)stringValue target:(IUTarget)target;
- (void)insertTag:(NSString*)tag floatFromNumber:(NSNumber*)floatNumber;
- (void)insertTag:(NSString*)tag floatFromNumber:(NSNumber*)floatNumber unit:(IUUnit)unit;
- (void)insertTag:(NSString*)tag intFromNumber:(NSNumber*)intNumber;
- (void)insertTag:(NSString*)tag intFromNumber:(NSNumber*)intNumber unit:(IUUnit)unit;
- (void)insertTag:(NSString*)tag integer:(int)number unit:(IUUnit)unit;
- (void)removeTag:(NSString*)tag identifier:(NSString*)identifier;

@end

