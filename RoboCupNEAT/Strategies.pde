
public static class Strategies{
  
  static Simulator s;
  
  public static void setSimulator(Simulator sim){
    s = sim;
  }
  
  public static void optimal1(Robot robot, float speed){
     
     float ballY = s.ball.getY();
     float ballX = s.ball.getX();
     float m = (robot._goalY-ballY)/(robot._goalX-ballX);
     float angle = degrees(atan(-m));
     float b = ballY-ballX*m;
     float l = 100;
     float redyX = ballX-l;
     float redyY = (ballX-l)*m+b;
     float allowedErrorX = 25;
     float allowedErrorY = 25;
     float ballSpeed = sqrt(s.ball.body.getLinearVelocity().x*s.ball.body.getLinearVelocity().x+s.ball.body.getLinearVelocity().y*s.ball.body.getLinearVelocity().y);
     
     if(robot._goalX < robot._x){
       redyX = ballX+l;
       redyY = (ballX+l)*m+b;
     }
     if(ballX-robot._goalX < 0){
       angle+=180;
     }
     if(redyX > robot._x-allowedErrorX && redyX < robot._x+allowedErrorX && redyY > robot._y-allowedErrorY && redyY < robot._y+allowedErrorY)
       robot.recentlyRedy = true;
     if(robot.holdsBall(s.ball.getX(), s.ball.getY())){
       moveTo(robot._goalX, robot._goalY, angle, speed, 0.1, robot);
       robot.recentlyRedy = false;
       //println("goal");
     }else if(ballSpeed > 1){
       moveTo(ballX, ballY, angle, speed, 0.1, robot);
     }else if(!robot.recentlyRedy){
       moveToAvoid(redyX, redyY, angle, speed, 0.1, robot, ballX, ballY, 21*4);
       //println("avoid to perfect");
   }else{
       moveTo(ballX, ballY, angle, speed, 0.1, robot);
       //recentlyRedy = false;
       //println("go to ball");
     } 
    //println(robot.holdsBall(ballX, ballY));
  
  }
  
  
  public static void getToBallSmart(Robot robot){
    float ballY = s.ball.getY();
     float ballX = s.ball.getX();
     float m = (robot._goalY-ballY)/(robot._goalX-ballX);
     float angle = degrees(atan(-m));
     float b = ballY-ballX*m;
     float l = 100;
     float redyX = ballX-l;
     float redyY = (ballX-l)*m+b;
     float allowedErrorX = 25;
     float allowedErrorY = 25;
     float ballSpeed = sqrt(s.ball.body.getLinearVelocity().x*s.ball.body.getLinearVelocity().x+s.ball.body.getLinearVelocity().y*s.ball.body.getLinearVelocity().y);
      if(robot._goalX < robot._x){
       redyX = ballX+l;
       redyY = (ballX+l)*m+b;
     }
     if(ballX-robot._goalX < 0){
       angle+=180;
     }
     if(redyX > robot._x-allowedErrorX && redyX < robot._x+allowedErrorX && redyY > robot._y-allowedErrorY && redyY < robot._y+allowedErrorY)
       robot.recentlyRedy = true;
       if(ballSpeed > 1){
       moveTo(ballX, ballY, angle, 3, 0.1, robot);
     }else if(!robot.recentlyRedy){
       moveToAvoid(redyX, redyY, angle, 3, 0.1, robot, ballX, ballY, 21*4);
       //println("avoid to perfect");
   }else{
       moveTo(ballX, ballY, angle, 3, 0.1, robot);
       //recentlyRedy = false;
       //println("go to ball");
     }
  }
  
  public static void goToBall(Robot robot){
    float ballY = s.ball.getY();
     float ballX = s.ball.getX();
     float m = (robot._y-ballY)/(robot._x-ballX);
     float angle = degrees(atan(-m)) + 180;
     float b = ballY-ballX*m;
     float l = 100;
     float redyX = ballX-l;
     float redyY = (ballX-l)*m+b;
     float allowedErrorX = 25;
     float allowedErrorY = 25;
     float ballSpeed = sqrt(s.ball.body.getLinearVelocity().x*s.ball.body.getLinearVelocity().x+s.ball.body.getLinearVelocity().y*s.ball.body.getLinearVelocity().y);

       moveTo(ballX, ballY, angle, 3, 0.1, robot);
  }
  
  public static void goToEnemysGoal(Robot robot){
    float ballY = s.ball.getY();
     float ballX = s.ball.getX();
     float m = (ballY-robot._y)/(ballX-robot._x);
     float angle = degrees(atan(-m)) + 180;
     float b = ballY-ballX*m;
     float l = 100;
     float redyX = ballX-l;
     float redyY = (ballX-l)*m+b;
     float allowedErrorX = 25;
     float allowedErrorY = 25;
     float ballSpeed = sqrt(s.ball.body.getLinearVelocity().x*s.ball.body.getLinearVelocity().x+s.ball.body.getLinearVelocity().y*s.ball.body.getLinearVelocity().y);
     
    
    
    moveTo(robot._goalX, robot._goalY, angle, 3, 0.1, robot);
    
    
    
    if(redyX > robot._x-allowedErrorX && redyX < robot._x+allowedErrorX && redyY > robot._y-allowedErrorY && redyY < robot._y+allowedErrorY)
       robot.recentlyRedy = true;
    if(robot.holdsBall(s.ball.getX(), s.ball.getY())){
       moveTo(robot._goalX, robot._goalY, angle, 3, 0.1, robot);
       robot.recentlyRedy = false;
     }
  }
  
  
  public static void goToMyGoal(Robot robot){
    float ballY = s.ball.getY();
     float ballX = s.ball.getX();
     float m = (ballY-robot._y)/(ballX-robot._x);
     float angle = degrees(atan(-m)) + 180;
     float b = ballY-ballX*m;
     float l = 100;
     float redyX = ballX-l;
     float redyY = (ballX-l)*m+b;
     float allowedErrorX = 25;
     float allowedErrorY = 25;
     float ballSpeed = sqrt(s.ball.body.getLinearVelocity().x*s.ball.body.getLinearVelocity().x+s.ball.body.getLinearVelocity().y*s.ball.body.getLinearVelocity().y);
     
    
    
    moveTo(robot._ownGoalX, robot._ownGoalY, angle, 3, 0.1, robot);
    
    
    
    if(redyX > robot._x-allowedErrorX && redyX < robot._x+allowedErrorX && redyY > robot._y-allowedErrorY && redyY < robot._y+allowedErrorY)
       robot.recentlyRedy = true;
    if(robot.holdsBall(s.ball.getX(), s.ball.getY())){
       moveTo(robot._goalX, robot._goalY, angle, 3, 0.1, robot);
       robot.recentlyRedy = false;
     }
  }
  
  
  
  public static void moveTo(float x, float y, float theta, float speed, float speedOfRotation, Robot robot){
     theta = theta-90;
     float m = (y-robot._y)/(x-robot._x);
     float angle = degrees(atan(m))+45-robot._theta;
     if(x-robot._x < 0){
       angle+=180;
     }
     angle = angle%360;
     //println(angle);
     moveTo(angle, speed, theta, speedOfRotation, robot);
  }
  
  public static void moveTo(float angle, float speed, float theta, float speedOfRotation, Robot robot){
     float a = cos(radians(angle)) * speed;
     float b = sin(radians(angle)) * speed;
     float d1 = a+(theta-robot._theta)*speedOfRotation;
     float d2 = a-(theta-robot._theta)*speedOfRotation;
     float d3 = b+(theta-robot._theta)*speedOfRotation;
     float d4 = b-(theta-robot._theta)*speedOfRotation;
     robot.move(d1, d2, d3, d4); 
     //appendTextToFile("data.csv", regressionPoints(robot, robot1, ball, angle, speed, theta));
     
  }
  
  public static void moveTo(float angle, float speed, float theta, Robot robot){
    if(speed > 3) speed = 3;
    else if(speed < -3) speed = -3;
     float a = cos(radians(angle)) * speed;
     float b = sin(radians(angle)) * speed;
     float d1 = a+(theta-robot._theta)*2;
     float d2 = a-(theta-robot._theta)*2;
     float d3 = b+(theta-robot._theta)*2;
     float d4 = b-(theta-robot._theta)*2;
     robot.move(d1, d2, d3, d4); 
  }
  
  public static void moveToWithoutControl(float angle, float speed, float omega, Robot robot){
     if(speed > 3) speed = 3;
     else if(speed < -3) speed = -3;
     float a = cos(radians(angle)) * speed;
     float b = sin(radians(angle)) * speed;
     float d1 = a+omega;
     float d2 = a-omega;
     float d3 = b+omega;
     float d4 = b-omega;
     robot.move(d1, d2, d3, d4); 
  }
  
  
  public static void moveToAvoid(float x, float y, float theta, float speed, float speedOfRotation, Robot robot, float ax, float ay, float r){
     theta = theta-90;
     float m = (y-robot._y)/(x-robot._x);
     float lastM = m;
      m = findMWithoutContact(robot._x, robot._y, m, ax, ay, r);
     //println(degrees(atan(m))+"    " + degrees(atan(lastM)));
     float angle = degrees(atan(m))+45-robot._theta;
     //appendTextToFile("data.csv", regressionPoints(robot, robot1, ball, angle, speed, theta));
     //println(angle);
     if(x-robot._x < 0){
       angle+=180;
     }
     angle = angle%360;
     //println(angle);
     float a = cos(radians(angle)) * speed;
     float b = sin(radians(angle)) * speed;
     float d1 = a+(theta-robot._theta)*speedOfRotation;
     float d2 = a-(theta-robot._theta)*speedOfRotation;
     float d3 = b+(theta-robot._theta)*speedOfRotation;
     float d4 = b-(theta-robot._theta)*speedOfRotation;
     robot.move(d1, d2, d3, d4); 
  }
  
  public static boolean isInCircle(float px, float py, float x, float y, float r){
    return (px-x)*(px-x)+(py-y)*(py-y) < r*r;//r square insted of root in the other side 
  }
  
  public static boolean willContact(float x0, float y0, float m, float x1, float y1, float r){
    float b = y0-x0*m;
    for(float x = x0; x < x0+300; x+=3){
      if(isInCircle(x, x*m+b, x1, y1, r)) return true;
    } 
    return false;
  }
  
  public static float findMWithoutContact(float x0, float y0, float m, float x1, float y1, float r){ 
    float startM = m;
    for(int i = 0;i < 360/15 && willContact(x0, y0, m, x1, y1, r); i++){
      //if (i > 360/15) return startM;
      m = tan((atan(m)+15)%360);
      //println(i);
      
    }
   //println(m-startM);
     return m;
  }
  
  public static void move(ANN ann, Robot r){
    float[] state = new float[6];
    state[0] = r._x/(244*4);
    state[1] = r._y/(182*4);
    state[2] = r._theta/360;
    state[3] = s.ball.getX()/(244*4);
    state[4] = s.ball.getY()/(182*4);
    state[5] = r.holdsBall(s.ball.getX(), s.ball.getY())? 0 : 1;
    float[] out = ann.step(state);
    float vx = out[0]*3;
    float vy = out[1]*3;
    float w = out[2]*2;
    float angle = degrees(atan2(vy, vx));
    float v = sqrt(vx*vx+vy*vy);
    moveToWithoutControl(angle, v, w, r);
  }
  
  
  public static float[][] policyGradient(float [] thetaA, float [] thetaB, float [] thetaC, Robot robot, Robot robot1, Ball ball){
    float[] state = new float[15];
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
    state[13] = robot.holdsBall(ball.getX(), ball.getY())? 0 : 1000;
    state[14] = 1;
    
    //float muT = thetaT[0]*robot._x + thetaT[1]*robot._y + thetaT[2]*robot.getVelocityX() + thetaT[3]*robot.getVelocityY() + thetaT[4]*robot._theta + thetaT[5]*robot1._x + thetaT[6]*robot1._y + thetaT[7]*robot1.getVelocityX() + thetaT[8]*robot1.getVelocityY() + 
    //thetaT[9]*ball.getX() + thetaT[10]*ball.getY() + thetaT[11]*ball.body.getLinearVelocity().x + thetaT[12]*ball.body.getLinearVelocity().y;
    float alpha = 0.001;
    float probA = 0;
    float probB = 0;
    float probC = 0;
    for(int i = 0 ; i < state.length; i++){
     probA +=  thetaA[i]*state[i];
     probB +=  thetaB[i]*state[i];
     probC +=  thetaC[i]*state[i];
    }
    probA = (float)Math.exp(alpha * probA);
    probB = (float)Math.exp(alpha * probB);
    probC = (float)Math.exp(alpha * probC);
    
    /*float probA = thetaA[0]*robot._x + thetaA[1]*robot._y + thetaA[2]*robot.getVelocityX() + thetaA[3]*robot.getVelocityY() + thetaA[4]*robot._theta + thetaA[5]*robot1._x + thetaA[6]*robot1._y + thetaA[7]*robot1.getVelocityX() + thetaA[8]*robot1.getVelocityY() + 
    thetaA[9]*ball.getX() + thetaA[10]*ball.getY() + thetaA[11]*ball.body.getLinearVelocity().x + thetaA[12]*ball.body.getLinearVelocity().y;
    probA = (float)Math.exp(alpha * probA);
    float probB = thetaB[0]*robot._x + thetaB[1]*robot._y + thetaB[2]*robot.getVelocityX() + thetaB[3]*robot.getVelocityY() + thetaB[4]*robot._theta + thetaB[5]*robot1._x + thetaB[6]*robot1._y + thetaB[7]*robot1.getVelocityX() + thetaB[8]*robot1.getVelocityY() + 
    thetaB[9]*ball.getX() + thetaB[10]*ball.getY() + thetaB[11]*ball.body.getLinearVelocity().x + thetaB[12]*ball.body.getLinearVelocity().y;
    probB = (float)Math.exp(alpha * probB);
    float probC = thetaC[0]*robot._x + thetaC[1]*robot._y + thetaC[2]*robot.getVelocityX() + thetaC[3]*robot.getVelocityY() + thetaC[4]*robot._theta + thetaC[5]*robot1._x + thetaC[6]*robot1._y + thetaC[7]*robot1.getVelocityX() + thetaC[8]*robot1.getVelocityY() + 
    thetaC[9]*ball.getX() + thetaC[10]*ball.getY() + thetaC[11]*ball.body.getLinearVelocity().x + thetaC[12]*ball.body.getLinearVelocity().y;
    probC = (float)Math.exp(alpha * probC);*/
    
    float[] nProbs = new float[3];
    if (probA + probB + probC < 1e-10)
    {
      nProbs[0] = 1/3;
      nProbs[1] = 1/3;
      nProbs[2] = 1/3;
    } else {
      nProbs[0] = probA / (probA + probB + probC);
      nProbs[1] = probB / (probA + probB + probC);
      nProbs[2] = probC / (probA + probB + probC);
    }
    
    float action = (float)Math.random();
    int chosen=0;
    for(int k=0; k<5; k++){
    if (action < nProbs[0]){
      chosen = 0;
      getToBallSmart(robot);
    }else if(action > nProbs[1]+ nProbs[0]){
      chosen = 2;
      goToEnemysGoal(robot);
    }else{
      chosen = 1;
      goToMyGoal(robot);
    }
    optimal1(s.robot1, 0);
    s.step();
    }
    //moveTo(rndB, rndV, rndA, robot);//b: angle v: speed a: theta
    
    //println("angle " + rndB);
    //float rndT = (float)rnd.nextGaussian() * 0.005 + muB;
    float[][] summand = new float[nProbs.length][state.length];//v a 
    
    float eps = 0.1; 
    for (int i = 0; i < summand.length; i++) {
      for (int j = 0; j < summand[i].length; j++){
        summand[i][j] = 0;
        if (chosen == j){        
          summand[i][j] += (float)eps * alpha * state[j];
          
        } 
        summand[i][j] -= (float)(eps*alpha*state[j]*nProbs[i]);
        if(Float.isNaN(summand[i][j])) summand[i][j] = 0;
        //if(Float.isNaN(summand[i][j])) println("sdsadasdasdasdasdasdasdasdas");
    }
  }
    return summand;
  }
  
  
  
}
