
/**
 * interface FitnessEvaluator evaluates the fitness of an ANN.
 * 
 * @author Ran Levinstein
 * @version 1.0
 */
public class RobotEvaluator implements FitnessEvaluator
{
    Simulator sim;
    RobotEvaluator(Simulator sim){
     this.sim = sim; 
    }
    
    public float getFitness(ANN ann){
      return sim.game(ann, 5);
    }
}


