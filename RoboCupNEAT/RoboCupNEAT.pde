
Population pop;

void setup(){
  
  ANN function = new ANN(1, 1);
  FitnessEvaluator fitness = new FunctionAproximationFitness();
  pop = new Population(100, function, fitness);
}


void draw(){
  pop.newGeneration();
}