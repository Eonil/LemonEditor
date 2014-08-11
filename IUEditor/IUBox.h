//
//  IUBox.h
//  IUEditor
//
//  Created by JD on 3/18/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUCSS.h"
#import "IUEvent.h"
#import "IUIdentifierManager.h"


@protocol IUSourceDelegate <NSObject>
@required

-(void)IUClassIdentifier:(NSString *)identifier CSSUpdated:(NSString*)css viewport:(NSInteger)width;
-(void)IUClassIdentifier:(NSString *)identifier CSSRemovedforWidth:(NSInteger)width;
-(void)removeAllCSSWithIdentifier:(NSString *)identifier;

-(void)IUHTMLIdentifier:(NSString*)identifier textHTML:(NSString *)html withParentID:(NSString *)parentID nearestID:(NSString *)nID index:(NSUInteger)index;
-(void)IUHTMLIdentifier:(NSString *)identifier HTML:(NSString *)html withParentID:(NSString *)parentID;

-(void)IUClassIdentifier:(NSString *)classIdentifier addClass:(NSString *)className;
-(void)IUClassIdentifier:(NSString *)classIdentifier removeClass:(NSString *)className;
-(void)updateTextRangeFromID:(NSString *)fromID toID:(NSString *)toID;

-(void)IURemoved:(NSString*)identifier withParentID:(NSString *)parentID;

- (NSPoint)distanceFromIU:(NSString *)iuName to:(NSString *)parentName;
- (NSSize)frameSize:(NSString *)identifier;
- (void)changeIUPageHeight:(CGFloat)pageHeight;

- (void)runCSSJS;
/**
 @brief call javascript function
 @param args javascirpt function argument, argument에 들어가는 것중에 dict, array는 string으로 보내서javascript내부에서 새로 var를 만들어서 사용
*/
- (id)callWebScriptMethod:(NSString *)function withArguments:(NSArray *)args;
- (id)evaluateWebScript:(NSString *)script;


@end

typedef enum _IUPositionType{
    IUPositionTypeAbsolute,
    IUPositionTypeAbsoluteCenter,
    IUPositionTypeRelative,
    IUPositionTypeRelativeCenter,
    IUPositionTypeFloatLeft,
    IUPositionTypeFloatRight,
    IUPositionTypeFixed,
}IUPositionType;

typedef enum{
    IUTextTypeDefault,
    IUTextTypeH1,
    IUTextTypeH2,
}IUTextType;

typedef enum _IUOverflowType{
    IUOverflowTypeHidden,
    IUOverflowTypeVisible,
    IUOverflowTypeScroll,
}IUOverflowType;


@class IUBox;
@class IUSheet;
@class IUProject;

@interface IUBox : NSObject <NSCoding, IUCSSDelegate, NSCopying>{
    NSMutableArray *_m_children;
    
    int IUEditorVersion;
}

/*
 Following are options
 */

#define IUFileName @"FileName"
/**
 initialize IU with project
 @param project project that will initizlie IU. Should not nil.
 @param options NSDictionary of options. \n
 IUFileName : define filename
 */
-(id)initWithProject:(IUProject*)project options:(NSDictionary*)options;
- (void)connectWithEditor;

- (BOOL)isConnectedWithEditor;
- (void)setIsConnectedWithEditor;

-(IUSheet *)sheet;


/**
 @brief return project of box
 @note if iu is not confirmed, return project argument at initialize process
 */
-(IUProject *)project;

#pragma mark - IU Setting

@property (copy, nonatomic) NSString *name;
@property (copy) NSString *htmlID;
- (void)confirmIdentifier;

@property (nonatomic, weak) id<IUSourceDelegate> delegate;
@property (weak) IUBox    *parent;

#if CURRENT_TEXT_VERSION < TEXT_SELECTION_VERSION
@property (nonatomic) NSString *text;
@property (nonatomic) BOOL lineHeightAuto;

#endif
//undoManager
- (NSUndoManager *)undoManager;


//Event
@property (readonly) IUEvent *event;
//scroll event
@property (nonatomic) float opacityMove;
@property (nonatomic) float xPosMove;

//Programming
@property (nonatomic) NSString *pgVisibleConditionVariable;
@property (nonatomic) NSString *pgContentVariable;


//CSS
@property (readonly) IUCSS *css; //used by subclass
- (NSArray *)cssIdentifierArray;
- (void)updateCSS;
- (void)updateCSSWithIdentifier:(NSString *)identifier;

//HTML
-(NSString*)html;
- (void)updateHTML;

//JS
- (void)updateJS;


//children
@property (readonly) NSMutableArray *referenceChildren;
- (NSArray*)children;
- (NSMutableArray*)allChildren;
- (NSMutableArray *)allIdentifierChildren;


-(BOOL)shouldAddIUByUserInput;

-(BOOL)insertIU:(IUBox *)iu atIndex:(NSInteger)index  error:(NSError**)error;
-(BOOL)addIU:(IUBox *)iu error:(NSError**)error;

/**
 removeIUAtIndex:
 @note removeIUAtIndex: uses removeIU: as implementation.
        unregister identifier automatically.
 */
-(BOOL)removeIUAtIndex:(NSUInteger)index;

/**
 removeIU:
 @note unregister identifier automatically.
 */
-(BOOL)removeIU:(IUBox *)iu;
-(BOOL)removeAllIU;

-(BOOL)shouldRemoveIUByUserInput;
-(BOOL)changeIUIndex:(IUBox*)iu to:(NSUInteger)index error:(NSError**)error;
-(BOOL)addIUReference:(IUBox *)iu error:(NSError**)error;


//Frame
//user interface status
@property (readonly) BOOL canChangeXByUserInput;
@property (readonly) BOOL canChangeYByUserInput;
@property (readonly) BOOL canChangeWidthByUserInput;
@property (readonly) BOOL canChangeHeightByUserInput;

- (BOOL)hasX;
- (BOOL)hasY;
- (BOOL)hasWidth;
- (BOOL)hasHeight;
- (BOOL)shouldCompileFontInfo;

- (void)setPixelFrame:(NSRect)frame;
- (void)setPercentFrame:(NSRect)frame;
- (void)setPosition:(NSPoint)position;
- (void)startDragSession;
- (void)endDragSession;
- (void)movePosition:(NSPoint)point withParentSize:(NSSize)parentSize;
- (void)increaseSize:(NSSize)size withParentSize:(NSSize)parentSize;
- (NSSize)currentApproximatePixelSize;


//Position
@property (nonatomic) IUPositionType positionType;
- (BOOL)canChangePositionType;
- (BOOL)canChangePositionAbsolute;
- (BOOL)canChangePositionRelative;
- (BOOL)canChangePositionFloatLeft;
- (BOOL)canChangePositionFloatRight;
- (BOOL)canChangePositionAbsoluteCenter;
- (BOOL)canChangePositionRelativeCenter;



//Property

- (BOOL)canCopy;


- (BOOL)canChangeOverflow;
@property (nonatomic) IUOverflowType overflowType;


- (void)setImageName:(NSString *)imageName;
- (NSString *)imageName;

@property (nonatomic) id link, divLink;
@property BOOL linkTarget;


//0 for default, 1 for H1, 2 for H2
@property IUTextType textType;

- (NSString*)cssClass;
- (NSString*)cssHoverClass;
- (NSString*)cssActiveClass;

@end