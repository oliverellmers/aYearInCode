/* dataViz by Phillip Stearns 2015 for aYearInCode();
 * http://ayearincode.tumblr.com
 *
 * USES code from the ControlP5 Controlframe Example by Andreas Schlegel, 2012
 * with controlP5 2.0 all java.awt dependencies have been removed
 * as a consequence the option to display controllers in a separate
 * window had to be removed as well. 
 * this example shows you how to create a java.awt.frame and use controlP5
 *
 * Requires controlP5 library available at www.sojamo.de/libraries/controlp5
 *
 */

import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*;

private ControlP5 cp5;

//for the GUI window
ControlFrame cf;

int def;

byte[] raw_bytes;
byte[] raw_bits;

//you will have to specify your own path for files you want to render
String input_path = "input/";
String input_filename = "GoogleChromeFramework";
String input_ext = ".bin";

String output_path = "output/test/";
String output_filename = "test";
String output_ext = ".PNG";

int bit_offset=0; // skips bits 
int pixel_offset=0; // skips pixels

// sets number of bits to be packed into color channel values
int chan1_depth = 8; //defaul = red channel
int chan2_depth = 8; //default = green channel
int chan3_depth = 8; //default = blue channel

// this is the total number of bits used to create a pixel
int pixel_depth = chan1_depth + chan2_depth + chan3_depth;

// used to swap RGB channels
int swap_mode;

boolean red_invert=false;
boolean green_invert=false;
boolean blue_invert=false;

int screen_width = 384;
int screen_height = 512;

void setup(){
  setScreenSize(screen_width, screen_height);
  if (frame != null) {
    frame.setResizable(true);
  }
  raw_bytes = loadBytes(input_path + input_filename + input_ext);
  raw_bits = new byte[raw_bytes.length*8];
  bytes_to_bits();
  
  cp5 = new ControlP5(this); 
  
  // by calling function addControlFrame() a
  // new frame is created and an instance of class
  // ControlFrame is instanziated.
  cf = addControlFrame("GUI", 500 ,200);
  
  // add Controllers to the 'extra' Frame inside 
  // the ControlFrame class setup() method below.
}

void draw(){
  bits_to_pixels();
}

public int sketchWidth() {
    return displayWidth;
  }

  public int sketchHeight() {
    return displayHeight;
  }

  public String sketchRenderer() {
    return P2D; 
  }

void setScreenSize(int x, int y){
  frame.setSize(x,y);
}

void bytes_to_bits(){ 
  for(int i = 0 ; i < raw_bytes.length ; i++){    
    for(int j = 0 ; j < 8 ; j++){    
      raw_bits[(i*8)+j] = byte((raw_bytes[i] >> j) & 1); 
    }  
  }
}

void bits_to_pixels(){
  loadPixels();

  for(int i = 0 ; i < pixels.length ; i++){
    
    int chan1 = 0;
    int chan2 = 0; 
    int chan3 = 0; 
    
    int red = 0;
    int green = 0; 
    int blue = 0; 
    
    //using some bit shifting voodoo to pack bits into channel values  
    
    if((i+pixel_offset)*pixel_depth+pixel_depth+bit_offset < raw_bits.length){
    
      for(int x = 0 ; x < chan1_depth ; x++){
        chan1 |=  (raw_bits[((i+pixel_offset)*pixel_depth)+x+bit_offset] << x);
      }
      chan1*=(255/(pow(2,(chan1_depth))-1)); //scale to 0-255
    
      for(int y = 0 ; y < chan2_depth ; y++){
        chan2 |=  (raw_bits[((i+pixel_offset)*pixel_depth)+chan1_depth+y+bit_offset] << y);
      }
      chan2*=(255/(pow(2,(chan2_depth))-1)); //scale to 0-255
    
      for(int z = 0 ; z < chan3_depth ; z++){
        chan3 |=  (raw_bits[((i+pixel_offset)*pixel_depth)+chan1_depth+chan2_depth+z+bit_offset] << z);       
      }
      chan3*=(255/(pow(2,(chan3_depth))-1)); //scale to 0-255
      
      //channel swap
      switch(swap_mode){
        case 0:
          red = chan1;
          green = chan2 ;
          blue = chan3;
          break;
        case 1:
          red = chan3;
          green = chan1;
          blue = chan2;
          break;
        case 2:
          red = chan2;
          green = chan3;
          blue = chan1;
          break;
        case 3:
          red = chan3;
          green = chan2;
          blue = chan1;
          break;
        case 4:
          red = chan1;
          green = chan3;
          blue = chan2;
          break;
        case 5:
          red = chan2;
          green = chan1;
          blue = chan3;
          break;
      }

      
      //channel invert
      if(red_invert == true){
        red^=0xFF;
      }
      if(green_invert == true){
        green^=0xFF;
      }
      if(blue_invert == true){
        blue^=0xFF;
      }
      
      pixels[i] = color(red, green, blue);
      
    } else {
      pixels[i] = color(0);
    }
  }
  updatePixels();
}
 





  
