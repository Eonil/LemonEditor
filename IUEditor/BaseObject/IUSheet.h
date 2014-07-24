//
//  IUSheet.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUCompiler.h"
#import "IUBox.h"
#import "IUIdentifierManager.h"

@class IUSheetGroup;

@interface IUSheet : IUBox

@property CGFloat ghostX, ghostY, ghostOpacity;
@property NSString *ghostImageName;

#pragma mark editor source
-(NSString*)editorSource;
-(NSString*)outputSource;
- (NSString*)outputInitJSSource;
- (NSArray *)outputArrayClipArt;

-(NSArray*)widthWithCSS;
-(IUBox *)selectableIUAtPoint:(CGPoint)point;

@property (weak) IUSheetGroup *group;

@end