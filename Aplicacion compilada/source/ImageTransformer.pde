import org.gicentre.utils.spatial.*;
import org.gicentre.utils.network.*;
import org.gicentre.utils.network.traer.physics.*;
import org.gicentre.utils.geom.*;
import org.gicentre.utils.move.*;
import org.gicentre.utils.stat.*;
import org.gicentre.utils.gui.*;
import org.gicentre.utils.colour.*;
import org.gicentre.utils.text.*;
import org.gicentre.utils.*;
import org.gicentre.utils.network.traer.animation.*;
import org.gicentre.utils.io.*;



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
  menu = new UI(this);
	
}


void draw() {
   	 menu.draw_all();
}
