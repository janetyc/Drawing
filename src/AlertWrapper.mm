//
//  alertWrapper.cpp
//  drawing
//
//  Created by janetyc on 12/11/19.
//
//

#include "AlertWrapper.h"
#include "testApp.h"

testApp *app;
char str_setting[30];
vector<string> data;

@implementation AlertWrapper

- (id)init{
    if(self == [super init])
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"Connect to server" message:@"Input Host & Port:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
        
        app = (testApp*) ofGetAppPtr();
    }
    
    return self;
    

}
- (void)getSetting{
   
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    someTextView = [alertView textFieldAtIndex:0];
    someTextView.placeholder = @"HOST:PORT";
    
    const char* str_host = app->remote_host.c_str();
    sprintf(str_setting, "%s:%d", str_host, app->remote_port);
    
    someTextView.text = [NSString stringWithUTF8String: str_setting];
    
    [alertView addSubview:someTextView];

}

- (void)show{
  [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            //NSLog(@"Cancel Button Pressed");
            break;
        case 1:
            //NSLog(@"Save Button Pressed");
            app->alertViewClickedButton(buttonIndex);
            data = ofSplitString([someTextView.text UTF8String], ":");
            
            app->saveData(data[0],atoi(data[1].c_str()));
            
            break;
        default:
            break;
    }
    
}

@end