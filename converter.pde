
import java.util.*;
// entropy
class converter {
  public PImage img;
  private ArrayList<PImage> historial;
  private PImage histogram;
  private PImage acc_histogram;
  public PImage second_img;
  public PImage output_img;
  private int min_val;
  private int max_val;
  private int drawable_x;
  private int drawable_y;

  public converter() {
    histogram = createImage(round(width * 0.29), round(height * 0.3), RGB);
    drawable_x = round(width * 0.7);
    drawable_y = round(height * 0.95);
    historial = new ArrayList<PImage>();
  }

  public void load_image(File selected) {
    if (selected == null) {
      println("Window was closed or the user hit cancel.");
    } else {
      img = loadImage(selected.getAbsolutePath());
      img = to_grayscale(img);
    }
    histogram = createImage(round(width * 0.29), round(height * 0.3), RGB);
    output_img = createImage(img.width, img.height, RGB);
    draw_image();
  }


  public void load_second_image(File selected) {
    if (selected == null) {
      println("Window was closed or the user hit cancel.");
    } else {
      second_img = loadImage(selected.getAbsolutePath());
      second_img = to_grayscale(second_img);
    }
  }



  public PImage to_grayscale(PImage image) {

    for (int i = 0; i < image.pixels.length; i++) {
      image.pixels[i] = color(red(image.pixels[i]) * 0.299 + blue(image.pixels[i]) * 0.114 + green(image.pixels[i]) * 0.587);
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
      acc_hist[i] = (acc_hist[i] * 255.0) / (float)img.pixels.length;
      acc_hist_2[i] = (acc_hist_2[i] * 255.0) / (float)second_img.pixels.length;
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
    reload_histogram();
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
      int val = round(pow((((float)i) / 255.0), gamma) * 255);
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
    app.background(0);
    app.image(output_img, 0, 0);
  }

  public void draw_histogram() {
    // a la izquierda hay que dibujar la información de la imagen
    image(histogram, 0, height / 4, width - histogram.width, height - histogram.height);
  }

void reload_histogram() {
    fill(200);
    rect(5, (height * 0.05), histogram.width, histogram.height);
    int[] values = new int[256];
    for (int i = 0; i < 256; i++) {
      values[i] = 0;
    }
    for (int i = 0; i < img.pixels.length; i++) {
      values[round(red(img.pixels[i]))]++;
    }

    int min = 0;
    while (values[min] == 0) {
      min++;
    }
    min_val = min;

    int max = 255;
    while (values[max] == 0) {
      max--;
    }
    max_val = max;

    int hist_max = max(values);
    stroke(0);

    float space = histogram.width / 256.0;
    strokeWeight(space / 2);
    float unit_height = (histogram.height * 0.9) / hist_max;
    for (int i = 0; i < 256; i++) {
      line(space * i + 5, (height * 0.05 + histogram.height), space * i + 5, (height * 0.05 + histogram.height) - (values[i] * unit_height) - (histogram.height * 0.05));
    }
    delay(100);
    histogram = get(0, height, histogram.width, histogram.height);

    //print("Histrogram width " + histogram.width + " width " + (width * 0.3) + "\nSpace: " + space + "\n");
  }




  void reload_acc_histogram() {
    fill(200);
    rect(5, (height * 0.05 + histogram.height), histogram.width, histogram.height);
    int[] values = new int[256];
    for (int i = 0; i < 256; i++) {
      values[i] = 0;
    }
    for (int i = 0; i < img.pixels.length; i++) {
      values[round(red(img.pixels[i]))]++;
    }

    int min = 0;
    while (values[min] == 0) {
      min++;
    }
    min_val = min;

    int max = 255;
    while (values[max] == 0) {
      max--;
    }
    max_val = max;

    int hist_max = img.pixels.length;
    stroke(0);

    float space = histogram.width / 256.0;
    strokeWeight(space / 2);
    float unit_height = (histogram.height * 0.9) / hist_max;
    int total = 0;
    for (int i = 0; i < 256; i++) {
      total += values[i];
      line(space * i + 5, (height * 0.05 + 2 * histogram.height), space * i + 5, (height * 0.05 + 2 * histogram.height) - (total * unit_height) - (histogram.height * 0.05));
    }
    delay(100);
    acc_histogram = get(0, height, histogram.width, histogram.height);

    //print("Histrogram width " + histogram.width + " width " + (width * 0.3) + "\nSpace: " + space + "\n");
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
  


  public void mousePositionInImage() {
    int posX, posY;
    float proportion = (float)img.height / img.width;
    if(proportion <= (float)drawable_y / drawable_x){    
      if (((mouseX > (width - drawable_x)) && (mouseY > (height - drawable_y))) && ((mouseX < ((width - (drawable_x * proportion)) + img.width) && (mouseY < ((height - (drawable_y * proportion) ) + img.height))))) {
        posX = mouseX - (int)(width - (drawable_x));
        posY = mouseY - (int)(height - (drawable_y));
        print("Está en la imagen x : " + posX + " y : " + posY + "\n");
      }
    } else {
      if (((mouseX > (width - drawable_x)) && (mouseY > (height - drawable_y))) && ((mouseX < ((width - drawable_x) + img.width) && (mouseY < ((height - drawable_y) + img.height))))) {
        posX = mouseX - (width - drawable_x);
        posY = mouseY - (height - drawable_y);
        print("Está en la imagen x : " + posX + " y : " + posY + "\n");
      }
    }
    
  }


 /* public void drawTwoImages() {
    image(img, width - drawable_x, height - drawable_y + img.height);  
    image(second_img, width - drawable_x + img.width, height - drawable_y + img.height);
  }*/
}
