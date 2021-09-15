

namespace Ademord
{
    public class DroneAgentTrainSceneControl : DroneAgentTrain
    {
        
        public override void OnEpisodeBegin()
        {
            RandomizeTargets();

            base.OnEpisodeBegin();
            
        }
        protected void RandomizeTargets()
        {
            RandomizeTargetSpeed();

            // m_World.MoveToSafeRandomPosition(m_Drone.transform, true);
        }
    }
}