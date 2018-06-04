public class Teemo extends Unit { //<>//
  
  private int _dmg, _attackSpeed, _score;
  private float _speed, _r;
  private Queue<Ability> _abilities;
  private int[] _abilityDurations; 
  
  public Teemo() {
    super( 700, 400, 10, createShape( ELLIPSE, 0, 0, 20, 20 ), color( 0, 175, 0 ) );
    _dmg = 10;
    _attackSpeed = 60;
    super.setTime( 1 );
    _score = 0;
    _speed = 1.5;
    _r = 10;
    _abilities = new Queue();
    _abilityDurations = new int[8];
  }
  
  public void move( int direction ) {
    float msMultiplier = 1;
    if ( _abilityDurations[4] > 0 ) {
      msMultiplier += 1;
    }
    if ( _abilityDurations[0] > 0 ) {
      msMultiplier *= 2;
    }
    super.move( direction * QUARTER_PI, _speed * msMultiplier );
    if ( outOfBounds() ) {
      super.move( direction * QUARTER_PI + PI, _speed * msMultiplier );
    }
  }
  
  public boolean attackReady() {
    return super.getTime() == 0;
  }
  
  public boolean isBoosted() {
    return _abilityDurations[0] > 0;
  }
  
  public boolean isMagnetized() {
    return _abilityDurations[2] > 0;
  }
  
  public void attackReset() {
    if ( _abilityDurations[6] > 0 ) {
      super.setTime( _attackSpeed / 2 );
    }
    else {
      super.setTime( _attackSpeed );
    }
  }
  
  public int score( int time ) {
    _score += time;
    return _score;
  }
  
  public TBullet[] shoot( float x, float y ) {
    float dy = super.getY() - y;
    float dx = x - super.getX();
    float bearing;
    float dmgMultiplier = 1;
    TBullet[] retArr;
    if ( _abilityDurations[5] > 0 ) {
      retArr = new TBullet[3];
    }
    else {
      retArr = new TBullet[1];
    }
    if ( dx >= 0 ) {
      if ( dy == 0 ) {
        bearing = 0;
      }
      else {
        bearing = atan( dy / dx );
      }
    }
    else {
      if ( dy == 0 ) {
        bearing = PI;
      }
      else {
        bearing = atan( dy / dx ) + PI;
      }
    }
    if ( _abilityDurations[1] > 0 ) {
      dmgMultiplier *= 2;
    }
    if ( _abilityDurations[0] > 0 ) {
      dmgMultiplier = 10000;
    }
    attackReset();
    retArr[0] = new TBullet( (int)(_dmg * dmgMultiplier), bearing, super.getX() + (_r + 4.5) * cos( bearing ), super.getY() - (_r + 4.5) * sin( bearing ) );     
    if ( _abilityDurations[5] > 0 ) {
      retArr[1] = new TBullet( (int)(_dmg * dmgMultiplier), bearing + PI/6, super.getX() + (_r + 4.5) * cos( bearing ), super.getY() - (_r + 4.5) * sin( bearing ) );
      retArr[2] = new TBullet( (int)(_dmg * dmgMultiplier), bearing - PI/6, super.getX() + (_r + 4.5) * cos( bearing ), super.getY() - (_r + 4.5) * sin( bearing ) );
    }
    return retArr;
  }
  
  public void pickUp( Item i ) {
    if ( i instanceof Coin ) {
      Coin c = (Coin)i;
      _score += c.getValue();
    }
    else {
      Ability a = (Ability)i;
      _abilities.enqueue( a );
    }
  }
  
  public void use() {
    if ( _abilities.isEmpty() ) {
      return;
    }
    Ability a = _abilities.dequeue();
    int type = a.getType();    
    if ( type == 0 ) {
      _abilityDurations[0] += 5 * (int)frameRate;
    }
    if ( type == 1 ) {
      _abilityDurations[1] += 20 * (int)frameRate;
    }
    if ( type == 2 ) {
      _abilityDurations[2] += 20 * (int)frameRate;
    }
    if ( type == 3 ) {
      _dmg += 10;
    }
    if ( type == 4 ) {
      _abilityDurations[4] += 15 * (int)frameRate;
    }
    if ( type == 5 ) {
      _abilityDurations[5] += 5 * (int)frameRate;
    }
    if ( type == 6 ) {
      _abilityDurations[6] += 20 * (int)frameRate;
    }
    if ( type == 7 ) {
      _attackSpeed *= 0.8; 
    }
  }
  
  public void tick() {
    super.tick();
    for( int i = 0; i < _abilityDurations.length; i++ ) {
      if ( _abilityDurations[i] > 0 ) {
        _abilityDurations[i]--;
      }
    }
  }
  
  public void spawn() {
    if ( _abilityDurations[0] > 0 ) {
      fill( 255, 255, 255 );
      shape( createShape( ELLIPSE, 0, 0, 20, 20 ), getX(), getY() );
    }
    else {
      super.spawn();
    }
  }
  
}
