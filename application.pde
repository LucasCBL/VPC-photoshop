
import java.util.*;

class converter{
  public PImage img;
  private ArrayList<PImage> historial;
  
  public converter(String file){
     img = loadImage(file);
     historial = new ArrayList<PImage>();
  }
  
  public PImage to_grayscale() {
    historial.add(img);
    for(int i = 0; i < img.pixels.length; i++) {
     img.pixels[i] = color(red(img.pixels[i]) * 0.299 + blue(img.pixels[i]) * 0.114 + green(img.pixels[i]) * 0.587);
    }
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
    return img;
  }
  
  private PImage convert_to_table(Object[] Vout){
    PImage converted_img = img;
    for(int i = 0; i < converted_img.pixels.length; i++) {
      converted_img.pixels[i] = color((float)Vout[(int)red(img.pixels[i])]);
    }
    return converted_img;
  }
  public void draw() {
    image(img, 0, 0);
  }
}
