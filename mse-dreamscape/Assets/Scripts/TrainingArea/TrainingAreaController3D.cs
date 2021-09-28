using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using Quaternion = UnityEngine.Quaternion;
using Random = UnityEngine.Random;
using Vector3 = UnityEngine.Vector3;

namespace Ademord
{
    public class TrainingAreaController3D : MonoBehaviour
    {
        public event EventHandler<VoxelCollectedEventArgs> OnObjectFullyScannedEventHandler;

        
        [Header("Collectible Parameters")]
        [SerializeField] 
        string collectibleTag = "collectible";
        [Tooltip("The material when the voxel can be collected")]
        [SerializeField]
        private Material undetectedMaterial;
        [Tooltip("The material when the voxel is not collectable")]
        [SerializeField]
        private Material detectedCollectibleMaterial;
        
        [Header("Spawn Parameters")]
        [SerializeField]
        [Range(0, 1)]
        int m_NSpawnTargets = 3;
        [SerializeField] private GameObject m_TargetSpawnPrefab;
        [SerializeField, MinMaxSlider(1f, 10f)]
        protected MinMax MaxSpawnHeight = new MinMax(1f, 10f);
        [SerializeField, MinMaxSlider(1f, 20f)]
        protected MinMax MaxSpawnRadius = new MinMax(1f, 15f);
        [SerializeField]
        protected Body m_Body;

        [Header("Respawn Parameters")]
        [SerializeField] 
        private bool RespawnOnCollection = false;
      
        public List<VoxelController> collectiblesList { get; private set; }
        
        // training elements tracks child: N_elements, List_Elements
        public Dictionary<Transform, (int numToCollect, List<VoxelController> collectibles)> trainingElements;
        
        protected float FieldRadius;
        
        // this constraints that the next respawned object is at least X meters away from last collected position in XZ
        private Vector3 lastCollectedPosition;
        [SerializeField] private float minRespawnDistanceFromLastCollected = 5f;
        [SerializeField] 
        private float TimeBeforeDestroy = 5f;
        
        
        public void Initialize(float ExplorationLimit)
        {
            FieldRadius = ExplorationLimit;
            trainingElements = new Dictionary<Transform, (int numToCollect, List<VoxelController> collectibles)>();
            collectiblesList = new List<VoxelController>();
        }
        
        public void Reset(bool randomizeHeight=false)
        {
            lastCollectedPosition = Vector3.zero;
            // empty the training area
            foreach (var kvp in trainingElements.ToArray())
            {
                Destroy(kvp.Key.gameObject);
            }

            trainingElements.Clear();
            
            // spawn new elements
            foreach (int value in Enumerable.Range(1, m_NSpawnTargets))
            {
                SpawnTarget(m_TargetSpawnPrefab, new Vector3(30, 30, 30));
            }

            // Debug.Log("found n Children on the TrainingArea you gave me: " + trainingElements.Count);
            // Debug.Log("found n Collectibles on the TrainingArea you gave me: " + collectiblesList.Count);
        }

        public bool EverythingHasBeenCollected
        {
            get
            {
                var scannedObjects = 0;
                foreach (var kvp in trainingElements)
                {
                    if (IsFullyScanned(kvp))
                    {
                        scannedObjects++;
                    }
                    else
                    {
                        // optimization: if one is found that has not been fully scanned, do not keep searching 
                        return false;
                    }
                }
                // obvious note: if the number of scanned objects is the same as
                // the number of objects to scan, all items have been scanned 
                return scannedObjects == trainingElements.Count;
            }
        }

        private bool IsFullyScanned(KeyValuePair<Transform, (int numToCollect, List<VoxelController> collectibles)> kvp)
        {
            // print("num to be collected: " + kvp.Value.numToCollect);
            return kvp.Value.numToCollect == 0;
        }
        private void FindCollectibles(Transform parent, bool clearGlobalList = true)
        {
            if (clearGlobalList)
            {
                collectiblesList = new List<VoxelController>();
            }
            
            // TODO change this so it doesnt use the global variable
            // foreach child in parent, exit1: exit when no more children in element
            // Debug.Log("found n children:" + parent.childCount);
            for (int i = 0; i < parent.childCount; i++)
            {
                Transform child = parent.GetChild(i);
                // Debug.Log("childs name: " + child.name + ", tag: " + child.tag);
                if (child.gameObject.activeInHierarchy && child.CompareTag(collectibleTag))
                {
                    // print("found a collectible inside FindCollectibles");
                    VoxelController current_child = child.GetComponent<VoxelController>();
                    // once flower found, add the flowers list and add the collider attached to the hash map
                    if (current_child != null)
                    {
                        // print("found a collectible with a voxelcontroller component as expected");

                        current_child.undetectedMaterial = undetectedMaterial;
                        current_child.detectedCollectibleMaterial = detectedCollectibleMaterial;
                        
                        collectiblesList.Add(current_child);
                        current_child.Collected += ReduceNumCollected;
                    }
                    else
                    {
                        print("found a collectible tag without a voxelcontroller of name: " + child.name);
                    }
                }
                else
                {
                    // no flowers found, continue checking looking for flowers
                    // until you find a flower or you run out of children (main loop)
                    FindCollectibles(child, false);
                }
            }
        }
        private void AssignBodyReferenceToDGOs(Transform parent)
        {
            for (int i = 0; i < parent.childCount; i++)
            {
                Transform child = parent.GetChild(i);
                VoxelDetectableGameObject current_child = child.GetComponent<VoxelDetectableGameObject>();
                if (current_child != null) current_child.m_AgentBody = m_Body;
               
                AssignBodyReferenceToDGOs(child);
            }
        }

        private void SpawnTarget(GameObject prefab, Vector3 pos)
        {
            // instantiate
            var m_Target = Instantiate(prefab, pos, Quaternion.identity, transform);
            var m_TargetTransform = m_Target.transform;

            // initialize references of subcomponents
            AssignBodyReferenceToDGOs(m_TargetTransform);
            
            // move to a safe position
            MoveToSafeRandomPosition(m_TargetTransform);
            
            // search all collectibles in this transform recursively (using global variable)
            FindCollectibles(m_TargetTransform);
            // deep copy of global variable  it doesnt keep old references
            List<VoxelController> collectibles = collectiblesList; 
            
            // print("Adding n collectibles from SpawnTarget: " + collectibles.Count);
            // initialize and reset
            foreach (var collectible in collectibles)
            {
                // collectible != null &&
                if (collectible.gameObject.activeInHierarchy)
                {
                    collectible.Initialize();
                    collectible.Reset();
                }
            }
            // add new object to training elements
            trainingElements.Add(m_TargetTransform, (collectibles.Count, collectibles));
        }
        public void MoveToSafeRandomPosition(Transform trans, bool randomizeHeight=false)
        {
            bool safePositionFound = false;
            int attemptsRemaining = 11;
            Vector3 potentialPosition = Vector3.zero;
            Quaternion potentialRotation = new Quaternion();

            // loop until safe position
            while (!safePositionFound && attemptsRemaining-- > 0) // 
            {
                potentialPosition = GetRandomPosition(minRespawnDistanceFromLastCollected);
                potentialRotation = GetRandomRotation();
                
                RaycastHit[] sphereCastHits = Physics.SphereCastAll(potentialPosition + new Vector3(0, 10, 0), 2f, -transform.up, 30f, Layer.ObstacleMask);
                // Debug.Log("spherecast hit length: " + sphereCastHits.Length);
                // safe position if no colliders found
                safePositionFound = sphereCastHits.Length == 0;
            }

            Debug.Assert(safePositionFound, "Could not found a safe position");
          
            // set position, rotation
            trans.position = potentialPosition;
            trans.rotation = potentialRotation;
        }

        Vector3 GetRandomPosition(float minDistanceXZ = 0)
        {
            int attempts = 11;
            bool positionFound = false;
            Vector3 result = Vector3.zero;
            while (!positionFound && attempts-- > 0)
            {
                // print("looking for a safe position....");
                float height = Random.Range(MaxSpawnHeight.Min, MaxSpawnHeight.Max);
                float radius = Random.Range(MaxSpawnRadius.Min, MaxSpawnRadius.Max);
                Quaternion direction = Quaternion.Euler(0, Random.Range(-180f, 180f), 0f);
                Vector3 pivotPosition = Vector3.zero; // transform.position;
                Vector3 temp_result = pivotPosition + Vector3.up * height + direction * Vector3.forward * radius;

                var distanceToNewPosition = Vector3.ProjectOnPlane(temp_result - lastCollectedPosition, Vector3.up).magnitude;
                if (distanceToNewPosition > minDistanceXZ)
                {
                    // print("found a safe position to spawn the new object");
                    result = temp_result;
                    positionFound = true;
                }
            }

            return result;
        }
        Quaternion GetRandomRotation()
        {
            // deactivated pitch
            float pitch = 0; // UnityEngine.Random.Range(-60f, 60f);
            float yaw = Random.Range(-180f, 180f);
            return Quaternion.Euler(pitch, yaw, 0f);
        }
        public void ReduceNumCollected(object sender, VoxelCollectedEventArgs e)
        {
            trainingElements[e.grandparent] = (trainingElements[e.grandparent].numToCollect - 1,
                trainingElements[e.grandparent].collectibles);
            // print("reducing collected number, received grandparent: " + e.grandparent + ", to: " + trainingElements[e.grandparent].numToCollect);

            // if finished scanning an object, notify agent.
            if (trainingElements[e.grandparent].numToCollect == 0 && RespawnOnCollection)
            {
                lastCollectedPosition = e.grandparent.position;
                // Debug.Assert(m_TargetSpawnPrefab != null, "No Respawn Prefab specified");
                // first spawn a new target
                SpawnTarget(m_TargetSpawnPrefab, new Vector3(30,30,30));
                // set destruction of old target
                Destroy(e.grandparent.gameObject, TimeBeforeDestroy);
                // destroy from our records
                trainingElements.Remove(e.grandparent);
                // notify of full scan
                OnFullyScanned();
            }
        }
        private void OnFullyScanned()
        {
            // m_OnCollisionEventHandler?.Invoke(this, EventArgs.Empty);
            VoxelCollectedEventArgs args = new VoxelCollectedEventArgs();
            // args.CollisionCollider = collider;
            NotifyObjectFullyScanned(args);
        }
        private void NotifyObjectFullyScanned(VoxelCollectedEventArgs e)
        {
            EventHandler<VoxelCollectedEventArgs> handler = OnObjectFullyScannedEventHandler;
            if (handler != null)
            {
                print("Notifying Agent of Full Scan.");
                handler(this, e);
            }
           
        }
        
        private void OnApplicationQuit()
        {
            foreach (var kvp in trainingElements.ToArray())
            {
                foreach (var collectible in kvp.Value.collectibles)
                {
                    collectible.Collected -= ReduceNumCollected;;
                }
            }
        }

        public Vector3 GetClosestTarget(Vector3 origin)
        {
            Vector3 closestPoint = new Vector3(0, 0, 0);
            float minDist = 100000f;
            foreach (var kvp in trainingElements.ToArray())
            {
                // print("looking for closest target... " + kvp.Key.name + ", with numToCollect: " + kvp.Value.numToCollect);
                if (kvp.Value.numToCollect > 0)
                {
                    float dist = Vector3.Distance(origin, kvp.Key.position);
                    // print("distance between objects is: " + dist);
                    if (dist < minDist)
                    {
                        minDist = dist;
                        closestPoint = kvp.Key.position;
                    }
                } 
            }
            return closestPoint;
        }

    }

}