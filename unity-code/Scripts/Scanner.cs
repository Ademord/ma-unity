using UnityEngine;

namespace Ademord
{
    /// <summary>
    /// Interface for bullet owner who must provide the position and
    /// direction of the gun, as well as a callback for reacting to scored hits.
    /// </summary>
    public interface IScannerOwner
    {
        /// <summary>
        /// Where to place the gun.
        /// </summary>
        Vector3 ScannerPosition { get; }

        /// <summary>
        /// Where to point the gun.
        /// </summary>
        Vector3 ScannerDirection { get; }

        /// <summary>
        /// Callback performs actions after a bullet hit was scored.
        /// </summary>
        void OnVoxelScanned(GameObject target);
        void ResetObservations(bool fullReset);
        
        
    }

    /// <summary>
    /// <see cref="Poolable"/> bullet.
    /// </summary>
    public class Scanner : Poolable
    {
        // [SerializeField]
        // protected float m_Force = 100;
        // [SerializeField]
        // protected string m_TargetTag = "Spaceship";

        // protected Rigidbody m_Rigidbody;
        public IScannerOwner m_Owner;

        protected Transform ScannerBeam;

        protected Animator m_ScannerAnimator;

        private float m_ScannedTime;
        [SerializeField]
        [Tooltip("Grace period to not destroy Scanner.")]
        private float m_GraceTimeBetweenScans = 0.2f;
   
        private void Awake()
        {
            Initialize();
        }

        protected virtual void Initialize()
        {
            m_ScannerAnimator = GetComponent<Animator>();
            // TODO
            // m_ScannerAnimator.Open();
        }

        /// <summary>
        /// Proyects a <see cref="Scan"/> associated 
        /// with a specified <see cref="IScannerOwner"/>.
        /// </summary>
        /// <param name="owner"><see cref="IScannerOwner"/></param>
        /// <param name="target"><see cref="Transform"/></param>
        public void Scan(IScannerOwner owner, GameObject target)
        {
            m_Owner = owner;
            // lerp to look at target
            VoxelController myVoxel = target.transform.parent.transform.GetComponent<VoxelController>();
            
            // if (myVoxel != null && myVoxel.Collect())
            if (myVoxel != null)
            {
                if (myVoxel.Collect())
                {
                    print("collected a voxel!");
                }
                else
                {
                    print("could not collect voxel");
                }
            }
            else
            {
                print("conecast could not detect a voxel in detected collider named: " + target.transform.name);
            }
            
            // transform.rotation = Quaternion.LookRotation(owner.ScannerDirection, Vector3.up);
            transform.LookAt(target.transform);
            // set the time at which the scan happened, in case a new one is coming, do not destroy this scanner
            m_ScannedTime = Time.time;
            // notify Agent of scan
            m_Owner.OnVoxelScanned(target);
            // TODO verify that this will not be needed
            // m_Owner.ResetObservations();

        }
        
        protected override void OnDiscard()
        {
            if (CanDiscard())
            {
                // if delta time > 2 seconds, continue discard 
                base.OnDiscard();
                // TODO
                // m_ScannerAnimator.Close()
                m_Owner = null;
            }
            else
            {
                DiscardAfter(m_Lifetime);
            }
        }
        private bool CanDiscard()
        {
            return Time.time - m_ScannedTime >= m_GraceTimeBetweenScans;
        }
    }
}