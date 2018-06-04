public class Minion extends Unit {

  private int _health, _attackSpeed;
  private float _speed, _bearing, _r;

  public Minion( int health, float bearing, float x, float y ) {
    super( x, y, 8, createShape( ELLIPSE, 0, 0, 16, 16 ), color( 110, 0, 0 ) );
    _health = health;
    _attackSpeed = 360;
    super.setTime( _attackSpeed / 2 );
    _speed = 1;
    _bearing = bearing;
    _r = 8;
  }

  public float getBearing() {
    return _bearing;
  }
  
  public boolean attackReady() {
    return super.getTime() == 0;
  }
  
  public void attackReset() {
    super.setTime( _attackSpeed );
  }

  public void hit( TBullet b ) {
    _health -= b.getDamage();
  }

  public boolean isAlive() {
    return _health > 0;
  }
  
  public boolean touching( Teemo t ) {
    return distanceTo( t ) <= 18;
  }

  public void move() {
    super.move( _bearing, _speed);
    if ( super.outOfBounds() ) {
      super.move( _bearing + PI, _speed );
      _bearing += HALF_PI;
      super.move( _bearing, _speed);
      if ( super.outOfBounds() ) {
        super.move( _bearing + PI, _speed );
        _bearing -= PI;
        super.move( _bearing, _speed);
      }
    }
  }

  public MBullet shoot( float x, float y ) {
    x += 1800 * (x - getX());
    y += 1800 * (y - getY());
    attackReset();
    return new MBullet( x, y, getX(), getY() );
  }
  
}
