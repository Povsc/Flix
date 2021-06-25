//
//  MoviesViewController.h
//  Flix
//
//  Created by felipeccm on 6/23/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoviesViewController : UIViewController

@property (strong, nonatomic) NSURL *url;
@property (weak, nonatomic) IBOutlet UINavigationItem *barTitle;

@end

NS_ASSUME_NONNULL_END
