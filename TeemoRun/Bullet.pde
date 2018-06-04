public class Bullet extends Unit {
  
  private boolean _friendly;
  private float _targetX, _targetY, _bearing;
  private float _speed;
  private int _firingMode;
  
  private Bullet( boolean friendly, float speed, float x, float y, color c ) {
    super( x, y, 4.5, createShape( ELLIPSE, 0, 0, 9, 9 ), c );
    _friendly = friendly;
    _speed = speed;
  }
  
  public Bullet( boolean friendly, float bearing, float speed, float x, float y, color c ) {
    this( friendly, speed, x, y, c );
    _bearing = bearing;
    _firingMode = 0;
  }
  
  public Bullet( boolean friendly, float targetX, float targetY, float speed, float x, float y, color c ) {
    this( friendly, speed, x, y, c );
    _targetX = targetX;
    _targetY = targetY;
    _firingMode = 1;
  }
  
  public boolean friendly() {
    return _friendly;
  }
  
  public void move() {
    if ( _firingMode == 0 ) {
      super.move( _bearing, _speed );
    }
    else {
      super.move( _targetX, _targetY, _speed );
    }
  }
  
}
