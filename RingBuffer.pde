//---------------------------------------------------
//|  empty  |  empty  |  empty  |  empty  |  empty  |
//  ^     ^
//  |     |
// betin end
// empty == true
// size = 0
//===================================================
//|  data0  |  data1  |  empty  |  empty  |  empty  |
//    ^                    ^
//    |                    |
//   begin                end
// empty == false
// size = 2
//===================================================
//|  empty  |  empty  |  empty  |  data3  |  data4  |
//    ^                              ^
//    |                              |
//   end                           begin
// empty == false
// size = 2
//===================================================
//|  data5  |  data6  |  data7  |  data3  |  data4  |
//                                ^    ^
//                                |    |
//                               end begin
// empty == false
// size = 5
//---------------------------------------------------

class RingBufferFloat{

  int BufferSize;
  int begin_pointer;
  int end_pointer;
  int data_size;
  float[] data;

  RingBufferFloat(){
    BufferSize = 0;
    begin_pointer = 0;
    end_pointer = 0;
    data_size = 0;
    //data;
  }
  RingBufferFloat( int max_data_size ){
    BufferSize = max_data_size;
     begin_pointer = 0;
     end_pointer = 0;
     data_size = 0;
     data = new float[ BufferSize ];
   }
  RingBufferFloat( int max_data_size, float value ){
    BufferSize = max_data_size;
     begin_pointer = 0;
     end_pointer = 0;
     data_size = 0;
     data = new float[ BufferSize ];
     for( int i = 0; i < BufferSize; i++ ){
       data[i] = value;
     }
   }
  RingBufferFloat( RingBufferFloat lq ){
    BufferSize = lq.BufferSize;
    begin_pointer = lq.begin_pointer;
     end_pointer = lq.end_pointer;
     data_size = lq.data_size;
     data = lq.data;
    
    //this->data = lq.data;
  }

  int size(){
    return data_size;
  }

  float get_data( int place ){
    int p = 0;
    if( 0 <= place ){
      p = ( begin_pointer + place ) % BufferSize;
    }else{
      p = ( end_pointer + place ) % BufferSize;
      if( p < 0 ){
        p = p + BufferSize;
      }
    }
    return data[ p ];
  }
 
  void push_front( float value ){
    begin_pointer--; if( begin_pointer < 0 ) begin_pointer += BufferSize;
    data[ begin_pointer ] = value;

    if( 0 < data_size && data_size == BufferSize ) end_pointer = begin_pointer;
    else                                           data_size++;
  }

  void push_back( float value ){
    data[ end_pointer ] = value;
    
    end_pointer = (end_pointer + 1) % BufferSize;
    if( 0 < data_size && data_size == BufferSize ) begin_pointer = end_pointer;
    else                                           data_size++;
  }

  float pop_front(){
    if( 0 == data_size ) return float( 0 );

    int data_place = begin_pointer;
    begin_pointer = (begin_pointer + 1) % BufferSize;

    data_size--;
    return data[ data_place ];
  }

  float pop_back(){
    if( 0 == data_size ) return float( 0 );

    end_pointer--; if( end_pointer < 0 ) end_pointer += BufferSize;

    data_size--;
    return data[ end_pointer ];
  }

  float front(){
    if( 0 == data_size ) return float(0);
    return data[ begin_pointer ];
  }

  float back(){
    if( 0 == data_size ) return float(0);
    int data_place = end_pointer - 1;
    if( data_place < 0 ) data_place += BufferSize;
   
    return data[ data_place ];
  }

  Boolean is_empty(){
    return (0 == data_size);
  }

  void print(){
    for( int i = 0; i < data_size; i++ ){
      println( this.get_data( i ) );
    }
  }
}