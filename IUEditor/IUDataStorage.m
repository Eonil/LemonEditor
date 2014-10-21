//
//  IUDataStorage.m
//  IUEditor
//
//  Created by jd on 10/20/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUDataStorage.h"
#import "NSString+IUTag.h"

@interface IUDataStorage()
- (void)setManager:(IUDataStorageManager *)manager;
- (IUDataStorageManager *)manager;

@property NSMutableDictionary *storage;
@end

@interface IUDataStorageManager()
@property NSArray * allViewPorts;
@property IUDataStorage *currentStorage;
@property IUDataStorage *defaultStorage;
@property IUDataStorage *liveStorage;
- (void)storage:(IUDataStorage*)storage updated:(NSString*)key;
@end



@implementation IUDataStorage {
    IUDataStorageManager *manager;
}

- (id)init{
    self = [super init];
    _storage = [NSMutableDictionary dictionary];
    return self;
}

- (id)initWithJDCoder:(JDCoder *)aDecoder{
    self = [super init];
    _storage = [aDecoder decodeObjectForKey:@"storage"];
    return self;
}

- (void)awakeAfterUsingJDCoder:(JDCoder *)aDecoder{
    manager = [aDecoder decodeByRefObjectForKey:@"manager"];
}

- (IUDataStorageManager *)manager{
    return manager;
}

- (void)setManager:(IUDataStorageManager *)aManager{
    manager = aManager;
}

- (void)encodeWithJDCoder:(JDCoder *)aCoder{
    [aCoder encodeObject:_storage forKey:@"storage"];
}

- (void)setValue:(id)value forKey:(NSString *)key{
    [self willChangeValueForKey:key];
    [_storage setValue:value forKey:key];
    [manager storage:self updated:key];
    [self didChangeValueForKey:key];
}

- (id)valueForKey:(NSString *)key{
    return [_storage valueForKey:key];
}

- (NSDictionary*)dictionary{
    return [_storage copy];
}

- (IUDataStorage*)storageByOverwritingDataStorage:(IUDataStorage*)aStorage{
    IUDataStorage *returnValue = [[IUDataStorage alloc] init];
    returnValue.storage = [_storage mutableCopy];
    
    for (NSString *key in aStorage.storage) {
        returnValue.storage[key] = aStorage.storage[key];
    }
    
    return returnValue;
}

@end




@implementation IUDataStorageManager{
    NSMutableDictionary *storages; //key == viewPort(NSNumber) value=IUDataStorage.
}

- (IUDataStorage *)newStorage{
    IUDataStorage *storage = [[IUDataStorage alloc] init];
    return storage;
}

- (id)init{
    self = [super init];

    _allViewPorts = [NSArray arrayWithObject:@(IUDefaultViewPort)];
    storages = [NSMutableDictionary dictionary];
    storages[@(IUDefaultViewPort)] = [self newStorage];
    _defaultStorage = storages[@(IUDefaultViewPort)];
    _defaultStorage.manager = self;
    
    [self addObserver:self forKeyPath:@"currentViewPort" options:0 context:nil];
    self.currentViewPort = IUCSSDefaultViewPort;
    return self;
}

- (id)initWithJDCoder:(JDCoder *)aDecoder{
    self = [super init];

    //storages
    storages = [NSMutableDictionary dictionary];
    NSDictionary *savedStorage = [aDecoder decodeObjectForKey:@"storages"];
    [savedStorage enumerateKeysAndObjectsUsingBlock:^(NSString* key, id obj, BOOL *stop) {
        storages[@([key integerValue])] = obj;
    }];
    return self;
}

- (void)encodeWithJDCoder:(JDCoder *)aCoder{
    NSMutableDictionary *saveStorage = [NSMutableDictionary dictionary];
    [storages enumerateKeysAndObjectsUsingBlock:^(NSNumber* key, id obj, BOOL *stop) {
        saveStorage[[key stringValue]] = obj;
    }];
    [aCoder encodeObject:saveStorage forKey:@"storages"];
}

- (void)currentViewPortDidChange:(NSDictionary*)change{
    //update
    if (storages[@(_currentViewPort)] == nil) {
        IUDataStorage *newStorage = [self newStorage];
        newStorage.manager = self;
        storages[@(_currentViewPort)] = newStorage;
    }
    
    self.currentStorage = storages[@(_currentViewPort)];
    self.liveStorage = [self.defaultStorage storageByOverwritingDataStorage:self.currentStorage];
}

- (IUDataStorage*)storageForViewPort:(NSInteger)viewPort{
    return storages[@(viewPort)];
}

- (void)removeViewPort:(NSInteger)viewPort{
    [storages removeObjectForKey:@(viewPort)];
}


/**
 Manage new value of liveStorage = currentStroage
 */
- (void)storage:(IUDataStorage*)storage updated:(NSString*)key{
    if (self.currentStorage.storage[key] == self.liveStorage.storage[key]) {
        return;
    }
    
    if (storage == self.currentStorage) {
        [self.liveStorage setValue:self.currentStorage.storage[key] forKey:key];
    }
    else if (storage == self.liveStorage) {
        [self.currentStorage setValue:self.currentStorage.storage[key] forKey:key];
    }
    else {
        NSAssert(0, @"Cannot come to here");
    }
}

@end

@implementation IUCSSStorage {
    BOOL changing;
}

- (void)setBorderColor:(id)borderColor{
    if (changing == NO) {
        changing = YES;
    }
    else {
        return;
    }

    _borderColor = borderColor;


    [self setValue:borderColor forKey:IUCSSTagBorderTopColor];
    [self setValue:borderColor forKey:IUCSSTagBorderLeftColor];
    [self setValue:borderColor forKey:IUCSSTagBorderRightColor];
    [self setValue:borderColor forKey:IUCSSTagBorderBottomColor];
    
    changing = NO;
}


- (void)setValue:(id)value forKey:(IUCSSTag)key{
    [super setValue:value forKey:key];

    if (changing == NO && [key isBorderColorComponentTag]) {
        if ([self isAllBorderColorsEqual]) {
            if (_borderColor == value) {
                return;
            }
            [self willChangeValueForKey:@"borderColor"];
            _borderColor = value;
            [self didChangeValueForKey:@"borderColor"];
        }
        else {
            if (_borderColor == NSMultipleValuesMarker) {
                return;
            }
            [self willChangeValueForKey:@"borderColor"];
            _borderColor = NSMultipleValuesMarker;
            [self didChangeValueForKey:@"borderColor"];
        }
    }
}

- (BOOL)isAllBorderColorsEqual{
    if ([self valueForKey:IUCSSTagBorderTopColor] == [self valueForKey:IUCSSTagBorderBottomColor] &&
        [self valueForKey:IUCSSTagBorderTopColor] == [self valueForKey:IUCSSTagBorderLeftColor] &&
        [self valueForKey:IUCSSTagBorderTopColor] == [self valueForKey:IUCSSTagBorderRightColor] ) {
        return YES;
    }
    return NO;
}


@end

@implementation IUCSSStorageManager

- (IUDataStorage *)newStorage{
    return [[IUCSSStorage alloc] init];
}

- (IUCSSStorage*)storageForViewPort:(NSInteger)viewPort{
    return (IUCSSStorage*)[super storageForViewPort:viewPort];
}

@end

