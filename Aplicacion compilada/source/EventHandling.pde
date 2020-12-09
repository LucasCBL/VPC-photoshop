
void call_load_img(File selected) {
  menu.transform.load_image(selected);
}

void call_load_second_img(File selected) {
  menu.transform.load_second_image(selected);
}



public void draw_output() {
  int w_height = menu.transform.output_img.height > 600 ? menu.transform.output_img.height : 600;
  GWindow output =  GWindow.getWindow(this, "output image", 0, 0, 400 + menu.transform.output_img.width, w_height, JAVA2D);
  output.addDrawHandler(this, "draw_out_image");
}


public void draw_out_image(PApplet app, GWinData windata) {
  menu.transform.draw_out_image(app);
  menu.transform.reload_histogram(app, menu.transform.output_img, (float)menu.transform.output_img.width, 0.0, 400.0, 280.0);
  menu.transform.reload_acc_histogram(app, menu.transform.output_img, (float)menu.transform.output_img.width, 300.0, 400.0, 280.0);
}

public void draw_second() {
  int w_height = menu.transform.second_img.height > 600 ? menu.transform.second_img.height : 600;
  GWindow output =  GWindow.getWindow(this, "second image", 0, 0, 400 + menu.transform.second_img.width, w_height, JAVA2D);
  output.addDrawHandler(this, "draw_second_image");
}


public void draw_second_image(PApplet app, GWinData windata) {
  menu.transform.draw_second_image(app);
  menu.transform.reload_histogram(app, menu.transform.second_img, (float)menu.transform.second_img.width, 0.0, 400.0, 280.0);
  menu.transform.reload_acc_histogram(app, menu.transform.second_img, (float)menu.transform.second_img.width, 300.0, 400.0, 280.0);
}

void brightness_prompt(PApplet app, GWinData windata) {
  app.textSize(25);
  app.text("Introduzca brillo: ", 10, 30); 
  app.fill(0);
}

void contrast_prompt(PApplet app, GWinData windata) {
  app.background(200);
  app.textSize(25);
  app.text("Introduzca contraste: ", 10, 30); 
  app.fill(0);
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

void sample_input(PApplet app, GWinData windata) {
  app.background(200);
  app.textSize(20);
  app.text("Introduzca el numero de muestras: ", 10, 30); 
  app.fill(0);
}

void bit_scale_input(PApplet app, GWinData windata) {
  app.background(200);
  app.textSize(20);
  app.text("Introduzca el numero de bits del color: ", 10, 30); 
  app.fill(0);
}


void cross_neighbours(PApplet app, GWinData windata) {
  app.background(200);
  app.textSize(20);
  app.text("Introduzca el radio de vecinos de redondeo: ", 10, 30); 
  app.fill(0);
}

void graphs(PApplet app, GWinData windata) {
  menu.transform.cross_section(app, menu.initial_cross_p, menu.final_cross_p, menu.neighbours);
}


public void fileCreate(File created) {
  if (created == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    menu.transform.img.save(created.getAbsolutePath());
  }
}
public void fileCreateOutput(File created) {
  if (created == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    menu.transform.output_img.save(created.getAbsolutePath());
  }
}


public void handleButtonEvents(GButton button, GEvent event) {
  if (event == GEvent.CLICKED) {
    if (button == menu.open_img_btn) {
      menu.deactivate_all_flags();
      selectInput("Select a file to process:", "call_load_img");
    } else if (button == menu.open_second_img_btn) {
      menu.deactivate_all_flags();
      selectInput("Select a file to process:", "call_load_second_img");
    } else if(button == menu.roi_btn) {
      menu.deactivate_all_flags();
      menu.roi_flag = true;
      
    } else if (button == menu.bc_specify_btn) {
      menu.deactivate_all_flags();

      menu.bc_image_flag = true;
      text_field =  GWindow.getWindow(this, "Input window", 100, 50, 500, 100, JAVA2D);
      GTextField x = new GTextField(text_field, 0, 50, 500, 50);
      text_field.addDrawHandler(this, "brightness_prompt");
    } else if (button == menu.lineal_tf_btn) {
      menu.deactivate_all_flags();

      menu.lt_input_flag = true;

      text_field =  GWindow.getWindow(this, "Input window", 100, 50, 500, 100, JAVA2D);
      GTextField x = new GTextField(text_field, 0, 50, 500, 50);
      text_field.addDrawHandler(this, "point_num_input");
    } else if (button == menu.equalize_hist_btn) {
      menu.deactivate_all_flags();
      menu.transform.equalize_hist();
    } else if (button == menu.specify_hist_btn) {
      menu.deactivate_all_flags();
      menu.transform.specify_hist();
    } else if (button == menu.get_diff_btn) {
      menu.deactivate_all_flags();
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
      menu.deactivate_all_flags();
      selectOutput("Eliga el nombre y formato de la imagen", "fileCreate");
    } else if (button == menu.save_output_btn) {
      menu.deactivate_all_flags();
      selectOutput("Eliga el nombre y formato de la imagen", "fileCreateOutput");
    } else if (button == menu.cross_sect_btn) {
      menu.deactivate_all_flags();
      menu.cross_flag = true;
    } else if (button == menu.digital_sim_btn) {
      menu.deactivate_all_flags();
      menu.digitalization_flag = true;
      
      text_field =  GWindow.getWindow(this, "Input window", 100, 50, 500, 100, JAVA2D);
      GTextField x = new GTextField(text_field, 0, 50, 500, 50);
      text_field.addDrawHandler(this, "sample_input");
    }
  }
}

public void handleTextEvents(GEditableTextControl textcontrol, GEvent event) {
  if (event == GEvent.ENTERED) {
    if (menu.highlight_input_flag) {
      menu.transform.highlight_difference(Integer.parseInt(textcontrol.getText()));
      draw_output();
      menu.highlight_input_flag = false;
      text_field.forceClose();
    } else if (menu.gamma_input_flag) {
      menu.transform.gamma_transform(Float.parseFloat(textcontrol.getText()));
      menu.gamma_input_flag = false;
      text_field.forceClose();
    } else if (menu.lt_input_flag) {
      if (menu.lineal_tf_point >= 2) {
        if (menu.inputs_left > 0) {
          if (menu.inputs_left % 2 == 0) {
            menu.points[menu.lineal_tf_point - ((menu.inputs_left + 1) / 2)] = Integer.parseInt(textcontrol.getText());
            text_field.addDrawHandler(this, "value_input");
          } else {
            menu.values[menu.lineal_tf_point - ((menu.inputs_left + 1) / 2)] = Integer.parseInt(textcontrol.getText());
            text_field.addDrawHandler(this, "hist_point_input");
          }
          menu.inputs_left--;
          if (menu.inputs_left == 0) {
            menu.transform.lineal_transformation(menu.lineal_tf_point, menu.points, menu.values);
            menu.lt_input_flag = false;
            menu.lineal_tf_point = 0;
            text_field.forceClose();
          }
        }
      } else {
        menu.lineal_tf_point = Integer.parseInt(textcontrol.getText());

        if (menu.lineal_tf_point >= 2) {
          menu.inputs_left = menu.lineal_tf_point * 2;
          menu.points = new int[menu.lineal_tf_point];
          menu.values = new int[menu.lineal_tf_point];
          text_field.addDrawHandler(this, "hist_point_input");
          
        }
      }
    } else if (menu.bc_image_flag) {
      if (!menu.brightness_input_done) {
        menu.brightness = Float.parseFloat(textcontrol.getText());
        menu.brightness_input_done = true;

        text_field.addDrawHandler(this, "contrast_prompt");
      } else {
        menu.brightness_input_done = false;
        menu.transform.brightness(menu.brightness, Float.parseFloat(textcontrol.getText()));
        menu.brightness = 0;
        text_field.forceClose();
      }
    } else if(menu.cross_flag && menu.cross_click_2) {
      menu.neighbours =  Integer.parseInt(textcontrol.getText());
      GWindow graphs = GWindow.getWindow(this, "graphs",100,100,800,800, JAVA2D);
      graphs.addDrawHandler(this, "graphs");
      text_field.forceClose();
    } else if(menu.digitalization_flag) {
      if(!menu.digitalization_flag2) {
        menu.samples =  Integer.parseInt(textcontrol.getText());
        text_field.addDrawHandler(this, "bit_scale_input");
        menu.digitalization_flag2 = true;
      } else {
        menu.transform.digitalize(menu.samples, Integer.parseInt(textcontrol.getText()));
        text_field.forceClose();
        menu.deactivate_all_flags();
      }
    
    }

    textcontrol.setText("");
  }
};

void mousePressed() {
  if(menu.roi_flag) {
    if(!menu.roi_first_click) {
      menu.roi_point_x = menu.transform.mouse_x_in_image() - 1;
      menu.roi_point_y = menu.transform.mouse_y_in_image()- 1;
      
      menu.screen_x = mouseX;
      menu.screen_y = mouseY;
      
      menu.roi_first_click = true;
    } else {
      int width_ = Math.abs(menu.transform.mouse_x_in_image() - menu.roi_point_x);
      int height_ = Math.abs(menu.transform.mouse_y_in_image() - menu.roi_point_y);
      menu.roi_point_x = menu.roi_point_x < menu.transform.mouse_x_in_image() ? menu.roi_point_x : menu.transform.mouse_x_in_image();
      menu.roi_point_y = menu.roi_point_y < menu.transform.mouse_y_in_image() ? menu.roi_point_y : menu.transform.mouse_y_in_image();
      menu.transform.img = menu.transform.img.get(menu.roi_point_x, menu.roi_point_y, width_, height_);
      menu.roi_first_click = false;
      menu.roi_flag = false;
    }
  
  } else if(menu.cross_flag) {
    if(!menu.cross_click_1) {
      float x = (float)menu.transform.mouse_x_in_image();
      float y = (float)menu.transform.mouse_y_in_image();
      menu.initial_cross_p = new PVector(x,y);
      menu.cross_click_1 = true;
    } else if(!menu.cross_click_2) {
      float x = (float)menu.transform.mouse_x_in_image();
      float y = (float)menu.transform.mouse_y_in_image();
      menu.final_cross_p = new PVector(x,y);
      menu.cross_click_2 = true;
      text_field =  GWindow.getWindow(this, "Input window", 100, 50, 500, 100, JAVA2D);
      GTextField text = new GTextField(text_field, 0, 50, 500, 50);
      text_field.addDrawHandler(this, "graph_neighbours");
    }
   
  }
}
