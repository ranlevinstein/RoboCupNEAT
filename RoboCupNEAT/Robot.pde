    
    public class Robot{
    Box2DProcessing box2d;
    Body body;
    public float _x;
    public float _y;
    public float _theta;
    public final float _l;
    public final float _r;
    public final float _goalX;
    public final float _goalY;
    public final float _ownGoalX;
    public final float _ownGoalY;
    public boolean recentlyRedy;
    public boolean isDead;
    public float kickPower;
    PApplet _obj;
    Robot(float x, float y, float theta, float l, float r, float goalX, float goalY, Box2DProcessing box2d, float kickPower, float myGoalX, float myGoalY){
      _ownGoalX = myGoalX;
      _ownGoalY = myGoalY;
      _l = l;
      _r = r;
      _x = x;
      _y = y;
      _goalX = goalX;
      _goalY = goalY;
      _theta = theta%360;
      this.box2d = box2d;
      makeBody(new Vec2(x, y), _theta);
      recentlyRedy = false;
      isDead = false;
      this.kickPower = kickPower;
    }
    
    public void kick(Ball ball){
     if(holdsBall(ball.getX(), ball.getY()) && !isDead){
       float vx = cos(radians(_theta-90)) * kickPower;
       float vy = sin(radians(_theta-90)) * kickPower;
       float ovx = ball.body.getLinearVelocity().x;
       float ovy = ball.body.getLinearVelocity().y;
       ball.body.setLinearVelocity(new Vec2(ovx+vx, ovy+vy));
     }
    }
    
    void makeBody(Vec2 center, float angle) {

    // Define the body and make it from the shape
    
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    //println(box2d.coordPixelsToWorld(center).x);//y -16 - +16 x -22.71 - +22.71
    bd.position.set(box2d.coordPixelsToWorld(center));
    bd.angle = radians(angle);
    body = box2d.createBody(bd);
    float xSizeFix = 1.25;
    float ySizeFix = 1.25;
    PolygonShape sd = new PolygonShape();
    Vec2[] vertices = new Vec2[3];
    vertices[0] = box2d.vectorPixelsToWorld(new Vec2(18*xSizeFix, -31*ySizeFix));
    vertices[1] = box2d.vectorPixelsToWorld(new Vec2(36*xSizeFix, 0));
    vertices[2] = box2d.vectorPixelsToWorld(new Vec2(18*xSizeFix, 31*ySizeFix));
    sd.set(vertices, vertices.length);
    body.createFixture(sd,1.0);
    PolygonShape left = new PolygonShape();
    Vec2[] leftVertices = new Vec2[3];
    leftVertices[0] = box2d.vectorPixelsToWorld(new Vec2(-18*xSizeFix, -31*ySizeFix));
    leftVertices[1] = box2d.vectorPixelsToWorld(new Vec2(-18*xSizeFix, 31*ySizeFix));
    leftVertices[2] = box2d.vectorPixelsToWorld(new Vec2(-36*xSizeFix, 0));
    left.set(leftVertices, leftVertices.length);
    body.createFixture(left,1.0);
    PolygonShape rect = new PolygonShape();
    Vec2[] rectVertices = new Vec2[4];
    rectVertices[0] = box2d.vectorPixelsToWorld(new Vec2(-19*xSizeFix, -31*ySizeFix));
    rectVertices[1] = box2d.vectorPixelsToWorld(new Vec2(19*xSizeFix, -31*ySizeFix));
    rectVertices[2] = box2d.vectorPixelsToWorld(new Vec2(19*xSizeFix, 19*ySizeFix));
    rectVertices[3] = box2d.vectorPixelsToWorld(new Vec2(-19*xSizeFix, 19*ySizeFix));
    rect.set(rectVertices, rectVertices.length);
    body.createFixture(rect,1.0);
    // Give it some initial random velocity
    body.setUserData("Robot");
  }
    
    public void setPosition(float x, float y, float angle){
       body.setTransform(box2d.coordPixelsToWorld(x,y), radians(angle));
    }
    
    
    
    
    public void move(float s1, float s2, float s3, float s4){//speeds for each motor.
    if(!isDead){
      //motor 1 is left up motor 2 is right down motor 3 is right motor 4 is left down
      float dx = (_r/2)*(s1+s2) * cos(radians(_theta-45)) + (_r/2)*(s3+s4) * cos(radians(_theta+45));
      float dy = (_r/2)*(s1+s2) * sin(radians(_theta-45)) + (_r/2)*(s3+s4) * sin(radians(_theta+45));   
      dy *=-1;//fix for the robot model... i think it's related to the robot's angle
      float dTheta = (_r/_l) * (s1-s2) + (_r/_l) * (s3-s4);
      //_x += (_r/2)*(s1+s2) * cos(radians(_theta-45)) + (_r/2)*(s3+s4) * cos(radians(_theta+45));
      //_y += (_r/2)*(s1+s2) * sin(radians(_theta-45)) + (_r/2)*(s3+s4) * sin(radians(_theta+45));
      //_theta += (_r/_l) * (s1-s2) + (_r/_l) * (s3-s4);
      //display();
      body.setLinearVelocity(new Vec2(dx, dy));
      body.setAngularVelocity(dTheta);
      _x = box2d.getBodyPixelCoord(body).x;
      _y = box2d.getBodyPixelCoord(body).y;
      _theta = degrees(body.getAngle());
       //println(_theta);
       //_theta = _poly.getRotation();
    }else{
      body.setLinearVelocity(new Vec2(0, 0));
      body.setAngularVelocity(0);
      _x = box2d.getBodyPixelCoord(body).x;
      _y = box2d.getBodyPixelCoord(body).y;
    }
    }
    
    
    
    float getVelocityX(){
      return body.getLinearVelocity().x;
    }
    
    float getVelocityY(){
      return body.getLinearVelocity().y;
    }
    
    

    private float fixAngle(){
     if(_theta > 0) return _theta % 360; 
     else return 360-(_theta% 360) ; 
    }
    
    
     private void wait(float millis){
      float start = millis();
      while (millis()-start < millis){}
    }
    
    
    public boolean holdsBall(float x, float y){
      return sqrt((_x-x)*(_x-x)+(_y-y)*(_y-y)) < 44+7.4;  
    }
    
    
    
    // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
    isDead = true;
  }
  
    void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    noStroke();
    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(120, 30, 90);
    
    //Fixture f = body.getFixtureList();
    //f= f.getNext();
    for(Fixture f = body.getFixtureList(); f != null; f = f.getNext()){
    PolygonShape ps = (PolygonShape) f.getShape();
    //println(vertices.length);
    // For every vertex, convert  pixel vector
    beginShape();
    for (int i = 0; i < ps.getVertexCount(); i++) {
      Vec2 v = box2d.vectorWorldToPixels(ps.getVertex(i));
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    }
    
    popMatrix();
    
  }

    
    
  }
