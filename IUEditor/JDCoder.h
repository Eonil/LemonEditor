//
//  JDCoder.h
//  IUEditor
//
//  Created by jd on 10/1/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+JDExtension.h"

@class JDCoder;



@protocol JDCoding

- (void)encodeWithJDCoder:(JDCoder *)aCoder;
- (id)initWithJDCoder:(JDCoder *)aDecoder;

@end


@interface NSArray(JDCoding) <JDCoding>
- (void)encodeWithJDCoder:(JDCoder *)aCoder;
- (id)initWithJDCoder:(JDCoder *)aDecoder;
@end

@interface NSDictionary(JDCoding) <JDCoding>
- (void)encodeWithJDCoder:(JDCoder *)aCoder;
- (id)initWithJDCoder:(JDCoder *)aDecoder;
@end

@interface NSString(JDCoding) <JDCoding>
- (void)encodeWithJDCoder:(JDCoder *)aCoder;
- (id)initWithJDCoder:(JDCoder *)aDecoder;
@end


/* JDCoder resemble NSCoder, but
 1) it save/load with JSON
 2) it controls initialize process by notification
 
 @note "_JD_ClassName" is pre-occupied key for JDCoder.
 */
@interface JDCoder : NSObject

/**
 Register Notifications of initialize process
 */
- (void)appendSelectorInInitProcess:(SEL)selector;

/**
 encode / decode top object
 */
- (void)encodeRootObject:(id<JDCoding>)object;
- (id)decodedAndInitializeObject;

/*
 Following are encode/decode functions. Messages are same with NSCoder functions
 */
- (void)encodeInteger:(NSInteger)value forKey:(id)key;
- (void)encodeBool:(BOOL)value forKey:(id)key;
- (void)encodeFloat:(float)value forKey:(id)key;
- (void)encodeDouble:(double)value forKey:(id)key;
- (void)encodeObject:(id <JDCoding>)obj forKey:(id)key;
- (void)encodeFromObject:(NSObject *)obj withProperties:(NSArray*)properties;

- (NSInteger)decodeIntegerForKey:(id)key;
- (id)decodeObjectForKey:(id)key;
- (float)decodeFloatForKey:(id)key;
- (double)decodeDoubleForKey:(id)key;
- (void)decodeToObject:(NSObject *)obj withProperties:(NSArray *)properties;

/*
 Followings are save/load functions
 */
- (void)saveToURL:(NSURL *)url error:(NSError **)error;
- (void)loadFromURL:(NSURL *)url error:(NSError **)error;
@end
