//
//  TableSectionInfo.m
//  User
//
//  Created by Phan Minh Nhut on 4/30/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "TableSectionInfo.h"

#define RATIO_AVATAR (self.frame.size.height / self.frame.size.width)
#define RATIO_LABEL (1.0 - RATIO_AVATAR)

#define RATIO_LABEL_NAME 0.7
#define RATION_LABEL_NUMBER_PHONE (1 - RATIO_LABEL_NAME)

#define DELTA_WIDTH 10 * RATIOX

#define TAG_AVATAR_IMAGE_VIEW 100

@implementation TableSectionInfo

-(UILabel*) createLabelWithName:(NSString*)name phone:(NSString*)phone{
    
    if ([name isKindOfClass:[NSNull class]]){
        name = @"";
    }
    
    CGRect frame = CGRectMake(avatar.frame.size.width + DELTA_WIDTH, 0, self.frame.size.width * RATIO_LABEL - DELTA_WIDTH, self.frame.size.height);
    UILabel *lbl = [[UILabel alloc] initWithFrame:frame];
    [lbl setNumberOfLines:2];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[UIColor blackColor]];
    [shadow setShadowOffset:CGSizeMake(0, 1)];
    
    NSDictionary *attrName = @{NSForegroundColorAttributeName: BACKGROUND_COLOR_BLUE,
                                 NSFontAttributeName: [UIFont fontWithName:LABEL_FONT size:17*RATIO_TEXT],
                                 NSShadowAttributeName:shadow};
    NSDictionary *attrPhone = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                               NSFontAttributeName: [UIFont fontWithName:LABEL_FONT size:13*RATIO_TEXT],
                               NSShadowAttributeName:shadow};
    NSString *info = [NSString stringWithFormat:@"%@\n%@", name, phone];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:info];
    [str addAttributes:attrName range:NSMakeRange(0,name.length)];
    [str addAttributes:attrPhone range:NSMakeRange(name.length+1, phone.length)];
    
    
    [lbl setAttributedText:str];
    [self addSubview:lbl];
    return lbl;
}

-(void)updateAvartar:(UIImage *)img{
    [imgView setImage:img];
}

-(UIView*) createAvatar{
    CGRect frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    UIView *containerView = [[UIView alloc] initWithFrame:frame];
    [containerView.layer setCornerRadius:frame.size.height / 2.0];
    [containerView setBackgroundColor:BACKGROUND_COLOR_BLUE];
    
    float size = containerView.frame.size.width - 2*RATIOY;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(RATIOY, RATIOY, size, size)];
    view.clipsToBounds = YES;
    [view.layer setCornerRadius:view.frame.size.height / 2.0];
    [view setBackgroundColor:BACKGROUND_COLOR_WHITE];
    [containerView addSubview:view];
    
    [self addSubview:containerView];
    return view;
}

-(id)initWithFrame:(CGRect)frame username:(NSString *)name numberPhone:(NSString *)phone{
    
    if (self = [super initWithFrame:frame]){
        
        // Avatar
        avatar = [self createAvatar];
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, avatar.frame.size.width, avatar.frame.size.height)];
        [avatar addSubview:imgView];
        
        // Name
        label = [self createLabelWithName:name phone:phone];
    }
    
    return self;
}

@end
