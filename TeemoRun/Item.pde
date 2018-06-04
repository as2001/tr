public class Item extends Unit {
  
  private int _despawnTime;
  private float _speed;
 
  public Item( float x, float y, PShape s, color c ) {
    super( x, y, 12, s, c );
    _despawnTime = 6 * (int)frameRate;
    super.setTime( _despawnTime );
    _speed = 0;
  }
  
  public boolean despawnReady() {
    return super.getTime() == 0;
  }
  
  public void move( Teemo t ) {
    _speed = pow( 0.5, distanceTo( t ) / 50 ) * 10;
    move( t.getX(), t.getY(), _speed );
  }
  
}
