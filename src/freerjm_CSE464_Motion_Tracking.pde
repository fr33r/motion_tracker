//****FINAL TURN IN VERSION****//
// CSE464: Intro to Algorithms //
//********* Jon Freer *********//
//******** Spring 2014 ********//
//*****************************//
import processing.video.*; //the video library for processing.

Capture camera;           //An instance of the Capture class that "grabs
                          //the frames of video for manipulation.
                          
PImage backgroundImage;   //The background image that used to detect
                          //changes.
                          
PImage changeMask;        //The change mask image that displays the changes
                          //detected.

float changeThreshold;    //The threshold used for the "simple differencing"
                          //change detection algorithm.

String cameraList[];      //The list of cameras detected to be connected to 
                          //the machine.

int rectX;                //The X coordinate of the rectangle.

int rectY;                //The Y coordinate of the rectangle.

boolean saveFrames = false;   //Boolean flag used to turn video saving on (true) or off (false).

boolean displayRectangle;     //Boolean variable that controls when to display the rectangle.

boolean displayPath = true;  //Boolean flag used to turn path tracking on (true) or off (false).

int rectangleWidth;           //The width of the rectangle.

int rectangleHeight;          //The height of the rectangle.

ArrayList<int[]> points;      //An array of x and y coordinates representing where the object has traveled.



/**
*  This method sets up the window size, checks to see what cameras
*  are connected (for diagnostics), and then begins video capture.
**/
void setup(){
  size(640, 256);
  rectX = 0;
  rectY = 0;
  changeThreshold = 65.0f;
  displayCamerasConnected();
  initializeChangeMask();
  camera = new Capture(this, width/2, height, 50);
  camera.start();
  rectMode(CENTER);
  fill(0,0,0,0);
  strokeWeight(2);
  stroke(255,0,0);
  displayRectangle = false;
  rectangleWidth = 40;
  rectangleHeight = 40;
  points = new ArrayList<int[]>();
}

void draw(){
  if (camera.available() == true) {                    //if the camera is available
    camera.read();                                     //get next frame
    resetChangeMask();                                 //reset the change mask
    if(frameCount == 30){                              //at the 30th frame...
      createBackgroundImage();                         //create the background image for comparison
    }else if(frameCount > 30){                         //after the background image has been created
      updateChangeMask();                              //update the change mask with changes compared to that image
    }
  }
  image(camera, 0, 0, width/2, height);                //the left side of the window (camera view)
  image(changeMask, width/2, 0, width/2, height);      //the right side of the window (change mask view)
  rectExperiment();                                    //places the rectangle in the correct loction (where the object is)
  if(displayRectangle){                                //if we want to display the rectangle because motion has been detected
   rect(rectX, rectY, rectangleWidth, rectangleHeight);//create the rectangle
  }
  if(displayPath){                                     //if we want to display the path
   if(rectX == 0 && rectY == 0){                       //dont do anything if the coordinate equal 0 (initialized at 0)
     
   }else{
    int[] pointCoords = {rectX, rectY};                //create an array containing the current x and y coordinates of the rectangle (location of the object)
    points.add(pointCoords);                           //add the array to the list of points to be drawn
   }
   displayPath();                                      //display the path
  }
  if(saveFrames){                                      //if we want to save the frames to make a video...
   saveFrame("videoframes/frame-########.png");        //save the frame in the videoframes folder
  }
}

/**
*  Displays all of the cameras connceted to the machine in a semi-neat
*  fashion. NOTE: May classify different resolutions possible for a camera
*  as separate cameras altogether.
**/
void displayCamerasConnected(){
 println("CAMERAS:");
 cameraList = camera.list();
 for(int i = 0; i < cameraList.length; i++){
   int indexOfFirstComma = cameraList[i].indexOf(",");
   String cameraName = cameraList[i].substring(0, indexOfFirstComma);
   println("CAMERA " + (i+1) + ": " +  cameraName);
 }
 println("----------------------------------------"); 
}

/**
*  Creates the change mask by creating an image and initialize
*  all pixels to white.
**/
void initializeChangeMask(){
  changeMask = createImage(width/2, height, ALPHA); //creates a change mask image with same size as the video frames.
  color white = color (255, 255, 255); //creates the color white.
  changeMask.loadPixels(); //load the pixels to be manipulated.
  for(int i = 0; i < changeMask.pixels.length; i++){ //the pixels are actually stored as a 1D array. Go through them all and make them white.
    changeMask.pixels[i] = white;
  }
  changeMask.updatePixels(); //update the change mask image
}
/**
*  Creates the background image used to detect motion.
**/
void createBackgroundImage(){
  backgroundImage = createImage(camera.width, camera.height, RGB);
  backgroundImage.loadPixels();
  for(int i = 0; i < camera.pixels.length; i++){
    backgroundImage.pixels[i] = camera.pixels[i];
  }
  backgroundImage.updatePixels();
}

/**
*  Performs the "diff" for every pixel in the current frame against
*  the background image. If the "diff" is above the threshold, display
*  that pixel as black in the change mask.
**/
void updateChangeMask(){
  float currentRed;
  float backgroundRed;
  float currentGreen;
  float backgroundGreen;
  float currentBlue;
  float backgroundBlue;
  float diff;
  
 camera.loadPixels();
 backgroundImage.loadPixels();
 for(int i = 0; i < camera.pixels.length; i++){
  currentRed = red(color(camera.pixels[i]));
  backgroundRed = red(color(backgroundImage.pixels[i]));
  currentGreen = green(color(camera.pixels[i]));
  backgroundGreen = green(color(backgroundImage.pixels[i]));
  currentBlue = blue(color(camera.pixels[i]));
  backgroundBlue = blue(color(backgroundImage.pixels[i]));
  
  diff = dist(currentRed, currentGreen, currentBlue, backgroundRed, backgroundGreen, backgroundBlue);
  
  changeMask.loadPixels();
  if(diff > changeThreshold){
   changeMask.pixels[i] = color(0, 0, 0);
  }
  changeMask.updatePixels();
 }
}

/**
*  Resets the change mask to all white pixels. 
**/
void resetChangeMask(){
 changeMask.loadPixels();
 color white = color (255, 255, 255); //creates the color white.
  changeMask.loadPixels(); //load the pixels to be manipulated.
  for(int i = 0; i < changeMask.pixels.length; i++){ //the pixels are actually stored as a 1D array. Go through them all and make them white.
    changeMask.pixels[i] = white;
  }
  changeMask.updatePixels(); //update the change mask image
}

/**
*  Creates a rectangle with a location of coordinates x and y
*  and a rectangle width and rectangle height.
**/
void createRectangle(int x, int y){
 rect(x, y, rectangleWidth, rectangleHeight); 
}

/**
*  Searchs the change mask using an invisible rectangle with a location locX and locY
*  and a rectangle width and rectangle height for the number
*  of black pixels located within its area.
**/
int computeNumberOfBlackPixels(int locX, int locY){
 int count = 0;
 color black = color(0, 0, 0);
 int topLeftCornerX = locX - (rectangleWidth/2);
 int topLeftCornerY = locY - (rectangleHeight/2);
 int pixelLoc;

  for( int y = topLeftCornerY; y < ((topLeftCornerY + rectangleHeight) - 1); y++){
   for( int x = topLeftCornerX; x < ((topLeftCornerX + rectangleWidth) - 1); x++){
     pixelLoc = (y * changeMask.width) + (x + 1);
     if(changeMask.pixels[pixelLoc] == black){
       count++;
     }
   }
  }
 return count;
}

/**
*  Places the invisible rectangle at each pixel to find the 
*  maximum black pixel count. Updates the rectangles x and y
*  location coordinates once the max is located.
**/
void rectExperiment(){
 int max = 0;
 int blackCount = 0;
 int xBuffer = rectangleWidth/2;
 int yBuffer = rectangleHeight/2;
 
 for(int y = yBuffer; y < (changeMask.height - yBuffer); y++){
  for(int x = xBuffer; x < (changeMask.width - xBuffer); x++){
   blackCount = computeNumberOfBlackPixels(x, y);
   if(blackCount > max){
    max = blackCount;
    rectX = x;
    rectY = y;
   }
  } 
 }
 if(max == 0){
  displayRectangle = false; 
 }else{
  displayRectangle = true; 
 }
}

/**
*  Displays the path of the object in motion.
**/
void displayPath(){
 for(int i = 0; i< points.size(); i++){ 
  if(i+1 < points.size()){
   line(points.get(i)[0], points.get(i)[1], points.get(i+1)[0], points.get(i+1)[1]);
  }
 }  
}


