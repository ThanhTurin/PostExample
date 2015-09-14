//
//  TableRequestSection.m
//  Driver
//
//  Created by Phan Minh Nhựt on 6/10/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "TableRequestCell.h"

#define RATIO_LABEL 0.9
#define RATIO_BUTTON (1-RATIO_LABEL)

@implementation TableRequestCell
@synthesize ID;

-(UILabel*) createLabel{
    UILabel *lbl = [[UILabel alloc] init];
    [lbl setFont:[UIFont fontWithName:LABEL_FONT size:15 * RATIO_TEXT]];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setNumberOfLines:4];
    
    return lbl;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        float posX = 10 * RATIOX;
        float height = TABLE_REQUEST_HEIGHT_CELL / 7.0;
        float width = [HelperView getSizeScreen].width * RATIO_LABEL - 2*posX;
        
        lblPhone = [self createLabel];
        [lblPhone setFrame:CGRectMake(posX, height*0, width, height)];
        
        lblDate = [self createLabel];
        [lblDate setFrame:CGRectMake(posX, height*1, width, height)];
        
        lblSeats = [self createLabel];
        [lblSeats setFrame:CGRectMake(posX, height*2, width, height)];
        
        lblFromLocation = [self createLabel];
        [lblFromLocation setFrame:CGRectMake(posX, height*3, width, 2*height)];
        
        lblToLocation = [self createLabel];
        [lblToLocation setFrame:CGRectMake(posX, height*5, width, 2*height)];
        
        float radius = [HelperView getSizeScreen].width * RATIO_BUTTON;
        btnCall = [[UIButton alloc] initWithFrame:CGRectMake([HelperView getSizeScreen].width - posX - radius, (TABLE_REQUEST_HEIGHT_CELL - radius) / 2.0, radius, radius)];
        [btnCall setBackgroundImage:[HelperView resizeImage:[HelperView createImageWithName:@"img_btn_call" extension:@"png"] scaledToSize:CGSizeMake(radius, radius)] forState:UIControlStateNormal];
        [btnCall setBackgroundImage:[HelperView resizeImage:[HelperView createImageWithName:@"img_btn_select_call" extension:@"png"] scaledToSize:CGSizeMake(radius, radius)] forState:UIControlStateHighlighted];
        [btnCall addTarget:self action:@selector(actionCall) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:lblDate];
        [self addSubview:lblFromLocation];
        [self addSubview:lblPhone];
        [self addSubview:lblSeats];
        [self addSubview:lblToLocation];
        [self addSubview:btnCall];
        [self setBackgroundColor:BACKGROUND_COLOR_WHITE];
    }
    
    return self;
}

-(void)customAlertViewButtonClicked:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)indexButton{
    
    if ([alertView tag ] == 1){
        if (indexButton == 0){
            CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Nhắc nhở" message:@"Bạn thực sự muốn xóa yêu cầu này khỏi hệ thông?" delegate:self buttonTitles:@[@"Xác nhận",@"Bỏ qua"]];
            [alert setTag:2];
            [alert show];
        }
    }
    else if ([alertView tag] == 2){
        if (indexButton == 0){
            [[DatabaseHandler sharedDatabaseHandler] showWaitingView];
            [[DatabaseHandler sharedDatabaseHandler] deleteTable:DB_TABLE_BOOK_INFO primaryKey:DB_TABLE_BOOK_INFO_PRIMARYKEY keyValue:ID];
            [self.delegate needUpdateTable];
            [[DatabaseHandler sharedDatabaseHandler] hideWaitingView];
        }
    }
    [alertView close];
}

-(void) actionCall{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",self.numberPhone]]];
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Cập nhật" message:@"Nếu nhận đón khách thành công hoặc khách hủy chuyến, vui lòng xóa yêu cầu đặt xe khỏi hệ thống" delegate:self buttonTitles:@[@"Xóa",@"Bỏ qua"]];
    [alert setTag:1];
    [alert show];
    NSLog(@"Call");
}

-(void)updateLabelType:(labelRequestType)type section:(NSString *)section content:(NSString *)content{
    UILabel *lbl = nil;
    if (type == labelRequestTypeDate){
        lbl = lblDate;
    }
    else if (type == labelRequestTypeFromLocation){
        lbl = lblFromLocation;
    }
    else if (type == labelRequestTypePhone){
        lbl = lblPhone;
    }
    else if (type == labelRequestTypeSeat){
        lbl = lblSeats;
    }
    else if (type == labelRequestTypeToLocation){
        lbl = lblToLocation;
    }
    NSMutableAttributedString *atrrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: %@",section,content]];
    
    NSDictionary *attrSection = @{NSForegroundColorAttributeName: BACKGROUND_COLOR_BLUE,
                                  NSFontAttributeName: [UIFont fontWithName:LABEL_FONT size:12*RATIO_TEXT],
                                  };
    NSDictionary *attrValue = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                NSFontAttributeName: [UIFont fontWithName:LABEL_FONT size:12*RATIO_TEXT],
                                };
    [atrrStr setAttributes:attrSection range:NSMakeRange(0, section.length+1)];
    [atrrStr setAttributes:attrValue range:NSMakeRange(section.length+2, content.length)];
    
    [lbl setAttributedText:atrrStr];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
