//
//  WPArticleBody.h
//  IUEditor
//
//  Created by jd on 2014. 8. 7..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUBox.h"
#import "IUProtocols.h"

@interface WPArticleBody : IUBox <IUCodeProtocol, IUSampleHTMLProtocol>

@property (nonatomic) NSString *sampleText;

@end
