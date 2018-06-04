public class MBullet extends Bullet {
  
  public MBullet( float targetX, float targetY, float x, float y ) {
    super( false, targetX, targetY, 2.5, x, y, color( 255, 200, 200 ) );
  }
  
  public boolean hitTeemo( Teemo t ) {
    return distanceTo( t ) <= 14.5;
  }
  
}
