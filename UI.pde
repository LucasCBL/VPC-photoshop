import g4p_controls.*;

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
  
  public int brightness_point;
  public int[] points;
  public int[] values;
  public int inputs_left;
  
  public UI(ImageTransformer canvas) {
    //setCloseAction(GWindow.CLOSE_WINDOW);
    transform = new converter();
    
    float pos = width / 12;
    float size = pos * 0.9;
    
    G4P.setGlobalColorScheme(5);
    open_img_btn = new GButton(canvas, pos, 10, size, 30, "Abrir imagen");
    open_second_img_btn = new GButton(canvas, pos * 2, 10, size, 30, "Abrir imagen secudnaria");
    change_brightness_btn = new GButton(canvas, pos * 3, 10, size, 30, "cambiar b&c");
    equalize_hist_btn = new GButton(canvas, pos * 4, 10, size, 30, "ecualizar hist");
    specify_hist_btn = new GButton(canvas, pos * 5, 10, size, 30, "especificar hist a img 2");
    get_diff_btn = new GButton(canvas, pos * 6, 10, size, 30, "Ver diferencia");
    show_diff_btn = new GButton(canvas, pos * 7, 10, size, 30, "Mostrar diff umbral");
    change_gamma_btn = new GButton(canvas, pos * 8, 10, size, 30, "cambiar gamma");
    save_img_btn = new GButton(canvas, pos * 9, 10, size, 30, "guardar imagen");
    save_output_btn = new GButton(canvas, pos * 10, 10, size, 30, "guardar output");
    
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
  }

  public void draw_all() {
    if(transform.img != null) {
      background(200);
      update_image();
      transform.reload_histogram();
      transform.reload_acc_histogram();
      
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


  void call_load_img(File selected) {
    menu.transform.load_image(selected);
  }
  
  void call_load_second_img(File selected) {
    menu.transform.load_second_image(selected);
  }
  

  
  public void draw_output() {
    GWindow output =  GWindow.getWindow(this, "output image", 0, 0, 100 + menu.transform.output_img.width , 100 + menu.transform.output_img.height, JAVA2D);
    output.addDrawHandler(this, "draw_out_image");
  }
  
  public void draw_out_image(PApplet applet, GWinData windata)  {
    menu.transform.draw_out_image(applet);
  }
  
  void input_gamma(PApplet app, GWinData windata) {
    app.textSize(25);
    app.text("Introduzca Valor gamma: ", 10, 30); 
    app.fill(0);
  }
  
  void input_threshold(PApplet app, GWinData windata) {
    app.textSize(20);
    app.text("Introduzca Valor umbral de diferencia: ", 10, 30); 
    app.fill(0);
  }
  
  void hist_point_input(PApplet app, GWinData windata) {
    app.background(200);
    app.textSize(20);
    app.text("Introduzca un punto en el histograma: ", 10, 30); 
    app.fill(0);
  }
  
  void value_input(PApplet app, GWinData windata) {
    app.background(200);
    app.textSize(20);
    app.text("Introduzca el valor del punto en el histograma: ", 10, 30); 
    app.fill(0);
  }
  
  void point_num_input(PApplet app, GWinData windata) {
    app.background(200);
    app.textSize(20);
    app.text("Introduzca el numero de puntos: ", 10, 30); 
    app.fill(0);
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
        selectInput("Select a file to process:", "fileSelected");
     
      } else if (button == menu.save_output_btn) {
        selectInput("Select a file to process:", "fileSelected");
     
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
