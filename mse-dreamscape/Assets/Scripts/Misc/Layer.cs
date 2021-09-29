
namespace Ademord
{
    public static class Layer
    {
        public const int Agent = 3;
        public const int Boundary = 6;
        public const int Collectible = 7;
        public const int Obstacle = 8;
        public const int Ground = 9;
        // public const int Trigger = 9;

        public const int AgentMask = 1 << 3;
        public const int BoundaryMask = 1 << 6;
        public const int CollectibleMask = 1 << 7;
        public const int ObstacleMask = 1 << 8;
        public const int GroundMask = 1 << 9;
        public const int ObjectMask = 1 << 11;
        // public const int BulletMask = 1 << 8;
        // public const int TriggerMask = 1 << 9;
    }
}