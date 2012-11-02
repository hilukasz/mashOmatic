//controls
import controlP5.*;
// load image from file path library
import javax.swing.JFileChooser;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.SwingUtilities;

///....
// end imports
/////////////////

ControlP5 cp5;

//sliders
int noise = 30,
    red = 255,
    green = 255,
    blue = 255,
    loadCounter;
    
boolean changeImageExists;    

//....
//global variables
//////////////////

PImage myImage,
       changedImage;
int x,
    y,
    width,
    height;
    

void setup(){
  
  boolean changeImageExists = false; 
  frame.setResizable(true);
  //....
  //slider controls
  //////////////////
  cp5 = new ControlP5(this);
  
  // noise
  cp5.addSlider("noise")
     .setPosition(10,10)
     .setRange(0,255)
     ;
  
  //tint RGB  
  cp5.addSlider("red")
     .setPosition(10,20)
     .setRange(0,255)
     ;
  cp5.addSlider("green")
     .setPosition(10,30)
     .setRange(0,255)
     ;   
  cp5.addSlider("blue")
     .setPosition(10,40)
     .setRange(0,255)
     ;
     
  //....
  // buttons
  ///////////////

  cp5.addButton("load")
   .setValue(0)
   .setPosition(10,52)
   .setSize(99,19)
   ;
  cp5.addButton("render")
   .setValue(0)
   .setPosition(10,72)
   .setSize(99,19)
   ;
  int height = myImage.height;
  int width = myImage.width;
  size(width, height);
} //end SETUP

void draw(){
  if(keyPressed) {
    if((key == 'r' || key == 'R')){
      renderImg();
    }
  }

  // check to see if renderImg() has been ran
  if(!changeImageExists){
    image(myImage, 0,0);
  } 
  else if(changeImageExists){ 
    background(0);
    image(myImage, 0,0);
    if(loadCounter > 0){
      image(changedImage, 0,0); 
    }
  }
}

void load(int theValue) {
    loadCounter = 0;
    String filePath = selectImage("Choose an Image");   
    myImage = loadImage(filePath); 
        
    height = myImage.height;
    width = myImage.width;
    frame.setSize(width, height);
    background(0);
    image(myImage, 0,0);
}
void render(int theValue) {
  renderImg();
}
void renderImg() {
    randomSeed(noise); 
    changedImage = createImage(width, height, ARGB);
    changeImageExists = true;
    y = 0;
    tint(red, green, blue);
    image(myImage, 0,0);
    loadPixels();
    println("width: "+width);
    for (int i = 0; i < pixels.length; i++ ) {
      // draw only one row at a time
      if((i % width) == 0){
        int x = i % width; 
        // grab random pixel # and color in a row
        //also try noise() function here later, returns float and allows 1-3 inputs
        float randomPixelValue = random(width); // can only return a float..? weird.
        int randomPixelValueI = int(randomPixelValue); //this seems messy
        color randomPixelColor = get(randomPixelValueI, y); // get random pixel color from image
        // start at random pixel position and draw until end of "line"
        for( int rp = randomPixelValueI; rp < width; rp++){
          int backToPixelArray = rp+(width*y);
          changedImage.pixels[backToPixelArray] = randomPixelColor;
        }
        // new row, add 1 to row count
        y++;
      }
    }
    
    updatePixels(); 
  
    image(changedImage, 0,0);
    save("test3.jpg");
    // count how many times a new image has loaded
    loadCounter++;
}

/////
// load image
////////////////

File selectedFile;
protected String selectImage(final String prompt)
{
  try
  {
    SwingUtilities.invokeAndWait(new Runnable()
    {
      public void run()
      {
        JFileChooser fileDialog = new JFileChooser();
        fileDialog.setDialogTitle(prompt);
        FileNameExtensionFilter filter = new FileNameExtensionFilter(
            "JPG & PNG Images", "jpg", "png"
        );
        fileDialog.setFileFilter(filter);
        int returnVal = fileDialog.showOpenDialog(null);
        if (returnVal == JFileChooser.APPROVE_OPTION)
        {
          selectedFile = fileDialog.getSelectedFile();
        }
      }
    });
    return selectedFile == null ? null : selectedFile.getAbsolutePath();
  }
  catch (Exception e)
  {
    e.printStackTrace();
    return null;
  }
}
