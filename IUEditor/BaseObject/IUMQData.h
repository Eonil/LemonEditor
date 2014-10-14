//
//  IUMQData.h
//  IUEditor
//
//  Created by seungmi on 2014. 10. 14..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JDCoder.h"

@protocol IUMQDataDelegate

@required
- (void)updateMQData;
- (NSUndoManager *)undoManager;
@end

/**
 This class for media query data, not css
 
 */
@interface IUMQData : NSObject <NSCoding, JDCoding, NSCopying>

@property (nonatomic)  NSInteger editViewPort;
@property (nonatomic)  NSInteger maxViewPort;
@property (weak) id  <IUMQDataDelegate> delegate;

//set tag, or delete tag
-(void)setValue:(id)value forTag:(IUMQDataTag)tag;
-(void)setValue:(id)value forTag:(IUMQDataTag)tag forViewport:(NSInteger)width;


/**
 @brief find viewport tag, if there not, return default value for tag
 */
-(id)effectiveValueForTag:(IUMQDataTag)tag forViewport:(NSInteger)width;


//remove tag of all tag dictionay in width
-(void)eradicateTag:(IUMQDataTag)type;

//get css tag dictionary for specific width
-(void)removeTagDictionaryForViewport:(NSInteger)width;
-(NSDictionary*)tagDictionaryForViewport:(NSInteger)width;
-(NSArray*)allViewports;

//observable.
@property (readonly) NSDictionary *effectiveTagDictionary;


@end
