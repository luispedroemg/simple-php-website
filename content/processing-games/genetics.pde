boolean DEBUG = true;

float gravity=0.0;
Thing a1;
Follower follower;
Population population;
Statistics statistics;
int totalPopulation = 500;
float mutationRate = 0.01;
PVector startingPoint;
int frame = 0;

void setup()
{
  size(640, 480)
  frameRate(500);  
  startingPoint = new PVector(width/2,  (8*height)/9);
  a1 = new Thing(width/2,height/2, gravity, 500);
  a1.applyForce(new PVector(0,0));
  population = new Population(totalPopulation, a1, startingPoint);
  statistics = new Statistics();
}
void draw(){
  //a1.setPosition(new PVector(mouseX,mouseY));
  if(population.finished){
    statistics.addGeneration(population);
    population.finished=false;
  }
  background(0);
  a1.update();
  statistics.display();
  population.cycle();
  text("Frame: " + frame, 10,10);
  text("Population: " + totalPopulation, 10,20);
  text("Generation: " + population.getGeneration(), 10,30);
  text("Population Current Frame: " + population.getCurrentFrame(), 10,40);
  text("Mating Pool Size: " + population.getMatingPoolSize(), 10,50);
  frame ++;
  //follower.update();
}

class Population{
  private IntelligentFollower[] pops;
  private int populationCap;
  private Thing target;
  private int currentFrame = 0;
  public boolean finished = false;
  private PVector startingPosition;
  private List<FollowerDNA> matingPool;
  
  public int generation = 0;
  
  public Population(int cap, Thing target, PVector startPos){
    this.target = target;
    this.startingPosition = startPos;
    this.populationCap = cap;
    this.pops = new IntelligentFollower[cap];
    for(int i=0; i<this.populationCap; i++){
      pops[i] = new IntelligentFollower(startPos.x,startPos.y, gravity, 5, target);
    }
  }  
  public void cycle(){
    for(int i=0; i<this.pops.length; i++){
      pops[i].update();
    }
    if(this.currentFrame == pops[0].dna.lifetime-1){
      for(int i=0; i<this.populationCap; i++){
        pops[i].calculateFitness();
      }
      this.sortByFitness();
      this.finished = true;
    }
    if(this.currentFrame == pops[0].dna.lifetime){  
      this.evolve();
      currentFrame=0;
      return;
    }
    this.currentFrame++;
  }
  
  public int getGeneration(){
    return this.generation;
  }
  
  public int getCurrentFrame(){
    return this.currentFrame;
  }
  
  private IntelligentFollower[] selectionSort(IntelligentFollower[] arr){
    if( arr == null ){
      arr = this.pops;
    }
    int minIdx,
      len = arr.length;
    IntelligentFollower temp;
    for(int i = 0; i < len; i++){
      minIdx = i;
      for(int  j = i+1; j<len; j++){
         if(arr[j].compareTo(arr[minIdx])<0){
            minIdx = j;
         }
      }
      temp = arr[i];
      arr[i] = arr[minIdx];
      arr[minIdx] = temp;
    }
    return arr;
  }
  
  // TODO: Implement sorting without Arrays JAVA lib
  private IntelligentFollower[] sortByFitness(){
    return this.selectionSort(null);
  }
  
  private void evolve(){    
    this.matingPool = new ArrayList<FollowerDNA>();
    for(int i=0; i<pops.length; i++){
      int n = int(pops[i].fitness * 100);
      for (int j = 0; j < n; j++) {
        this.matingPool.add(pops[i].dna);
      }
    }
    
    for (int i = 0; i < pops.length; i++) {
      int a = int(random(matingPool.size()));
      int b = int(random(matingPool.size()));
      FollowerDNA partnerA = matingPool.get(a);
      FollowerDNA partnerB = matingPool.get(b); //<>//
      FollowerDNA child = partnerA.crossover(partnerB);
      child.mutate(mutationRate);
      pops[i] = new IntelligentFollower(startingPosition.x, startingPosition.y, gravity, 5, this.target, child);
    }
    this.generation++;
  }
  public int getMatingPoolSize(){
    if(this.matingPool != null)
      return this.matingPool.size();
    else
      return -1;
  }
}

class GenerationStatistics{
  public int genNumber;
  private IntelligentFollower[] genPops;
  private float averageFitness;
  private Population tempPop = new Population(1, new Thing(0,0,0,0), new PVector(0,0));
  
  public GenerationStatistics(int genNumber, IntelligentFollower[] pops){
    this.genNumber = genNumber;
    this.genPops = pops;
    this.genPops = tempPop.selectionSort(this.genPops);
    float sumFit = 0;
    for(IntelligentFollower f : this.genPops){
      sumFit += f.fitness;
    }
    this.averageFitness = sumFit/this.genPops.length;
  }
  
  public IntelligentFollower getMedianFollower(){
    return this.genPops[genPops.length/2 - 1];
  }
  
  public float getMedianFitness(){
    return this.getMedianFollower().fitness;
  }
  
  public IntelligentFollower getBestFollower(){
    return this.genPops[this.genPops.length-1];
  }
  
  public float getBestFitness(){
    return getBestFollower().fitness;
  }
  
  public float getAverageFitness(){
    return this.averageFitness;
  }
  
  public IntelligentFollower getWorstFollower(){
    return this.genPops[0];
  }
  
  public float getWorstFitness(){
    return this.getWorstFollower().fitness;
  }
}

class Statistics{
  private ArrayList<GenerationStatistics> genStats;
  
  public Statistics(){
    this.genStats = new ArrayList<GenerationStatistics>();
  }
  
  public void addGeneration(Population pop){
    IntelligentFollower[] pops = new IntelligentFollower[pop.pops.length];
    for(int i=0; i<pops.length; i++){
       pops[i]=pop.pops[i];
    }
    this.genStats.add(new GenerationStatistics(pop.generation, pops));
  }
  
  public void display(){
    for(int i=0; i<this.genStats.size()-1; i++){
      GenerationStatistics gs1 = this.genStats.get(i);
      GenerationStatistics gs2 = this.genStats.get(i+1);
      
      stroke(255);
      text(gs1.genNumber, i*(width/this.genStats.size()),height);
      line(i*(width/this.genStats.size()), height - 10 - gs1.getMedianFitness()*100, (i+1)*(width/this.genStats.size()), height - 10 - gs2.getMedianFitness()*100);
      ellipse(i*(width/this.genStats.size()), height - 10 - gs1.getMedianFitness()*100, 2, 2);
      
      line(i*(width/this.genStats.size()), height - 10 - gs1.getWorstFitness()*100, (i+1)*(width/this.genStats.size()), height - 10 - gs2.getWorstFitness()*100);
      ellipse(i*(width/this.genStats.size()), height - 10 - gs1.getWorstFitness()*100, 2, 2);
      
      stroke(255,255,0);
      line(i*(width/this.genStats.size()), height - 10 - gs1.getAverageFitness()*100, (i+1)*(width/this.genStats.size()), height - 10 - gs2.getAverageFitness()*100);
      ellipse(i*(width/this.genStats.size()), height - 10 - gs1.getAverageFitness()*100, 2, 2);
      
      stroke(255,0,0);
      line(i*(width/this.genStats.size()), height - 10 - gs1.getBestFitness()*100, (i+1)*(width/this.genStats.size()), height - 10 - gs2.getBestFitness()*100);
      ellipse(i*(width/this.genStats.size()), height - 10 - gs1.getBestFitness()*100, 2, 2);
      
      stroke(255);
      
      if(i==this.genStats.size()-2){
        text(gs2.genNumber, (i+1)*(width/this.genStats.size()),height);
      }
    }
    if(this.genStats.size()>1){
      text("Size: "+ this.genStats.size(), 0, 230);
      text("Gen: "+ this.genStats.get(this.genStats.size()-1).genNumber, 0, 240);
      text("Best: "+ this.genStats.get(this.genStats.size()-1).getBestFitness(), 0, 250);
      text("Median: "+ this.genStats.get(this.genStats.size()-1).getMedianFitness(), 0, 260);
      text("Average: "+ this.genStats.get(this.genStats.size()-1).getAverageFitness(), 0, 270);
      text("Worst: "+ this.genStats.get(this.genStats.size()-1).getWorstFitness(), 0, 280);
    }
  }
}


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

  public PVector add(PVector arg){
    this.x += arg.x;
    this.y += arg.y;
    return this;
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

class IntelligentFollower extends Follower implements Comparable{
  private FollowerDNA dna;
  private Thing target;
  private int currentFrame = 0;
  private float fitness;
  private float[] distance;
  
  public IntelligentFollower(float x, float y, float gravity, float mass, Thing target){
    this(x,y,gravity,mass,target,new FollowerDNA());
  }
  
  public IntelligentFollower(float x, float y, float gravity, float mass, Thing target, FollowerDNA dna){
    super(x,y,gravity,mass);
    this.dna = dna;
    this.distance = new float[this.dna.lifetime];
    this.target = target;
  }

  public float dist(PVector target){
    float dx = this.x + target.x;
    float dy = this.y + target.y;
    float ret = sqrt((dx*dx) + (dy*dy));
    return ret;
  }

  public void update(){
    if(currentFrame < dna.lifetime){
      this.applyForce(dna.getGene(currentFrame));
      this.distance[currentFrame] = PVector.dist(this, this.target);
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
    for(int i=0; i<this.distance.length-1; i++)
      factor += distance[i]-distance[i+1];
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
      genes[i] = new PVector(random(-1, 1), random(-1, 1));
      genes[i].mult(random(0, maxForce));
    }
  }
  public FollowerDNA(){
    this(150, 0.2);
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
        this.genes[i] = new PVector(random(), random());
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




