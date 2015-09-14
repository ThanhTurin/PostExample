//
//  TableRequestSection.h
//  Driver
//
//  Created by Phan Minh Nhựt on 6/10/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TABLE_REQUEST_HEIGHT_CELL (200 * RATIOY)

typedef enum{
    labelRequestTypeFromLocation,
    labelRequestTypeToLocation,
    labelRequestTypeDate,
    labelRequestTypePhone,
    labelRequestTypeSeat,
} labelRequestType;

@protocol TableRequestCellDelegate <NSObject>

@required -(void) needUpdateTable;

@end

@interface TableRequestCell : UITableViewCell<CustomAlertViewDelegate>{
    UIButton *btnCall;
    UILabel *lblFromLocation;
    UILabel *lblToLocation;
    UILabel *lblDate;
    UILabel *lblPhone;
    UILabel *lblSeats;
}

-(void) updateLabelType:(labelRequestType)type section:(NSString*)section content:(NSString*)content;

@property (nonatomic,strong) NSString *numberPhone;
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,weak) id<TableRequestCellDelegate> delegate;

@end
