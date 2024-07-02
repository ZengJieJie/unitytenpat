//
//  ViewController.m
//  unitytenpat
//
//  Created by feng ting on 2024/7/1.
//

#import "ViewController.h"
#import "AppDelegate.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
       [appDelegate showUnityView];
    // Do any additional setup after loading the view.
}


@end
