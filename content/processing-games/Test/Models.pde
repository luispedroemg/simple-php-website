class Thing extends PVector{
  protected final float size = 10;
  protected float mass;
  protected PVector speed = new PVector(0,0);
  protected PVector gravity;
  
  public Thing(float x, float y, float gravity, float mass){
    this.x=x;
    this.y=y;
    this.gravity=new PVector(0, gravity);
    this.mass=mass;
  }
  
  private void move(){
    this.speed.add(this.gravity);
    this.add(this.speed);
  
    // Constrain movement of things to the screen space
    if(this.x<=0 || this.x>=width-size/2 || this.y<=0 || this.y>=height-size/2){
      this.speed=new PVector(0,0);
    }
    this.x=constrain(this.x, 0, width-size/2);
    this.y=constrain(this.y, 0, height-size/2);
  }
  
  public void update(){
    this.move();
    stroke(0);
    ellipse(this.x, this.y, this.size, this.size);
  }
  
  public void applyForce(PVector force){
    force.div(this.mass);
    this.speed.add(force);
  }
  
  public void setPosition(PVector position){
    this.x=position.x;
    this.y=position.y;
  }
}

class Follower extends Thing{
  private PVector target = null;
  public Follower(float x, float y, float gravity, float mass, PVector target){
    this(x, y, gravity, mass);
    this.target = target;
  }
  public Follower(float x, float y, float gravity, float mass){
    super(x, y, gravity, mass);
  }
  
  public void update(){
    if(target!=null){
      PVector forceDirection = PVector.sub(target,this).normalize();
      this.applyForce(forceDirection);
      if(DEBUG){
        line(this.x, this.y, this.x+forceDirection.x*100, this.y+forceDirection.y*100);
      }
    }
    super.update();
  }
  
  public void setTarget(PVector target){
    this.target = target;
  }
}