import g4p_controls.*;

class UI {
  public GButton open_img_btn;
  public GButton open_second_img_btn;
  public GButton lineal_tf_btn;
  public GButton bc_specify_btn;
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
  public boolean lt_input_flag;
  public boolean save_image_flag;
  public boolean bc_image_flag;
  
  public int lineal_tf_point;
  public int[] points;
  public int[] values;
  public int inputs_left;
  
  public float brightness;
  public boolean brightness_input_done;
  
  private ImageTransformer canvas_;
  
  public UI(ImageTransformer canvas) {
    //setCloseAction(GWindow.CLOSE_WINDOW);
    canvas_ = canvas;
    transform = new converter();
    
    float pos = width / 12;
    float size = pos * 0.9;
    
    G4P.setGlobalColorScheme(5);
    open_img_btn = new GButton(canvas, pos/ 2, 10, size, 30, "Abrir imagen");
    open_second_img_btn = new GButton(canvas, pos / 2 + pos, 10, size, 30, "Abrir imagen secudnaria");
    bc_specify_btn = new GButton(canvas, pos / 2 + pos * 2, 10, size, 30, "Brillo y contraste");
    lineal_tf_btn = new GButton(canvas, pos / 2 + pos * 3, 10, size, 30, "Transformacion Lineal");
    equalize_hist_btn = new GButton(canvas, pos / 2 + pos * 4, 10, size, 30, "ecualizar hist");
    specify_hist_btn = new GButton(canvas, pos / 2 + pos * 5, 10, size, 30, "especificar hist a img 2");
    get_diff_btn = new GButton(canvas, pos / 2 + pos * 6, 10, size, 30, "Ver diferencia");
    show_diff_btn = new GButton(canvas, pos / 2 + pos * 7, 10, size, 30, "Mostrar diff umbral");
    change_gamma_btn = new GButton(canvas, pos / 2 + pos * 8, 10, size, 30, "cambiar gamma");
    save_img_btn = new GButton(canvas, pos / 2 + pos * 9, 10, size, 30, "guardar imagen");
    save_output_btn = new GButton(canvas, pos / 2 + pos * 10, 10, size, 30, "guardar output");
    
    open_img_btn.fireAllEvents(true);
    open_second_img_btn.fireAllEvents(true);
    bc_specify_btn.fireAllEvents(true);
    lineal_tf_btn.fireAllEvents(true);
    equalize_hist_btn.fireAllEvents(true);
    specify_hist_btn.fireAllEvents(true);
    //get_diff_btn.fireAllEvents(true);
    show_diff_btn.fireAllEvents(true);
    change_gamma_btn.fireAllEvents(true);
    save_img_btn.fireAllEvents(true);
    save_output_btn.fireAllEvents(true);
    
    
    highlight_input_flag = false;
    gamma_input_flag = false;
    lt_input_flag = false;
    save_image_flag = false;
    bc_image_flag = false;
    brightness_input_done = false;
  }

  public void draw_all() {
    if(transform.img != null) {
      background(200);
      fill(0);
      update_image();
      text("Histograma", width * 0.07,  (float)height * 1.04 - menu.transform.drawable_y );
      text("Histograma acumulativo", width * 0.07,  (float)height * 1.04 - menu.transform.drawable_y  + (float)height * 0.3);
      transform.reload_histogram(canvas_, menu.transform.img, 0.0, (float)height - menu.transform.drawable_y, (float)width * 0.29, (float)height * 0.3);
      transform.reload_acc_histogram(canvas_, menu.transform.img, 0.0, (float)height - menu.transform.drawable_y + (float)height * 0.31, (float)width * 0.29, (float)height * 0.3);
      textSize(20);
      text(menu.transform.mouse_position_in_image(), 15.0, (float)height - 80);
      text("Brillo: " + menu.transform.get_brightness(), 15.0, (float)height - 120);
      text("Contraste: " + menu.transform.get_contrast(), 15.0, (float)height - 160);
      text("Formato de imagen: " + menu.transform.format, 15.0, (float)height - 200);
      text("Tamaño de imagen: " + menu.transform.img.width + " x " + menu.transform.img.height, 15.0, (float)height - 240);
      text("Entropía: " + menu.transform.get_entropy(), 15.0, (float)height - 280);  
    }
  }
  
  public void deactivate_all_flags(){
    highlight_input_flag = false;
    gamma_input_flag = false;
    lt_input_flag = false;
    bc_image_flag = false;
    brightness_input_done = false;
  }

  public void update_image(){

    menu.transform.img.loadPixels();
    menu.transform.draw_image();
    menu.transform.img.updatePixels();
  }
}
