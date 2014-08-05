//
//  IUCSSCompiler.m
//  IUEditor
//
//  Created by jd on 2014. 8. 4..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUCSSCompiler.h"
#import "LMFontController.h"

#import "IUHeader.h"
#import "PGPageLinkSet.h"


typedef enum _IUUnit{
    IUUnitNone,
    IUUnitPixel,
    IUUnitPercent,
} IUUnit;


@interface IUCSSCode() {
    IUTarget _currentTarget;
    int _currentViewPort;
    NSString *_currentIdentifier;
    NSMutableDictionary *_editorCSSDictWithViewPort; // data = key:width
    NSMutableDictionary *_outputCSSDictWithViewPort; // data = key:width
}

- (void)setInsertTarget:(IUTarget)target;
- (void)setInsertViewPort:(int)viewPort;
- (void)setInsertIdentifier:(NSString *)identifier;

/**
 insert css tag to receiver
 */

- (void)insertTag:(NSString*)tag color:(NSColor*)colorValue;
- (void)insertTag:(NSString*)tag string:(NSString*)stringValue;
- (void)insertTag:(NSString*)tag string:(NSString*)stringValue target:(IUTarget)target;
- (void)insertTag:(NSString*)tag floatFromNumber:(NSNumber*)floatNumber;
- (void)insertTag:(NSString*)tag floatFromNumber:(NSNumber*)floatNumber unit:(IUUnit)unit;
- (void)insertTag:(NSString*)tag intFromNumber:(NSNumber*)intNumber;
- (void)insertTag:(NSString*)tag intFromNumber:(NSNumber*)intNumber unit:(IUUnit)unit;
- (void)removeTag:(NSString*)tag identifier:(NSString*)identifier;

@end

@implementation IUCSSCode

- (id)init{
    self = [super init];
    if (self) {
        _editorCSSDictWithViewPort = [NSMutableDictionary dictionary];
        _outputCSSDictWithViewPort = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setInsertTarget:(IUTarget)target{
    _currentTarget = target;
}

- (void)setInsertViewPort:(int)viewPort{
    _currentViewPort = viewPort;
}

- (void)setInsertIdentifier:(NSString *)identifier{
    _currentIdentifier = identifier;
}

- (NSMutableDictionary*)tagDictionaryWithTarget:(IUTarget)target viewPort:(int)viewPort identifier:(NSString*)identifier{
    if (target == IUTargetEditor) {
        return [[_editorCSSDictWithViewPort objectForKey:@(viewPort)] objectForKey:identifier];
    }
    else if (target == IUTargetOutput){
        return [[_outputCSSDictWithViewPort objectForKey:@(viewPort)] objectForKey:identifier];
    }
    else {
        NSAssert(0, @"Cannot be IUTarget Both");
        return nil;
    }
}

- (NSMutableDictionary*)tagDictionaryWithTarget:(IUTarget)target{
    if (target == IUTargetBoth) {
        NSAssert(0, @"Cannot be IUTarget Both");
    }
    NSMutableDictionary *cssDictWithViewPort = (target == IUTargetEditor) ?_editorCSSDictWithViewPort : _outputCSSDictWithViewPort;
    
    NSMutableDictionary *cssDictWithIdentifier = cssDictWithViewPort[@(_currentViewPort)];
    if (cssDictWithIdentifier == nil) {
        cssDictWithIdentifier = [NSMutableDictionary dictionary];
        cssDictWithViewPort[@(_currentViewPort)] = cssDictWithIdentifier;
    }
    NSMutableDictionary *tagDictionary = cssDictWithIdentifier[_currentIdentifier];
    if (tagDictionary == nil) {
        tagDictionary = [NSMutableDictionary dictionary];
        cssDictWithIdentifier[_currentIdentifier] = tagDictionary;
    }
    return tagDictionary;
}



/**
 insert css tag to receiver
 */

- (void)insertTag:(NSString*)tag color:(NSColor*)color{
    if (_currentTarget & IUTargetEditor) {
        NSMutableDictionary *tagDict = [self tagDictionaryWithTarget:IUTargetEditor];
        if (color.colorSpace != [NSColorSpace deviceRGBColorSpace]) {
            color = [color colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
        }
        tagDict[tag] = [color rgbString];
    }
    if (_currentTarget & IUTargetOutput) {
        NSMutableDictionary *tagDict = [self tagDictionaryWithTarget:IUTargetEditor];
        if (color.colorSpace != [NSColorSpace deviceRGBColorSpace]) {
            color = [color colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
        }
        tagDict[tag] = [color rgbString];
    }
}

- (void)insertTag:(NSString*)tag string:(NSString*)stringValue{
    if (_currentTarget & IUTargetEditor) {
        NSMutableDictionary *tagDict = [self tagDictionaryWithTarget:IUTargetEditor];
        tagDict[tag] = [stringValue copy];
    }
    if (_currentTarget & IUTargetOutput) {
        NSMutableDictionary *tagDict = [self tagDictionaryWithTarget:IUTargetEditor];
        tagDict[tag] = [stringValue copy];
    }
}

- (void)insertTag:(NSString*)tag string:(NSString*)stringValue target:(IUTarget)target{
    NSMutableDictionary *tagDict = [self tagDictionaryWithTarget:target];
    
    tagDict[tag] = [stringValue copy];
}

- (void)insertTag:(NSString*)tag floatFromNumber:(NSNumber*)floatNumber{
    [self insertTag:tag floatFromNumber:floatNumber unit:IUUnitNone];
}

- (void)insertTag:(NSString*)tag floatFromNumber:(NSNumber*)floatNumber unit:(IUUnit)unit{
    NSString *unitString;
    switch (unit) {
        case IUUnitPercent: unitString = @"%"; break;
        case IUUnitPixel: unitString = @"px"; break;
        case IUUnitNone: unitString = @""; break;
    }

    if (_currentTarget & IUTargetEditor) {
        NSMutableDictionary *tagDict = [self tagDictionaryWithTarget:IUTargetEditor];
        tagDict[tag] = [NSString stringWithFormat:@"%.2f%@", [floatNumber floatValue] , unitString];
    }
    if (_currentTarget & IUTargetOutput) {
        NSMutableDictionary *tagDict = [self tagDictionaryWithTarget:IUTargetOutput];
        tagDict[tag] = [NSString stringWithFormat:@"%.2f%@", [floatNumber floatValue], unitString];
    }
}

- (void)insertTag:(NSString*)tag intFromNumber:(NSNumber*)intNumber{
    [self insertTag:tag intFromNumber:intNumber unit:IUUnitNone];
}

- (void)insertTag:(NSString*)tag intFromNumber:(NSNumber*)intNumber unit:(IUUnit)unit{
    NSString *unitString;
    switch (unit) {
        case IUUnitPercent: unitString = @"%"; break;
        case IUUnitPixel: unitString = @"px"; break;
        case IUUnitNone: unitString = @""; break;
    }
    
    if (_currentTarget & IUTargetEditor) {
        NSMutableDictionary *tagDict = [self tagDictionaryWithTarget:IUTargetEditor];
        tagDict[tag] = [NSString stringWithFormat:@"%d%@", [intNumber intValue] , unitString];
    }
    if (_currentTarget & IUTargetOutput) {
        NSMutableDictionary *tagDict = [self tagDictionaryWithTarget:IUTargetOutput];
        tagDict[tag] = [NSString stringWithFormat:@"%d%@", [intNumber intValue], unitString];
    }
}


- (NSArray*)allViewPorts{
    NSArray *widthsOne = [_editorCSSDictWithViewPort allKeys];
    NSArray *widthsTwo = [_outputCSSDictWithViewPort allKeys];
    if ([widthsOne isEqualToArray:widthsTwo]) {
        return widthsOne;
    }
    NSAssert (0, @"Two widths should be equal");
    return nil;
}


- (NSDictionary*)stringTagDictionaryWithTarget:(IUTarget)unit viewPort:(int)viewPort{
    NSMutableDictionary *returnDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *sourceDictWithViewPort = (unit == IUTargetEditor) ? _editorCSSDictWithViewPort : _outputCSSDictWithViewPort;
    NSMutableDictionary *sourceDictWithIdentifier = sourceDictWithViewPort[@(viewPort)];
    for (NSString *identifier in sourceDictWithIdentifier) {
        [returnDict setObject:[[sourceDictWithIdentifier objectForKey:identifier] CSSCode] forKey:identifier];
    }
    return returnDict;
}

- (void)removeTag:(NSString*)tag identifier:(NSString*)identifier{
    for (NSMutableDictionary *dictWithIdentifier in [_editorCSSDictWithViewPort allValues]) {
        NSMutableDictionary *tagDict = [dictWithIdentifier objectForKey:identifier];
        [tagDict removeObjectForKey:tag];
    }
    for (NSMutableDictionary *dictWithIdentifier in [_outputCSSDictWithViewPort allValues]) {
        NSMutableDictionary *tagDict = [dictWithIdentifier objectForKey:identifier];
        [tagDict removeObjectForKey:tag];
    }
}

@end


@implementation IUCSSCompiler {
    __weak IUResourceManager *_resourceManager;
}

- (id)initWithResourceManager:(IUResourceManager *)resourceManager{
    self = [super init];
    _resourceManager = resourceManager;
    return self;
}


- (IUCSSCode*)cssCodeForIU:(IUBox*)iu{
    IUCSSCode *code = [[IUCSSCode alloc] init];
    [self updateCSSCode:code asIUBox:iu];
    NSString *str = [NSString stringWithFormat:@"updateCSSCode:as%@:", [iu className]];
    SEL selector = NSSelectorFromString(str);
    if ([self respondsToSelector:selector]) {
        IMP imp = [self methodForSelector:selector];
        void (*func)(id, SEL, id, id) = (void *)imp;
        func(self, selector, code, iu);
    }
    return code;
}


- (NSString *)imagePathWithImageName:(NSString *)imageName target:(IUTarget)target{
    NSAssert (target != IUTargetBoth, @"IUTarget cannot both");
    
    NSString *imgSrc;
    if ([imageName isHTTPURL]) {
        return imageName;
    }
    
    //clipart
    //path : clipart/arrow_right.png
    else if([[imageName pathComponents][0] isEqualToString:@"clipArt"]){
        if(target == IUTargetEditor){
            imgSrc = [[NSBundle mainBundle] pathForImageResource:[imageName lastPathComponent]];
        }
        else{
            if(_rule == IUCompileRuleDjango){
                imgSrc = [@"/resource/" stringByAppendingString:imageName];
            }
            else{
                imgSrc = [@"resource/" stringByAppendingString:imageName];
            }
        }
    }
    else {
        IUResourceFile *file = [_resourceManager resourceFileWithName:imageName];
        if(file){
            if(_rule == IUCompileRuleDjango && target == IUTargetOutput){
                imgSrc = [@"/" stringByAppendingString:[file relativePath]];
            }
            else{
                imgSrc = [file relativePath];
            }
        }
    }
    return imgSrc;
}


- (void)updateCSSCode:(IUCSSCode*)code asIUBox:(IUBox*)_iu{
    NSArray *editWidths = [_iu.css allEditWidth];

    for (NSNumber *viewPortNumber in editWidths) {
        int viewPort = [viewPortNumber intValue];
        
        /* insert to editor and output, with default css identifier. */
        [code setInsertIdentifier:_iu.cssClass];
        [code setInsertTarget:IUTargetBoth];

        /* width can vary to data */
        [code setInsertViewPort:viewPort];

        [self updateCSSPositionCode:code asIUBox:_iu viewPort:viewPort];
        [self updateCSSApperanceCode:code asIUBox:_iu viewPort:viewPort];
        if ([_iu shouldCompileFontInfo]) {
            [self updateCSSFontCode:code asIUBox:_iu viewPort:viewPort];
        }
    }
}

- (void)updateCSSFontCode:(IUCSSCode*)code asIUBox:(IUBox*)_iu viewPort:(int)viewPort{
    NSDictionary *cssTagDict = [_iu.css tagDictionaryForWidth:viewPort];
    if (cssTagDict[IUCSSTagFontName]) {
        [code insertTag:@"font-family" string:[[LMFontController sharedFontController] cssForFontName:cssTagDict[IUCSSTagFontName]]];
    }
    if (cssTagDict[IUCSSTagFontSize]) {
        [code insertTag:@"font-size" intFromNumber:cssTagDict[IUCSSTagFontSize] unit:IUUnitPixel];
    }
    if (cssTagDict[IUCSSTagFontColor]) {
        [code insertTag:@"color" color:cssTagDict[IUCSSTagFontColor]];
    }
    if ([cssTagDict[IUCSSTagTextLetterSpacing] floatValue]) {
        [code insertTag:@"letter-spacing" floatFromNumber:cssTagDict[IUCSSTagTextLetterSpacing] unit:IUUnitPixel];
    }
    if ([cssTagDict[IUCSSTagFontWeight] boolValue]) {
        [code insertTag:@"font-weight" string:@"bold"];
    }
    if ([cssTagDict[IUCSSTagFontWeight] boolValue]) {
        [code insertTag:@"font-style" string:@"italic"];
    }
    if ([cssTagDict[IUCSSTagFontWeight] boolValue]) {
        [code insertTag:@"text-decoration" string:@"underline"];
    }
    if (cssTagDict[IUCSSTagTextAlign]) {
        NSString *alignText;
        switch ([cssTagDict[IUCSSTagTextAlign] intValue]) {
            case IUAlignLeft: alignText = @"left"; break;
            case IUAlignCenter: alignText = @"center"; break;
            case IUAlignRight: alignText = @"right"; break;
            case IUAlignJustify: alignText = @"justify"; break;
            default: JDErrorLog(@"no align type"); NSAssert(0, @"no align type");
        }
        [code insertTag:@"text-align" string:alignText];
    }
    if (cssTagDict[IUCSSTagLineHeight]) {
        if ([cssTagDict[IUCSSTagLineHeight] isEqualToString:@"Auto"] == NO) {
            [code insertTag:@"line-height" floatFromNumber:cssTagDict[IUCSSTagLineHeight]];
            //if pgtextview, set 1.3
        }
    }
}

- (void)updateCSSApperanceCode:(IUCSSCode*)code asIUBox:(IUBox*)_iu viewPort:(int)viewPort{
    NSDictionary *cssTagDict = [_iu.css tagDictionaryForWidth:viewPort];
    /* pointer */
    if (_iu.link) {
        [code insertTag:@"cursor" string:@"pointer"];
    }
    
    /* overflow */
    switch (_iu.overflowType) {
        case IUOverflowTypeHidden: break; //default is hidden
        case IUOverflowTypeVisible:{
            [code insertTag:@"overflow" string:@"visible"]; break;
        }
        case IUOverflowTypeScroll:{
            [code insertTag:@"overflow" string:@"scroll"]; break;
        }
    }
    
    if ([cssTagDict[IUCSSTagDisplayIsHidden] boolValue]) {
        [code insertTag:@"display" string:@"none"];
    }
    
    /* apperance */
    if (cssTagDict[IUCSSTagOpacity]) {
        float opacity = [cssTagDict[IUCSSTagOpacity] floatValue]/100;
        [code insertTag:@"opacity" floatFromNumber:@(opacity)];
        [code insertTag:@"filter" string:[NSString stringWithFormat:@"alpha(opacity=%d)",[cssTagDict[IUCSSTagOpacity] intValue]] ];
    }
    if (cssTagDict[IUCSSTagBGColor]) {
        [code insertTag:@"background-color" color:cssTagDict[IUCSSTagBGColor]];
    }
    if (cssTagDict[IUCSSTagImage]) {
        NSString *imgSrc = [[self imagePathWithImageName:cssTagDict[IUCSSTagImage] target:IUTargetEditor] CSSURLString];
        [code insertTag:@"background-image" string:imgSrc target:IUTargetEditor];
        NSString *outputImgSrc = [[self imagePathWithImageName:cssTagDict[IUCSSTagImage] target:IUTargetOutput] CSSURLString];
        [code insertTag:@"background-image" string:outputImgSrc target:IUTargetOutput];
        
        /* bg size & position */
        IUBGSizeType bgSizeType = [cssTagDict[IUCSSTagBGSize] intValue];
        switch (bgSizeType) {
            case IUBGSizeTypeStretch:
                [code insertTag:@"background-size" string:@"100% 100%"];
                break;
            case IUBGSizeTypeContain:
                [code insertTag:@"background-size" string:@"contain"];
                break;
            case IUBGSizeTypeFull:
                [code insertTag:@"background-attachment" string:@"fixed"];
            case IUBGSizeTypeCover:
                [code insertTag:@"background-size" string:@"cover"];
                break;
            case IUBGSizeTypeAuto:
            default:
                break;
        }
        
        if ([cssTagDict[IUCSSTagEnableBGCustomPosition] boolValue]) {
            /* custom bg position */
            [code insertTag:@"background-position-x" floatFromNumber:cssTagDict[IUCSSTagBGYPosition] unit:IUUnitPixel];
            [code insertTag:@"background-position-y" floatFromNumber:cssTagDict[IUCSSTagBGYPosition] unit:IUUnitPixel];
        }
        else {
            IUCSSBGVPostion vPosition = [cssTagDict[IUCSSTagBGVPosition] intValue];
            IUCSSBGHPostion hPosition = [cssTagDict[IUCSSTagBGHPosition] intValue];
            if (vPosition != IUCSSBGVPostionTop && hPosition != IUCSSBGHPostionLeft) {
                NSString *vPositionString, *hPositionString;
                switch (vPosition) {
                    case IUCSSBGVPostionTop: vPositionString = @"top"; break;
                    case IUCSSBGVPostionCenter: vPositionString = @"center"; break;
                    case IUCSSBGVPostionBottom: vPositionString = @"bottom"; break;
                    default: NSAssert(0, @"Cannot be default");  break;
                }
                switch (hPosition) {
                    case IUCSSBGHPostionLeft: hPositionString = @"left"; break;
                    case IUCSSBGHPostionCenter: hPositionString = @"center"; break;
                    case IUCSSBGVPostionBottom: hPositionString = @"right"; break;
                    default: NSAssert(0, @"Cannot be default");  break;
                }
                [code insertTag:@"background-position" string:[NSString stringWithFormat:@"%@ %@", vPositionString, hPositionString]];
            }
        }
        
        /* bg repeat */
        if ([cssTagDict[IUCSSTagBGRepeat] boolValue] == NO) {
            [code insertTag:@"background-repeat" string:@"no-repeat"];
        }
    }
}

- (void)updateCSSPositionCode:(IUCSSCode*)code asIUBox:(IUBox*)_iu viewPort:(int)viewPort{
    NSDictionary *cssTagDict = [_iu.css tagDictionaryForWidth:viewPort];

    /*  X, Y, Width, Height */
    IUUnit xUnit = [cssTagDict[IUCSSTagXUnitIsPercent] boolValue] ? IUUnitPercent : IUUnitPixel;
    IUUnit yUnit = [cssTagDict[IUCSSTagYUnitIsPercent] boolValue] ? IUUnitPercent : IUUnitPixel;
    
    NSNumber *xValue = (xUnit == IUUnitPercent) ? cssTagDict[IUCSSTagPercentX] : cssTagDict[IUCSSTagPixelX];
    NSNumber *yValue = (yUnit == IUUnitPercent) ? cssTagDict[IUCSSTagPercentY] : cssTagDict[IUCSSTagPixelY];
    
    NSString *topTag;
    NSString *leftTag;
    /* insert position */
    switch (_iu.positionType) {
        case IUPositionTypeAbsolute:{
            topTag = @"top"; leftTag = @"left"; break;
        }
        case IUPositionTypeAbsoluteCenter:{
            topTag = @"top"; break;
        }
        case IUPositionTypeRelative:{
            [code insertTag:@"position" string:@"relative"];
            topTag = @"margin-top"; leftTag = @"margin-left"; break;
            break;
        }
        case IUPositionTypeRelativeCenter:{
            [code insertTag:@"position" string:@"relative"];
            topTag = @"margin-top"; break;
        }
        case IUPositionTypeFloatLeft:{
            [code insertTag:@"position" string:@"relative"];
            [code insertTag:@"float" string:@"left"];
            topTag = @"margin-top"; break;
            break;
        }
        case IUPositionTypeFloatRight:{
            [code insertTag:@"position" string:@"relative"];
            [code insertTag:@"float" string:@"right"];
            topTag = @"margin-top"; break;
            float xValueFloat = [xValue floatValue] * (-1);
            xValue = @(xValueFloat);
            break;
        }
        case IUPositionTypeFixed:{
            [code insertTag:@"position" string:@"fixed"];
            topTag = @"top"; leftTag = @"left"; break;
            break;
        }
        default:
            break;
    }
    if (_iu.hasY && topTag) {
        [code insertTag:topTag floatFromNumber:yValue unit:yUnit];
    }
    if (_iu.hasX && leftTag) {
        [code insertTag:leftTag floatFromNumber:xValue unit:xUnit];
    }
    
    if (_iu.hasWidth) {
        IUUnit wUnit = [cssTagDict[IUCSSTagWidthUnitIsPercent] boolValue] ? IUUnitPercent : IUUnitPixel;
        NSNumber *wValue = (wUnit == IUUnitPercent) ? cssTagDict[IUCSSTagPercentWidth] : cssTagDict[IUCSSTagPixelWidth];
        [code insertTag:@"width" floatFromNumber:wValue unit:wUnit];
    }
    
    if (_iu.hasHeight) {
        IUUnit hUnit = [cssTagDict[IUCSSTagHeightUnitIsPercent] boolValue] ? IUUnitPercent : IUUnitPixel;
        NSNumber *hValue = (hUnit == IUUnitPercent) ? cssTagDict[IUCSSTagPercentHeight] : cssTagDict[IUCSSTagPixelHeight];
        [code insertTag:@"height" floatFromNumber:hValue unit:hUnit];
    }
}

@end
