public class Unit {
  
  private float _x, _y, _r;//position, radius
  private PShape _s;
  private int _time;
  
  public Unit( float x, float y, float r, PShape s, color c ) {
    _x = x;
    _y = y;
    _r = r;
    _s = s;
    _s.setFill( c );
  }
  
  public float getX() {
    return _x;
  }
  
  public float getY() {
    return _y;
  }
  
  public int getTime() {
    return _time;
  }
  
  public boolean outOfBounds() {//out of play area?
    return _x < 0 + _r || _x > 1400 - _r || _y < 0 + _r  || _y > 800 - _r;
  }
  
  public float distanceTo( Unit u ) {
    return sqrt( sq( u.getX() - this.getX() ) + sq( u.getY() - this.getY() ) );
  }
  
  public void setTime( int t ) {
    _time = t;
  }
  
  public void tick() {
    if ( _time > 0 ) {
      _time--;
    }
  }
  
  private void moveH( float x, float y ) {
    _x += x;
    _y += y;
  }
  
  public void move( float x, float y, float speed ) {
    moveH( speed * (x - _x) / sqrt( sq( x - _x ) + sq( y - _y ) ), speed * (y - _y) / sqrt( sq( x - _x ) + sq( y - _y ) ) );
  }
  
  public void move( float bearing, float speed ) {
    moveH( speed * cos( bearing ), speed * -sin( bearing ) );
  }  
  
  public void spawn() {
    rectMode( CENTER );    
    shape( _s, _x, _y );
  }
  
}
