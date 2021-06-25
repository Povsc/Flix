//
//  TrailerViewController.m
//  Flix
//
//  Created by felipeccm on 6/25/21.
//

#import "TrailerViewController.h"
#import <WebKit/WebKit.h>

@interface TrailerViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *trailerView;
@property (strong, nonatomic) NSString *keyString;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.trailerView.layer.cornerRadius = 5;
    self.trailerView.layer.masksToBounds = true;
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%d/videos?api_key=eda1a3f4d4cd22b61fe7a4971ba6450d&language=en-US", [self.movie[@"id"] intValue]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", @"Here!");
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               NSArray *tempArray = dataDictionary[@"results"];
               NSDictionary *tempDict = tempArray[0];
//               NSString *tempString = tempDict[@"key"];
//               NSLog(@"keySTRING HERE:%@", tempString);
               self.keyString = tempDict[@"key"];
               
               NSString *urlString = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@", self.keyString];
               NSURL *url = [NSURL URLWithString:urlString];
               NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                        cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                    timeoutInterval:10.0];
               [self.trailerView loadRequest:request];

           }}];
    [task resume];
    };



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
