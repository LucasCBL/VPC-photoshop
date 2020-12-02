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
  public UI(ImageTransformer canvas) {
    transform = new converter();
    open_img_btn = new GButton(canvas, 10, 10, 100, 30, "Abrir imagen");
    open_second_img_btn = new GButton(canvas, 120, 10, 100, 30, "Abrir imagen secudnaria");
    change_brightness_btn = new GButton(canvas, 220, 10, 100, 30, "cambiar b&c");
    equalize_hist_btn = new GButton(canvas, 320, 10, 100, 30, "ecualizar hist");
    specify_hist_btn = new GButton(canvas, 420, 10, 100, 30, "especificar hist a img 2");
    //get_diff_btn = new GButton(canvas, 520, 10, 100, 30, "Ver diferencia");
    show_diff_btn = new GButton(canvas, 520, 10, 100, 30, "Mostrar diff umbral");
    change_gamma_btn = new GButton(canvas, 620, 10, 100, 30, "cambiar gamma");
    save_img_btn = new GButton(canvas, 720, 10, 100, 30, "guardar imagen");
    save_output_btn = new GButton(canvas, 830, 10, 100, 30, "guardar output");
    
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
  }

  public void draw_all() {
    if(transform.img != null) {
      background(255);
      update_image();
      transform.reload_histogram();
      transform.reload_acc_histogram();
      
    }
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
  
  public void handleButtonEvents(GButton button, GEvent event) {
    if(event == GEvent.CLICKED){
      if (button == menu.open_img_btn) {
        selectInput("Select a file to process:", "call_load_img");
      } else if (button == menu.open_second_img_btn) {
        selectInput("Select a file to process:", "call_load_second_img");
     
      } else if (button == menu.change_brightness_btn) {
         
      } else if (button == menu.equalize_hist_btn) {
        menu.transform.equalize_hist();
        
      } else if (button == menu.specify_hist_btn) {
        menu.transform.specify_hist();
      } else if (button == menu.get_diff_btn) {
        menu.transform.difference();
        draw_output();
      } else if (button == menu.show_diff_btn) {
        menu.highlight_input_flag = true;
        
        text_field =  GWindow.getWindow(this, "Input window", 100, 50, 500, 100, JAVA2D);
        GTextField x = new GTextField(text_field, 0, 50, 500, 50);
      } else if (button == menu.change_gamma_btn) {
        menu.gamma_input_flag = true;
        
        text_field =  GWindow.getWindow(this, "Input window", 100, 50, 500, 100, JAVA2D);
        GTextField x = new GTextField(text_field, 0, 50, 500, 50);
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
      }
      
      if(menu.gamma_input_flag) {
        menu.transform.gamma_transform(Float.parseFloat(textcontrol.getText()));
        menu.gamma_input_flag = false;
      }
      
      
      textcontrol.setText("");
    }
  }
