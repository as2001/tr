public class TBullet extends Bullet {
  
  private int _dmg;
  
  public TBullet( int dmg, float bearing, float x, float y) {
    super( true, bearing, 10, x, y, color( 95, 0, 180 ) );
    _dmg = dmg;
  }
  
  public int getDamage() {
    return _dmg;
  }
  
  public boolean hitMinion( Minion m ) {
    return distanceTo( m ) <= 12.5;
  }
  
}
