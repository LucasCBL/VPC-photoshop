import g4p_controls.*;

import g4p_controls.*;

import gab.opencv.*;
/**
* Load and Display 
* 
* Images can be loaded and displayed to the screen at their actual size
* or any other size. 
*/

 
UI menu;
GWindow text_field;
void setup() {
 
	int window_height = displayHeight - (int)(0.05 * displayWidth);
	int window_width = (int)displayWidth;
	surface.setSize(window_width, window_height);
	surface.setResizable(true);
	 background(255);
	// The image file must be in the data folder of the current sketch 
	// to load successfully
	menu = new UI(this);
  //print(this.getClass());
	
  

  
}


void draw() {
	// Displays the image at its actual size at point (0,0)
//	 menu.reload_histogram();
//	 menu.reload_acc_histogram();
   	 menu.draw_all();

//Runtime.getRuntime().exec("explorer.exe /select, path");
	 //menu.drawHistogram();
}
