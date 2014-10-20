//
//  LMCanvasView.m
//  IUEditor
//
//  Created by ChoiSeungmi on 2014. 4. 2..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "LMCanvasView.h"
#import "LMCanvasVC.h"

@implementation LMCanvasView{
    BOOL isSelected, isDragged, isSelectDragged, isMouseDown;
    NSPoint startDragPoint, middleDragPoint, endDragPoint;
    NSUInteger keyModifierFlags;
}


- (void)awakeFromNib{
    
    self.mainView = [[NSFlippedView alloc] init];
    self.webView = [[WebCanvasView alloc] init];
    self.gridView = [[GridView alloc] init];
    
    self.webView.VC = self.delegate;
    self.gridView.delegate= self.delegate;
    self.sizeView.delegate = self.delegate;
    
    [self.mainScrollView setDocumentView:self.mainView];
    [self.mainView addSubviewFullFrame:self.webView];
    [self.mainView addSubviewFullFrame:self.gridView];
    
    [self.mainView setFrameOrigin:NSZeroPoint];
    [self.mainView setFrameSize:NSMakeSize(defaultFrameWidth, self.mainScrollView.frame.size.height)];
    
    [self.mainView addObserver:self forKeyPath:@"frame" options:0 context:nil];
    
    [[self.mainScrollView contentView] setPostsBoundsChangedNotifications:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boundsDidChange:) name:NSViewBoundsDidChangeNotification object:[self.mainScrollView contentView]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMQSelect:) name:IUNotificationMQSelected object:[self sizeView]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMQMaxSize:) name:IUNotificationMQMaxChanged object:[self sizeView]];


}

-(void)prepareDealloc{
    self.webView.VC = nil;
    self.gridView.delegate= nil;
    self.sizeView.delegate = nil;
    self.delegate = nil;
}

-(void) dealloc{
    [self.mainView removeObserver:self forKeyPath:@"frame"];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSViewBoundsDidChangeNotification object:[self.mainScrollView contentView]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IUNotificationMQSelected object:[self sizeView]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IUNotificationMQMaxChanged object:[self sizeView]];

    
}
- (BOOL)isFlipped{
    return YES;
}

-(void)boundsDidChange:(NSNotification *)notification{
    NSRect contentBounds = [self.mainScrollView contentView].bounds;
    [self.sizeView moveSizeView:contentBounds.origin withWidth:contentBounds.size.width];
}
#pragma mark -
#pragma mark sizeView

- (void)changeMQSelect:(NSNotification *)notification{
    
    NSInteger selectedSize = [[notification.userInfo valueForKey:IUNotificationMQSize] integerValue];
    NSInteger maxSize = [[notification.userInfo valueForKey:IUNotificationMQMaxSize] integerValue];

    if([[self.mainView subviews] containsObject:self.webView]){
        [self.mainView subview:self.webView changeConstraintTrailing:(maxSize -selectedSize)];
    }
    
    [self.delegate reloadSheet];
    
    [[self webView] updateFrameDict];
}

- (void)changeMQMaxSize:(NSNotification *)notification{
    NSInteger selectedSize = [[notification.userInfo valueForKey:IUNotificationMQSize] integerValue];
    NSInteger maxSize = [[notification.userInfo valueForKey:IUNotificationMQMaxSize] integerValue];
    //extend to scroll size
    [self.mainView setWidth:maxSize];
    if([[self.mainView subviews] containsObject:self.webView]){
        [self.mainView subview:self.webView changeConstraintTrailing:(maxSize -selectedSize)];
    }
    
    [[self webView] updateFrameDict];
    
}

- (void)setHeightOfMainView:(CGFloat)height{
    if (abs(height -self.mainView.frame.size.height) < 1) {
        return;
    }
    if(height > 50000){
        height = 50000;
    }
    [self.mainView setHeight:height];
    [self.webView resizePageContent];
    [[self webView] updateFrameDict];
}
- (void)extendMainViewToFullSize{
    [self setHeightOfMainView:[[self mainScrollView] frame].size.height];
}

#pragma mark -
#pragma mark mouseEvent


- (BOOL)isDifferentIU:(NSString *)IUID{

    if(IUID != nil){
        if( [((LMCanvasVC *)self.delegate) containsIU:IUID] == NO ){
            return YES;
        }
    }
    return NO;
}

- (BOOL)canRemoveIU:(NSEvent *)theEvent IUID:(NSString *)IUID{
    
    if( ( [theEvent modifierFlags] & NSCommandKeyMask )){
        return NO;
    }
    
    if( [((LMCanvasVC *)self.delegate) containsIU:IUID] == YES &&
        [((LMCanvasVC *)self.delegate) countOfSelectedIUs] == 1){
        return NO;
    }
    return YES;
}

//exclude top-botoom view
-  (BOOL)pointInScrollView:(NSPoint)point{
    NSRect frame = NSMakeRect(0, 0, self.bounds.size.width, self.mainScrollView.bounds.size.height);
    if (NSPointInRect(point, frame)){
        return YES;
    }
    return NO;
}

//include bottom view(including scroll heihgt)
-  (BOOL)pointInMainView:(NSPoint)point{
    NSRect frame = NSMakeRect(0, 0, self.bounds.size.width, self.mainView.bounds.size.height);
    if (NSPointInRect(point, frame)){
        return YES;
    }
    return NO;
}

#pragma mark event

//no를 리턴하면 sendevent 슈퍼를 호출하지 않음.
-(BOOL)receiveKeyEvent:(NSEvent *)theEvent{
    NSResponder *currentResponder = [[self window] firstResponder];
    NSView *mainView = self.mainView;
    
    if([currentResponder isKindOfClass:[NSView class]]
       && [mainView hasSubview:(NSView *)currentResponder]){
        
        if(theEvent.type == NSKeyDown){
            unichar key = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
            
            
            if([[self webView] isEditable]== NO){
                //delete key
                if(key == NSDeleteCharacter){
                    [((LMCanvasVC *)self.delegate) removeSelectedIUs];
                    return YES;
                }
            }
            else{
                //editor mode 이고 delete key가 들어오면
                //한글의composition state 중이면서 캐릭터가 내부에 저장되지 않았으면 delete key 무효화
                if(key == NSDeleteCharacter){
                    if([[self webView] removeLastCharacter] == YES){
                        return NO;
                    }
                }
            }
        }
    }
    return YES;
}


-(void)receiveMouseEvent:(NSEvent *)theEvent{
    NSPoint originalPoint = [theEvent locationInWindow];
    NSPoint convertedPoint = [self.mainView convertPoint:originalPoint fromView:nil];
    NSPoint convertedScrollPoint = [self.mainScrollView convertPoint:originalPoint fromView:nil];
    NSView *hitView = [self.gridView hitTest:convertedPoint];
    
    if([hitView isKindOfClass:[GridView class]] == NO){
        if( [self pointInScrollView:convertedScrollPoint]){
            if ( theEvent.type == NSLeftMouseDown){
                JDTraceLog( @"mouse down");
                isMouseDown = YES;
                NSString *currentIUID = [self.webView IUAtPoint:convertedPoint];
                
                //webview에서 발견 못하면 gridView에서 한번더 체크
                //media query 에서 보이지 않는 iu를 위해서 체크함.
                if(currentIUID == nil){
                    currentIUID = [self.gridView IUAtPoint:convertedPoint];
                }
                
                if (theEvent.clickCount == 1){
                    if( [theEvent modifierFlags] & NSCommandKeyMask ){
                        //여러개 select 하는 순간 editing mode out
                        //[[self webView] setEditable:NO];
                        
                        //이미 select되어 있으면 deselect
                        if( [((LMCanvasVC *)self.delegate) containsIU:currentIUID] ){
                            [((LMCanvasVC *)self.delegate) removeSelectedIU:currentIUID];
                        }
                        else{
                            [((LMCanvasVC *)self.delegate) addSelectedIU:currentIUID];
                        }
                    }
                    else{
                        //다른 iu를 선택하는 순간 editing mode out
                        /*
                        if([self isDifferentIU:currentIUID]){
                            [[self webView] setEditable:NO];
                            
                        }
                         */
                        
                        if([((LMCanvasVC *)self.delegate) containsIU:currentIUID] == NO || [(LMCanvasVC *)self.delegate countOfSelectedIUs] == 1){
                            [((LMCanvasVC *)self.delegate) setSelectedIU:currentIUID];
                        }
                    }
                    
                    if(currentIUID){
                        isSelected = YES;
                    }
                    [((LMCanvasVC *)(self.delegate)) startFrameMoveWithUndoManager:self];
                    startDragPoint = convertedPoint;
                    middleDragPoint = startDragPoint;
                }
                //change editable mode
                if(theEvent.clickCount ==2){
                    [[NSNotificationCenter defaultCenter] postNotificationName:IUNotificationDoubleClickCanvas object:self.window];
#if CURRENT_TEXT_VERSION >= TEXT_SELECTION_VERSION
                    if([((LMCanvasVC *)self.delegate) isEditable]){
                        [[self webView] setEditable:YES];
                        [[self webView] changeDOMRange:convertedPoint];
                    }
                    else {
                        NSString *alertText= [currentIUID stringByAppendingString:@" is not text-editable\nPlease use IUText box"];
                        [JDUIUtil hudAlert:alertText second:5];
                    }
#endif
                }
            }
            else if (theEvent.type == NSRightMouseDown){
                /* currently, right mouse button down is disable
                NSString *currentIUID = [self.webView IUAtPoint:convertedPoint];
                [((LMCanvasVC *)self.delegate) performRightClick:currentIUID withEvent:theEvent];
                 */
            }
        }
        if (theEvent.type == NSLeftMouseDragged && isMouseDown){
            JDTraceLog( @"mouse dragged");
            endDragPoint = convertedPoint;
            
            if([theEvent modifierFlags] & NSCommandKeyMask ){
                [self selectWithDrawRect];
            }
            if(isSelected){
                [self moveIUByDragging:theEvent];
            }
            
            middleDragPoint = endDragPoint;
        }
        else if ( theEvent.type == NSLeftMouseUp ){
            JDTraceLog( @"NSLeftMouseUp");
            isMouseDown = NO;
            [self clearMouseMovement];
            
        }
    }
    else {
        JDTraceLog( @"gridview select");
    }

    
    if(isSelectDragged){
        [[NSCursor crosshairCursor] push];
    }
}


#pragma mark -
#pragma mark handle mouse event

- (void)startDraggingFromGridView{
    //turn off canvas view dragging.
    isMouseDown = NO;
    isSelected = NO;
}

- (void)moveIUByDragging:(NSEvent *)theEvent{
    isDragged = YES;
    NSPoint totalPoint = NSMakePoint(endDragPoint.x-startDragPoint.x, endDragPoint.y-startDragPoint.y);
    NSPoint diffPoint = NSMakePoint(endDragPoint.x - middleDragPoint.x, endDragPoint.y - middleDragPoint.y);
    
    if([theEvent modifierFlags] & NSShiftKeyMask){
        if(abs(diffPoint.x) > abs(diffPoint.y)){
            [((LMCanvasVC *)self.delegate) moveIUToDiffPoint:NSMakePoint(diffPoint.x, 0) totalDiffPoint:NSMakePoint(totalPoint.x, 0)];
        }
        else{
            [((LMCanvasVC *)self.delegate) moveIUToDiffPoint:NSMakePoint(0, diffPoint.y) totalDiffPoint:NSMakePoint(0, totalPoint.y)];
        }
    }
    else{
        [((LMCanvasVC *)self.delegate) moveIUToDiffPoint:diffPoint totalDiffPoint:totalPoint];
    }
    
}

- (void)selectWithDrawRect{
    isSelectDragged = YES;
    isSelected = NO;
    
    NSSize size = NSMakeSize(endDragPoint.x-startDragPoint.x, endDragPoint.y-startDragPoint.y);
    NSRect selectFrame = NSMakeRect(startDragPoint.x, startDragPoint.y, size.width, size.height);
    
    [self.gridView drawSelectionLayer:selectFrame];
    [((LMCanvasVC *)self.delegate) selectIUInRect:selectFrame];
}

- (void)clearMouseMovement{
    [self.gridView clearGuideLine];
    
    if(isSelected){
        isSelected = NO;
    }
    if(isDragged){
        isDragged = NO;
        [((LMCanvasVC *)(self.delegate)) endFrameMoveWithUndoManager:self];
    }
    if(isSelectDragged){
        isSelectDragged = NO;
        [NSCursor pop];
        [self.gridView resetSelectionLayer];
    }

}




@end
