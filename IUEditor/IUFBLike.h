//
//  IUFBLike.h
//  IUEditor
//
//  Created by ChoiSeungme on 2014. 4. 23..
//  Copyright (c) 2014년 JDLab. All rights reserved.
//

#import "IUHTML.h"

typedef enum{
 IUFBLikeColorLight,
 IUFBLikeColorDark,
}IUFBLikeColor;

@interface IUFBLike : IUHTML

@property (nonatomic) NSString *likePage;
@property (nonatomic) BOOL showFriendsFace;
@property (nonatomic) IUFBLikeColor colorscheme;

@end
