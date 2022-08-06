//
//  ViewController.m
//  MyService
//
//  Created by Shen on 2022/7/3.
//

#import "ViewController.h"
#import "ServiceTools.h"
#import <PhotosUI/PhotosUI.h>

@interface ViewController ()<ServiceToolsDelegate, PHPickerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ipTextField;
@property (weak, nonatomic) IBOutlet UITextField *msgField;
@property (weak, nonatomic) IBOutlet UILabel *result;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSString *imgName;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;


@property (strong, nonatomic) ServiceTools* serviceTools;
@property (strong, nonatomic) PHPickerViewController *phPickerViewController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ipTextField.text = @"https://192.168.50.46:8888";
    
    self.serviceTools = [[ServiceTools alloc] init:YES];
    self.serviceTools.delegate = self;
    
    PHPickerConfiguration *cfg = [[PHPickerConfiguration alloc] init];
    cfg.selectionLimit = 1; //照片選擇數量
    cfg.filter = [PHPickerFilter imagesFilter];
    self.phPickerViewController = [[PHPickerViewController alloc] initWithConfiguration:cfg];
    self.phPickerViewController.delegate = self;
    
}

- (IBAction)sendClick:(id)sender {
    [[[[UIApplication sharedApplication] windows]firstObject]endEditing:YES];
    
    if(self.imageView.image == nil){
        NSDictionary* josnBody = @{@"msg":self.msgField.text};
        [self.serviceTools doPost:self.ipTextField.text
                                 :@"test"
                                 :josnBody];
        
    }else{
        [self.serviceTools doPostImg:self.ipTextField.text
                                     :@"fileUpload"
                                     :self.msgField.text
                                     :UIImageJPEGRepresentation(self.imageView.image, 0.7)
                                     :self.imgName];
    }
    
}

- (IBAction)getImage:(id)sender{
    self.imageView.image = nil;
    self.imgName = @"";
    [self presentViewController:self.phPickerViewController animated:YES completion:nil];
}

-(void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 只顯示一張圖
    if([results count]!=0){
        PHPickerResult *result = [results firstObject];
        self.imgName = [result.itemProvider suggestedName];
        [result.itemProvider loadObjectOfClass:[UIImage class] completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error){
           if ([object isKindOfClass:[UIImage class]]){
              dispatch_async(dispatch_get_main_queue(), ^{
                  self.imageView.image = (UIImage*)object;
              });
           }
        }];
    }
}



#pragma mark ServiceTools delegate
- (void)getPostResult:(NSHTTPURLResponse *)response :(NSDictionary *)data{
    dispatch_async(dispatch_get_main_queue(), ^(){
        if(data == nil){
            self.result.text = @"unknow error";
        }else{
            self.result.text = [NSString stringWithFormat:@"result:\n%@", data];
        }
        
    });
    
}

- (void)getProgress:(NSInteger)progress{
    dispatch_async(dispatch_get_main_queue(), ^(){
        self.progressLabel.text = [NSString stringWithFormat:@"progress: %ld%%", progress];
    });
}

@end
