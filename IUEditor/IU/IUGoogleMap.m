//
//  IUGoogleMap.m
//  IUEditor
//
//  Created by seungmi on 2014. 8. 7..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUGoogleMap.h"
#import "JDCode.h"
#import "IUProject.h"

@implementation IUGoogleMap

#pragma mark - Initialize

- (id)initWithProject:(IUProject *)project options:(NSDictionary *)options{
    self = [super initWithProject:project options:options];
    if(self){
        self.zoomLevel = 14;
        self.latitude = @"37.790896";
        self.longitude = @"-122.401502";
        self.enableMarkerIcon = YES;
        self.markerTitle = @"JDLab @ RocketSpace";
        
        [self.css setValue:@(400) forTag:IUCSSTagPixelWidth forViewport:IUCSSDefaultViewPort];
        [self.css setValue:@(400) forTag:IUCSSTagPixelHeight forViewport:IUCSSDefaultViewPort];
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self =  [super initWithCoder:aDecoder];
    [self.undoManager disableUndoRegistration];
    
    if(self){
        [aDecoder decodeToObject:self withProperties:[[IUGoogleMap class] properties]];
    }
    
    [self.undoManager enableUndoRegistration];
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeFromObject:self withProperties:[[IUGoogleMap class] properties]];
    
}

-(id)copyWithZone:(NSZone *)zone{
    [self.undoManager disableUndoRegistration];
    
    IUGoogleMap *map = [super copyWithZone:zone];
    
    map.longitude = _longitude;
    map.latitude = _latitude;
    map.zoomLevel = _zoomLevel;
    map.panControl = _panControl;
    map.zoomControl = _zoomControl;
    map.enableMarkerIcon = _enableMarkerIcon;
    map.markerIconName = [_markerIconName copy];
    map.markerTitle =[_markerTitle copy];
    
    //color
    map.water = [_water copy];
    map.road = [_road copy];
    map.landscape = [_landscape copy];
    map.poi = [_poi copy];
    
    [self.undoManager enableUndoRegistration];
    return map;
}

#pragma mark - set Property


- (void)setLongitude:(NSString *)longitude{
    if([longitude isEqualToString:_longitude] == NO){
        [[self.undoManager prepareWithInvocationTarget:self] setLongitude:_longitude];
        _longitude = longitude;
    }
    [self updateHTML];
}

- (void)setLatitude:(NSString *)latitude{
    if([latitude isEqualToString:_latitude] == NO){
        [[self.undoManager prepareWithInvocationTarget:self] setLatitude:_latitude];
        _latitude = latitude;
    }
    [self updateHTML];
}

- (void)setZoomLevel:(NSInteger)zoomLevel{
    if(_zoomLevel != zoomLevel){
        [[self.undoManager prepareWithInvocationTarget:self] setZoomLevel:_zoomLevel];
        _zoomLevel = zoomLevel;
    }
    [self updateHTML];
}

- (void)setPanControl:(BOOL)panControl{
    if(_panControl != panControl){
        [[self.undoManager prepareWithInvocationTarget:self] setPanControl:_panControl];
        _panControl = panControl;
    }
    [self updateHTML];
}

- (void)setZoomControl:(BOOL)zoomControl{
    if(_zoomControl != zoomControl){
        [[self.undoManager prepareWithInvocationTarget:self] setZoomControl:_zoomControl];
        _zoomControl = zoomControl;
    }
    [self updateHTML];
}

- (void)setEnableMarkerIcon:(BOOL)enableMarkerIcon{
    if(_enableMarkerIcon != enableMarkerIcon){
        [[self.undoManager prepareWithInvocationTarget:self] setEnableMarkerIcon:_enableMarkerIcon];
        _enableMarkerIcon = enableMarkerIcon;
    }
    [self updateHTML];
}

- (void)setMarkerIconName:(NSString *)markerIconName{
    if([_markerIconName isEqualToString:markerIconName]){
        return;
    }
    
    [[self.undoManager prepareWithInvocationTarget:self] setMarkerIconName:_markerIconName];
    _markerIconName = markerIconName;
    [self updateHTML];
}

- (void)setMarkerTitle:(NSString *)markerTitle{
    if([_markerTitle isEqualToString:markerTitle]){
        return;
    }
    
    [[self.undoManager prepareWithInvocationTarget:self] setMarkerTitle:_markerTitle];
    _markerTitle = markerTitle;
    [self updateHTML];
}

- (void)setWater:(NSColor *)water{
    if([_water isEqualTo:water]){
        return;
    }
    [[self.undoManager prepareWithInvocationTarget:self] setWater:_water];
    _water = water;
    [self updateHTML];
}

- (void)setRoad:(NSColor *)road{
    if([_road isEqualTo:road]){
        return;
    }
    [[self.undoManager prepareWithInvocationTarget:self] setRoad:_road];
    _road = road;
    [self updateHTML];
}

- (void)setLandscape:(NSColor *)landscape{
    if ([_landscape isEqualTo:landscape]) {
        return;
    }
    [[self.undoManager prepareWithInvocationTarget:self] setLandscape:_landscape];
    _landscape = landscape;
    [self updateHTML];
}

- (void)setPoi:(NSColor *)poi{
    if([_poi isEqualTo:poi]){
        return;
    }
    [[self.undoManager prepareWithInvocationTarget:self] setPoi:_poi];
    _poi = poi;
    [self updateHTML];
}

#pragma mark - size
- (void)increaseSize:(NSSize)size withParentSize:(NSSize)parentSize{
    [super increaseSize:size withParentSize:parentSize];
    [self updateHTML];
}




@end
