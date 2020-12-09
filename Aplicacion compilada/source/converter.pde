
import java.util.*;
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
  private PApplet canvas_;

  public converter(PApplet canvas) {
    canvas_ = canvas;
    drawable_x = round(width * 0.7);
    drawable_y = round(height * 0.95);
  }

  public void load_image(File selected) {
    if (selected == null) {
      println("Window was closed or the user hit cancel.");
    } else {
      img = loadImageIO(selected.getAbsolutePath());
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
      second_img = loadImageIO(selected.getAbsolutePath());
      second_img = to_grayscale(second_img);
      draw_second();
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



  public PImage lineal_transformation(int line_number, int[] points, int[] values) {
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

  public PImage brightness(float brightness, float contrast) {
    int[] Vout = new int[256];

    float A = contrast / get_contrast();
    float B =  brightness -  (A * get_brightness());
    for (int i = 0; i < 256; i++) {
      Vout[i] = round((A * (float)i) + B);
      Vout[i] = Vout[i] < 0 ? 0 : Vout[i];
      Vout[i] = Vout[i] > 255 ? 255 : Vout[i];
    }
    img = convert_to_table(Vout);
    return img;
  }

  public PImage highlight_difference(int umbral) {
    if(img.pixels.length != second_img.pixels.length) {
      return output_img;
    }
    output_img = createImage(img.width, img.height, RGB);
    for (int i = 0; i < second_img.pixels.length; i++) {
      output_img.pixels[i] = abs(red(img.pixels[i]) - red(second_img.pixels[i])) > umbral ?  color(255, 0, 0) : img.pixels[i];
    }

    return output_img;
  }



  public PImage difference() {
    if(img.pixels.length != second_img.pixels.length) {
      return output_img;
    }
    output_img = createImage(img.width, img.height, RGB);
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

  public void cross_section(PApplet chart_window, PVector p1, PVector p2, int neighbours) {
    PVector[] line = get_line(p1, p2);
    float[] x_axis = new float[line.length];
    float[] graph = new float[line.length];
    float[] diff_graph = new float[line.length];
    
    for(int i = 0; i < line.length; i++) {
      x_axis[i] = i;
    }
    
    for(int i = 0; i < graph.length; i++) {
      graph[i] = round(red(img.get(round(line[i].x), round(line[i].y))));
    }
    
    for(int i = 0; i < diff_graph.length - 1; i++) {
      diff_graph[i] = graph[i] - graph[i + 1];
    }
    diff_graph[diff_graph.length - 1] = 0;
    
    float[] round_graph = new float[line.length];
    float[] round_diff_graph = new float[line.length];
    for(int i = 0; i < round_graph.length; i++) {
      int count = 0;
      int sum = 0;
      for(int j = -neighbours; j <= neighbours; j++){
        if(i + j >= 0 && i + j < graph.length) {
          count++;
          sum += graph[i + j];
        }
      }
      round_graph[i] = sum / count;
    }
    
    for(int i = 0; i < round_diff_graph.length - 1; i++) {
      round_diff_graph[i] = round_graph[i] - round_graph[i + 1];
    }
    round_diff_graph[round_diff_graph.length - 1] = 0;
    
    // Both x and y data set here.  
    XYChart line_graph1 = new XYChart(chart_window);
    line_graph1.setData(x_axis, graph);
     
    // Axis formatting and labels.
    line_graph1.showXAxis(true); 
    line_graph1.showYAxis(true); 
    line_graph1.setMinY(0);
     
    // Symbol colours
    line_graph1.setPointColour(color(255,0,0));
    line_graph1.setPointSize(5);
    line_graph1.setLineWidth(2);
    
    XYChart line_graph2 = new XYChart(chart_window);
    line_graph2.setData(x_axis, round_graph);
     
    // Axis formatting and labels.
    line_graph2.showXAxis(true); 
    line_graph2.showYAxis(true); 
    line_graph2.setMinY(0);
     
    // Symbol colours
    line_graph2.setPointColour(color(255,0,0));
    line_graph2.setPointSize(5);
    line_graph2.setLineWidth(2);
    
    // Both x and y data set here.  
    XYChart line_diff_graph1 = new XYChart(chart_window);
    line_diff_graph1.setData(x_axis, diff_graph);
     
    // Axis formatting and labels.
    line_diff_graph1.showXAxis(true); 
    line_diff_graph1.showYAxis(true); 
    line_diff_graph1.setMinY(min(diff_graph));
     
    // Symbol colours
    line_diff_graph1.setPointColour(color(255,0,0));
    line_diff_graph1.setPointSize(5);
    line_diff_graph1.setLineWidth(2);
    
    XYChart line_diff_graph2 = new XYChart(chart_window);
    line_diff_graph2.setData(x_axis, round_diff_graph);
     
    // Axis formatting and labels.
    line_diff_graph2.showXAxis(true); 
    line_diff_graph2.showYAxis(true); 
    line_diff_graph2.setMinY(min(diff_graph));
    line_diff_graph2.setMaxY(max(diff_graph) + 50);
    // Symbol colours
    line_diff_graph2.setPointColour(color(255,0,0));
    line_diff_graph2.setPointSize(5);
    line_diff_graph2.setLineWidth(2);
    
    
    line_graph1.draw(0, 0, 400, 400);
    line_graph2.draw(0, 400, 400, 400);
    line_diff_graph1.draw(400, 0, 400, 400);
    line_diff_graph2.draw(400, 400, 400, 400);
  }
  
  public void digitalize(int sample_size, int color_bit_size) {
    PImage new_img = createImage(ceil((float)img.width / (float)sample_size), ceil((float)img.height / (float)sample_size), RGB);
    
    if(sample_size >= 1) {
      for(int i = 0; i < img.width - sample_size; i += sample_size) {
        for(int j = 0; j < img.height - sample_size; j += sample_size) {
          int pixel_count = 0;
          int sum = 0;
          for(int k = 0; k < sample_size; k++) {
            if(i + k < img.width) {
              for(int t = 0; t < sample_size; t++) {
                if(j + t < img.height) {
                  pixel_count++;
                  sum += red(img.get(i + k, j + t));
                }
              }
            }
          } 
          new_img.set((i / sample_size), (j / sample_size), color(sum / pixel_count));
        }
      }
    }
    
    if(color_bit_size <= 8) {
      int scale = (int)(Math.pow(2, 8 - color_bit_size)); 
      
      for(int i = 0; i < new_img.pixels.length; i++) {
         int scaled =  ceil((float)(red(new_img.pixels[i]))  / (float)scale);
         new_img.pixels[i] = color(scaled * scale);
      }
    }
    
    img = new_img;
    
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


  void reload_histogram(PApplet app, PImage image, float x, float y, float width_h, float height_h) {
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




  void reload_acc_histogram(PApplet app, PImage image, float x, float y, float width_h, float height_h) {
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
  
   public int mouse_x_in_image() {
    int posX;
    float proportion = (float)img.height / img.width;
    if(proportion <= (float)drawable_y / drawable_x){    
      if (((mouseX >= (width - drawable_x)) && (mouseY >= (height - drawable_y))) && ((mouseX < (width) && (mouseY < ((height - drawable_y + drawable_x * proportion) ))))) {
        return round((float)(mouseX - (int)(width - (drawable_x))) / ((float)drawable_x / (float)img.width));
      }
    } else {
      if (((mouseX >= (width - drawable_x)) && (mouseY >= (height - drawable_y))) && ((mouseX < (width - drawable_x +  drawable_y / proportion) && (mouseY < height)))) {
        return round((float)(mouseX - (width - drawable_x) )/ (((float)drawable_y / proportion) / (float)img.width));
      }
    }
    return 0;
  }
  
   public int mouse_y_in_image() {
    int posX, posY;
    float proportion = (float)img.height / img.width;
    if(proportion <= (float)drawable_y / drawable_x){    
      if (((mouseX >= (width - drawable_x)) && (mouseY >= (height - drawable_y))) && ((mouseX < (width) && (mouseY < ((height - drawable_y + drawable_x * proportion) ))))) {
        return round((float)(mouseY - (int)(height - (drawable_y))) / ((float)drawable_x * proportion / (float)img.height));

      }
    } else {
      if (((mouseX >= (width - drawable_x)) && (mouseY >= (height - drawable_y))) && ((mouseX < (width - drawable_x +  drawable_y / proportion) && (mouseY < height)))) {
        return round((float)(mouseY - (height - drawable_y) )/ ((float)drawable_y / (float)img.height));
       
      }
    }
    return 0;
  }
  
  public PVector[] get_line(PVector p1, PVector p2) {
    float A = ((p1.y - p2.y) / (p1.x - p2.x));
    float B = p1.y - A * p1.x;
    PVector[] line;
    if(Math.abs(p1.x - p2.x) < Math.abs(p1.y - p2.y)) {
      line = new PVector[round(Math.abs(p1.y - p2.y))]; 
      boolean up = p1.y < p2.y;
      for(int i = 0; i < line.length; i++) {
        int y = up ? round(p1.y + i) : round(p1.y - i);
        int x = round((y - B) / A);
        line[i] = new PVector(x, y);
        //print("y -> x " + y + " -> " + x + "\n");
      }
    } else {
      line = new PVector[round(Math.abs(p1.x - p2.x))]; 
      boolean up = p1.x < p2.x;
      for(int i = 0; i < line.length; i++) {
        int x = up ? round(p1.x + i) : round(p1.x - i);
        int y = round(A*x + B);
        line[i] = new PVector(x, y);
        //print("x -> y " + x + " -> " + y + "\n");
      }
    }
    return line;
  }
  
  public void draw_line(PVector p1, PVector p2) {
    PVector[] line = get_line(p1, p2);
    float proportion = (float)img.height / img.width;
    float upscale = (proportion <= (float)drawable_y / drawable_x) ? (float)drawable_x / (float)img.width : (float)drawable_y / (float)img.height;
    float begin_x = width - drawable_x;
    float begin_y = height - drawable_y;
    //print("UP = " + upscale + "\n");
    //print("prop = " + proportion + "\n");
    for(int i = 0; i < line.length; i++) {
      stroke(255,0,0);
      strokeWeight(1);
      fill(255,0,0);
      rect(begin_x + (line[i].x * upscale), begin_y + (line[i].y * upscale), upscale, upscale);
    }
  
  }
  
   //<>// //<>// //<>// //<>// //<>// //<>// //<>//

}
