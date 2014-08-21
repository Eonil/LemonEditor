//
//  IUCSS.h
//  IUEditor
//
//  Created by JD on 3/17/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IUCSSDelegate
@required
- (void)updateCSS;
- (BOOL)CSSShouldChangeValue:(id)value forTag:(IUCSSTag)tag forWidth:(NSInteger)width;
- (NSUndoManager *)undoManager;
@end



@interface IUCSS : NSObject <NSCoding, NSCopying>

@property (nonatomic)  NSInteger editWidth;
@property (nonatomic)  NSInteger maxWidth;
@property (weak) id  <IUCSSDelegate> delegate;

//set tag, or delete tag
-(void)setValue:(id)value forTag:(IUCSSTag)tag;
-(void)setValue:(id)value forTag:(IUCSSTag)tag forViewport:(NSInteger)width;

-(void)setValueWithoutUpdateCSS:(id)value forTag:(IUCSSTag)tag;
-(void)setValueWithoutUpdateCSS:(id)value forTag:(IUCSSTag)tag forViewport:(NSInteger)width;


//remove tag of all tag dictionay in width
-(void)eradicateTag:(IUCSSTag)type;

//get css tag dictionary for specific width
-(void)removeTagDictionaryForViewport:(NSInteger)width;
-(NSDictionary*)tagDictionaryForViewport:(NSInteger)width;
-(NSArray*)allViewports;

/**
 @brief copy max-size cssDictionary to specific width dictionary;
 */
- (void)copyMaxSizeToSize:(NSInteger)width;

//observable.
@property (readonly) NSMutableDictionary *assembledTagDictionary;
@end