


class fialog_box{
  public int box_width;
  public int lines;
  private int font_size;
  private String font;
  public String content;
  private boolean active;
  private boolean visible;
  private boolean numerical;
  private boolean natural_num;
  
  public void draw_box(){}
  public void avtivate(){}// para activar la barra manualmente cuando solo hay un valor a pedir
  public void listen_activation(){}// para activar la barra con un click;
  public void hide(){}
  public void show(){}
  public void listen_input(){
    /*if(input retroceso) borrar ultima letra
    if(input enter) desactivar la barra-,
    if(input no retroceso o enter) escribir caracter si hay hueco en la barra
    */
  
  }
}
