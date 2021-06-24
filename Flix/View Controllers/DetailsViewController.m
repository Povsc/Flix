//
//  DetailsViewController.m
//  Flix
//
//  Created by felipeccm on 6/23/21.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *blurImage;
@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *baseURL = @"https://image.tmdb.org/t/p/w500";
    NSString *postURL = self.movie[@"poster_path"];
    NSString *fullURL = [baseURL stringByAppendingFormat:@"%@", postURL];
    NSURL *posterURL = [NSURL  URLWithString:fullURL];
    [self.posterView setImageWithURL:posterURL];
    
    NSString *backdropPostURL = self.movie[@"backdrop_path"];
    NSString *backdropFullURL = [baseURL stringByAppendingFormat:@"%@", backdropPostURL];
    NSURL *backdropURL = [NSURL  URLWithString:backdropFullURL];
    [self.backdropView setImageWithURL:backdropURL];
    [self.blurImage setImageWithURL:backdropURL];

    
    self.titleLabel.text = self.movie[@"title"];
    self.navigationBar.title = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    self.dateLabel.text = self.movie[@"release_date"];
    self.ratingLabel.text = [NSString stringWithFormat:@"%.1f", [self.movie[@"vote_average"] doubleValue]];//[self.movie[@"vote_average"] stringValue];

//
//    NSString *preText = @"RELEASED: ";
//    NSString *postText = self.movie[@"release_date"];
//    self.dateLabel.text = [preText stringByAppendingString:postText];
    
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    NSInteger displacement = self.synopsisLabel.frame.size.height;
    
    CGRect dateFrame = self.dateLabel.frame;
    dateFrame.origin.y += displacement + 20;
    self.dateLabel.frame = dateFrame;
    
    CGRect ratingFrame = self.ratingView.frame;
    ratingFrame.origin.y += displacement;
    self.ratingView.frame = ratingFrame;
    
    self.ratingView.layer.cornerRadius = 5;
    self.ratingView.layer.masksToBounds = true;
    float rating = [self.ratingLabel.text floatValue] / 10.0;
    
    [self.ratingView setBackgroundColor:[UIColor
                                       colorWithHue:0.3f * rating saturation:1.0f brightness:0.7f alpha:1.0f]];
    
// Code with some help from StackOverflow below:

// create effect
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];

// add effect to an effect view
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = self.view.frame;

// add the effect view to the image view
    [self.blurImage addSubview:effectView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
