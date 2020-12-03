import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

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
import g4p_controls.*; 
import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ImageTransformer extends PApplet {



















/**
* Load and Display 
* 
* Images can be loaded and displayed to the screen at their actual size
* or any other size. 
*/

 
UI menu;
GWindow text_field;
public void setup() {
 
	int window_height = displayHeight - (int)(0.05f * displayWidth);
	int window_width = (int)displayWidth;
	surface.setSize(window_width, window_height);
	surface.setResizable(true);
	background(255);
  menu = new UI(this);
	
}


public void draw() {
   	 menu.draw_all();
}

  public void call_load_img(File selected) {
    menu.transform.load_image(selected);
  }
  
  public void call_load_second_img(File selected) {
    menu.transform.load_second_image(selected);
  }
  

  
  public void draw_output() {
    int w_height = menu.transform.output_img.height > 600 ? menu.transform.output_img.height : 600;
    GWindow output =  GWindow.getWindow(this, "output image", 0, 0, 400 + menu.transform.output_img.width , w_height, JAVA2D);
    output.addDrawHandler(this, "draw_out_image");
  }

  
  public void draw_out_image(PApplet app, GWinData windata)  {
    menu.transform.draw_out_image(app);
    menu.transform.reload_histogram(app, menu.transform.output_img, (float)menu.transform.output_img.width, 0.0f, 400.0f, 280.0f);
    menu.transform.reload_acc_histogram(app, menu.transform.output_img, (float)menu.transform.output_img.width, 300.0f, 400.0f, 280.0f);
  }
  
  public void draw_second() {
    int w_height = menu.transform.second_img.height > 600 ? menu.transform.second_img.height : 600;
    GWindow output =  GWindow.getWindow(this, "second image", 0, 0, 400 + menu.transform.second_img.width , w_height, JAVA2D);
    output.addDrawHandler(this, "draw_second_image");
  }

  
  public void draw_second_image(PApplet app, GWinData windata)  {
    menu.transform.draw_second_image(app);
    menu.transform.reload_histogram(app, menu.transform.second_img, (float)menu.transform.second_img.width, 0.0f, 400.0f, 280.0f);
    menu.transform.reload_acc_histogram(app, menu.transform.second_img, (float)menu.transform.second_img.width, 300.0f, 400.0f, 280.0f);
  }
  
  public void input_gamma(PApplet app, GWinData windata) {
    app.textSize(25);
    app.text("Introduzca Valor gamma: ", 10, 30); 
    app.fill(0);
  }
  
  public void input_threshold(PApplet app, GWinData windata) {
    app.textSize(20);
    app.text("Introduzca Valor umbral de diferencia: ", 10, 30); 
    app.fill(0);
  }
  
  public void hist_point_input(PApplet app, GWinData windata) {
    app.background(200);
    app.textSize(20);
    app.text("Introduzca un punto en el histograma: ", 10, 30); 
    app.fill(0);
  }
  
  public void value_input(PApplet app, GWinData windata) {
    app.background(200);
    app.textSize(20);
    app.text("Introduzca el valor del punto en el histograma: ", 10, 30); 
    app.fill(0);
  }
  
  public void point_num_input(PApplet app, GWinData windata) {
    app.background(200);
    app.textSize(20);
    app.text("Introduzca el numero de puntos: ", 10, 30); 
    app.fill(0);
  }
  
  public void image_name(PApplet app, GWinData windata) {
    app.background(200);
    app.textSize(20);
    app.text("Introduzca el nombre de la imagen: ", 10, 30); 
    app.fill(0);
  }
  
  
  public void fileCreate(File created){
    if (created == null) {
      println("Window was closed or the user hit cancel.");
    } else {
      menu.transform.img.save(created.getAbsolutePath());
    }
  }
  public void fileCreateOutput(File created){
    if (created == null) {
      println("Window was closed or the user hit cancel.");
    } else {
      menu.transform.output_img.save(created.getAbsolutePath());
    }
  }
  
  
  public void handleButtonEvents(GButton button, GEvent event) {
    if(event == GEvent.CLICKED){
      if (button == menu.open_img_btn) {
        selectInput("Select a file to process:", "call_load_img");
      } else if (button == menu.open_second_img_btn) {
        selectInput("Select a file to process:", "call_load_second_img");
     
      } else if (button == menu.change_brightness_btn) {
        menu.deactivate_all_flags();
        
        menu.brightness_input_flag = true;
        
        text_field =  GWindow.getWindow(this, "Input window", 100, 50, 500, 100, JAVA2D);
        GTextField x = new GTextField(text_field, 0, 50, 500, 50);
        text_field.addDrawHandler(this, "point_num_input");
      } else if (button == menu.equalize_hist_btn) {
        menu.transform.equalize_hist();
        
      } else if (button == menu.specify_hist_btn) {
        menu.transform.specify_hist();
      } else if (button == menu.get_diff_btn) {
        menu.transform.difference();
        draw_output();
      } else if (button == menu.show_diff_btn) {
        menu.deactivate_all_flags();
        
        menu.highlight_input_flag = true;
        
        text_field =  GWindow.getWindow(this, "Input window", 100, 50, 500, 100, JAVA2D);
        GTextField x = new GTextField(text_field, 0, 50, 500, 50);
        text_field.addDrawHandler(this, "input_threshold");
        
      } else if (button == menu.change_gamma_btn) {
        menu.deactivate_all_flags();
        
        menu.gamma_input_flag = true;
        
        text_field =  GWindow.getWindow(this, "Input window", 100, 50, 500, 100, JAVA2D);
        GTextField x = new GTextField(text_field, 0, 50, 500, 50);
        text_field.addDrawHandler(this, "input_gamma");
        
      } else if (button == menu.save_img_btn) {
          selectOutput("Eliga el nombre y formato de la imagen", "fileCreate");
     
      } else if (button == menu.save_output_btn) {
        selectOutput("Eliga el nombre y formato de la imagen", "fileCreateOutput");
     
      }
    
    }
    
  }
  
    public void handleTextEvents(GEditableTextControl textcontrol, GEvent event){
    if(event == GEvent.ENTERED) {
      if(menu.highlight_input_flag) {
        menu.transform.highlight_difference(Integer.parseInt(textcontrol.getText()));
        draw_output();
        menu.highlight_input_flag = false;
        text_field.forceClose();
      }else if(menu.gamma_input_flag) {
        menu.transform.gamma_transform(Float.parseFloat(textcontrol.getText()));
        menu.gamma_input_flag = false;
        text_field.forceClose();
      } else if(menu.brightness_input_flag){
        if(menu.brightness_point >= 2) {
          if(menu.inputs_left > 0){
            if(menu.inputs_left % 2 == 0) {
              menu.points[menu.brightness_point - ((menu.inputs_left + 1) / 2)] = Integer.parseInt(textcontrol.getText());
              text_field.addDrawHandler(this, "value_input");
              
            } else {
              menu.values[menu.brightness_point - ((menu.inputs_left + 1) / 2)] = Integer.parseInt(textcontrol.getText());
              text_field.addDrawHandler(this, "hist_point_input");
            }
            menu.inputs_left--;
            if(menu.inputs_left == 0) {
              menu.transform.brightness(menu.brightness_point, menu.points, menu.values);
              menu.brightness_input_flag = false;
              text_field.forceClose();
            }
          }
        } else {
          menu.brightness_point = Integer.parseInt(textcontrol.getText());
         
          if(menu.brightness_point >= 2) {
            menu.inputs_left = menu.brightness_point * 2;
            menu.points = new int[menu.brightness_point];
            menu.values = new int[menu.brightness_point];
            text_field.addDrawHandler(this, "hist_point_input");
          }
          
        }
      }
      
      textcontrol.setText("");
    }
  };


class UI {
  public GButton open_img_btn;
  public GButton open_second_img_btn;
  public GButton change_brightness_btn;
  public GButton change_gamma_btn;
  public GButton get_diff_btn;
  public GButton show_diff_btn;
  public GButton equalize_hist_btn;
  public GButton specify_hist_btn;
  public GButton save_img_btn;
  public GButton save_output_btn;
  
  public converter transform;
  
  public boolean highlight_input_flag;
  public boolean gamma_input_flag;
  public boolean brightness_input_flag;
  public boolean save_image_flag;
  
  public int brightness_point;
  public int[] points;
  public int[] values;
  public int inputs_left;
  private ImageTransformer canvas_;
  public UI(ImageTransformer canvas) {
    //setCloseAction(GWindow.CLOSE_WINDOW);
    canvas_ = canvas;
    transform = new converter();
    
    float pos = width / 12;
    float size = pos * 0.9f;
    
    G4P.setGlobalColorScheme(5);
    open_img_btn = new GButton(canvas, pos/ 2, 10, size, 30, "Abrir imagen");
    open_second_img_btn = new GButton(canvas, pos / 2 + pos, 10, size, 30, "Abrir imagen secudnaria");
    change_brightness_btn = new GButton(canvas, pos / 2 + pos * 2, 10, size, 30, "cambiar b&c");
    equalize_hist_btn = new GButton(canvas, pos / 2 + pos * 3, 10, size, 30, "ecualizar hist");
    specify_hist_btn = new GButton(canvas, pos / 2 + pos * 4, 10, size, 30, "especificar hist a img 2");
    get_diff_btn = new GButton(canvas, pos / 2 + pos * 5, 10, size, 30, "Ver diferencia");
    show_diff_btn = new GButton(canvas, pos / 2 + pos * 6, 10, size, 30, "Mostrar diff umbral");
    change_gamma_btn = new GButton(canvas, pos / 2 + pos * 7, 10, size, 30, "cambiar gamma");
    save_img_btn = new GButton(canvas, pos / 2 + pos * 8, 10, size, 30, "guardar imagen");
    save_output_btn = new GButton(canvas, pos / 2 + pos * 9, 10, size, 30, "guardar output");
    
    open_img_btn.fireAllEvents(true);
    open_second_img_btn.fireAllEvents(true);
    change_brightness_btn.fireAllEvents(true);
    equalize_hist_btn.fireAllEvents(true);
    specify_hist_btn.fireAllEvents(true);
    //get_diff_btn.fireAllEvents(true);
    show_diff_btn.fireAllEvents(true);
    change_gamma_btn.fireAllEvents(true);
    save_img_btn.fireAllEvents(true);
    save_output_btn.fireAllEvents(true);
    
    
    highlight_input_flag = false;
    gamma_input_flag = false;
    brightness_input_flag = false;
    save_image_flag = false;
  }

  public void draw_all() {
    if(transform.img != null) {
      background(200);
      fill(0);
      update_image();
      text("Histograma", width * 0.07f,  (float)height * 1.04f - menu.transform.drawable_y );
      text("Histograma acumulativo", width * 0.07f,  (float)height * 1.04f - menu.transform.drawable_y  + (float)height * 0.3f);
      transform.reload_histogram(canvas_, menu.transform.img, 0.0f, (float)height - menu.transform.drawable_y, (float)width * 0.29f, (float)height * 0.3f);
      transform.reload_acc_histogram(canvas_, menu.transform.img, 0.0f, (float)height - menu.transform.drawable_y + (float)height * 0.31f, (float)width * 0.29f, (float)height * 0.3f);
      textSize(20);
      text(menu.transform.mouse_position_in_image(), 15.0f, (float)height - 80);
      text("Brillo: " + menu.transform.get_brightness(), 15.0f, (float)height - 120);
      text("Contraste: " + menu.transform.get_contrast(), 15.0f, (float)height - 160);
      text("Formato de imagen: " + menu.transform.format, 15.0f, (float)height - 200);
      text("Tamaño de imagen: " + menu.transform.img.width + " x " + menu.transform.img.height, 15.0f, (float)height - 240);
      text("Entropía: " + menu.transform.get_entropy(), 15.0f, (float)height - 280);  
    }
  }
  
  public void deactivate_all_flags(){
    highlight_input_flag = false;
    gamma_input_flag = false;
    brightness_input_flag = false;
  }

  public void update_image(){

    menu.transform.img.loadPixels();
    menu.transform.draw_image();
    menu.transform.img.updatePixels();
  }
}




// entropy
class converter {
  public PImage img;
  public PImage second_img;
  public PImage output_img;
  public String format;
  private int min_val;
  private int max_val;
  private int drawable_x;
  private int drawable_y;

  public converter() {
    drawable_x = round(width * 0.7f);
    drawable_y = round(height * 0.95f);
  }

  public void load_image(File selected) {
    if (selected == null) {
      println("Window was closed or the user hit cancel.");
    } else {
      img = loadImage(selected.getAbsolutePath());
      img = to_grayscale(img);
      String[] x = split(selected.getAbsolutePath(), ".");
      format = x[x.length - 1];
    }
    output_img = createImage(img.width, img.height, RGB);
    draw_image();
  }


  public void load_second_image(File selected) {
    if (selected == null) {
      println("Window was closed or the user hit cancel.");
    } else {
      second_img = loadImage(selected.getAbsolutePath());
      second_img = to_grayscale(second_img);
      draw_second();
    }
  }



  public PImage to_grayscale(PImage image) {

    for (int i = 0; i < image.pixels.length; i++) {
      image.pixels[i] = color(red(image.pixels[i]) * 0.299f + blue(image.pixels[i]) * 0.114f + green(image.pixels[i]) * 0.587f);
    }
    return image;
  }  



  public PImage equalize_hist() {
    int[] Vout = new int[256];
    int[] acc_hist = new int[256];
    for (int i = 0; i < 256; i++) {
      acc_hist[i] = 0;
    }
    for (int i = 0; i < img.pixels.length; i++) {
      acc_hist[round(red(img.pixels[i]))]++;
    }

    for (int i = 1; i < 256; i++) {
      acc_hist[i] = acc_hist[i] + acc_hist[i - 1];
    }
    for (int i = 0; i < 256; i++) {
      int vout_val = round(((float)256  * (float)acc_hist[i]) / (float)img.pixels.length) - 1;
      Vout[i] = (vout_val > 0 ? vout_val : 0);
    }
    img = convert_to_table(Vout);
    return img;
  }


  public PImage specify_hist() {
    //primero convertir histogramas acumulativos en proporciones tal que acch= acch * 255/tamaño img
    // segundo vout[i] = acch2.find_valor_mas_cercano(acch[i])
    int[] Vout = new int[256];
    float[] acc_hist = new float[256];
    float[] acc_hist_2 = new float[256];
    for (int i = 0; i < 256; i++) {
      acc_hist[i] = 0;
      acc_hist_2[i] = 0;
    }
    for (int i = 0; i < img.pixels.length; i++) {
      acc_hist[round(red(img.pixels[i]))]++;
    }

    for (int i = 0; i < second_img.pixels.length; i++) {
      acc_hist_2[round(red(second_img.pixels[i]))]++;
    }

    for (int i = 1; i < 256; i++) {
      acc_hist[i] = acc_hist[i] + acc_hist[i - 1];
      acc_hist_2[i] = acc_hist_2[i] + acc_hist_2[i - 1];
    }
    for (int i = 0; i < acc_hist.length; i++) {
      acc_hist[i] = (acc_hist[i] * 255.0f) / (float)img.pixels.length;
      acc_hist_2[i] = (acc_hist_2[i] * 255.0f) / (float)second_img.pixels.length;
    }

    for (int i = 0; i < 256; i++) {
      Vout[i] = find_closest(acc_hist[i], acc_hist_2);
      print(Vout[i] + "\n");
    }
    img = convert_to_table(Vout);
    return img;
  }




  private int find_closest(float target, float[] search_array) {
    boolean found = false;
    int pos = search_array.length / 2; 
    while (!found) {
      if (target == search_array[pos]) {
        return pos;
      } else if (target >= search_array[pos] && target <= search_array[pos + 1]) {
        found = true;
      } else if (target <= search_array[pos] && target >= search_array[pos - 1]) {
        found = true;
      } else {
        pos = (target < search_array[pos] ? pos - 1 : pos + 1);
        if (pos == 255 || pos == 0) {
          return pos;
        }
      }
    }
    float diff_a;
    float diff_b;
    if (target >= search_array[pos] && target <= search_array[pos + 1]) {
      diff_a = target - search_array[pos];   
      diff_b = search_array[pos + 1] - target;
      pos = (diff_a < diff_b ? pos : pos + 1);
    } else {
      diff_b = target - search_array[pos - 1];   
      diff_a = search_array[pos] - target;
      pos = (diff_a < diff_b ? pos : pos - 1);
    }
    return pos;
  }



  public boolean grayscale_check() {
    for (int i = 0; i < img.pixels.length; i++) {
      if (red(img.pixels[i]) != blue(img.pixels[i]) || red(img.pixels[i]) != green(img.pixels[i])) {
        return false;
      }
    }
    return true;
  }



  public PImage brightness(int line_number, int[] points, int[] values) {
    int[] Vout = new int[256];

    if (line_number < 2 || points.length != values.length) {
      print("error in size");
      return img;
    } else if (points[0] != 0 || points[points.length - 1] != 255) {
      return img;
    }
    for (int i = 0; i < points.length - 1; i++) {
      float A = ((float)values[i + 1] - (float)values[i]) / (float)(points[i + 1] - (float)points[i]);
      float B = values[i] -  A * points[i];
      for (int j = points[i]; j < points[i + 1]; j++) {
        float Voutj = A * j + B;
        Vout[j] = round(Voutj);
      }
    }
    img = convert_to_table(Vout);
    return img;
  }

    public PImage highlight_difference(int umbral) {
    if(img.pixels.length != second_img.pixels.length) {
      return output_img;
    }
    for (int i = 0; i < second_img.pixels.length; i++) {
      output_img.pixels[i] = abs(red(img.pixels[i]) - red(second_img.pixels[i])) > umbral ?  color(255, 0, 0) : img.pixels[i];
    }

    return output_img;
  }



  public PImage difference() {
    if(img.pixels.length != second_img.pixels.length) {
      return output_img;
    }
    
    for (int i = 0; i < second_img.pixels.length; i++) {
      output_img.pixels[i] = img.pixels[i] - second_img.pixels[i];
    }

    return  output_img;
  }





  private PImage convert_to_table(int[] Vout) {
    PImage converted_img = img;
    for (int i = 0; i < converted_img.pixels.length; i++) {
      converted_img.pixels[i] = color((float)Vout[round(red(img.pixels[i]))]);
    }
    return converted_img;
  }

  public PImage gamma_transform(float gamma) {
    int[] Vout = new int[256];
    for (int i = 0; i < 256; i++) {
      int val = round(pow((((float)i) / 255.0f), gamma) * 255);
      Vout[i] = (val > 255 ? 255 : val);
    }
    img = convert_to_table(Vout);
    return img;
  }

  public void draw_image() {
    float proportion = (float)img.height / img.width;
    if(proportion <= (float)drawable_y / drawable_x){
      image(img, width - drawable_x, height - drawable_y, drawable_x, drawable_x * proportion);
    } else {
      image(img, width - drawable_x, height - drawable_y, drawable_y / proportion, drawable_y);
    }
    
  }

  public void draw_out_image(PApplet app) {
    app.background(200);
    app.image(output_img, 0, 0);
  }
  
    public void draw_second_image(PApplet app) {
    app.background(200);
    app.image(second_img, 0, 0);
  }


  public void reload_histogram(PApplet app, PImage image, float x, float y, float width_h, float height_h) {
    float[] values = new float[256];
    for (int i = 0; i < 256; i++) {
      values[i] = 0;
    }
    for (int i = 0; i < image.pixels.length; i++) {
      values[round(red(image.pixels[i]))]++;
    }
    BarChart histograma = new BarChart(app);
    histograma.setData(values);
    histograma.setBarColour(0); 
    histograma.showValueAxis(true);
    histograma.draw(x, y, width_h, height_h);
  }




  public void reload_acc_histogram(PApplet app, PImage image, float x, float y, float width_h, float height_h) {
    float[] values = new float[256];
    for (int i = 0; i < 256; i++) {
      values[i] = 0;
    }
    for (int i = 0; i < image.pixels.length; i++) {
      values[round(red(image.pixels[i]))]++;
    }
    for (int i = 1; i < 256; i++) {
      values[i] += values[i - 1];
    }
    BarChart histograma = new BarChart(app);
    histograma.setData(values);
    histograma.setBarColour(0); 
    histograma.showValueAxis(true);
    histograma.draw(x, y, width_h, height_h);
  }




  public float get_brightness() {
    float sum = 0;
    for (int i = 0; i < img.pixels.length; i++) {
      sum += red(img.pixels[i]);
    }
    return sum / (float)img.pixels.length;
  }



  public float get_contrast() {
    float sum = 0;
    float mean = get_brightness();
    for (int i = 0; i < img.pixels.length; i++) {
      sum += pow(red(img.pixels[i]) - mean, 2);
    }
    return sqrt(sum / (float)img.pixels.length);
  }
  
  public float get_entropy() {
    float sum = 0;
    float[] values = new float[256];
    
    for (int i = 0; i < 256; i++) {
      values[i] = 0;
    }
    for (int i = 0; i < img.pixels.length; i++) {
      values[round(red(img.pixels[i]))]++;
    }
    
    for(int i = 0; i < 256; i++) {
      double val = values[i] / img.pixels.length;
      if(val != 0)  {
        double log = Math.log(val) / Math.log(2);
        sum += val * log;
      }
    }
    return sum * -1;
  }


  public String mouse_position_in_image() {
    int posX, posY;
    float proportion = (float)img.height / img.width;
    if(proportion <= (float)drawable_y / drawable_x){    
      if (((mouseX >= (width - drawable_x)) && (mouseY >= (height - drawable_y))) && ((mouseX < (width) && (mouseY < ((height - drawable_y + drawable_x * proportion) ))))) {
        posX = round((float)(mouseX - (int)(width - (drawable_x))) / ((float)drawable_x / (float)img.width));
        posY = round((float)(mouseY - (int)(height - (drawable_y))) / ((float)drawable_x * proportion / (float)img.height));
        String result = new String("Está en la imagen x : " + (posX + 1) + " y : " + (posY + 1) + "\nNivel de gris:" + red(img.get(posX, posY)));
        
        return result;
      }
    } else {
      if (((mouseX >= (width - drawable_x)) && (mouseY >= (height - drawable_y))) && ((mouseX < (width - drawable_x +  drawable_y / proportion) && (mouseY < height)))) {
        posX = round((float)(mouseX - (width - drawable_x) )/ (((float)drawable_y / proportion) / (float)img.width));
        posY = round((float)(mouseY - (height - drawable_y) )/ ((float)drawable_y / (float)img.height));
        String result = new String("Está en la imagen x : " + (posX + 1) + " y : " + (posY + 1) + "\nNivel de gris:" + red(img.get(posX, posY)));
        
        return result;
      }
    }
    return "";
  }

}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ImageTransformer" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
