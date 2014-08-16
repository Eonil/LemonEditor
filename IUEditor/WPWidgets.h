//
//  WPWidgets.h
//  IUEditor
//
//  Created by jd on 8/14/14.
//  Copyright (c) 2014 JDLab. All rights reserved.
//

#import "IUBox.h"
#import "IUProtocols.h"

@interface WPWidgets : IUBox <IUCodeProtocol, IUSampleHTMLProtocol>

@property (nonatomic) NSString *wordpressName;

@end
