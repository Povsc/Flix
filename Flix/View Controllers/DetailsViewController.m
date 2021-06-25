//
//  DetailsViewController.m
//  Flix
//
//  Created by felipeccm on 6/23/21.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MoviesViewController.h"
#import "TrailerViewController.h"

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
@property (weak, nonatomic) IBOutlet UIScrollView *DetailsScrollView;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIButton *trailerButton;
@property (strong, nonatomic) NSString *keyString;
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
    
    CGRect buttonFrame = self.moreButton.frame;
    buttonFrame.origin.y += displacement;
    self.moreButton.frame = buttonFrame;
    
    CGRect trailerButtonFrame = self.trailerButton.frame;
    trailerButtonFrame.origin.y += displacement;
    self.trailerButton.frame = trailerButtonFrame;
    
    CGSize contentSize = self.DetailsScrollView.contentSize;
    contentSize.height += displacement + 600;
    self.DetailsScrollView.contentSize = contentSize;
    
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
//    UIButton *tappedCell = sender;
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
//    NSDictionary *movie = self.movies[indexPath.row];
    
    int identification = [self.movie[@"id"] intValue];
//    NSLog(@"%d", (long *)identification);
    if ([segue.identifier  isEqual: @"toMenu"]){
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%d/similar?api_key=eda1a3f4d4cd22b61fe7a4971ba6450d&language=en-US&page=1", identification];
    NSURL *url = [NSURL URLWithString:urlString];
    
    MoviesViewController *moviesViewController = [segue destinationViewController];
    moviesViewController.url = url;
    moviesViewController.barTitle.title = [NSString stringWithFormat:@"Similar to %@", self.movie[@"title"]];
    }
    
    else {
        TrailerViewController *trailerViewController = [segue destinationViewController];
        trailerViewController.movie = self.movie;
    }
}


@end
