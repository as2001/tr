//variables to aid with controls
boolean[] _keys;  //true = key currently pressed down  0:W 1:A 2:S 3:D 4:SPACE 5:ESCAPE
boolean _mouse; //true = mouse currently pressed down
boolean _spaceLock; //makes sure holding down space isn't read as space pressed repeatedly

//stores on-screen entities
Teemo _t;
ArrayList<Bullet> _bullets;
ArrayList<Minion> _minions;
ArrayList<Item> _items;

//stores all non player controlled on-screen entities
ArrayList<ArrayList> _units;

//variables related to game events
int _minionSpawnTime, _minionSpawnTimer, _dropSpawnTime, _dropSpawnTimer, _minionHealth;
float _minionSpawnRate, _dropSpawnRate, _abilitySpawnRate;


void setup() {

  frameRate( 120 );//120fps :O
  size( 1400, 800 );

  _keys = new boolean[6];

  //initialize Teemo
  _t = new Teemo();

  _bullets = new ArrayList();
  _minions = new ArrayList();
  _items = new ArrayList();

  _units = new ArrayList();
  _units.add( _bullets );
  _units.add( _minions );  
  _units.add( _items );

  //initialize values
  _minionSpawnTime = _minionSpawnTimer = 120;//frames between checking to spawn minions or not; frames before next check
  _dropSpawnTime = _dropSpawnTimer = 360;//frames between checking to spawn drop or not; frames before next check
  _minionHealth = 10;//minion health
  _minionSpawnRate = 0.5;//odds of spawning a minion during a check
  _dropSpawnRate = 0.5;//odds of spawning a drop during a check
  _abilitySpawnRate = 0.5;//odds of spawning ability instead of coin

  //start game with 1 minion on screen, OPTIONAL
  addNewMinion();  
}

//helper methods
void addNewMinion() {//spawns in new minion at random location
  float tmpX, tmpY;
  tmpX = random( 1384 ) + 8;
  tmpY = random( 784 ) + 8;
  while ( sq( tmpX - _t.getX() ) + sq( tmpY - _t.getY() ) < 250000 ) {//forces location to be certain distance away from Teemo
    tmpX = random( 1388 ) + 8;
    tmpY = random( 788 ) + 8;
  }
  _minions.add( new Minion( _minionHealth, random( 360 ), tmpX, tmpY ) );
}

void addNewAbility( float x, float y ) {//spawns in new ability drop at (x,y)
  float n = random( 100 );
  color tmp;
  if ( n < 9 ) {//9-0% (9) chance
    tmp = color( 255, 0, 0 );//red: boost
  } else if ( n < 24 ) {//24-9% (15) chance
    tmp = color( 255, 125, 0 );//orange: twin
  } else if ( n < 34 ) {//34-24% (10) chance
    tmp = color( 255, 255, 0 );//yellow: magnet
  } else if ( n < 42 ) {//42-34% (8) chance
    tmp = color( 0, 255, 0 );//green: damage upgrade
  } else if ( n < 62 ) {//62-42% (20) chance
    tmp = color( 0, 255, 255 );//light blue: ghost
  } else if ( n < 77 ) {//77-62% (15) chance
    tmp = color( 0, 0, 255 );//dark blue: trident
  } else if ( n < 92 ) {//92-77% (15) chance
    tmp = color( 175, 0, 255 );//purple: rage
  } else {//100-92% (8) chance
    tmp = color( 255, 0, 200 );//pink: attack speed upgrade
  }
  _items.add( new Ability( x, y, tmp ) );
}

void addNewCoin( float x, float y ) {//spawns in new coin drop
  _items.add( new Coin( ceil( random( 3 ) ) * 2 + 6, x, y ) );
}

void gameOver() {//oh no
  clear();
  textSize( 64 );//font size
  rectMode( CENTER );//uh idk
  text( "GAME OVER", 700, 400, 900, 200 );
  textSize( 16 );//font size
  text( "Score: " + _t.score( frameCount / 5 ), 700, 700, 900, 200);
  noLoop();//stops calling draw
}


void draw() {

  clear();//IMPORTANT

  if ( keyPressed ) {
    if ( _keys[4] ) {//space pressed
      _t.use();
    } else if ( _keys[0] ) {
      if ( _keys[1] ) {//W & A
        _t.move( 3 );//up & left
      } else if ( _keys[3] ) {//W & D
        _t.move( 1 );//up & right
      } else {//only W
        _t.move( 2 );//up
      }
    } else if ( _keys[2] ) {
      if ( _keys[1] ) {//S & A
        _t.move( 5 );//down & left
      } else if ( _keys[3] ) {//S & D
        _t.move( 7 );//down & right
      } else {//only S
        _t.move( 6 );//down
      }
    } else if ( _keys[1] ) {//only A
      _t.move( 4 );//left
    } else {//only D
      _t.move( 0 );//right
    }
  }  

  //"You may fire when ready"
  if ( _mouse && _t.attackReady() ) {//mouse has been clicked/held down AND Teemo ready to fire
    for ( Bullet b : _t.shoot( mouseX, mouseY ) ) {//shoot at mouse location
      _bullets.add( b );//spawns bullet
    }
  }

  //check all minions
  for ( int i = _minions.size() - 1; i >= 0; i-- ) {
    _minions.get( i ).move();//move minion forward
    if ( _minions.get( i ).attackReady() ) {//check if minion is ready to shoot
      _bullets.add( _minions.get( i ).shoot( _t.getX(), _t.getY() ) );//minion shoots, bullet spawned
    }
    if ( _minions.get( i ).touching( _t ) ) {//check if minion is touching Teemo
      if ( _t.isBoosted() ) {//check if Teemo invulnerable
        _minions.remove( i );//rekt
      } else {
        gameOver();//not rekt
      }
    }
  }

  TBullet tmpTB;//temporary storage for Teemo bullets
  MBullet tmpMB;//temporary storage for minion bullets
  for ( int i = _bullets.size() - 1; i >= 0; i-- ) {//check all bullets
    if ( _bullets.get( i ).friendly() ) {//bullet is a Teemo bullet
      tmpTB = (TBullet)_bullets.get( i );
      for ( int j = _minions.size() - 1; j >= 0; j-- ) {//check all minions
        if ( tmpTB.hitMinion( _minions.get( j ) ) ) {//check if bullet hit minion
          _minions.get( j ).hit( tmpTB );//deduct health
          if ( !_minions.get( j ).isAlive() ) {//if hit was fatal
            if ( _dropSpawnTimer == 0 ) {//ready to check to spawn a drop or not
              if ( random( 1 ) < _dropSpawnRate ) {//check to spawn a drop
                if ( random( 1 ) < _abilitySpawnRate ) {//ability drop
                  addNewAbility( _minions.get( j ).getX(), _minions.get( j ).getY() - 6 );
                } else {//coin drop
                  addNewCoin( _minions.get( j ).getX() - 6, _minions.get( j ).getY() - 6 );
                }
              }
              _dropSpawnTimer = _dropSpawnTime;//reset timer
            }
            _minions.remove( j );//despawn minion if killed
          }
          _bullets.remove( i );//despawn bullet if hit
          break;//IMPORTANT! move to next bullet
        }
      }
    } else {
      tmpMB = (MBullet)_bullets.get( i );
      if ( tmpMB.hitTeemo( _t ) && !_t.isBoosted() ) {//man down
        gameOver();//mama mia
        break;
      }
    }
  }
  for ( int i = _bullets.size() - 1; i >= 0; i-- ) {//check all bullets
    if ( _bullets.get( i ).outOfBounds() ) {//check if bullet out of play area
      _bullets.remove( i );//despawn bullet
    } else {//otherwise keep moving bullet
      _bullets.get( i ).move();
    }
  }

  //check all items
  for ( int i = _items.size() - 1; i >= 0; i-- ) {
    if ( _items.get( i ).despawnReady() ) {//check if time to despawn item
      _items.remove( i );//despawn item
    }
  }

  if ( _minionSpawnTimer == 0) {//check if time to check to spawn minion or not
    if ( random( 1 ) < _minionSpawnRate ) {//check whether to spawn minion
      addNewMinion();//spawn new minion
    }
    _minionSpawnTimer = _minionSpawnTime;//reset minion spawn timer
  }

  //check all items
  for ( int i = _items.size() - 1; i >= 0; i-- ) {
    if ( _t.distanceTo( _items.get( i ) ) <= 12 ) {//if Teemo is next to or on top of item
      _t.pickUp( _items.get( i ) );//Teemo picks up item
      _items.remove( i );//despawns item
    } else if ( _t.isMagnetized() ) {//Teemo has magnet ability active
      _items.get( i ).move( _t );//items move toward Teemo
    }
  }

  for ( ArrayList<Unit> A : _units ) {
    for ( Unit u : A ) {
      u.spawn();//draw all entities
      u.tick();//indicate frame has passed
    }
  }
  _t.spawn();//draw Teemo
  _t.tick();  

  if ( _minionSpawnTimer > 0 ) {//decrement minion spawning timer for passage of time
    if ( _minions.isEmpty() && _minionSpawnTimer > 1 ) {//spawn timer is faster when no minions left
      _minionSpawnTimer --;
    }
    _minionSpawnTimer--;
  }

  if ( _dropSpawnTimer > 0 ) {//decrease drop spawning timer for passage of time
    _dropSpawnTimer--;
  }
}

void keyPressed() {
  if ( key == CODED ) {//esc
    _keys[5] = true;
  } else {
    if ( key == 'w' ) {
      _keys[0] = true;
    } else if ( key == 'a' ) {
      _keys[1] = true;
    } else if ( key == 's' ) {
      _keys[2] = true;
    } else if ( key == 'd' ) {
      _keys[3] = true;
    } else {
      if ( !_spaceLock ) {//space has been released/not pressed
        _keys[4] = true;
        _spaceLock = true;
      }
    }
  }
}

void keyReleased() {
  if ( key == CODED ) {//esc
    _keys[5] = false;
  } else {
    if ( key == 'w' ) {
      _keys[0] = false;
    } else if ( key == 'a' ) {
      _keys[1] = false;
    } else if ( key == 's' ) {
      _keys[2] = false;
    } else if ( key == 'd' ) {
      _keys[3] = false;
    } else {
      _keys[4] = false;
      _spaceLock = false;//space ready to be pressed again
    }
  }
}

void mousePressed() {
  _mouse = true;
}

void mouseReleased() {
  _mouse = false;
}
