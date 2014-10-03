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

/*
 Followings are classes which support JDCoding
 */
@interface NSArray(JDCoding) <JDCoding>
@end

@interface NSDictionary(JDCoding) <JDCoding>
@end

@interface NSString(JDCoding) <JDCoding>
@end

@interface NSColor(JDCoding) <JDCoding>
@end

@interface NSNumber(JDCoding) <JDCoding>

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
- (void)encodeInteger:(NSInteger)value forKey:(NSString*)key;
- (void)encodeBool:(BOOL)value forKey:(NSString*)key;
- (void)encodeFloat:(float)value forKey:(NSString*)key;
- (void)encodeDouble:(double)value forKey:(NSString*)key;
- (void)encodeObject:(id <JDCoding>)obj forKey:(NSString*)key;
- (void)encodeFromObject:(NSObject *)obj withProperties:(NSArray*)properties;

- (NSInteger)decodeIntegerForKey:(NSString*)key;
- (id)decodeObjectForKey:(NSString*)key;
- (float)decodeFloatForKey:(NSString*)key;
- (double)decodeDoubleForKey:(NSString*)key;
- (void)decodeToObject:(NSObject *)obj withProperties:(NSArray *)properties;

/*
 Followings are save/load functions
 */
- (BOOL)saveToURL:(NSURL *)url error:(NSError **)error;
- (void)loadFromURL:(NSURL *)url error:(NSError **)error;
@end
