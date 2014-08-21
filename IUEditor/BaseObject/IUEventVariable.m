//
//  IUEventVariable.m
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 25..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUEventVariable.h"
#import "IUSheet.h"

@interface IUEventVariable()

@property NSMutableDictionary* variablesDict;

@end

@implementation IUEventVariable

- (id)init{
    self = [super init];
    if(self){
        _variablesDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BOOL)hasVariableDict:(NSString *)variable{
    if([_variablesDict objectForKey:variable]==nil){
        return NO;
    }
    return YES;
}

- (NSMutableDictionary *)eventCollectionDictOfVariable:(NSString *)variable{
    NSMutableDictionary *oneDict;
    
    if([self hasVariableDict:variable]){
        oneDict = [_variablesDict objectForKey:variable];
    }
    else{
        oneDict = [NSMutableDictionary dictionary];
        NSMutableArray *array = [NSMutableArray array];
        [oneDict setObject:array forKey:IUEventTagReceiverArray];
        [_variablesDict setObject:oneDict forKey:variable];
    }
    return oneDict;
}

- (NSMutableArray *)receiverArrayOfVariable:(NSString *)variable{
    NSMutableDictionary *dict = [self eventCollectionDictOfVariable:variable];
    return [dict objectForKey:IUEventTagReceiverArray];
}

- (void)makeEventDictionary:(IUSheet *)sheet{
    for (IUBox *obj in sheet.allChildren) {
        NSString *variable =  obj.event.variable;
        if(variable){
            NSMutableDictionary *oneDict = [self eventCollectionDictOfVariable:variable];
            [oneDict setObject:variable forKey:IUEventTagVariable];
            if([oneDict objectForKey:IUEventTagIUID]){
                NSMutableArray *ids = [[oneDict objectForKey:IUEventTagIUID] mutableCopy];
                if([ids containsString:obj.htmlID] == NO){
                    [ids addObject:obj.htmlID];
                    [oneDict setObject:ids forKey:IUEventTagIUID];
                }
            }
            else{
                [oneDict setObject:@[obj.htmlID] forKey:IUEventTagIUID];
            }
            [oneDict setObject:@(obj.event.initialValue) forKey:IUEventTagInitialValue];
            [oneDict setObject:@(obj.event.maxValue) forKey:IUEventTagMaxValue];
            [oneDict setObject:@(obj.event.actionType) forKey:IUEventTagActionType];
        }
        NSString *visibleVariable = obj.event.eqVisibleVariable;
        if(visibleVariable){
            NSMutableDictionary *visibleDict = [NSMutableDictionary dictionary];
            [visibleDict setObject:obj.htmlID forKey:IUEventTagVisibleID];
            [visibleDict setObject:obj.event.eqVisible forKey:IUEventTagVisibleEquation];
            [visibleDict setObject:@(obj.event.eqVisibleDuration) forKey:IUEventTagVisibleDuration];
            [visibleDict setObject:@(obj.event.directionType) forKey:IUEventTagVisibleType];
            
            NSMutableArray *receiverArray = [self receiverArrayOfVariable:visibleVariable];
            [receiverArray addObject:visibleDict];
        }
        
        NSString *frameVariable = obj.event.eqFrameVariable;
        if(frameVariable){
            NSMutableDictionary *frameDict = [NSMutableDictionary dictionary];
            [frameDict setObject:obj.htmlID forKey:IUEventTagFrameID];
            [frameDict setObject:obj.event.eqFrame forKey:IUEventTagFrameEquation];
            [frameDict setObject:@(obj.event.eqFrameDuration) forKey:IUEventTagFrameDuration];
            [frameDict setObject:@(obj.event.eqFrameWidth) forKey:IUEventTagFrameWidth];
            [frameDict setObject:@(obj.event.eqFrameHeight) forKey:IUEventTagFrameHeight];
            
            NSMutableArray *receiverArray = [self receiverArrayOfVariable:frameVariable];
            [receiverArray addObject:frameDict];
            
        }
    }
}


- (NSString *)outputEventJSSource{
    NSArray *variableArray = _variablesDict.allKeys;
    
    JDCode *header = [JDCode code];
    JDCode *bodyHeader = [JDCode code];
    JDCode *body = [JDCode code];
    JDCode *visibleFnCode = [JDCode code];
    JDCode *frameFnCode = [JDCode code];
    JDCode *initializeFn = [JDCode code];
    
    for(NSString *variable in variableArray){
        NSDictionary *oneDict = [_variablesDict objectForKey:variable];
        if(oneDict){
            [header addCodeLineWithFormat:@"var %@=0;", variable];
            
            id value;
#pragma mark initialize variable
            value = [oneDict objectForKey:IUEventTagInitialValue];
            if(value){
                NSInteger initial = [value integerValue];
                [header addCodeLineWithFormat:@"var INIT_IU_%@=%ld;", variable, initial];
                [bodyHeader addCodeLineWithFormat:@"%@ = INIT_IU_%@;", variable, variable];
            }
            
            value = [oneDict objectForKey:IUEventTagMaxValue];
            if(value){
                NSInteger max = [value integerValue];
                [header addCodeLineWithFormat:@"var MAX_IU_%@=%ld;", variable, max];
                
            }
            
#pragma mark make body;
            
            value = [oneDict objectForKey:IUEventTagIUID];
            if(value){
                IUEventActionType type = [[oneDict objectForKey:IUEventTagActionType] intValue];
                
#pragma mark make event innerJS
                NSArray *receiverArray = [oneDict objectForKey:IUEventTagReceiverArray];
                JDCode *innerfunctionCode = [JDCode code];

                for(NSDictionary *receiverDict in receiverArray){
#pragma mark Visible Src
                    value = [receiverDict objectForKey:IUEventTagVisibleEquation];
                    if(value){
                        NSString *visibleID = [receiverDict objectForKey:IUEventTagVisibleID];

                        NSString *fnName;
                        if(type == IUEventActionTypeClick){
                            fnName =  [NSString stringWithFormat:@"%@ClickVisible%@Fn", variable, visibleID];
                        }
                        else if(type == IUEventActionTypeHover){
                            fnName =  [NSString stringWithFormat:@"%@HoverVisible%@Fn", variable, visibleID];
                        }
                        [innerfunctionCode addCodeLineWithFormat:@"%@();", fnName];

                        JDCode *fnCode = [JDCode code];
                        NSInteger duration = [[receiverDict objectForKey:IUEventTagVisibleDuration] integerValue];
                        IUEventVisibleType type = [[receiverDict objectForKey:IUEventTagVisibleType] intValue];
                        NSString *typeStr = [self visibleType:type];
                        
                        [fnCode addCodeLineWithFormat:@"if( %@ ){", value];
                        
                        JDCode *innerJS = [JDCode code];
                        [innerJS addCodeWithFormat:@"$(\"#%@\").show(", visibleID];
                        NSString *reframe = [NSString stringWithFormat:@"function(){reframeCenterIU('#%@' ,false)}", visibleID];

                        if(duration > 0){
                            [innerJS addCodeLineWithFormat:@"\"%@\", %ld, %@);", typeStr, duration*100, reframe];
                        }
                        else{
                            [innerJS addCodeLineWithFormat:@"\"%@\", 1, %@);", typeStr, reframe];
                        }
                        [innerJS addCodeLineWithFormat:@"$(\"#%@\").data(\"run%@\", 1);", visibleID, fnName];
                        
                        [fnCode addCodeWithIncreaseIndent:innerJS];
                        [fnCode addCodeLine:@"}"];
                        
                        [fnCode addCodeLine:@"else{"];
                        innerJS = [JDCode code];
                        [innerJS addCodeLineWithFormat:@"var clicked =$(\"#%@\").data(\"run%@\");", visibleID,fnName];
                        [innerJS addCodeLineWithFormat:@"if(clicked == undefined){"];
                        [innerJS addCodeLineWithFormat:@"\t$(\"#%@\").hide();", visibleID];
                        [innerJS addCodeLine:@"}"];
                        [innerJS addCodeLine:@"else{"];
                        if(duration > 0){
                            [innerJS addCodeLineWithFormat:@"\t$(\"#%@\").hide(\"%@\",%ld);", visibleID, typeStr, duration*100];
                        }
                        else{
                            [innerJS addCodeLineWithFormat:@"\t$(\"#%@\").hide(\"%@\", 1);", visibleID, typeStr];
                        }
                        [innerJS addString:@"}"];
                        [fnCode addCodeWithIncreaseIndent:innerJS];

                        [fnCode addCodeLine:@"}"];
                        
                        [visibleFnCode addCodeLineWithFormat:@"function %@(){", fnName ];
                        [visibleFnCode addCodeWithIncreaseIndent:fnCode];
                        [visibleFnCode addString:@"}"];

                        
                        
                    }
#pragma mark Frame Src
                    value = [receiverDict objectForKey:IUEventTagFrameEquation];
                    if(value){
                        
                        NSString *frameID = [receiverDict objectForKey:IUEventTagFrameID];
                        
                        NSString *fnName;
                        if(type == IUEventActionTypeClick){
                            fnName =  [NSString stringWithFormat:@"%@ClickVisible%@Fn", variable, frameID];
                        }
                        else if(type == IUEventActionTypeHover){
                            fnName =  [NSString stringWithFormat:@"%@HoverVisible%@Fn", variable, frameID];
                        }
                        
                        [innerfunctionCode addCodeLineWithFormat:@"%@();", fnName];

                        JDCode *fnCode = [JDCode code];
                        [fnCode addCodeLineWithFormat:@"if( %@ ){", value];
                        
                        JDCode *innerJS = [JDCode code];
                        
                        [innerJS addCodeLineWithFormat:@"$(\"#%@\").data(\"run%@\", 1);", frameID, fnName];
                        [innerJS addCodeLineWithFormat:@"$(\"#%@\").data(\"width\", $(\"#%@\").css('width'));", frameID, frameID];
                        [innerJS addCodeLineWithFormat:@"$(\"#%@\").data(\"height\", $(\"#%@\").css('height'));", frameID, frameID];
                        [innerJS addCodeWithFormat:@"$(\"#%@\").animate({", frameID];
                        
                        CGFloat width = [[receiverDict objectForKey:IUEventTagFrameWidth] floatValue];
                        CGFloat height = [[receiverDict objectForKey:IUEventTagFrameHeight] floatValue];
                        [innerJS addCodeWithFormat:@"width:\"%.2fpx\", height:\"%.2fpx\"}", width, height];
                        
                        NSInteger duration = [[receiverDict objectForKey:IUEventTagFrameDuration] integerValue];
                        NSString *reframe = [NSString stringWithFormat:@"function(){reframeCenterIU('#%@' ,false)}", frameID];
                        if(duration > 0){
                            [innerJS addCodeWithFormat:@", %ld, %@);", duration*100, reframe];
                        }
                        else{
                            [innerJS addCodeWithFormat:@", 1, %@);", reframe];
                        }
                        
                        [fnCode addCodeWithIncreaseIndent:innerJS];
                        
                        [fnCode addCodeLine:@"}"];
                        [fnCode addCodeLine:@"else{"];
                        
                        innerJS = [JDCode code];
                        [innerJS addCodeLineWithFormat:@"var clicked =$(\"#%@\").data(\"run%@\");", frameID, fnName];
                        [innerJS addCodeLineWithFormat:@"var d_width =$(\"#%@\").data(\"width\");", frameID];
                        [innerJS addCodeLineWithFormat:@"var d_height =$(\"#%@\").data(\"height\");", frameID];
                        [innerJS addCodeWithFormat:@"if(clicked == undefined){"];
                        if(duration > 0){
                            [innerJS addCodeLineWithFormat:@"\t$(\"#%@\").animate({width:d_width, height:d_height}, %ld);", frameID, duration*100];
                        }
                        else{
                            [innerJS addCodeLineWithFormat:@"\t$(\"#%@\").animate({width:d_width, height:d_height}, 1 );", frameID];
                        }
                        [innerJS addCodeLine:@"}"];
                        [innerJS addCodeLine:@"else{"];
                        if(duration > 0){
                            [innerJS addCodeLineWithFormat:@"\t$(\"#%@\").animate({width:d_width, height:d_height}, %ld);", frameID, duration*100];
                        }
                        else{
                            [innerJS addCodeLineWithFormat:@"\t$(\"#%@\").animate({width:d_width, height:d_height} ,1);", frameID];
                        }
                        [innerJS addString:@"}"];
                        
                        
                        [fnCode addCodeWithIncreaseIndent:innerJS];
                        
                        [fnCode addCodeLine:@"}"];
                        
                        [frameFnCode addCodeLineWithFormat:@"function %@(){", fnName ];
                        [frameFnCode addCodeWithIncreaseIndent:fnCode];
                        [frameFnCode addCodeLineWithFormat:@"}"];
                    }
                }//End of receiverArray
                
                [initializeFn addCodeWithIncreaseIndent:innerfunctionCode];
                
                //initialize source
                JDCode *eventCode = [JDCode code];
                NSArray *bindingIUArray = [oneDict objectForKey:IUEventTagIUID];;
                for(NSString *bindingIUID in bindingIUArray){
                    
                    [eventCode addCodeLineWithFormat:@"/* [IU:%@] Event Declaration */", bindingIUID];
                    if(type == IUEventActionTypeClick){
                        [eventCode addCodeLineWithFormat:@"$(\"#%@\").css('cursor', 'pointer');", bindingIUID];
                    }
                    [eventCode addCodeWithFormat:@"$(\"#%@\").", bindingIUID];
                    
                    if(type == IUEventActionTypeClick){
                        [eventCode addString:@"click(function(){"];
                    }
                    else if(type == IUEventActionTypeHover){
                        [eventCode addString:@"hover(function(){"];
                    }
                    else{
                        JDFatalLog(@"no action type");
                    }
                    [eventCode increaseIndentLevelForEdit];
                    [eventCode addCodeLineWithFormat:@"%@++;",variable];
                    [eventCode addCodeLineWithFormat:@"if( %@ > MAX_IU_%@ ){ %@ = INIT_IU_%@ }",variable, variable, variable, variable];
                    [eventCode addCodeWithIncreaseIndent:innerfunctionCode];
                    [eventCode decreaseIndentLevelForEdit];
                    [eventCode addCodeLine:@"});"];

                }
                [body addCodeWithIncreaseIndent:eventCode];

            }
            
        }
        
    }
    
    JDTraceLog(@"header=====\n%@", header.string);
    JDTraceLog(@"body-header=====\n%@", bodyHeader.string);
    JDTraceLog(@"body======\n%@", body.string);
    
    JDCode *eventJSCode = [JDCode code];
    [eventJSCode addCodeWithIncreaseIndent:header];
    
    [eventJSCode addCodeLine:@" /* Decleare Visible Fn */ "];
    [eventJSCode addCodeWithIncreaseIndent:visibleFnCode];

    [eventJSCode addCodeLine:@" /* Decleare Frame Fn */ "];
    [eventJSCode addCodeWithIncreaseIndent:frameFnCode];
    
    [eventJSCode addCodeLine:@"$(document).ready(function(){"];
    [eventJSCode addCodeLine:@"console.log('ready : iuevent.js');"];
    [eventJSCode increaseIndentLevelForEdit];
    [eventJSCode addCodeWithIncreaseIndent:bodyHeader];
    [eventJSCode addCodeWithIncreaseIndent:body];
    [eventJSCode addCodeLine:@" /* initialize fn */ "];
    [eventJSCode addCodeWithIncreaseIndent:initializeFn];
    [eventJSCode decreaseIndentLevelForEdit];

    [eventJSCode addCodeLine:@"});"];
    
    JDTraceLog(@"total======\n%@", eventJSCode.string);
    
    return eventJSCode.string;
}

#pragma mark visible event 
- (NSString *)visibleType:(IUEventVisibleType)type{
    NSString *typeStr;
    switch (type) {
        case IUEventVisibleTypeBlind:
            typeStr = @"blind";
            break;
        case IUEventVisibleTypeBounce:
            typeStr = @"bounce";
            break;
        case IUEventVisibleTypeClip:
            typeStr = @"clip";
            break;
        case IUEventVisibleTypeDrop:
            typeStr = @"drop";
            break;
        case IUEventVisibleTypeExplode:
            typeStr = @"explode";
            break;
        case IUEventVisibleTypeFold:
            typeStr = @"fold";
            break;
        case IUEventVisibleTypeHide:
            typeStr = @"hide";
            break;
        case IUEventVisibleTypeHighlight:
            typeStr = @"highlight";
            break;
        case IUEventVisibleTypePuff:
            typeStr = @"puff";
            break;
        case IUEventVisibleTypePulsate:
            typeStr = @"pulsate";
            break;
        case IUEventVisibleTypeScale:
            typeStr = @"scale";
            break;
        case IUEventVisibleTypeShake:
            typeStr = @"shake";
            break;
        case IUEventVisibleTypeSize:
            typeStr = @"size";
            break;
        case IUEventVisibleTypeSlide:
            typeStr = @"slide";
            break;
        default:
            typeStr = nil;
            break;
    }
    
    return typeStr;
}

@end
