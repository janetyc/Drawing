#include "testApp.h"


//--------------------------------------------------------------
void testApp::setup(){	
	// register touch events
	ofRegisterTouchEvents(this);
	
	// initialize the accelerometer
	ofxAccelerometer.setup();
	
	//iPhoneAlerts will be sent to this.
	ofxiPhoneAlerts.addListener(this);
	
	//If you want a landscape oreintation 
	iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
    
    
    //load xml setting : HOST & PORT
	if( XML.loadFile(ofxiPhoneGetDocumentsDirectory() + "mySettings.xml") ){

		remote_host	= XML.getValue("HOST", "127.0.0.1");
        remote_port = XML.getValue("PORT", 12000);
	}else if(XML.loadFile("mySettings.xml")){

		remote_host	= XML.getValue("HOST", "127.0.0.1");
        remote_port = XML.getValue("PORT", 12000);
	}else{

		remote_host	= "127.0.0.1";
        remote_port = 12000;
	}
    
    //alert
    wrapper = [[AlertWrapper alloc] init];
    [wrapper getSetting];
    
    //osc
    sender.setup(remote_host, remote_port);
    
    
    //drawing stuff
    interpolate = 0.5;
	
    clear = true;
    trashPress = false;
    settingPress = false;
    drawing = false;
    currWidth = SMALL*4+3;
    currColor = BLACK;
    touchStatus = 0;
    
    ofSetBackgroundAuto(false);
    ofBackground(255, 255, 255);
    ofSetLineWidth(currWidth);
    ofEnableSmoothing();
    
    
    colorArr[BLACK] = ofColor(0,0,0);
    colorArr[RED] = ofColor(255,0,0);
    colorArr[GREEN] = ofColor(0,255,0);
    colorArr[BLUE] = ofColor(0,0,255);
    colorArr[PURPLE] = ofColor(150,99,234);
    colorArr[YELLOW] = ofColor(255,245,74);
    colorArr[PINK] = ofColor(237,104,163);
    colorArr[ORANGE] = ofColor(255,127,0);
    colorArr[GYAN] = ofColor(0,255,255);

    char fName[26];
    for(int i=0;i<6;i++){
        sprintf(fName, "pen%d.png", i+1);
        btArr[i].loadImage(fName);
    }

    
    char colorName[26];
    for(int i=0;i<9;i++){
        sprintf(colorName, "color%d.png", i+1);
        colorBtArr[i].loadImage(colorName);
    }
    
    trash.loadImage("trash.png");
    setting.loadImage("setting.png");
    background.loadImage("cream_dust.png");
    
    //setting button
    settingBt.addVertex(ofVec2f(15, 50-1*42));
    settingBt.addVertex(ofVec2f(15+35, 50-1*42));
    settingBt.addVertex(ofVec2f(15+35, 50-1*42+31));
    settingBt.addVertex(ofVec2f(15, 50-1*42+31));
    settingBt.close();
    
    //pen buttons
    for(int i=0; i<6; i++){
        penBt[i].addVertex(ofVec2f(15,60+i*42));
        penBt[i].addVertex(ofVec2f(15+35,60+i*42));
        penBt[i].addVertex(ofVec2f(15+35,60+i*42+31));
        penBt[i].addVertex(ofVec2f(15,60+i*42+31));
        penBt[i].close();
    }
    
    
    //color button
    for(int i=0; i<9; i++){
        colorBt[i].addVertex(ofVec2f(15,340+i*42));
        colorBt[i].addVertex(ofVec2f(15+35,340+i*42));
        colorBt[i].addVertex(ofVec2f(15+35,340+i*42+31));
        colorBt[i].addVertex(ofVec2f(15,340+i*40+31));
        colorBt[i].close();
    }
    
    
    //clean button
    trashBt.addVertex(ofVec2f(15,350+9*42));
    trashBt.addVertex(ofVec2f(15+35,350+9*42));
    trashBt.addVertex(ofVec2f(15+35,350+9*42+31));
    trashBt.addVertex(ofVec2f(15,350+9*42+31));
    trashBt.close();
    
}

//--------------------------------------------------------------
void testApp::update(){
    
}

//--------------------------------------------------------------
void testApp::draw(){
    ofEnableAlphaBlending();
    //ofEnableSmoothing();

    if(clear){
        drawBackground();
        clear = false;
    }
        
    if (drawing) {
        /*ofSetLineWidth(currWidth);
        ofSetColor(colorArr[currColor]);
        ofLine(lastTouchLoc.x, lastTouchLoc.y, touchLoc.x, touchLoc.y);*/
        
        
        /*float dist = ofDist(lastTouchLoc.x, lastTouchLoc.y, touchLoc.x, touchLoc.y);
        float lineWidth = 16 - dist * 0.2;
        if (lineWidth < 6) {
            lineWidth = 6;
        }
        ofSetColor(colorArr[currColor]);
        lastTouchLoc += (touchLoc - lastTouchLoc) * interpolate;
        ofFill();
        ofCircle(lastTouchLoc.x, lastTouchLoc.y, lineWidth);
        ofNoFill();
        ofCircle(lastTouchLoc.x, lastTouchLoc.y, lineWidth);*/
        
        //cout << pointCount << endl;

        ofSetLineWidth(currWidth);
        ofSetColor(colorArr[currColor]);

        ofNoFill();
        ofBeginShape();
        for(int i = 0; i < pointCount; i++){
            ofVertex(dragPts[i].x, dragPts[i].y);
        }
        ofEndShape(false);
        
        
        
    }

    //background
    ofFill();
    ofSetColor(245, 245, 245);
    ofRect(0, 0, 70, ofGetHeight());
    ofSetLineWidth(2);
    ofSetColor(200,200,200);
    ofLine(71, 0, 71, ofGetHeight());
    
    
    ofSetColor(245,245,245);
    setting.draw(15, 50-1*42);

    for(int i=0;i<6;i++){
        
        if (i == int((currWidth-3)/4)) ofSetColor(225,225,225);
        else ofSetColor(245, 245, 245);
        
        btArr[i].draw(15, 60+i*42);
    }
    
    for(int i=0;i<9;i++){

        if (i == currColor) ofSetColor(225,225,225);
        else ofSetColor(245, 245, 245);
        
        colorBtArr[i].draw(15, 340+i*42);
    }
     

    ofSetColor(245,245,245);
    trash.draw(15, 350+9*42);
    
}

//--------------------------------------------------------------
void testApp::exit(){

}



//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs &touch){
    if( touch.id == 0 ){

        //touch button area
        if (ofInsidePoly(touch.x, touch.y, penBt[0].getVertices())) {
            currWidth = SMALL*4+3;
        }else if (ofInsidePoly(touch.x, touch.y, penBt[1].getVertices())) {
            currWidth = MEDIUM*4+3;
        }else if (ofInsidePoly(touch.x, touch.y, penBt[2].getVertices())) {
            currWidth = LARGE*4+3;
        }else if (ofInsidePoly(touch.x, touch.y, penBt[3].getVertices())) {
            currWidth = PEN4*4+3;
        }else if (ofInsidePoly(touch.x, touch.y, penBt[4].getVertices())) {
            currWidth = PEN5*4+3;
        }else if (ofInsidePoly(touch.x, touch.y, penBt[5].getVertices())) {
            currWidth = PEN6*4+3;
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[0].getVertices())) {
            currColor = BLACK;
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[1].getVertices())) {
            currColor = RED;
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[2].getVertices())) {
            currColor = GREEN;
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[3].getVertices())) {
            currColor = BLUE;
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[4].getVertices())) {
            currColor = PURPLE;
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[5].getVertices())) {
            currColor = YELLOW;
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[6].getVertices())) {
            currColor = PINK;
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[7].getVertices())) {
            currColor = ORANGE;
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[8].getVertices())) {
            currColor = GYAN;
        }else if (ofInsidePoly(touch.x, touch.y, trashBt.getVertices())){ //clear event
            trashPress = true;
            
            //clear up the screen
            ofFill();
            ofSetColor(255, 255, 255);
            ofRect(0, 0, ofGetWidth(), ofGetHeight());
            clear = true;
            drawBackground();
            
            sendClean();

        }else if (ofInsidePoly(touch.x, touch.y, settingBt.getVertices())) {
            settingPress = true;
            [wrapper show];
            
        }else{
            touchStatus = 1;
            touchLoc.x = touch.x;
            touchLoc.y = touch.y;
            pointCount	= 0;
            
            sendOSC();
        }
    }

}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs &touch){
    if( touch.id == 0 ){
        
        if (ofInsidePoly(touch.x, touch.y, penBt[0].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, penBt[1].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, penBt[2].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, penBt[3].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, penBt[4].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, penBt[5].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[0].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[1].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[2].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[3].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[4].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[5].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[6].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[7].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[8].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, trashBt.getVertices())){ //clear event
        }else if (ofInsidePoly(touch.x, touch.y, settingBt.getVertices())){
        }else{
            touchStatus = 2;
            lastTouchLoc = touchLoc;
            touchLoc.x = touch.x;
            touchLoc.y = touch.y;
            
            sendOSC();
            drawing = true;
            if(pointCount < NUM_PTS -1){
                dragPts[pointCount].set(touch.x, touch.y);
                pointCount++;
            }
        }
        
    }
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs &touch){
    if( touch.id == 0 ){
        
        if (ofInsidePoly(touch.x, touch.y, penBt[0].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, penBt[1].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, penBt[2].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, penBt[3].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, penBt[4].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, penBt[5].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[0].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[1].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[2].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[3].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[4].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[5].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[6].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[7].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, colorBt[8].getVertices())) {
        }else if (ofInsidePoly(touch.x, touch.y, trashBt.getVertices())){ //clear event
            trashPress = false;
        }else if (ofInsidePoly(touch.x, touch.y, settingBt.getVertices())){
            settingPress = false;
        }else{
            touchStatus = 3;
            sendOSC();
            drawing = false;
        }

    }
}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void testApp::lostFocus(){

}

//--------------------------------------------------------------
void testApp::gotFocus(){

}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){

}


//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs& args){

}

//------------------------------------------------------------------
void testApp::sendOSC(){
    
    ofxOscMessage sendMsg;
    sendMsg.setAddress( "/drawing" );
    sendMsg.addIntArg(touchStatus);
    //sendMsg.addIntArg(currColor);
    sendMsg.addIntArg(colorArr[currColor].getHex());
    sendMsg.addIntArg(currWidth);
    sendMsg.addIntArg(touchLoc.x);
    sendMsg.addIntArg(touchLoc.y);
    sender.sendMessage(sendMsg);
    
}

void testApp::sendClean(){
    ofxOscMessage sendMsg;
    sendMsg.setAddress("/clean");
    sender.sendMessage(sendMsg);

}



void testApp::drawBackground(){
    
    for(int i=0;i<ceil(ofGetWidth()/50.0);i++){
        for(int j=0;j<ceil(ofGetHeight()/50.0);j++){
            background.draw(i*50,j*50);
        }
    }


}

void  testApp::alertViewClickedButton(int buttonIndex) {
    
}
void testApp::saveData(string hostname, int port){
    XML.setValue("HOST", hostname);
    XML.setValue("PORT", port);
    //cout<< hostname << ","<< port << endl;
    XML.saveFile( ofxiPhoneGetDocumentsDirectory() + "mySettings.xml" );
    sender.setup(hostname, port);
    
}
