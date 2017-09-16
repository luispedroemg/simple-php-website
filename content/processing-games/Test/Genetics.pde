class IntelligentFollower extends Follower implements Comparable{
  private FollowerDNA dna;
  private Thing target;
  private int currentFrame = 0;
  private float fitness;
  private float[] dist;
  
  public IntelligentFollower(float x, float y, float gravity, float mass, Thing target){
    this(x,y,gravity,mass,target,new FollowerDNA());
  }
  
  public IntelligentFollower(float x, float y, float gravity, float mass, Thing target, FollowerDNA dna){
    super(x,y,gravity,mass);
    this.dna = dna;
    this.dist = new float[this.dna.lifetime];
    this.target = target;
  }
  
  public void update(){
    if(currentFrame < dna.lifetime){
      this.applyForce(dna.getGene(currentFrame));
      this.dist[currentFrame] = PVector.dist(this, this.target);
      if(DEBUG){
        stroke(0,255,0);
        line(this.x, this.y, this.x+dna.getGene(currentFrame).x*100, this.y+dna.getGene(currentFrame).y*100);
        stroke(0);
      }
      currentFrame++;
    }
    else if(DEBUG){
      fill(255,0,0);
      text("DEAD", this.x, this.y);
      fill(255);
      this.speed = new PVector(0,0);
    }
    super.update();
  }
  
  public int compareTo(Object o){
    IntelligentFollower other = (IntelligentFollower) o;
    if(this.fitness > other.fitness)
      return 1;
     else if(this.fitness == other.fitness)
       return 0;
     else if(this.fitness<other.fitness)
      return -1;
     return -999;
  }
  
  public float calculateFitness(){
    float factor = 1;
    for(int i=0; i<this.dist.length-1; i++)
      factor += dist[i]-dist[i+1];
    this.fitness = factor * (1/PVector.dist(this, target));
    return this.fitness;
    
  }
}

//------------ DNA ------------

class FollowerDNA{
  public PVector[] genes;
  public int lifetime;
  public float maxForce;
  
  public FollowerDNA(int lifetime, float maxForce){
    this.maxForce = maxForce;
    this.lifetime = lifetime;
    genes = new PVector[lifetime];
    for(int i=0; i<lifetime; i++){
      genes[i] = PVector.random2D();
      genes[i].mult(random(0, maxForce));
    }
  }
  public FollowerDNA(){
    this(150, 0.1);
  }
  
  public FollowerDNA crossover(FollowerDNA partner){
    FollowerDNA child = new FollowerDNA();
    for(int i=0; i<child.lifetime; i++){
      if(i<child.lifetime/2)
        child.genes[i] = new PVector(this.genes[i].x, this.genes[i].y);
      else
        child.genes[i] = new PVector(partner.genes[i].x, partner.genes[i].y);
    }
    return child;
  }
  
  public void mutate(float mutationRate){
    for (int i = 0; i < this.genes.length; i++) {
      if (random(1) < mutationRate) {
        this.genes[i] = PVector.random2D();
        this.genes[i].mult(random(0, this.maxForce));
      }
    }
  }
  
  public PVector getGene(int frame){
    if(frame < 300)
      return new PVector(genes[frame].x, genes[frame].y);
    else
      return null;
  }
  
  public String toString(){
    String s = new String();
    for(PVector g : genes){
      s +="[x:"+g.x+" y:"+g.y+"]";
    }
    return s;
  }
}