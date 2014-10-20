//
//  IUDataStorage.h
//  IUEditor
//
//  Created by jd on 10/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//
//
//  Declare IUDataStorageManager, IUDataStorage, IUDataStorageManagerDelegate
//  Support Unit test
//

#import <Foundation/Foundation.h>
#import "JDCoder.h"

@interface IUDataStorage : NSObject <JDCoding>

/**
 @note value and key should support JSON rule.
 */
- (void)setValue:(id)value forKey:(NSString *)key;
- (id)valueForKey:(NSString *)key;
- (NSDictionary*)dictionary;
@end

@protocol IUDataStorageManagerDelegate
@required
- (void)setNeedsToUpdateData:(IUDataStorage*)storage;
@end


/**
 Manage Data(CSS or anything) of IUBox
 
 Change value in liveTagDict or currentTagDict will make KVO-notification to each other.
 
 KVO-Noti :
 viewPort, allViewPorts, liveTagDict, currentTagDict
 
 If updating should be disabled, DO IT AT IUBOX!!!!
 */

#define IUDefaultViewPort 9999

@interface IUDataStorageManager : NSObject <JDCoding>

@property id <IUDataStorageManagerDelegate> box;
@property NSUndoManager *undoManager;

@property NSInteger currentViewPort;

@property (readonly) NSArray* allViewPorts;

- (IUDataStorage*)storageForViewPort:(NSInteger)viewPort;

@property (readonly) IUDataStorage *currentStorage;
@property (readonly) IUDataStorage *defaultStorage;
@property (readonly) IUDataStorage *liveStorage;

- (void)removeViewPort:(NSInteger)viewPort;

@end


/* IUCSSStorage controls marker or proxy key.
 For example, it will manage 'IUCSSTagBorderWidth' as proxy of 'IUCSSTagBorderLeftWidth', 'IUCSSTagBorderRightWidth', 'IUCSSTagBorderTopWidth', 'IUCSSTagBorderBottomWidth'.
 */
@interface IUCSSStorage : IUDataStorage

/* following tags can have marker */
@property (nonatomic) id borderWidth;
@property (nonatomic) id borderColor;
@property (nonatomic) id borderRadius;

@end

@interface IUCSSStorageManager : IUDataStorageManager
- (IUCSSStorage*)storageForViewPort:(NSInteger)viewPort;

@property (readonly) IUCSSStorage *currentStorage;
@property (readonly) IUCSSStorage *defaultStorage;
@property (readonly) IUCSSStorage *liveStorage;
@end

