import g4p_controls.*;

class UI {
  public GButton open_img_btn;
  public GButton open_second_img_btn;
  public GButton roi_btn;
  public GButton lineal_tf_btn;
  public GButton bc_specify_btn;
  public GButton change_gamma_btn;
  public GButton get_diff_btn;
  public GButton show_diff_btn;
  public GButton equalize_hist_btn;
  public GButton specify_hist_btn;
  public GButton cross_sect_btn;
  public GButton digital_sim_btn;
  public GButton save_img_btn;
  public GButton save_output_btn;
  
  //P2
  
  public GButton vert_mirror_btn;
  public GButton hor_mirror_btn;
  public GButton transpose_btn;
  public GButton rotate_90_btn;
  public GButton resize_btn;
  public GButton rotate_btn;
  
  
  
  
  public converter transform;
  
  // flags para recoger inputs
  public boolean highlight_input_flag;
  public boolean gamma_input_flag;
  public boolean lt_input_flag;
  public boolean bc_image_flag;
  public boolean roi_flag;
  public boolean cross_flag;
  public boolean digitalization_flag;
  public boolean digitalization_flag2;
  // variables transformacion lineal
  public int lineal_tf_point;
  public int[] points;
  public int[] values;
  public int inputs_left;

  //variables brillo y contraste
  public float brightness;
  public boolean brightness_input_done;
  
  // variables region of interest
  public int roi_point_x;
  public int roi_point_y;
  public int screen_x;
  public int screen_y;
  public boolean roi_first_click;
  
  // Variables cross_section
  public boolean cross_click_1;
  public boolean cross_click_2;
  public PVector initial_cross_p;
  public PVector final_cross_p;
  public int neighbours;
  
  //Variables digitalizacion
  public int samples;
  
  // variables resize
  public boolean resize_flag; 
  public Float[]  new_sizes;
  
  // variables rotate
  public boolean rotate_flag;
  
  // variables rotate_90
  public boolean rotate_90_flag;
  
  private ImageTransformer canvas_;
  
  public UI(ImageTransformer canvas) {
    //setCloseAction(GWindow.CLOSE_WINDOW);
    canvas_ = canvas;
    transform = new converter(canvas);
    
    float pos = width / 21;
    float size = pos * 0.9;
    
    G4P.setGlobalColorScheme(5);
    open_img_btn = new GButton(canvas, pos/ 2, 10, size, 30, "Abrir imagen");
    open_second_img_btn = new GButton(canvas, pos / 2 + pos, 10, size, 30, "Abrir imagen secudnaria");
    roi_btn = new GButton(canvas, pos / 2 + pos * 2, 10, size, 30, "Recortar región");
    bc_specify_btn = new GButton(canvas, pos / 2 + pos * 3, 10, size, 30, "Brillo y contraste");
    lineal_tf_btn = new GButton(canvas, pos / 2 + pos * 4, 10, size, 30, "Transformacion Lineal");
    equalize_hist_btn = new GButton(canvas, pos / 2 + pos * 5, 10, size, 30, "ecualizar hist");
    specify_hist_btn = new GButton(canvas, pos / 2 + pos * 6, 10, size, 30, "especificar hist a img 2");
    get_diff_btn = new GButton(canvas, pos / 2 + pos * 7, 10, size, 30, "Ver diferencia");
    show_diff_btn = new GButton(canvas, pos / 2 + pos * 8, 10, size, 30, "Mostrar diff umbral");
    change_gamma_btn = new GButton(canvas, pos / 2 + pos * 9, 10, size, 30, "cambiar gamma");
    cross_sect_btn = new GButton(canvas, pos / 2 + pos * 10, 10, size, 30, "Perfil");
    digital_sim_btn = new GButton(canvas, pos / 2 + pos * 11, 10, size, 30, "Simulacion digitalización");
    save_img_btn = new GButton(canvas, pos / 2 + pos * 18, 10, size, 30, "guardar imagen");
    save_output_btn = new GButton(canvas, pos / 2 + pos * 19, 10, size, 30, "guardar output");
    
    
    vert_mirror_btn = new GButton(canvas, pos / 2 + pos * 12, 10, size, 30, "V mirror");
    hor_mirror_btn = new GButton(canvas, pos / 2 + pos * 13, 10, size, 30, "H Mirror");
    transpose_btn = new GButton(canvas, pos / 2 + pos * 14, 10, size, 30, "Transpose");
    rotate_90_btn = new GButton(canvas, pos / 2 + pos * 15, 10, size, 30, "Rotar mult 90");
    resize_btn = new GButton(canvas, pos / 2 + pos * 16, 10, size, 30, "Redimension");
    rotate_btn = new GButton(canvas, pos / 2 + pos * 17, 10, size, 30, "Rotar");
    
    
    
    open_img_btn.fireAllEvents(true);
    open_second_img_btn.fireAllEvents(true);
    roi_btn.fireAllEvents(true);
    bc_specify_btn.fireAllEvents(true);
    lineal_tf_btn.fireAllEvents(true);
    equalize_hist_btn.fireAllEvents(true);
    specify_hist_btn.fireAllEvents(true);
    get_diff_btn.fireAllEvents(true);
    show_diff_btn.fireAllEvents(true);
    change_gamma_btn.fireAllEvents(true);
    cross_sect_btn.fireAllEvents(true);
    digital_sim_btn.fireAllEvents(true);
    save_img_btn.fireAllEvents(true);
    save_output_btn.fireAllEvents(true);
    vert_mirror_btn.fireAllEvents(true);
    hor_mirror_btn.fireAllEvents(true);
    transpose_btn.fireAllEvents(true);
    rotate_90_btn.fireAllEvents(true);
    rotate_btn.fireAllEvents(true);
    resize_btn.fireAllEvents(true);
    
    deactivate_all_flags();
  }

  public void draw_all() {
    if(transform.img != null) {
      background(200);
      fill(0);
      stroke(0);
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
      text("min - max: " + menu.transform.return_min() + " - " + menu.transform.return_max(), 15.0, (float)height - 300);  
      if(roi_first_click) {
        stroke(100,0,0);
        noFill();
        rect(screen_x, screen_y, mouseX - screen_x, mouseY - screen_y);
      }
      if(cross_click_1 && !cross_click_2) {
        PVector current_point = new PVector(menu.transform.mouse_x_in_image(), menu.transform.mouse_y_in_image());
        if(current_point.x != -1 && current_point.y != -1) {
          menu.transform.draw_line(initial_cross_p, current_point);
        }
      }else if(cross_click_1 && cross_click_2) {
        menu.transform.draw_line(initial_cross_p, final_cross_p);
      }
    }
  }
  
  public void deactivate_all_flags(){
    highlight_input_flag = false;
    gamma_input_flag = false;
    lt_input_flag = false;
    bc_image_flag = false;
    brightness_input_done = false;
    roi_flag = false;
    roi_first_click = false;
    cross_flag = false;
    cross_click_1 = false;
    cross_click_2 = false;
    digitalization_flag = false;
    digitalization_flag2 = false;
    resize_flag = false;
    rotate_flag = false;
    rotate_90_flag = false;
  }

  public void update_image(){

    menu.transform.img.loadPixels();
    menu.transform.draw_image();
    menu.transform.img.updatePixels();
  }
}
