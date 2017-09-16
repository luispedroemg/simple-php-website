import java.util.*;
boolean DEBUG = true;

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
  
  private IntelligentFollower[] sortByFitness(){
    Arrays.sort(this.pops);
    return this.pops;
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
  
  public GenerationStatistics(int genNumber, IntelligentFollower[] pops){
    this.genNumber = genNumber;
    this.genPops = pops;
    Arrays.sort(this.genPops);
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
    IntelligentFollower[] pops = pop.pops.clone();
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

float gravity=0.0;
Thing a1;
Follower follower;
Population population;
Statistics statistics;
int totalPopulation = 500;
float mutationRate = 0.01;
PVector startingPoint;
int frame = 0;
void setup(){
  size(480, 320);
  frameRate(1000);
  
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