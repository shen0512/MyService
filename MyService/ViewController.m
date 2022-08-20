//
//  ViewController.m
//  MyService
//
//  Created by Shen on 2022/7/3.
//

#import "ViewController.h"
#import "ServiceTools.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, ServiceToolsDelegate>
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *reloadBtn;
@property (strong, nonatomic) UITextField *ipAddress;
@property (strong, nonatomic) UIButton *uploadBtn;

@property (strong, nonatomic) NSMutableArray *floders;
@property (strong, nonatomic) NSMutableDictionary *selectedFiles;
@property (strong, nonatomic) NSArray *files;

@property (strong, nonatomic) ServiceTools *myService;
@property (strong, nonatomic) UIAlertController *alert;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // width=375 height=812
    NSLog(@"view width: %f, view height: %f", self.view.frame.size.width, self.view.frame.size.height);
    
    // create upload floder
    
    self.floders = [NSMutableArray new];
    [self.floders addObject:@"upload"];
    [self createFolder:[[self getDocumentPath] stringByAppendingPathComponent:[self.floders lastObject]]];
    
    // view init
    // back button
    self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,
                                                              60,
                                                              self.view.frame.size.width*0.2,
                                                              self.view.frame.size.height*0.05)];
    [self.backBtn setTitle:@"<返回" forState:UIControlStateNormal];
    [self.backBtn setBackgroundColor:[UIColor redColor]];
    self.backBtn.layer.cornerRadius = 5;
    self.backBtn.clipsToBounds = YES;
    self.backBtn.enabled = NO;
    self.backBtn.alpha = 0.5;
    self.backBtn.hidden = YES;
    [self.backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    //reload button
    self.reloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,
                                                                60,
                                                                self.view.frame.size.width*0.2,
                                                                self.view.frame.size.height*0.05)];
    [self.reloadBtn setTitle:@"重整" forState:UIControlStateNormal];
    [self.reloadBtn setBackgroundColor:[UIColor blueColor]];
    self.reloadBtn.layer.cornerRadius = 5;
    self.reloadBtn.clipsToBounds = YES;
    [self.reloadBtn addTarget:self action:@selector(reloadClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.reloadBtn];
    
    // title label
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.backBtn.frame.origin.x+self.backBtn.frame.size.width+10,
                                                                self.backBtn.frame.origin.y,
                                                                self.view.frame.size.width-10-(self.backBtn.frame.origin.x+self.backBtn.frame.size.width),
                                                                self.backBtn.frame.size.height)];
    self.titleLabel.text = [self.floders lastObject];
    self.titleLabel.font = [self.titleLabel.font fontWithSize:30];
    
    [self.view addSubview:self.titleLabel];
    
    // UITextfield (ip address)
    self.ipAddress = [[UITextField alloc] initWithFrame:CGRectMake(10,
                                                                   self.backBtn.frame.origin.y+self.backBtn.frame.size.height+10,
                                                                   self.view.frame.size.width*0.8-5,
                                                                   34)];
    self.ipAddress.placeholder = @"ip address";
    self.ipAddress.text = @"https://192.168.50.46:8888";
    [self.ipAddress addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:self.ipAddress];
    
    // upload button
    self.uploadBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.8-5,
                                                                self.backBtn.frame.origin.y+self.backBtn.frame.size.height+10,
                                                                self.view.frame.size.width*0.2-5,
                                                                34)];
    [self.uploadBtn setBackgroundColor:[UIColor blueColor]];
    self.uploadBtn.layer.cornerRadius = 5;
    self.uploadBtn.clipsToBounds = YES;
    [self.uploadBtn addTarget:self action:@selector(uploadClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.uploadBtn setTitle:@"上傳" forState:UIControlStateNormal];
    [self.view addSubview:self.uploadBtn];
    
    // table view
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   self.uploadBtn.frame.origin.y+self.uploadBtn.frame.size.height+10,
                                                                   self.view.frame.size.width,
                                                                   (self.view.frame.size.height-10-(self.uploadBtn.frame.size.height+self.uploadBtn.frame.origin.y))*0.5)];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsMultipleSelection = YES;
    [self.view addSubview:self.tableView];
    
    // files
    [self searchFiles:[self getDocumentPath] :self.floders];
    self.selectedFiles = [NSMutableDictionary new];
    
    // service tool
    self.myService = [[ServiceTools alloc] init:YES];
    self.myService.delegate = self;
}

#pragma mark button target
- (void)reloadClick:(id)sender{
    NSLog(@"reload click");
    
    [self searchFiles:[self getDocumentPath] :self.floders];
    if(self.selectedFiles == nil){
        self.selectedFiles = [NSMutableDictionary new];
    }else{
        [self.selectedFiles removeAllObjects];
    }
    
    [self.tableView reloadData];
}

- (void)backClick:(id)sender{
    NSLog(@"clikc");
    if([self.floders count] == 1){
        return;
    }
    
    
    [self.floders removeLastObject];
    if([self.floders count] == 1){
        self.backBtn.enabled = NO;
        self.backBtn.alpha = 0.5;
        self.backBtn.hidden = YES;
        
        self.reloadBtn.hidden = NO;
    }
    self.titleLabel.text = [self.floders lastObject];
    [self searchFiles:[self getDocumentPath] :self.floders];
    [self.selectedFiles removeAllObjects];
    [self.tableView reloadData];
    
}

- (void)uploadClick:(id)sender{
    NSLog(@"upload click");
    
//    if(self.alert){
//        [self.alert setTitle:@""];
//        [self.alert setMessage:@""];
//    }else{
        self.alert = [UIAlertController alertControllerWithTitle:@""
                                                         message:@""
                                                  preferredStyle:UIAlertControllerStyleAlert];
//    }
    
    if(self.ipAddress == nil || [self.ipAddress.text isEqualToString:@""]){
        [self.alert setTitle:@"Error"];
        [self.alert setMessage:@"ip address is empty"];
        
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action){
                                                            [self.alert dismissViewControllerAnimated:NO completion:nil];}
        ];
        
        [self.alert addAction:okAction];
        [self presentViewController:self.alert animated:YES completion:nil];
    }else if([self.selectedFiles count] == 0){
        [self.alert setTitle:@"Error"];
        [self.alert setMessage:@"請選擇上傳檔案"];
        
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action){
                                                            [self.alert dismissViewControllerAnimated:NO completion:nil];}
        ];
        
        [self.alert addAction:okAction];
        [self presentViewController:self.alert animated:YES completion:nil];
    }else{
        [self.alert setTitle:@"file upload"];
        [self.alert setMessage:@""];
        [self presentViewController:self.alert animated:YES completion:^(){
            
        [self.myService doPostFiles:[self.ipAddress.text stringByAppendingPathComponent:@"fileUpload"]
                                   :[self getFileRoot]
                                   :[self.selectedFiles allValues]
                         completion:^(NSDictionary* response){
                            dispatch_async(dispatch_get_main_queue(), ^(){
                                [self.alert dismissViewControllerAnimated:NO completion:^(){
                                    UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@""
                                                                                                    message:@""
                                                                                             preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction* okAction2 = [UIAlertAction actionWithTitle:@"OK"
                                                                                        style:UIAlertActionStyleDefault
                                                                                      handler:nil];
                                    [alert2 addAction:okAction2];
                                                    
                                    if([response[@"status"] isKindOfClass:[NSString class]] && [response[@"status"] isEqualToString:@"accept"]){
                                        NSLog(@"upload success");
                                        [alert2 setTitle:@"upload success"];
                                    }else{
                                        NSLog(@"upload error");
                                        [alert2 setTitle:@"upload error"];
                                        [alert2 setMessage:[NSString stringWithFormat:@"error code: %@", response[@"status"]]];
                                    }
                                    
                                    [self presentViewController:alert2 animated:YES completion:nil];}];
                            });

                    }
        ];
            
            
        }];
    }
    
}


#pragma mark keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark ServiceTool delegate
-(void)getProgress:(NSInteger)progress{
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self.alert setMessage:[NSString stringWithFormat:@"progress: %ld%%", progress]];
    });
}

#pragma mark TableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
    cell.textLabel.text = self.files[indexPath.row];
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = backgroundView;
    
    return cell;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"select: %ld", indexPath.row);
    
    NSString *tmpName = self.files[indexPath.row];
    if([[tmpName componentsSeparatedByString:@"."] count] == 1){
        self.reloadBtn.hidden = YES;
        self.backBtn.hidden = NO;
        self.backBtn.enabled = YES;
        self.backBtn.alpha = 1;
        
        [self.selectedFiles removeAllObjects];
        
        NSString *nowFloder = self.files[indexPath.row];
        [self.floders addObject:nowFloder];
        self.titleLabel.text = nowFloder;
        [self searchFiles:[self getDocumentPath] :self.floders];
        
        [self.tableView reloadData];
    }else{
        [self.selectedFiles setValue:tmpName forKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
        NSLog(@"%@", self.selectedFiles);
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"deselect: %ld", indexPath.row);
    
    [self.selectedFiles removeObjectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
    NSLog(@"%@", self.selectedFiles);
}

#pragma mark file

- (NSString*)getDocumentPath{
    /**
     @brief get document path
     */
    NSArray *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [documentsPath firstObject];
    
    return documentPath;
}

- (void)createFolder:(NSString *)folderPath{
    /**
     @brief create folder
     */
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:folderPath]){
        NSLog(@"folder exist.");
        return;
    }
    
    NSError *error;
    [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
    if(error){
        NSLog(@"error: %@", error);
    }
}

- (void)searchFiles:(NSString*)root :(NSArray*)folder{
    NSString *tmpPath = root;
    for(NSString *name in folder){
        tmpPath = [tmpPath stringByAppendingPathComponent:name];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    self.files = nil;
    self.files = [fileManager contentsOfDirectoryAtPath:tmpPath error:&error];
    if(error) NSLog(@"error= %@", error);
    
}

- (NSString*)getFileRoot{
    NSString *path = [self getDocumentPath];
    for(NSString *name in self.floders){
        path = [path stringByAppendingPathComponent:name];
    }
    
    return path;
}

@end
