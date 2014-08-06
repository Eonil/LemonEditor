//
//  IUCSSCompiler.m
//  IUEditor
//
//  Created by jd on 2014. 8. 4..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUCSSCompiler.h"
#import "LMFontController.h"
#import "IUCSS.h"

#import "IUHeader.h"
#import "PGPageLinkSet.h"
#import "IUMenuBar.h"
#import "IUMenuItem.h"
#import "IUCarousel.h"

typedef enum _IUUnit{
    IUUnitNone,
    IUUnitPixel,
    IUUnitPercent,
} IUUnit;


@interface IUCSSCode() {
    IUTarget _currentTarget;
    int _currentViewPort;
    NSArray *_currentIdentifiers;
    NSMutableDictionary *_editorCSSDictWithViewPort; // data = key:width
    NSMutableDictionary *_outputCSSDictWithViewPort; // data = key:width
}

- (void)setInsertingTarget:(IUTarget)target;
- (void)setInsertingViewPort:(int)viewport;
- (int)insertingViewPort;
- (void)setInsertingIdentifier:(NSString *)identifier;
- (void)setInsertingIdentifiers:(NSArray *)identifiers;
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
- (void)insertTag:(NSString*)tag integer:(int)number unit:(IUUnit)unit;
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

- (void)setInsertingTarget:(IUTarget)target{
    _currentTarget = target;
}

- (void)setInsertingViewPort:(int)viewport{
    _currentViewPort = viewport;
}

- (void)setInsertingIdentifier:(NSString *)identifier{
    _currentIdentifiers = @[[identifier copy]];
}

- (void)setInsertingIdentifiers:(NSArray *)identifiers{
    _currentIdentifiers = [[NSArray alloc] initWithArray:identifiers copyItems:YES];
}

- (int)insertingViewPort{
    return _currentViewPort;
}


- (NSMutableDictionary*)tagDictionaryWithTarget:(IUTarget)target viewport:(int)viewport identifier:(NSString*)identifier{
    if (target == IUTargetEditor) {
        return [[_editorCSSDictWithViewPort objectForKey:@(viewport)] objectForKey:identifier];
    }
    else if (target == IUTargetOutput){
        return [[_outputCSSDictWithViewPort objectForKey:@(viewport)] objectForKey:identifier];
    }
    else {
        NSAssert(0, @"Cannot be IUTarget Both");
        return nil;
    }
}

/*
- (NSMutableDictionary*)tagDictionaryWithTarget:(IUTarget)target{
    if (target == IUTargetBoth) {
        NSAssert(0, @"Cannot be IUTarget Both");
    }
    if (_currentIdentifier == nil) {
        NSAssert(0, @"Cannot be current identifier nil");
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
 */



/**
 insert css tag to receiver
 */

- (void)insertTag:(NSString*)tag color:(NSColor*)color{
    if (color == nil) {
        color = [NSColor blackColor];
    }
    if (color.colorSpace != [NSColorSpace deviceRGBColorSpace]) {
        color = [color colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
    }
    [self insertTag:tag string:[color rgbString]];
}

- (void)insertTag:(NSString*)tag string:(NSString*)stringValue{
    [self insertTag:tag string:stringValue target:_currentTarget];
}

- (void)insertTag:(NSString*)tag string:(NSString*)stringValue target:(IUTarget)target{
    if (target & IUTargetEditor ) {
        NSMutableDictionary *cssDictWithIdentifier = _editorCSSDictWithViewPort[@(_currentViewPort)];
        if (cssDictWithIdentifier == nil) { //does not have view port, so make new one
            cssDictWithIdentifier = [NSMutableDictionary dictionary];
            _editorCSSDictWithViewPort[@(_currentViewPort)] = cssDictWithIdentifier;
        }
        for (NSString *identifier in _currentIdentifiers) {
            NSMutableDictionary *tagDictionary = cssDictWithIdentifier[identifier];
            if (tagDictionary == nil) {
                tagDictionary = [NSMutableDictionary dictionary];
                cssDictWithIdentifier[identifier] = tagDictionary;
            }
            tagDictionary[tag] = [stringValue copy];
        }
    }
    if (target & IUTargetOutput ) {
        NSMutableDictionary *cssDictWithIdentifier = _outputCSSDictWithViewPort[@(_currentViewPort)];
        if (cssDictWithIdentifier == nil) { //does not have view port, so make new one
            cssDictWithIdentifier = [NSMutableDictionary dictionary];
            _outputCSSDictWithViewPort[@(_currentViewPort)] = cssDictWithIdentifier;
        }
        for (NSString *identifier in _currentIdentifiers) {
            NSMutableDictionary *tagDictionary = cssDictWithIdentifier[identifier];
            if (tagDictionary == nil) {
                tagDictionary = [NSMutableDictionary dictionary];
                cssDictWithIdentifier[identifier] = tagDictionary;
            }
            tagDictionary[tag] = [stringValue copy];
        }
    }
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
    NSString *stringValue = [NSString stringWithFormat:@"%.2f%@", [floatNumber floatValue] , unitString];
    [self insertTag:tag string:stringValue];
}

- (void)insertTag:(NSString*)tag intFromNumber:(NSNumber*)intNumber{
    [self insertTag:tag intFromNumber:intNumber unit:IUUnitNone];
}

- (void)insertTag:(NSString*)tag intFromNumber:(NSNumber*)intNumber unit:(IUUnit)unit{
    [self insertTag:tag integer:[intNumber intValue] unit:unit];
}

- (void)insertTag:(NSString*)tag integer:(int)number unit:(IUUnit)unit{
    NSString *unitString;
    switch (unit) {
        case IUUnitPercent: unitString = @"%"; break;
        case IUUnitPixel: unitString = @"px"; break;
        case IUUnitNone: unitString = @""; break;
    }
    NSString *stringValue = [NSString stringWithFormat:@"%d%@", number , unitString];
    [self insertTag:tag string:stringValue];
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


- (NSDictionary*)tagDictionaryWithIdentifierForTarget:(IUTarget)unit viewport:(int)viewport{
    NSMutableDictionary *returnDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *sourceDictWithViewPort = (unit == IUTargetEditor) ? _editorCSSDictWithViewPort : _outputCSSDictWithViewPort;
    NSMutableDictionary *sourceDictWithIdentifier = sourceDictWithViewPort[@(viewport)];
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


- (IUCSSCode*)cssCodeForIU:(IUBox*)iu {
    IUCSSCode *code = [[IUCSSCode alloc] init];

    NSArray *classPedigree = [[iu class] classPedigreeTo:[IUBox class]].reversedArray;
    for (NSString *className in classPedigree) {
        NSString *str = [NSString stringWithFormat:@"updateCSSCode:as%@:", className];
        SEL selector = NSSelectorFromString(str);
        if ([self respondsToSelector:selector]) {
            IMP imp = [self methodForSelector:selector];
            void (*func)(id, SEL, id, id) = (void *)imp;
            func(self, selector, code, iu);
        }
    }

    return code;
}


- (void)updateCSSCode:(IUCSSCode*)code asIUBox:(IUBox*)_iu {
    NSArray *editWidths = [_iu.css allViewports];

    for (NSNumber *viewportNumber in editWidths) {
        int viewport = [viewportNumber intValue];
        
        /* insert to editor and output, with default css identifier. */
        [code setInsertingIdentifier:_iu.cssClass];
        [code setInsertingTarget:IUTargetBoth];

        /* width can vary to data */
        [code setInsertingViewPort:viewport];

        /* update CSSCode */
        [self updateCSSPositionCode:code asIUBox:_iu viewport:viewport];
        [self updateCSSApperanceCode:code asIUBox:_iu viewport:viewport ];
        if ([_iu shouldCompileFontInfo]) {
            [self updateCSSFontCode:code asIUBox:_iu viewport:viewport];
        }
        [self updateCSSRadiousAndBorderCode:code asIUBox:_iu viewport:viewport];
        
        [code setInsertingIdentifier:_iu.cssHoverClass];
        [self updateCSSHoverCode:code asIUBox:_iu viewport:viewport];
        
#if 0
        if(_rule == IUCompileRuleDjango && isEdit == NO && iu.pgContentVariable){
            NSDictionary *cssDict = [iu.css tagDictionaryForViewport:width];
            NSInteger line =  [cssDict[IUCSSTagEllipsis] integerValue];
            if([identifier isEqualToString:[[iu.htmlID cssClass] stringByAppendingString:@">p"]])
                if(line > 0){
                    if(line > 1){
                        [dict putTag:@"display" string:@"-webkit-box"];
                    }
                    else if(line == 1){
                        [dict putTag:@"white-space" string:@"nowrap"];
                    }
                    [dict putTag:@"overflow" string:@"hidden"];
                    [dict putTag:@"text-overflow" string:@"ellipsis"];
                    [dict putTag:@"-webkit-line-clamp" intValue:(int)line ignoreZero:YES unit:IUCSSUnitNone];
                    [dict putTag:@"-webkit-box-orient" string:@"vertical"];
                    [dict putTag:@"height" intValue:100 ignoreZero:NO unit:IUCSSUnitPercent];
                }
        }

#endif
    }
}

- (void)updateCSSHoverCode:(IUCSSCode*)code asIUBox:(IUBox*)_iu viewport:(int)viewport{
    NSDictionary *cssTagDict = [_iu.css tagDictionaryForViewport:viewport];

    if ([cssTagDict[IUCSSTagHoverBGImagePositionEnable] boolValue]) {
        [code insertTag:@"background-position-x" floatFromNumber:cssTagDict[IUCSSTagHoverBGImageX] unit:IUUnitPixel];
        [code insertTag:@"background-position-y" floatFromNumber:cssTagDict[IUCSSTagHoverBGImageY] unit:IUUnitPixel];
    }
    
    if ([cssTagDict[IUCSSTagHoverBGColorEnable] boolValue]){
        NSString *colorStr = [cssTagDict[IUCSSTagHoverBGColor] cssBGColorString];
        if ([colorStr length] == 0) {
            colorStr = @"black";
        }
        [code insertTag:@"background-color" string:colorStr];
    }
    
    
    if ([cssTagDict[IUCSSTagHoverTextColorEnable] boolValue]){
        [code insertTag:@"color" color:cssTagDict[IUCSSTagHoverTextColor]];
    }
}


- (void)updateCSSFontCode:(IUCSSCode*)code asIUBox:(IUBox*)_iu viewport:(int)viewport{
    NSDictionary *cssTagDict = [_iu.css tagDictionaryForViewport:viewport];
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
    if ([cssTagDict[IUCSSTagFontStyle] boolValue]) {
        [code insertTag:@"font-style" string:@"italic"];
    }
    if ([cssTagDict[IUCSSTagTextDecoration] boolValue]) {
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
            //???  코드 안넣은 이유는??
        }
    }
}

- (void)updateCSSRadiousAndBorderCode:(IUCSSCode*)code asIUBox:(IUBox*)_iu viewport:(int)viewport{
    NSDictionary *cssTagDict = [_iu.css tagDictionaryForViewport:viewport];


    if (cssTagDict[IUCSSTagBorderTopWidth]) {
        [code insertTag:@"border-top-width" floatFromNumber:cssTagDict[IUCSSTagBorderTopWidth] unit:IUUnitPixel];
        [code insertTag:@"border-top-color" color:cssTagDict[IUCSSTagBorderTopColor]];
    }
    if (cssTagDict[IUCSSTagBorderLeftWidth]) {
        [code insertTag:@"border-left-width" floatFromNumber:cssTagDict[IUCSSTagBorderLeftWidth] unit:IUUnitPixel];
        [code insertTag:@"border-left-color" color:cssTagDict[IUCSSTagBorderLeftColor]];
    }
    if (cssTagDict[IUCSSTagBorderRightWidth]) {
        [code insertTag:@"border-right-width" floatFromNumber:cssTagDict[IUCSSTagBorderRightWidth] unit:IUUnitPixel];
        [code insertTag:@"border-right-color" color:cssTagDict[IUCSSTagBorderRightColor]];
    }
    if (cssTagDict[IUCSSTagBorderBottomWidth]) {
        [code insertTag:@"border-bottom-width" floatFromNumber:cssTagDict[IUCSSTagBorderBottomWidth] unit:IUUnitPixel];
        [code insertTag:@"border-bottom-color" color:cssTagDict[IUCSSTagBorderBottomColor]];
    }

    if (cssTagDict[IUCSSTagBorderRadiusTopLeft]) {
        [code insertTag:@"border-top-left-radius" floatFromNumber:cssTagDict[IUCSSTagBorderRadiusTopLeft] unit:IUUnitPixel];
    }
    if (cssTagDict[IUCSSTagBorderRadiusTopRight]) {
        [code insertTag:@"border-top-right-radius" floatFromNumber:cssTagDict[IUCSSTagBorderRadiusTopRight] unit:IUUnitPixel];
    }
    if (cssTagDict[IUCSSTagBorderRadiusBottomLeft]) {
        [code insertTag:@"border-bottom-left-radius" floatFromNumber:cssTagDict[IUCSSTagBorderRadiusBottomLeft] unit:IUUnitPixel];
    }
    if (cssTagDict[IUCSSTagBorderRadiusBottomRight]) {
        [code insertTag:@"border-bottom-right-radius" floatFromNumber:cssTagDict[IUCSSTagBorderRadiusBottomRight] unit:IUUnitPixel];
    }

    NSInteger hOff = [cssTagDict[IUCSSTagShadowHorizontal] integerValue];
    NSInteger vOff = [cssTagDict[IUCSSTagShadowVertical] integerValue];
    NSInteger blur = [cssTagDict[IUCSSTagShadowBlur] integerValue];
    NSInteger spread = [cssTagDict[IUCSSTagShadowSpread] integerValue];
    NSColor *color = cssTagDict[IUCSSTagShadowColor];

    if (hOff || vOff || blur || spread){
        if (color == nil) {
            color = [NSColor blackColor];
        }
        [code insertTag:@"-moz-box-shadow" string:[NSString stringWithFormat:@"%ldpx %ldpx %ldpx %ldpx %@", hOff, vOff, blur, spread, [color rgbString]]];
        [code insertTag:@"-webkit-box-shadow" string:[NSString stringWithFormat:@"%ldpx %ldpx %ldpx %ldpx %@", hOff, vOff, blur, spread, [color rgbString]]];
        [code insertTag:@"box-shadow" string:[NSString stringWithFormat:@"%ldpx %ldpx %ldpx %ldpx %@", hOff, vOff, blur, spread, [color rgbString]]];
        //for IE5.5-7
        [code insertTag:@"filter" string:[NSString stringWithFormat:@"progid:DXImageTransform.Microsoft.Shadow(Strength=%ld, Direction=135, Color='%@')",spread, [color rgbString]]];
        //            [code insertTag:@"filter" string:[NSString stringWithFormat:@"progid:DXImageTransform.Microsoft.Blur(pixelradius=%ld)",blur]];
        
        //for IE 8
        [code insertTag:@"-ms-filter" string:[NSString stringWithFormat:@"\"progid:DXImageTransform.Microsoft.Shadow(Strength=%ld, Direction=135, Color='%@')",spread, [color rgbString]]];
        //          [code insertTag:@"-ms-filter" string:[NSString stringWithFormat:@"\"progid:DXImageTransform.Microsoft.Blur(pixelradius=%ld)\"",blur]];
    }
}

- (void)updateCSSApperanceCode:(IUCSSCode*)code asIUBox:(IUBox*)_iu viewport:(int)viewport{
    NSDictionary *cssTagDict = [_iu.css tagDictionaryForViewport:viewport];
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
    
    /* display */
    id value = cssTagDict[IUCSSTagDisplayIsHidden];
    if (value && [value boolValue]) {
        [code insertTag:@"display" string:@"none"];
    }
    else{
        [code insertTag:@"display" string:@"inherit"];
    }
    value = cssTagDict[IUCSSTagEditorDisplay];
    if (value && [value boolValue] == NO) {
        [code insertTag:@"display" string:@"none" target:IUTargetEditor];
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

- (void)updateCSSPositionCode:(IUCSSCode*)code asIUBox:(IUBox*)_iu viewport:(int)viewport{
    NSDictionary *cssTagDict = [_iu.css tagDictionaryForViewport:viewport];

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


- (void)updateCSSCode:(IUCSSCode*)code asPGPageLinkSet:(PGPageLinkSet*)pageLinkSet{
    [code setInsertingTarget:IUTargetBoth];
    [code setInsertingViewPort:IUCSSDefaultViewPort];
    
    [code setInsertingIdentifier:[pageLinkSet.cssClass stringByAppendingString:@" > div"]];
    switch (pageLinkSet.pageLinkAlign) {
        case IUAlignLeft: break;
        case IUAlignRight: [code insertTag:@"float" string:@"right"]; break;
        case IUAlignCenter: [code insertTag:@"margin" string:@"auto"]; break;
        default:NSAssert(0, @"Error");
    }
    
    [code setInsertingIdentifier:[pageLinkSet.cssClass stringByAppendingString:@" selected > div > ul > a > li"]];
    [code insertTag:@"background-color" color:pageLinkSet.selectedButtonBGColor];
    
    NSArray *editWidths = [pageLinkSet.css allViewports];
    for (NSNumber *viewportNumber in editWidths) {
        [code setInsertingViewPort:[viewportNumber intValue]];
        
    }

    
    [code setInsertingIdentifier:[pageLinkSet.cssClass stringByAppendingString:@" > div > ul > a > li"]];
    [code insertTag:@"display" string:@"block"];
    [code insertTag:@"margin-left" floatFromNumber:@(pageLinkSet.buttonMargin) unit:IUCSSUnitPixel];
    [code insertTag:@"margin-right" floatFromNumber:@(pageLinkSet.buttonMargin) unit:IUCSSUnitPixel];
    [code insertTag:@"background-color" color:pageLinkSet.defaultButtonBGColor];
    
    for (NSNumber *viewPort in [pageLinkSet.css allViewports]) {
        NSDictionary *tagDictionary = [pageLinkSet.css tagDictionaryForViewport:[viewPort intValue]];
        if ([tagDictionary objectForKey:IUCSSTagPixelY]) {
            [code setInsertingViewPort:[viewPort intValue]];
            [code insertTag:@"height" floatFromNumber:tagDictionary[IUCSSTagPixelY] unit:IUUnitPixel];
            [code insertTag:@"width" floatFromNumber:tagDictionary[IUCSSTagPixelY] unit:IUUnitPixel];
            [code insertTag:@"line-height" floatFromNumber:tagDictionary[IUCSSTagPixelY] unit:IUUnitPixel];
        }
    }
}

- (void)updateCSSCode:(IUCSSCode*)code asIUMenuBar:(IUMenuBar*)menuBar{
    
    /*
     IUMenuBar *menuBar = (IUMenuBar *)iu;
     if(width < 640){
     int height = [[menuBar.css tagDictionaryForViewport:width][IUCSSTagPixelHeight] intValue];
     if([identifier isEqualToString:menuBar.mobileButtonIdentifier]){
     [dict putTag:@"line-height" intValue:height ignoreZero:YES unit:IUCSSUnitPixel];
     }
     else if([identifier isEqualToString:menuBar.topButtonIdentifier]){
     int top = (height -10)/2;
     [dict putTag:@"top" intValue:top ignoreZero:YES unit:IUCSSUnitPixel];
     }
     else if([identifier isEqualToString:menuBar.bottomButtonIdentifier]){
     int top =(height -10)/2 +10;
     [dict putTag:@"top" intValue:top ignoreZero:YES unit:IUCSSUnitPixel];
     }
     else if([identifier isEqualToString:menuBar.editorDisplayIdentifier] && isEdit){
     if(menuBar.isOpened){
     [dict putTag:@"display" string:@"block"];
     }
     else{
     [dict putTag:@"display" string:@"none"];
     }
     }
     }
    */
}

- (void)updateCSSCode:(IUCSSCode*)code asIUMenuItem:(IUMenuItem*)menuItem{

    [code setInsertingIdentifier:menuItem.itemIdentifier];
    /*

        id value = [menuItem.css tagDictionaryForViewport:width][IUCSSTagBGColor];
        if(value){
            [dict putTag:@"background-color" color:value ignoreClearColor:NO];
        }
        value = [menuItem.css tagDictionaryForViewport:width][IUCSSTagFontColor];
        if(value){
            [dict putTag:@"color" color:value ignoreClearColor:NO];
        }
        value = [menuItem.parent.css tagDictionaryForViewport:width][IUCSSTagPixelHeight];
        if(value){
            [dict putTag:@"line-height" intValue:[value intValue] ignoreZero:YES unit:IUCSSUnitPixel];
        }
        
    }
    else if([identifier isEqualToString:menuItem.closureIdentifier]){
        id value = [menuItem.css tagDictionaryForViewport:width][IUCSSTagFontColor];
        if(value){
            NSString *color = [(NSColor *)value rgbString];
            if(menuItem.depth == 1){
                [dict putTag:@"border-top-color" string:color];
            }
            else if(menuItem.depth ==2){
                if(width > 640){
                    [dict putTag:@"border-left-color" string:color];
                }
                else{
                    [dict putTag:@"border-left-color" string:@"transparent"];
                    [dict putTag:@"border-top-color" string:color];
                }
            }
        }
        value = [menuItem.parent.css tagDictionaryForViewport:width][IUCSSTagPixelHeight];
        if(value){
            int top = ([value intValue] - 10)/2;
            [dict putTag:@"top" intValue:top ignoreZero:YES unit:IUCSSUnitPixel];
            
        }
        
    }
    else if([identifier isEqualToString:menuItem.hoverItemIdentifier] ||
            [identifier isEqualToString:menuItem.activeItemIdentifier]){
        if(menuItem.bgActive){
            [dict putTag:@"background-color" color:menuItem.bgActive ignoreClearColor:NO];
        }
        if(menuItem.fontActive){
            [dict putTag:@"color" color:menuItem.fontActive ignoreClearColor:NO];
        }
    }
    else if([identifier isEqualToString:menuItem.editorDisplayIdentifier] && isEdit){
        if(width  > 640){
            if(menuItem.isOpened){
                [dict putTag:@"display" string:@"block"];
            }
            else{
                [dict putTag:@"display" string:@"none"];
            }
        }
        else{
            [dict putTag:@"display" string:@"block"];
        }
    }
     */

}

- (void)updateCSSCode:(IUCSSCode*)code asIUCarousel:(IUCarousel*)carousel{
    
    
    [code setInsertingIdentifier:carousel.pagerID];
    [code insertTag:@"background-color" color:carousel.deselectColor];
    
    [code setInsertingIdentifier:[carousel.pagerID cssHoverClass]];
    [code insertTag:@"background-color" color:carousel.selectColor];
    
    
    [code setInsertingIdentifier:[carousel.pagerID cssActiveClass]];
    [code insertTag:@"background-color" color:carousel.selectColor];
    
    
    [code setInsertingIdentifier:carousel.pagerWrapperID];
    if(carousel.pagerPosition){
        NSInteger currentWidth = [carousel.css.assembledTagDictionary[IUCSSTagPixelWidth] integerValue];
        
        if(carousel.pagerPosition < 50){
            [code insertTag:@"text-align" string:@"left"];
            int left = (int)((currentWidth) * ((CGFloat)carousel.pagerPosition/100));
            [code insertTag:@"left" integer:left unit:IUUnitPixel];
        }
        else if(carousel.pagerPosition == 50){
            [code insertTag:@"text-align" string:@"center"];
        }
        else if(carousel.pagerPosition < 100){
            [code insertTag:@"text-align" string:@"center"];
            int left = (int)((currentWidth) * ((CGFloat)(carousel.pagerPosition-50)/100));
            [code insertTag:@"left" integer:left unit:IUUnitPixel];
            
        }
        else if(carousel.pagerPosition == 100){
            int right = (int)((currentWidth) * ((CGFloat)(100-carousel.pagerPosition)/100));
            [code insertTag:@"text-align" string:@"right"];
            [code insertTag:@"right" integer:right unit:IUUnitPixel];
        }
    }
    
    [code setInsertingIdentifier:carousel.prevID];
    
    NSString *imageName = carousel.leftArrowImage;
        [code insertTag:@"left" integer:carousel.leftX unit:IUUnitPixel];
        [code insertTag:@"top" integer:carousel.leftY unit:IUUnitPixel];
    
    NSString *imgSrc = [[self imagePathWithImageName:imageName target:IUTargetEditor] CSSURLString];
    [code insertTag:@"background" string:imgSrc target:IUTargetEditor];
    
    NSString *outputImgSrc = [[self imagePathWithImageName:imageName target:IUTargetOutput] CSSURLString];
    [code insertTag:@"background" string:outputImgSrc target:IUTargetOutput];
    

    NSImage *arrowImage;
    
    if ([imageName isHTTPURL]) {
        arrowImage = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:imageName]];
    }
    else{
        IUResourceFile *file = [_resourceManager resourceFileWithName:imageName];
        NSString *imageAbsolutePath = [file absolutePath];
        arrowImage = [[NSImage alloc] initWithContentsOfFile:imageAbsolutePath];
        
    }
    
    [code insertTag:@"height" floatFromNumber:@(arrowImage.size.height) unit:IUCSSUnitPixel];
    [code insertTag:@"width" floatFromNumber:@(arrowImage.size.width) unit:IUCSSUnitPixel];
    
    [code setInsertingIdentifier:carousel.nextID];
    
    
    imageName = carousel.rightArrowImage;
    [code insertTag:@"right" integer:carousel.rightX unit:IUUnitPixel];
    [code insertTag:@"top" integer:carousel.rightY unit:IUUnitPixel];
    
    imgSrc = [[self imagePathWithImageName:imageName target:IUTargetEditor] CSSURLString];
    [code insertTag:@"background" string:imgSrc target:IUTargetEditor];
    
    outputImgSrc = [[self imagePathWithImageName:imageName target:IUTargetOutput] CSSURLString];
    [code insertTag:@"background" string:outputImgSrc target:IUTargetOutput];
    
    
    if ([imageName isHTTPURL]) {
        arrowImage = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:imageName]];
    }
    else{
        IUResourceFile *file = [_resourceManager resourceFileWithName:imageName];
        NSString *imageAbsolutePath = [file absolutePath];
        arrowImage = [[NSImage alloc] initWithContentsOfFile:imageAbsolutePath];
        
    }
    
    [code insertTag:@"height" floatFromNumber:@(arrowImage.size.height) unit:IUCSSUnitPixel];
    [code insertTag:@"width" floatFromNumber:@(arrowImage.size.width) unit:IUCSSUnitPixel];
    
}

@end
