//
//  ViewController.m
//  MyService
//
//  Created by Shen on 2022/7/3.
//

#import "ViewController.h"
#import "ServiceTools.h"

@interface ViewController ()<ServiceToolsDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ipTextField;
@property (weak, nonatomic) IBOutlet UITextField *msgField;
@property (weak, nonatomic) IBOutlet UILabel *result;

@property (nonatomic) ServiceTools* serviceTools;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ipTextField.text = @"https://192.168.50.46:8888";
    
    self.serviceTools = [[ServiceTools alloc] init:YES];
    self.serviceTools.delegate = self;
}

- (IBAction)sendClick:(id)sender {
//    [[[UIApplication sharedApplication] keyWindow] endEditing: YES];
    [[[[UIApplication sharedApplication] windows]firstObject]endEditing:YES];
    NSDictionary* josnBody = @{@"msg":self.msgField.text};
    [self.serviceTools doPost:self.ipTextField.text :@"test" :josnBody];
}


#pragma mark ServiceTools delegate
- (void)getPostResult:(NSHTTPURLResponse *)response :(NSDictionary *)data{
    dispatch_async(dispatch_get_main_queue(), ^(){
        if(data == nil){
            self.result.text = @"unknow error";
        }else{
            self.result.text = [NSString stringWithFormat:@"%@", data];
        }
        
    });
    
}

@end
