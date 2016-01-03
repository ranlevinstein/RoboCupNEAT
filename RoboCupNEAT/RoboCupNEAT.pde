import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import java.util.Random;
import java.io.BufferedWriter;
import java.io.FileWriter;


Box2DProcessing box2d;


  boolean recentlyRedy;
  boolean needToInit = false;
  int lastWin = 0;//0 tie 1 blue 2 yellow
  int totalSteps = 0;
  boolean saved = true;
  
  Simulator s;
  Population pop;
  void setup(){
    s = new Simulator(this);
    Strategies.setSimulator(s);
    ANN function = new ANN(6, 3);
    FitnessEvaluator fitnessEvaluator = new RobotEvaluator(s);
    pop = new Population(150, function, fitnessEvaluator);
  }
   
  //robot1 -> right
  //robot -> left
  void draw(){
    //Strategies.optimal1(s.robot, 3);
    //s.step();
    pop.newGeneration();
    s.display();
  }
  
  
  /**
 * Appends text to the end of a text file located in the data directory, 
 * creates the file if it does not exist.
 * Can be used for big files with lots of rows, 
 * existing lines will not be rewritten
 */
void appendTextToFile(String filename, String text){
  File f = new File(dataPath(filename));
  if(!f.exists()){
    createFile(f);
    appendTextToFile(filename, "robot._x,robot._y,ball.getX(),ball.getY(),ball.body.getLinearVelocity().x,ball.body.getLinearVelocity().y,angle");
  }
  try {
    PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(f, true)));
    out.println(text);
    out.close();
  }catch (IOException e){
      e.printStackTrace();
  }
}

/**
 * Creates a new file including all subfolders
 */
void createFile(File f){
  File parentDir = f.getParentFile();
  try{
    parentDir.mkdirs(); 
    f.createNewFile();
  }catch(Exception e){
    e.printStackTrace();
  }
}    

void beginContact(Contact cp){
  s.beginContact(cp);
}

void endContact(Contact cp) {
}
  
  
  
