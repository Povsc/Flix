//
//  MoviesViewController.m
//  Flix
//
//  Created by felipeccm on 6/23/21.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *movies;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.url == nil){
    self.url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=eda1a3f4d4cd22b61fe7a4971ba6450d"];
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // Do any additional setup after loading the view.
    
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void) fetchMovies {
    [self.activityIndicator startAnimating];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               [self showAlert];
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

               self.movies = dataDictionary[@"results"];
               if (self.movies.count == 0){
                   [self noSimilarAlert];
               }

               [self.tableView reloadData];
               [self.activityIndicator stopAnimating];

           }
        [self.refreshControl  endRefreshing];
       }];
    [task resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoiveCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
    NSString *baseURL = @"https://image.tmdb.org/t/p/w500";
    NSString *postURL = movie[@"poster_path"];
    NSString *fullURL = [baseURL stringByAppendingFormat:@"%@", postURL];
    NSURL *posterURL = [NSURL  URLWithString:fullURL];
    
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:posterURL];
    return cell;
}

- (void) showAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Error"
                                                                               message:@"No Network Connection."
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];

    // create an Try again action
    UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try again"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
        [self fetchMovies];
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:tryAgainAction];
    
    [self presentViewController:alert animated:YES completion:^{
//        [self fetchMovies];
    }];
}

- (void) noSimilarAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Movies Found"
                                                                               message:@"Try again later"
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];

    // create an Try again action
    UIAlertAction *noSimilarAction = [UIAlertAction actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:noSimilarAction];
    
    [self presentViewController:alert animated:YES completion:^{
//        do nothing
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
    tappedCell.highlighted = false;
}

@end
