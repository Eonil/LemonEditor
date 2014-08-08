//
//  IUGoogleMap.h
//  IUEditor
//
//  Created by seungmi on 2014. 8. 7..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUBox.h"

@interface IUGoogleMap : IUBox

@property (nonatomic) NSString *longitude, *latitude;
@property (nonatomic) NSInteger zoomLevel;
@property (nonatomic) BOOL mapControl, panControl, zoomControl, enableMarkerIcon;
@property (nonatomic) NSString *markerIconName;
@property (nonatomic) NSString *markerTitle;
@property (nonatomic) NSColor *water, *road, *landscape, *poi;


@end
