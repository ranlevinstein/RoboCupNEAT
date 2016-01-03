

public class Simulator{
  Box2DProcessing box2d;

  ArrayList<Boundary> boundaries;
  Robot robot;
  Robot robot1;
  int goalsYellow;
  int goalsBlue;
  int steps;
  int stepsFromLastGoal = 0;
  int ties;
  boolean recentlyRedy;
  boolean needToInit = false;
  int lastWin = 0;//0 tie 1 blue 2 yellow
  int totalSteps = 0;
  Ball ball;
  
  
  public Simulator(PApplet p){
  smooth();
  size(244*4, 182*4);
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(p,20);
  box2d.createWorld();
  box2d.listenForCollisions();
  box2d.setGravity(0, 0);
  boundaries = new ArrayList<Boundary>();
  color boundariesColor = color(0, 0, 0);
  boundaries.add(new Boundary(width,height/2,5,height,0,boundariesColor, "Boundary", box2d));
  boundaries.add(new Boundary(0,height/2,5,height,0,boundariesColor, "Boundary",box2d));
  boundaries.add(new Boundary(0, 0,width*2,5,0,boundariesColor, "Boundary", box2d));
  boundaries.add(new Boundary(0, height-0,width*2,5,0,boundariesColor, "Boundary", box2d));
  
    ties = 0;
    stepsFromLastGoal = 0;
    steps = 0;
    goalsYellow = 0;
    goalsBlue = 0;
    recentlyRedy = false;
    
    smooth();
    mouseX = 500;
    mouseY = 500;
    robot = new Robot(244*2-250, 182*2, 90, 90, 2, 870.8, 364, box2d, 1, 105.2, 364);
    robot1 = new Robot(244*2+250, 182*2, -90, 90, 2, 105.2, 364, box2d, 1, 870.8, 364);
    createBlueGoal(105.2, 364);
    createYellowGoal(870.8, 364);
    createBall(random(width-(240*3), 240*3), random(height-(200*3), 200*3));

  }
  
  public void init(){
      needToInit = false;
      ball.setPosition(random(width-(240*3), 240*3), random(height-(200*3), 200*3));
      //ball.setPosition(random(240*2, 240*3), random(height-(200*3), 200*3));
      //ball.setPosition(random(240, 240 *1.4), random(height-(200*3), 200*3));
      //ball.setPosition(200*2, 182*2);
      ball.body.setLinearVelocity(new Vec2(0, 0));
      robot.setPosition(244*2-250, 182*2, 90);
      robot1.setPosition(100, 100, 0);
      //robot1.setPosition(244*2+250, 182*2, -90);
      steps = 0;
      //robot = new Robot(244*2-250, 182*2, 90, 90, 2, 870.8, 364, box2d);
      //robot1 = new Robot(244*2+250, 182*2, 0, 90, 2, 105.2, 364, box2d);
      robot.isDead = false;
      robot1.isDead = false;
      
  }
  public void step(){
    if(steps > 2500){//1250 for normal game
      steps = 0;
      ties++;
      needToInit = true;
      lastWin = 0;
     }
    /*if(needToInit || (robot.isDead && robot1.isDead)){
      init();
      println("blue: " + goalsBlue + " yellow: " + goalsYellow + " ties: " + ties + " games: " + (goalsBlue+goalsYellow+ties) + " stpes: " + totalSteps); 
    }*/
    robot.isDead = outOfField(robot); 
    robot1.isDead = outOfField(robot1); 
    box2d.step();
    robot.move(0,0,0,0);
    robot1.move(0,0,0,0);
    
      
    
    steps++;
    totalSteps++;
 }
 
 
   public int game(ANN ann){
     init();
     float y = goalsYellow;
     float b = goalsBlue;
     while(!needToInit){
       Strategies.move(ann, robot);
       step();
     }
     //init();
     if(goalsYellow > y) return 1;
     if(goalsBlue > b) return -1;
     return 0;
   }
   
   public int game(ANN ann, int matches){
     int score = 0;
     for(int i = 0; i < matches; i++){
      score += game(ann);
     } 
     return score;
   }
 
 
  public boolean outOfField(Robot robot){
    // 120 120
    // 120 608
    // 856 120
    // 856 608
    float x = robot._x;
    float y = robot._y;
    float r = 36;
    return x-r > 856 || x+r < 120 || y-r > 608 || y+r < 120;
  }
  public void display(){
    drawField();
    drawObjects();
  }
  public void drawObjects(){
    
    for (Boundary wall: boundaries) {
    wall.display();
  }
   robot.display();
   robot1.display();
   ball.display();
  }
  public void drawField(){
       background(58, 203, 82);
       fill(0, 102, 153);
       textSize(32);
       text("RoboCup Simulator", 10, 30); 
       
  
       stroke(255, 255, 255);
       
       line(120, 120, 856, 120);//up
       line(120, 120, 120, 608);//left
       line(856, 608, 856, 120);//right
       line(120, 608, 856, 608);//down
       
       stroke(0, 0, 0);
       
       line(240, 184, 240, 544);
       line(240, 184, 120, 184);
       line(240, 544, 120, 544);
       
       line(736, 184, 736, 544);
       line(736, 184, 856, 184);
       line(736, 544, 856, 544);
       noFill();
       ellipse(488, 364, 240, 240); 
      
      
    }
  
  
  void createBlueGoal(float x, float y){
    boundaries.add(new Boundary(x, y,29.6,240, 0,color(55, 94, 199), "Blue Goal", box2d));
  }
  

  void createYellowGoal(float x, float y){
    boundaries.add(new Boundary(x, y,29.6,240, 0,color(234, 255, 36), "Yellow Goal", box2d));
  }
  
  void createBall(float x, float y){
    ball = new Ball(x, y, box2d);
  }
  
  
  
  void beginContact(Contact cp) {
  // Get both fixtures
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
  if(ball.getX() <= 870.8+1 && ball.getX() >= 105.2+28.6){
  if((o1 == "Blue Goal" && o2.getClass() == Ball.class) || (o2 == "Blue Goal" && o1.getClass() == Ball.class)){
    needToInit = true;
    goalsBlue++;
    lastWin = -1;
  }else if((o1 == "Yellow Goal" && o2.getClass() == Ball.class) || (o2 == "Yellow Goal" && o1.getClass() == Ball.class)){
    needToInit = true;
    goalsYellow++;
    lastWin = 1;
    //ball.setPosition(random(100, 500), random(100, 500));
  }
  }
  
  
}


// Objects stop touching each other
void endContact(Contact cp) {
}
  
}
