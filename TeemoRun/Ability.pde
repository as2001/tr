public class Ability extends Item {
  
  private int _type;
  private String _name;
  
  public Ability( float x, float y, color c ) {
    super( x , y, createShape( TRIANGLE, 6, sqrt( sq( 12 ) - sq( 6 ) ), 0, 0, 12, 0 ), c );
    if ( c == color( 255, 0, 0 ) ) {
      _type = 0;
      _name = "Boost";
    }
    else if ( c == color( 255, 125, 0 ) ) {
      _type = 1;
      _name = "Twin";
    }
    else if ( c == color( 255, 255, 0 ) ) {
      _type = 2;
      _name = "Magnet";
    }
    else if ( c == color( 0, 255, 0 ) ) {
      _type = 3;
      _name = "Damage Upgrade";
    }
    else if ( c == color( 0, 255, 255 ) ) {
      _type = 4;
      _name = "Ghost";
    }
    else if ( c == color( 0, 0, 255 ) ) {
      _type = 5;
      _name = "Trident";
    }
    else if ( c == color( 175, 0, 255 ) ) {
      _type = 6;
      _name = "Rage";
    }
    else {
      _type = 7;
      _name = "Attack Speed Upgrade";
    }
  }
  
  public int getType() {
    return _type;
  }
  
  public String getName() {
    return _name;
  }
  
}
