
import java.util.*;

class converter{
  public PImage img;
  private ArrayList<PImage> historial;
  private PImage histogram;
  private int min_val;
  private int max_val;
  public converter(String file){
     img = loadImage(file);
     histogram = createImage((int)(width * 0.9), (int)(height * 0.95), RGB);
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
    int[] values = new int[256];
    for(int i = 0 ; i < 256; i++) {
      values[i] = 0;
    }
    for(int i = 0; i < img.pixels.length; i++){
      values[(int)red(img.pixels[i])]++; 
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

    float space = histogram.width / 257;
    strokeWeight(space / 2);
    float unit_height = (histogram.height * 0.9) / hist_max;
    for(int i = 0; i < 256; i++) {
      line(space * (i + 1.5), height - (histogram.height * 0.05), space * (i + 1.5), height - (values[i] * unit_height) - (histogram.height * 0.05));
      
    }
    
    print(histogram.height +" asdasd  " + histogram.width + "\n");
    histogram = get(0, height, histogram.width,  height - histogram.height);
    
    
  }
  
  private PImage convert_to_table(Object[] Vout){
    PImage converted_img = img;
    for(int i = 0; i < converted_img.pixels.length; i++) {
      converted_img.pixels[i] = color((float)Vout[(int)red(img.pixels[i])]);
    }
    return converted_img;
  }
  public void drawImage() {
    image(img, width - histogram.width, height - histogram.height);
  }
  
  public void drawHistogram() {
    // a la izquierda hay que dibujar la información de la imagen

    image(histogram, width - histogram.width, height - histogram.height);
  }
}
