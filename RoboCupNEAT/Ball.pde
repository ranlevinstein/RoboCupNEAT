import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import processing.core.PApplet;


class Ball {

  // We need to keep track of a Body and a radius
  public Body body;
  Box2DProcessing box2d;
  color col;


  Ball(float x, float y, Box2DProcessing box2d) {
    // This function puts the particle in the Box2d world
    this.box2d = box2d;
    makeBody(x, y);
    body.setUserData(this);
    col = color(175);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  void setPosition(float x, float y){
    body.setTransform(box2d.coordPixelsToWorld(x,y), 1);
  }

  // 
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    pushMatrix();
    translate(pos.x, pos.y);
    fill(col);
    stroke(0);
    strokeWeight(1);
    ellipse(0, 0, 7.4*2*2, 7.4*2*2);
    popMatrix();
  }

  // Here's our function that adds the particle to the Box2D world
  void makeBody(float x, float y) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.DYNAMIC;
    body = box2d.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(7.4*2);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 40;
    fd.friction = 0.01;
    fd.restitution = 0.3;

    // Attach fixture to body
    body.createFixture(fd);
    
  }
  
  float getX(){
    Vec2 pos = box2d.getBodyPixelCoord(body);
    return pos.x;
  }
  
  float getY(){
    Vec2 pos = box2d.getBodyPixelCoord(body);
    return pos.y;
  }
}

