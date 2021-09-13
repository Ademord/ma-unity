using UnityEngine;

namespace Ademord.Drone
{
    /// <summary>
    /// Concrete pool for <see cref="Bullet"/>s.
    /// </summary>
    public class ScannerPool : Pool<Scanner>
    {
        private Scanner m_LastScanner = null;
        
        /// <summary>
        /// Shoots a <see cref="Bullet"/> associated 
        /// with a specified <see cref="IBulletOwner"/>.
        /// </summary>
        /// <param name="owner"><see cref="IBulletOwner"/></param>
        public void Scan(IScannerOwner owner, Transform target)
        {
            // if no scanner exists or the last one was archived, Spawn a new one
            if (m_LastScanner == null || m_LastScanner.m_Owner == null)
            {
                m_LastScanner = Spawn(owner.ScannerPosition);
            }
            // scan 
            m_LastScanner.Scan(owner, target);
        }
    }
}