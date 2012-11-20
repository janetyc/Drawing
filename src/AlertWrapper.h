//
//  AlertWrapper.h
//  drawing
//
//  Created by janetyc on 12/11/19.
//
//

#ifndef drawing_AlertWrapper_h
#define drawing_AlertWrapper_h

#import <UIKit/UIKit.h>
//#include "testApp.h"

@interface AlertWrapper : NSObject <UIAlertViewDelegate>
{
    //string settingStr;
    UIAlertView *alertView;
    UITextField *someTextView;
    
}

- (void)show;
- (void)getSetting;
@end


#endif
