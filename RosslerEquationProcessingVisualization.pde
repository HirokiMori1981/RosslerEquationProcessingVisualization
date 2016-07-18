float RosslerConstantA = 0.2;
float RosslerConstantB = 0.4;
float RosslerConstantC = 5.7;
float TimeConstant = 0.5; //[sec]
int RosslerEquationSize = 10;


RosslerEquation[] rossler_equation_array;
int[][] color_map;

RingBufferFloat[] rossler_x_buffer;
RingBufferFloat[] rossler_y_buffer;
RingBufferFloat[] rossler_z_buffer;
int RosslerBufferSize = 200;

float step_time = 0.01; //[sec]
int frame_rate = int(1/step_time);

float Display3D_ScaleX = 20;
float Display3D_ScaleY = 20;
float Display3D_ScaleZ = -20;
float Display3D_ShiftX = 500;
float Display3D_ShiftY = 0;
float Display3D_ShiftZ = 150;

float Display2D_ScaleTime = 2;
float Display2D_ScaleX = -10;
float Display2D_ScaleY = -10;
float Display2D_ScaleZ = -10;
float Display2D_ShiftTime = 100;
float Display2D_ShiftX = 150;
float Display2D_ShiftY = 400;
float Display2D_ShiftZ = 750;




int mouseX_dragged = 0;
int mouseY_dragged = 0;
int mouseX_pressed = 0;
int mouseY_pressed = 0;

int window_size_x = 800;
int window_size_y = 800;



void setup() {
  size( 1200, 800, P3D );
  frameRate(frame_rate);


  rossler_equation_array = new RosslerEquation[RosslerEquationSize];
  rossler_x_buffer = new RingBufferFloat[RosslerEquationSize];
  rossler_y_buffer = new RingBufferFloat[RosslerEquationSize];
  rossler_z_buffer = new RingBufferFloat[RosslerEquationSize];
  color_map = new int[RosslerEquationSize][];

  for ( int rossler_index = 0; rossler_index < RosslerEquationSize; rossler_index++ ) {

    rossler_equation_array[rossler_index] = new RosslerEquation();
    rossler_equation_array[rossler_index].set_parameters( step_time, 
      TimeConstant, 
      RosslerConstantA, 
      RosslerConstantB, 
      RosslerConstantC );
    rossler_equation_array[rossler_index].set_initial_states( random(-1, 1), random(-1, 1), random(-1, 1) );
    rossler_equation_array[rossler_index].reset();
    color_map[rossler_index] = new int[3];
    int[] color_rgb = HSVtoRGB(int(float(rossler_index)/float(RosslerEquationSize)*360), 255, 255);
    //println(rossler_index, " ", RosslerEquationSize, float(rossler_index)/float(RosslerEquationSize),
    //int(float(rossler_index)/float(RosslerEquationSize)*360), " ",
    //println(color_rgb[0], " ", color_rgb[1], " ", color_rgb[2]);
    color_map[rossler_index][0] = color_rgb[0];
    color_map[rossler_index][1] = color_rgb[1];
    color_map[rossler_index][2] = color_rgb[2];

    rossler_x_buffer[rossler_index] = new RingBufferFloat( RosslerBufferSize, 
      rossler_equation_array[rossler_index].get_x() );
    rossler_y_buffer[rossler_index] = new RingBufferFloat( RosslerBufferSize, 
      rossler_equation_array[rossler_index].get_y() );
    rossler_z_buffer[rossler_index] = new RingBufferFloat( RosslerBufferSize, 
      rossler_equation_array[rossler_index].get_z() );
    for ( int data_index = 0; data_index < RosslerBufferSize; data_index++ ) {
      rossler_x_buffer[rossler_index].push_back( rossler_equation_array[rossler_index].get_x() );
      rossler_y_buffer[rossler_index].push_back( rossler_equation_array[rossler_index].get_y() );
      rossler_z_buffer[rossler_index].push_back( rossler_equation_array[rossler_index].get_z() );
    }
  }
}

void draw() {
  background(0);
  noStroke();
  colorMode(RGB, 100);
  //background(100,0,100);
  for ( int rossler_index = 0; rossler_index < RosslerEquationSize; rossler_index++ ) {
    rossler_equation_array[rossler_index].update();
    //println("index: ", rossler_index, 
    //        ", x: ", rossler_equation_array[rossler_index].get_x(),
    //        ", y: ", rossler_equation_array[rossler_index].get_y(),
    //        ", z: ", rossler_equation_array[rossler_index].get_z() );
  }
    stroke( 255, 255, 255 );
    fill(  255, 255, 255 );
    textSize(20);
    text("X-Y-Z", 800, 30);
    text("Time-X", Display2D_ShiftTime-80, Display2D_ShiftX);
    text("Time-Y", Display2D_ShiftTime-80, Display2D_ShiftY);
    text("Time-Z", Display2D_ShiftTime-80, Display2D_ShiftZ);
    text("X-Y-Z", 800, 30);
    text("Rossler Equation", 510, 30);
    text("tau dx/dt = - y + z", 510, 60);
    text("tau dy/dt =    x + ay", 510, 80);
    text("tau dz/dt =    b + xz - cz", 510, 100);
    text("tau=", 510, 130);
    text(TimeConstant, 550, 130);
    text("a=", 510, 150);
    text(RosslerConstantA, 550, 150);
    text("b=", 510, 170);
    text(RosslerConstantB, 550, 170);
    text("c=", 510, 190);
    text(RosslerConstantC, 550, 190);

  for ( int rossler_index = 0; rossler_index < RosslerEquationSize; rossler_index++ ) {
//Plot Time-X
    for( int data_index = 0; data_index < RosslerBufferSize - 1; data_index++ ){
      stroke( color_map[rossler_index][0], 
              color_map[rossler_index][1], 
              color_map[rossler_index][2] );
      fill( color_map[rossler_index][0], 
            color_map[rossler_index][1], 
            color_map[rossler_index][2] );
      line( data_index*Display2D_ScaleTime+Display2D_ShiftTime,
            rossler_x_buffer[rossler_index].get_data( data_index )*Display2D_ScaleX+Display2D_ShiftX,
            (data_index + 1)*Display2D_ScaleTime+Display2D_ShiftTime,
            rossler_x_buffer[rossler_index].get_data( data_index + 1 )*Display2D_ScaleX+Display2D_ShiftX );
            
    }
    fill( color_map[rossler_index][0], 
          color_map[rossler_index][1], 
          color_map[rossler_index][2] );
    stroke( color_map[rossler_index][0],
            color_map[rossler_index][1], 
            color_map[rossler_index][2] );
    line( (RosslerBufferSize - 1)*Display2D_ScaleTime+Display2D_ShiftTime,
          rossler_x_buffer[rossler_index].get_data( RosslerBufferSize - 1 )*Display2D_ScaleX+Display2D_ShiftX,
          RosslerBufferSize*Display2D_ScaleTime+Display2D_ShiftTime,
          rossler_equation_array[rossler_index].get_x()*Display2D_ScaleX+Display2D_ShiftX );
                
            
    //Plot Time-Y
    for( int data_index = 0; data_index < RosslerBufferSize - 1; data_index++ ){
            
      fill( color_map[rossler_index][0], 
            color_map[rossler_index][1], 
            color_map[rossler_index][2] );
      stroke( color_map[rossler_index][0], 
              color_map[rossler_index][1], 
              color_map[rossler_index][2] );
      line( data_index*Display2D_ScaleTime+Display2D_ShiftTime,
            rossler_y_buffer[rossler_index].get_data( data_index )*Display2D_ScaleY+Display2D_ShiftY,
            (data_index + 1)*Display2D_ScaleTime+Display2D_ShiftTime,
            rossler_y_buffer[rossler_index].get_data( data_index + 1 )*Display2D_ScaleY+Display2D_ShiftY );
    }
                
    fill( color_map[rossler_index][0], 
          color_map[rossler_index][1], 
          color_map[rossler_index][2] );
    stroke( color_map[rossler_index][0],
            color_map[rossler_index][1], 
            color_map[rossler_index][2] );
    line( (RosslerBufferSize - 1)*Display2D_ScaleTime+Display2D_ShiftTime,
          rossler_y_buffer[rossler_index].get_data( RosslerBufferSize - 1 )*Display2D_ScaleY+Display2D_ShiftY,
          RosslerBufferSize*Display2D_ScaleTime+Display2D_ShiftTime,
          rossler_equation_array[rossler_index].get_y()*Display2D_ScaleY+Display2D_ShiftY );

    //Plot Time-Z

    for( int data_index = 0; data_index < RosslerBufferSize - 1; data_index++ ){
      fill( color_map[rossler_index][0], 
            color_map[rossler_index][1], 
            color_map[rossler_index][2] );
      stroke( color_map[rossler_index][0], 
              color_map[rossler_index][1], 
              color_map[rossler_index][2] );
      line( data_index*Display2D_ScaleTime+Display2D_ShiftTime,
            rossler_z_buffer[rossler_index].get_data( data_index )*Display2D_ScaleZ+Display2D_ShiftZ,
            (data_index + 1)*Display2D_ScaleTime+Display2D_ShiftTime,
            rossler_z_buffer[rossler_index].get_data( data_index + 1 )*Display2D_ScaleZ+Display2D_ShiftZ );
            
    }
                
    fill( color_map[rossler_index][0], 
          color_map[rossler_index][1], 
          color_map[rossler_index][2] );
    stroke( color_map[rossler_index][0],
            color_map[rossler_index][1], 
            color_map[rossler_index][2] );
    line( (RosslerBufferSize - 1)*Display2D_ScaleTime+Display2D_ShiftTime,
          rossler_z_buffer[rossler_index].get_data( RosslerBufferSize - 1 )*Display2D_ScaleZ+Display2D_ShiftZ,
          RosslerBufferSize*Display2D_ScaleTime+Display2D_ShiftTime,
          rossler_equation_array[rossler_index].get_z()*Display2D_ScaleZ+Display2D_ShiftZ );
            
  }



  translate( window_size_x/2, window_size_y/2);
  rotateY(radians(mouseX_dragged));
  rotateX(radians(mouseY_dragged)-PI*3.0/4);

  float boxSize = 5.0;
  for ( int rossler_index = 0; rossler_index < RosslerEquationSize; rossler_index++ ) {
    //println(rossler_index);
    pushMatrix();
    translate( rossler_equation_array[rossler_index].get_x()*Display3D_ScaleX+Display3D_ShiftX, 
               rossler_equation_array[rossler_index].get_y()*Display3D_ScaleY+Display3D_ShiftY, 
               rossler_equation_array[rossler_index].get_z()*Display3D_ScaleZ+Display3D_ShiftZ );
    fill( color_map[rossler_index][0], 
      color_map[rossler_index][1], 
      color_map[rossler_index][2] );
    stroke( color_map[rossler_index][0], 
      color_map[rossler_index][1], 
      color_map[rossler_index][2] );
    //fill(0, 0, rossler_index*10 );
    //stroke(0, 0, rossler_index*10 );

    box(boxSize, boxSize, boxSize);
    popMatrix();
    //println(bvp_neuron[neuron_index_x][neuron_index_y].get_membrane_potential());
  }



  for ( int rossler_index = 0; rossler_index < RosslerEquationSize; rossler_index++ ) {
    for( int data_index = 0; data_index < RosslerBufferSize - 1; data_index++ ){
      fill( color_map[rossler_index][0], 
            color_map[rossler_index][1], 
            color_map[rossler_index][2] );
      stroke( color_map[rossler_index][0], 
              color_map[rossler_index][1], 
              color_map[rossler_index][2] );
      line( rossler_x_buffer[rossler_index].get_data( data_index )*Display3D_ScaleX+Display3D_ShiftX,
            rossler_y_buffer[rossler_index].get_data( data_index )*Display3D_ScaleY+Display3D_ShiftY,
            rossler_z_buffer[rossler_index].get_data( data_index )*Display3D_ScaleZ+Display3D_ShiftZ,
            rossler_x_buffer[rossler_index].get_data( data_index + 1 )*Display3D_ScaleX+Display3D_ShiftX,
            rossler_y_buffer[rossler_index].get_data( data_index + 1 )*Display3D_ScaleY+Display3D_ShiftY,
            rossler_z_buffer[rossler_index].get_data( data_index + 1 )*Display3D_ScaleZ+Display3D_ShiftZ );
      
    }
                
    fill( color_map[rossler_index][0], 
          color_map[rossler_index][1], 
          color_map[rossler_index][2] );
    stroke( color_map[rossler_index][0],
            color_map[rossler_index][1], 
            color_map[rossler_index][2] );
    line( rossler_x_buffer[rossler_index].get_data( RosslerBufferSize - 1 )*Display3D_ScaleX+Display3D_ShiftX,
          rossler_y_buffer[rossler_index].get_data( RosslerBufferSize - 1 )*Display3D_ScaleY+Display3D_ShiftY,
          rossler_z_buffer[rossler_index].get_data( RosslerBufferSize - 1 )*Display3D_ScaleZ+Display3D_ShiftZ,
          rossler_equation_array[rossler_index].get_x()*Display3D_ScaleX+Display3D_ShiftX,
          rossler_equation_array[rossler_index].get_y()*Display3D_ScaleY+Display3D_ShiftY, 
          rossler_equation_array[rossler_index].get_z()*Display3D_ScaleZ+Display3D_ShiftZ );
  }



  for ( int rossler_index = 0; rossler_index < RosslerEquationSize; rossler_index++ ) { 
    rossler_x_buffer[rossler_index].push_back( rossler_equation_array[rossler_index].get_x() );
    rossler_y_buffer[rossler_index].push_back( rossler_equation_array[rossler_index].get_y() );
    rossler_z_buffer[rossler_index].push_back( rossler_equation_array[rossler_index].get_z() );
  }
  //saveFrame("frames/######.png");
}

void mousePressed() {
  mouseX_pressed = mouseX;
  mouseY_pressed = mouseY;
}
void mouseDragged() {
  mouseX_dragged += 0.01*(mouseX-mouseX_pressed);
  mouseY_dragged -= 0.01*(mouseY-mouseY_pressed);
}