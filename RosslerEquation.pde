class RosslerEquation {
  float ConstantA;
  float ConstantB;
  float ConstantC;

  float InitialX;
  float InitialY;
  float InitialZ;

  float x;
  float y;
  float z;

  float TimeConstant;
  float delta_t;

  RosslerEquation() {
    ConstantA=0.2;
    ConstantB=0.2;
    ConstantC=5.7;


    InitialX=0.0;
    InitialY=0.0;
    InitialZ=0.0;

    x=0.0;
    y=0.0;
    z=0.0;

    TimeConstant = 1.0;
    delta_t=0.01;
  }


  void update() {
    x += diff_x()*delta_t;
    y += diff_y()*delta_t;
    z += diff_z()*delta_t;
  }
  void set_initial_states( float initial_x, float initial_y, float initial_z ) {
    InitialX = initial_x;
    InitialY = initial_y;
    InitialZ = initial_z;
  }

  void set_parameters( float delta_T, 
    float time_constant, 
    float constant_a, 
    float constant_b, 
    float constant_c ) {
    delta_t = delta_T;
    TimeConstant = time_constant;
    ConstantA = constant_a;
    ConstantB = constant_b;
    ConstantC = constant_c;
  }


  float get_x() {
    return x;
  }
  float get_y() {
    return y;
  }
  float get_z() {
    return z;
  }
  void reset() {
    x = InitialX;
    y = InitialY;
    z = InitialZ;
  }

  float diff_x() {
    //std::cout << "ref" << std::endl;
    return (- y - z)/TimeConstant;
  }
  float diff_y() {
    return (x + ConstantA * y)/TimeConstant;
  }
  float diff_z() {
    return (ConstantB + x * z - ConstantC * z)/TimeConstant;
  }
}