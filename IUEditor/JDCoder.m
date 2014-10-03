//
//  JDCoder.m
//  IUEditor
//
//  Created by jd on 10/1/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "JDCoder.h"
#import "NSObject+JDExtension.h"

@interface JDCoder()
- (NSArray*)keysOfCurrentDecodingObject;
- (void)encodeString:(NSString*)string forKey:(NSString*)key;
- (NSString*)decodeStringForKey:(NSString*)key;
@end

@implementation NSArray(JDCoding)

- (void)encodeWithJDCoder:(JDCoder *)aCoder{
    [aCoder encodeString:self.className forKey:@"JDClassName_"];
    for (NSUInteger i=0; i<self.count; i++) {
        NSObject <JDCoding> *obj = [self objectAtIndex:i];
        [aCoder encodeObject:obj forKey:[NSString stringWithFormat:@"%ld", i]];
    }
    [aCoder encodeInteger:self.count forKey:@"count"];
}

- (id)initWithJDCoder:(JDCoder *)aDecoder{
    self = [super init];
    NSMutableArray *tempArr = [NSMutableArray array];
    NSUInteger count = [aDecoder decodeIntegerForKey:@"count"];
    for (NSUInteger i=0; i<count; i++) {
        NSObject <JDCoding> *obj = [aDecoder decodeObjectForKey:[NSString stringWithFormat:@"%ld", i]];
        [tempArr addObject:obj];
    }
    self = [self initWithArray:tempArr];
    return self;
}

@end

@implementation NSDictionary(JDCoding)
- (void)encodeWithJDCoder:(JDCoder *)aCoder{
    [aCoder encodeString:self.className forKey:@"JDClassName_"];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [aCoder encodeObject:obj forKey:key];
    }];
}

- (id)initWithJDCoder:(JDCoder *)aDecoder{
    self = [super init];
    NSMutableDictionary *temp = [NSMutableDictionary dictionary];
    for (id key in [aDecoder keysOfCurrentDecodingObject]) {
        if ([key isEqualTo:@"JDClassName_"] == NO ) {
            temp[key] = [aDecoder decodeObjectForKey:key];
        }
    }
    return [self initWithDictionary:temp];
}
@end

@implementation NSString (JDCoding)
- (void)encodeWithJDCoder:(JDCoder *)aCoder{
    [aCoder encodeString:self forKey:@"value"];
}

- (id)initWithJDCoder:(JDCoder *)aDecoder{
    NSString *str = [aDecoder decodeStringForKey:@"value"];
    self = [self initWithString:str];
    return self;
}
@end

@implementation NSNumber (JDCoding)
- (void)encodeWithJDCoder:(JDCoder *)aCoder{
    [aCoder encodeDouble:[self doubleValue] forKey:@"value"];
}

- (id)initWithJDCoder:(JDCoder *)aDecoder{
    self = [self initWithDouble:[aDecoder decodeDoubleForKey:@"value"]];
    return self;
}
@end



@implementation NSColor (JDCoding)

- (void)encodeWithJDCoder:(JDCoder *)aCoder{
    NSColor *convertedColor=[self colorUsingColorSpaceName:NSDeviceRGBColorSpace];
    [aCoder encodeDouble:[convertedColor redComponent] forKey:@"R"];
    [aCoder encodeDouble:[convertedColor greenComponent] forKey:@"G"];
    [aCoder encodeDouble:[convertedColor blueComponent] forKey:@"B"];
    [aCoder encodeDouble:[convertedColor alphaComponent] forKey:@"A"];
}

- (id)initWithJDCoder:(JDCoder *)aDecoder{
    NSColor *color = [NSColor colorWithDeviceRed:[aDecoder decodeDoubleForKey:@"R"]
                                           green:[aDecoder decodeDoubleForKey:@"G"]
                                            blue:[aDecoder decodeDoubleForKey:@"B"]
                                           alpha:[aDecoder decodeDoubleForKey:@"A"]];
    return color;
}

@end


@implementation JDCoder {
    NSMutableArray *initSelectors;
    NSMutableDictionary *dataDict;
    NSMutableArray *decodedObjects;
}

/**
 Register Notifications of initialize process
 */

- (instancetype)init{
    self = [super init];
    initSelectors = [NSMutableArray array];
    dataDict = [NSMutableDictionary dictionary];
    decodedObjects = [NSMutableArray array];
    return self;
}

- (void)appendSelectorInInitProcess:(SEL)selector{
    NSString *selectorStr = NSStringFromSelector(selector);
    [initSelectors addObject:selectorStr];
}


/**
 encode / decode top object
 */

- (void)encodeRootObject:(NSObject <JDCoding> *)object{
    if (object == nil) {
        NSAssert(0, @"object should not be nil");
    }
    dataDict[@"JDClassName_"] = object.className;
    [object encodeWithJDCoder:self];
}

- (id)decodedAndInitializeObject{
    NSString *className = dataDict[@"JDClassName_"];
    NSObject <JDCoding> *newObj = [(NSObject <JDCoding>  *)[NSClassFromString(className) alloc] initWithJDCoder:self];
    for (NSString *selectorString in initSelectors) {
        SEL sel = NSSelectorFromString(selectorString);
        for (NSObject *obj in decodedObjects) {
            if ([obj respondsToSelector:sel]) {
                IMP imp = [obj methodForSelector:sel];
                void (*func)(id, SEL) = (void *)imp;
                func(obj, sel);
            }
        }
    }
    return newObj;
}

- (void)encodeInteger:(NSInteger)value forKey:(NSString*)key{
    [dataDict setValue:@(value) forKey:key];
}

- (void)encodeBool:(BOOL)value forKey:(NSString*)key{
    [dataDict setValue:@(value) forKey:key];
}

- (void)encodeFloat:(float)value forKey:(NSString*)key{
    [dataDict setValue:@(value) forKey:key];
}

- (void)encodeDouble:(double)value forKey:(NSString*)key{
    [dataDict setValue:@(value) forKey:key];
}

- (void)encodeString:(NSString*)value forKey:(NSString*)key{
    [dataDict setValue:value forKey:key];
}


- (void)encodeObject:(NSObject <JDCoding> *)obj forKey:(NSString*)key{
    if ([[obj className] isEqualToString:@"__NSCFNumber"]) {
        [self encodeDouble:[(NSNumber*)obj doubleValue] forKey:key];
    }
    else if ([[obj className] isEqualToString:@"__NSCFConstantString"]){
        [self encodeString:(NSString*)obj forKey:key];
    }
    else {
        NSMutableDictionary* current = dataDict;
        dataDict = [NSMutableDictionary dictionary];
        current[key] = dataDict;
        current[key][@"JDClassName_"] = NSStringFromClass([obj classForKeyedArchiver]);
        if (obj != nil) {
            [obj encodeWithJDCoder:self];
        }
        dataDict = current;
    }
}

- (void)encodeFromObject:(NSObject *)obj withProperties:(NSArray*)properties{
    for (JDProperty *property in properties) {
        if ([property isReadonly]) {
            continue;
        }
        else if ([property isInteger]){
            [self encodeInteger:[[obj valueForKey:property.name] integerValue] forKey:property.name];
        }
        else if ([property isChar]){
            [self encodeInteger:[[obj valueForKey:property.name] charValue] forKey:property.name];
        }
        else if ([property isFloat]){
            [self encodeFloat:[[obj valueForKey:property.name] floatValue] forKey:property.name];
        }
        else if ([property isDouble]){
            [self encodeDouble:[[obj valueForKey:property.name] doubleValue] forKey:property.name];
        }
        else if ([property isID]){
            [self encodeObject:[obj valueForKey:property.name] forKey:property.name];
        }
        else if ([property isSize]){
            NSAssert(0, @"You cannot encode size");
        }
        else if ([property isPoint]){
            NSAssert(0, @"You cannot encode point");
        }
        else if ([property isRect]){
            NSAssert(0, @"You cannot encode rect");
        }
        else{
            NSAssert(0, @"");
        }
    }
}



- (NSInteger)decodeIntegerForKey:(NSString*)key{
    return [dataDict[key] integerValue];
}

- (id)decodeObjectForKey:(NSString*)key{
    id value = dataDict[key];
    if ([value isMemberOfClass:[NSNumber class]] || [value isMemberOfClass:[NSString class]]) {
        return value;
    }
    else if ([[value className] isEqualToString:@"__NSCFConstantString"] || [value isKindOfClass:[NSString class]] || [[value className] isEqualToString:@"__NSCFNumber"] || [value isKindOfClass:[NSNumber class]]){
        return value;
    }
    else {
        NSMutableDictionary* current = dataDict;
        dataDict = current[key];
        NSString *className = dataDict[@"JDClassName_"];
        NSObject <JDCoding> *newObj;
        if ([className isEqualToString:@"__NSDictionaryM"]) {
            newObj = [[NSMutableDictionary alloc] initWithJDCoder:self];
        }
        else {
            newObj= [(NSObject <JDCoding>  *)[NSClassFromString(className) alloc] initWithJDCoder:self];
        }
        dataDict = current;
        
        [decodedObjects addObject:newObj];
        return newObj;
    }
}

- (float)decodeFloatForKey:(NSString*)key{
    return [dataDict[key] floatValue];
}

- (double)decodeDoubleForKey:(NSString*)key{
    return [dataDict[key] doubleValue];
}

- (NSString*)decodeStringForKey:(NSString*)key{
    return dataDict[key];
}

-(void) decodeToObject:(id)obj withProperties:(NSArray*)properties{
    for (JDProperty *property in properties) {
        if ([property isReadonly]) {
            continue;
        }
        else if ([property isInteger]){
            [obj setValue:@([self decodeIntegerForKey:property.name]) forKey:property.name];
        }
        else if ([property isFloat]){
            [obj setValue:@([self decodeFloatForKey:property.name]) forKey:property.name];
        }
        else if ([property isDouble]){
            [obj setValue:@([self decodeDoubleForKey:property.name]) forKey:property.name];
        }
        else if ([property isChar]){
            [obj setValue:@([self decodeIntegerForKey:property.name]) forKey:property.name];
        }
        else if ([property isID]){
            id v = [self decodeObjectForKey:property.name];
            if (v) {
                [obj setValue:v forKey:property.name];
            }
        }
        else if ([property isSize]){
            NSAssert(0, @"Cannot decode size");
        }
        else if ([property isPoint]){
            NSAssert(0, @"Cannot decode point");
        }
        else if ([property isRect]){
            NSAssert(0, @"Cannot decode rect");
        }
        else{
            NSAssert(0, @"");
        }
    }
}

- (BOOL)saveToURL:(NSURL *)url error:(NSError **)error{
    NSError *err;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:0 error:&err];
    return [data writeToURL:url atomically:YES];
}

- (void)loadFromURL:(NSURL *)url error:(NSError **)error{
    NSData *data = [NSData dataWithContentsOfURL:url];
    dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
}

- (NSArray*)keysOfCurrentDecodingObject{
    return [dataDict allKeys];
}

@end