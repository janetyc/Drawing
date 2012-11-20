#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"

//osc
#include "ofxOsc.h"
//xml file to store ip address
#include "ofxXmlSettings.h"
//#import "ofxiOSAlertView.h"
#import "AlertWrapper.h"

#define HOST "127.0.0.1"
#define PORT 12000

#define SMALL 0
#define MEDIUM 1
#define LARGE 2
#define PEN4 3
#define PEN5 4
#define PEN6 5

#define BLACK 0
#define RED 1
#define GREEN 2
#define BLUE 3
#define PURPLE 4
#define YELLOW 5
#define PINK 6
#define ORANGE 7
#define GYAN 8

//
#define NUM_PTS 800

class testApp : public ofxiPhoneApp {
	
public:
	void setup();
	void update();
	void draw();
	void exit();
	
	void touchDown(ofTouchEventArgs &touch);
	void touchMoved(ofTouchEventArgs &touch);
	void touchUp(ofTouchEventArgs &touch);
	void touchDoubleTap(ofTouchEventArgs &touch);
	void touchCancelled(ofTouchEventArgs &touch);

	void lostFocus();
	void gotFocus();
	void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);

    //customize
    void sendOSC();
    void drawBackground();
    void sendClean();
    void alertViewClickedButton(int buttonIndex);
    void saveData(string hostname, int port);
    //--------------
    ofPoint touchLoc;
    ofPoint lastTouchLoc;
    bool drawing;
    bool clear;
    
    bool trashPress;
    bool settingPress;
    
    int currWidth;
    int touchStatus;
    int currColor;
    float interpolate;
    
    
    //buttons
    ofPolyline penBt[6];
    ofPolyline colorBt[9];
    
    ofPolyline trashBt;
    ofPolyline settingBt;

    ofColor colorArr[9];
    
    ofImage btArr[6];
    ofImage colorBtArr[9];
    ofImage trash;
    ofImage setting;
    ofImage background;

    
    //osc
    ofxOscSender sender;
    
    //xml
	ofxXmlSettings XML;
    string remote_host;
    int remote_port;
    
    //alert
    //ofxiOSAlertView * alert;
    UIAlertView *alert;
	UITextView *someTextView;
    AlertWrapper *wrapper;
    
    //drawing
    ofPoint dragPts[NUM_PTS];
    int pointCount;
    
};


