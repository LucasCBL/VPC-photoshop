
import java.util.*;

class converter{
  public PImage img;
  private ArrayList<PImage> historial;
  private PImage histogram;
  public PImage second_img;
  private int min_val;
  private int max_val;
  private int drawable_x;
  private int drawable_y;
  public converter(String file){
     img = loadImage(file);
     histogram = createImage(round(width * 0.29), round(height * 0.3), RGB);
     second_img = createImage(img.width, img.height, RGB);
     drawable_x = round(width * 0.7);
     drawable_y = round(height * 0.95);
     historial = new ArrayList<PImage>();
  }
  
  public PImage to_grayscale() {
    historial.add(img);
    for(int i = 0; i < img.pixels.length; i++) {
     img.pixels[i] = color(red(img.pixels[i]) * 0.299 + blue(img.pixels[i]) * 0.114 + green(img.pixels[i]) * 0.587);
    }
    reload_histogram();
    return img;
  }  
  
  public PImage brightness(int line_number, int[] points, int[] values) {
    ArrayList Vout = new ArrayList();
    
    if(line_number < 2 || points.length != values.length) {
      print("error in size");
      return img;
    } else if(points[0] != 0 || points[points.length - 1] != 255){
      return img;
    }
    for(int i = 0; i < points.length - 1; i++){
      float A = (points[i + 1] - points[i]) / (values[i + 1] - values[i]);
      float B = values[i] -  A * points[i];
      for(int j = points[i]; j < points[i + 1]; j++) {
        float Voutj = A*j + B;
        Vout.add(Voutj);
      }
    }
    img = convert_to_table(Vout.toArray());
    reload_histogram();
    return img;
  }
  
  void reload_histogram(){
    fill(200);
    rect(5, (height * 0.05), histogram.width, histogram.height);
    int[] values = new int[256];
    for(int i = 0 ; i < 256; i++) {
      values[i] = 0;
    }
    for(int i = 0; i < img.pixels.length; i++){
      values[round(red(img.pixels[i]))]++; 
    }
    
    int min = 0;
    while(values[min] == 0) {
      min++;
    }
    min_val = min;
    
    int max = 255;
    while(values[max] == 0) {
      max--;
    }
    max_val = max;
    
    int hist_max = max(values);
    stroke(0);

    float space = histogram.width / 256.0;
    strokeWeight(space/2);
    float unit_height = (histogram.height * 0.9) / hist_max;
    for(int i = 0; i < 256; i++) {
      line(space * i + 5, (height * 0.05 + histogram.height) , space * i + 5, (height * 0.05 + histogram.height) - (values[i] * unit_height) - (histogram.height * 0.05));
    }
    delay(100);
    histogram = get(0, height, histogram.width,  histogram.height);
    
    print("Histrogram width " + histogram.width + " width " + (width * 0.3) + "\nSpace: " + space + "\n");
  }
  
  void reload_acc_histogram(){
    fill(200);
    rect(5, (height * 0.05 + histogram.height), histogram.width, histogram.height);
    int[] values = new int[256];
    for(int i = 0 ; i < 256; i++) {
      values[i] = 0;
    }
    for(int i = 0; i < img.pixels.length; i++){
      values[round(red(img.pixels[i]))]++; 
    }
    
    int min = 0;
    while(values[min] == 0) {
      min++;
    }
    min_val = min;
    
    int max = 255;
    while(values[max] == 0) {
      max--;
    }
    max_val = max;
    
    int hist_max = img.pixels.length;
    stroke(0);

    float space = histogram.width / 256.0;
    strokeWeight(space/2);
    float unit_height = (histogram.height * 0.9) / hist_max;
    int total = 0;
    for(int i = 0; i < 256; i++) {
      total += values[i];
      line(space * i + 5, (height * 0.05 + 2 * histogram.height) , space * i + 5, (height * 0.05 + 2 * histogram.height) - (total * unit_height) - (histogram.height * 0.05));
    }
    delay(100);
    histogram = get(0, height, histogram.width,  histogram.height);
    
    print("Histrogram width " + histogram.width + " width " + (width * 0.3) + "\nSpace: " + space + "\n");
  }
  
  private PImage convert_to_table(Object[] Vout){
    PImage converted_img = img;
    for(int i = 0; i < converted_img.pixels.length; i++) {
      converted_img.pixels[i] = color((float)Vout[round(red(img.pixels[i]))]);
    }
    return converted_img;
  }
  public void drawImage() {
    image(img, width - drawable_x, height - drawable_y);
  }
  
  public void drawHistogram() {
    // a la izquierda hay que dibujar la información de la imagen
    image(histogram, 0, height/4, width - histogram.width, height - histogram.height);
  }
  public PImage difference(int umbral){
    for(int i = 0; i < second_img.pixels.length; i++){
      second_img.pixels[i] = abs(red(img.pixels[i]) - red(second_img.pixels[i])) > umbral ?  color(255,0,0) : img.pixels[i];
    }

    return second_img;
  }
  
  public void drawTwoImages(){
    image(img, width - drawable_x, height - drawable_y + img.height);  
    image(second_img, width - drawable_x + img.width, height - drawable_y + img.height);
  }
}
