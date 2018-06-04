public class Coin extends Item {
  
  private int _value;
 
  public Coin( int size, float x, float y ) {
    super( x, y, createShape( RECT, 0, 0, size, size ), color( 255, 215, 0) );
    if ( size == 12 ) {
      _value = 20;
    }
    if ( size == 10 ) {
      _value = 10;
    }
    else {
      _value = 5;
    }
  }
  
  public int getValue() {
    return _value;
  }
  
}
