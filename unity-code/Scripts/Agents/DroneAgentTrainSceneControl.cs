

namespace Ademord
{
    public class DroneAgentTrainSceneControl : DroneAgentTrain
    {
        
        public override void OnEpisodeBegin()
        {
            base.OnEpisodeBegin();

            RandomizeTargets();
        }
        protected void RandomizeTargets()
        {
            RandomizeTargetSpeed();

            if (m_World != null)
                m_World.Reset(false); 
            
            // m_World.MoveToSafeRandomPosition(m_Drone.transform, true);
        }
    }
}