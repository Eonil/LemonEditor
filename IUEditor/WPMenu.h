//
//  WPMenu.h
//  IUEditor
//
//  Created by jd on 2014. 7. 16..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUBox.h"
#import "IUProtocols.h"

@interface WPMenu : IUBox <IUCodeProtocol, IUSampleHTMLProtocol>
@property NSInteger itemCount;
@property BOOL fullWidthMenu;
@property NSInteger leftRightPadding;
@property IUAlign align;
@end
