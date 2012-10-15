//
//  AppDelegate.m
//  UIAnimation
//
//  Created by Ibokan on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#define ITEM_SPACING 200

@implementation ViewController

@synthesize carousel;
@synthesize navItem;
@synthesize wrap;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        wrap = YES;
    }
    
    return self;
}

- (void)dealloc
{
    [carousel release];
    [navItem release];
    
    [super dealloc];
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    carousel.delegate = self;
    carousel.dataSource = self;

    carousel.type = iCarouselTypeCoverFlow;
    navItem.title = @"封面展示";
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.carousel = nil;
    self.navItem = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)switchCarouselType
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择类型" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"直线", @"圆圈", @"反向圆圈", @"圆桶", @"反向圆桶", @"封面展示", @"封面展示2", @"纸牌", nil];
    [sheet showInView:self.view];
    [sheet release];
}

- (IBAction)toggleWrap
{
    wrap = !wrap;
    navItem.rightBarButtonItem.title = wrap? @"边界:ON": @"边界:OFF";
    [carousel reloadData];
}

#pragma mark -

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    for (UIView *view in carousel.visibleItemViews)
    {
        view.alpha = 1.0;
    }
    
    [UIView beginAnimations:nil context:nil];
    carousel.type = buttonIndex;
    [UIView commitAnimations];
    
    navItem.title = [actionSheet buttonTitleAtIndex:buttonIndex];
}

#pragma mark -

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 30;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    UIView *view = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",index]]] autorelease];
    
    view.frame = CGRectMake(70, 80, 180, 260);
    return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	return 0;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return 30;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return ITEM_SPACING;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.carousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return wrap;
}

@end
