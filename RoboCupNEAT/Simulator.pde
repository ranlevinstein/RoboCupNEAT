import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;


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
  float[] state = new float[17];
  float stateDegree = 1;
  //float[] polyState = new float[(int)(state.length*(state.length+1)/2)];
  float[] polyState = new float[17];
  
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
    //createBall(random(width-(240*3), 240*3), random(height-(200*3), 200*3));
    createBall(244*2+random(-100, 100), 182*2+random(-100, 100));
    ball.setPosition(244*2+random(-100, 100), 182*2+random(-100, 100));
    updateState();
  }
  
  public void init(){
      needToInit = false;
      
      ball.setPosition(244*2+random(-100, 100), 182*2+random(-100, 100));
      
      ball.body.setLinearVelocity(new Vec2(0, 0));
      
      
      robot.setPosition(244*2-250, 182*2, 90);

      robot1.setPosition(244*2+250, 182*2, -90);
      
      
      steps = 0;
      //robot = new Robot(244*2-250, 182*2, 90, 90, 2, 870.8, 364, box2d);
      //robot1 = new Robot(244*2+250, 182*2, 0, 90, 2, 105.2, 364, box2d);
      robot.isDead = false;
      robot1.isDead = false;
      updateState();
  }
  public void step(){
    if(steps > 1800){//1250 for normal game
      steps = 0;
      ties++;
      needToInit = true;
      lastWin = 0;
     }
    if(needToInit || (robot.isDead && robot1.isDead)){
      
      //init();
      //println("blue: " + goalsBlue + " yellow: " + goalsYellow + " ties: " + ties + " games: " + (goalsBlue+goalsYellow+ties) + " stpes: " + totalSteps); 
    }
    
    //change to enable out of field.
    //robot.isDead = outOfField(robot); 
    //robot1.isDead = outOfField(robot1); 
    
    
    
    box2d.step();
    updateState();
    //Strategies.optimal1(robot, 3);
    //Strategies.optimal1(robot1, 3);
    //robot.move(0,0,0,0);
    //robot1.move(0,0,0,0);
    
      
    
    steps++;
    totalSteps++;
 }
 
   void playStep(Strategy s){
     step();
      float ballY = ball.getY();
      float ballX = ball.getX();
      float m = (ballY-robot._goalY)/(ballX-robot._goalX);
      float heading = degrees(atan(-m)) + 90;
      float angle = s.run(polyState);
      for(int i = 0; i < 1; i++){
      Strategies.moveTo(angle, 3, heading, robot);
      Strategies.optimal1(robot1, 3);//2.8 good
      }
   }

  float play(Strategy s){
    init(); 
    if(steps > 1800){//1250 for normal game
      steps = 0;
      ties++;
      needToInit = true;
      lastWin = 0;
     }
    while(!needToInit){
      playStep(s);
      //println(lastWin);
    }
    return lastWin;
  }
  
  
  float play(Strategy s, int matches){
   float score = 0;
    for(int i = 0 ; i < matches; i++){
      score += play(s);
    }
    if (score > 0) return score;//1
    else return -1;
    //return score;
  }
  
  
  void updateState(){
    state[0] = robot._x;
    state[1] = robot._y;
    state[2] = robot.getVelocityX();
    state[3] = robot.getVelocityY();
    state[4] = robot._theta;
    state[5] = robot1._x;
    state[6] = robot1._y;
    state[7] = robot1.getVelocityX();
    state[8] = robot1.getVelocityY();
    state[9] = ball.getX();
    state[10] = ball.getY();
    state[11] = ball.body.getLinearVelocity().x;
    state[12] = ball.body.getLinearVelocity().y;
    state[13] = robot.holdsBall(ball.getX(), ball.getY())? 0 : 300;
    state[14] = 1; 
    float m = (state[10]-robot._y)/(state[9]-robot._x);
     float angle = degrees(atan(m))+45-robot._theta;
     if(state[9]-robot._x < 0){
       angle+=180;
     }
    angle = angle%360;
    state[15] = angle; 
    
    float mGoal = (robot._goalY-robot._y)/(robot._goalX-robot._x);
     float angleGoal = degrees(atan(mGoal))+45-robot._theta;
     if(robot._goalX-robot._x < 0){
       angleGoal+=180;
     }
     angleGoal = angleGoal%360;
     state[16] = angleGoal;
     //state[17] = sqrt((state[9]-robot._x)*(state[9]-robot._x) + (state[10]-robot._y)*(state[10]-robot._y));
     updatePolyState();
  }
 
   void updatePolyState(){
       int counter = 0;
     for(int i = 0; i < state.length; i++){
       //for(int j = i; j < state.length; j++){
           polyState[counter] = state[i];//*state[j];
           counter++;
       //}
     }
     
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

       text(goalsYellow+"-"+goalsBlue, 700, 100);
  
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
  //println(needToInit);
}


// Objects stop touching each other
void endContact(Contact cp) {
}
  
}
