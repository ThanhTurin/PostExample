//
//  PickViewController.m
//  User
//
//  Created by Phan Minh Nhut on 5/18/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "PickViewController.h"

@implementation PickViewController
@synthesize isShow;

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [delegateController pickerView:(PickViewController*)pickerView didSelectTitle:(NSString*)[data objectAtIndex:row]];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return data.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return (NSString*)[data objectAtIndex:row];
}

-(void)show{
    
    if (isShow == NO){
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        if (isFirstShow){
            isFirstShow = NO;
            if ([delegateController respondsToSelector:@selector(pickerViewSetSelectRowForTheFirstTime:)]){
                currentRow = [delegateController pickerViewSetSelectRowForTheFirstTime:self];
            }
        }
        
        [self setHidden:NO];
        [toolbar setHidden:NO];
        CGRect frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        CGRect frameToolbar = CGRectMake(0, toolbar.frame.origin.y, toolbar.frame.size.width, toolbar.frame.size.height);
        [UIView animateWithDuration:0.3 animations:^(void){
            [self setFrame:frame];
            [toolbar setFrame:frameToolbar];
        } completion:^(BOOL finshed){
            
            if (currentRow != -1){
                [self selectRow:currentRow inComponent:0 animated:YES];
                [self pickerView:self didSelectRow:currentRow inComponent:0];
            }
            else{
                [self selectRow:currentRow inComponent:0 animated:YES];
                [self pickerView:self didSelectRow:0 inComponent:0];
            }
        }];
        [viewController.view addSubview:waitingView];
        [viewController.view bringSubviewToFront:waitingView];
        [viewController.view bringSubviewToFront:self];
        [viewController.view bringSubviewToFront:toolbar];
        isShow = YES;
    }
}

-(void) actionBtnDone{
    
    if (isShow == YES){
        CGRect frame = CGRectMake(self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        CGRect frameToolbar = CGRectMake(toolbar.frame.size.width, toolbar.frame.origin.y, toolbar.frame.size.width, toolbar.frame.size.height);
        
        [UIView animateWithDuration:0.3 animations:^(void){
            [self setFrame:frame];
            [toolbar setFrame:frameToolbar];
        } completion:^(BOOL finish){
            [self setHidden:YES];
            [toolbar setHidden:YES];
            currentRow = [self selectedRowInComponent:0];
        }];
        [waitingView removeFromSuperview];
        isShow = NO;
    }
}

-(id)initWithData:(NSArray *)d delegate:(id<PickViewControllerDelegate>)del forViewController:(UIViewController *)vc{
    
    CGSize sizeScreen = [HelperView getSizeScreen];
    float heightTabbar = vc.tabBarController.tabBar.frame.size.height;
    
    if (self = [super init]){
        
        [self setFrame:CGRectMake(sizeScreen.width, sizeScreen.height - heightTabbar - self.frame.size.height, sizeScreen.width, self.frame.size.height)];
        data = d;
        delegateController = del;
        viewController = vc;
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
        isShow = NO;
        
        toolbar = [[UIToolbar alloc] init];
        float heightToolbar = 40;
        toolbar.frame=CGRectMake(sizeScreen.width, self.frame.origin.y,320 * RATIOX, heightToolbar);
        toolbar.barStyle = UIBarStyleDefault;
        
        UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(actionBtnDone)];
        [toolbar setItems:@[flexibleSpaceLeft,doneButton]];
        
        waitingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320 * RATIOX, 480 * RATIOY)];
        
        [viewController.view addSubview:self];
        [viewController.view addSubview:toolbar];
        
        isFirstShow = YES;
        currentRow = -1;
    }
    
    return self;
}

-(void)updateData:(NSArray *)d{
    data = d;
    isFirstShow = YES;
    [self reloadAllComponents];
}

-(NSInteger)rowForTitle:(NSString *)title{
    for (int i=0; i<data.count; i++){
        NSString *str = (NSString*)[data objectAtIndex:i];
        if ([str isEqualToString:title]){
            return i;
        }
    }
    
    return -1;
}

@end
