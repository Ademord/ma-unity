using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TorusSegmentController : MonoBehaviour
{
    // The solid collider representing the flower petals
    private Collider flowerCollider;
    // The flower's material
    private Material flowerMaterial;
    [Tooltip("The color when the flower is full")]
    // public Color fullFlowerColor = new Color(1f, 0f, 0.3f, 0.5f);
    public Color fullFlowerColor = new Color(253, 204, 36, 128);

    [Tooltip("The color when the flower is empty")]
    // public Color emptyFlowerColor = new Color(0.5f, 0f, 1f, 0.5f);
    public Color emptyFlowerColor = new Color(200, 200, 200, 128);
 
    /// <summary>
    /// The amount of nectar remaining in flower
    /// </summary>
    public float NectarAmount { get; private set; }

    public float MAX_NECTAR_AMOUNT = 100f;
    public bool HasNectar { get { return NectarAmount > 0f; } }

    public float Feed(float amount)
    {

        float nectarTaken = Mathf.Clamp(amount, 0f, NectarAmount);
        NectarAmount -= nectarTaken;

        if (!HasNectar)
        {
            NectarAmount = 0;
            flowerCollider.gameObject.SetActive(false);
            flowerMaterial.SetColor("_BaseColor", emptyFlowerColor);
        }

        // return amount of nectar that was taken
        return nectarTaken;
    }
    
    public void Reset()
    {
        NectarAmount = MAX_NECTAR_AMOUNT * 100f;
        flowerCollider.gameObject.SetActive(true);
        flowerMaterial.SetColor("_BaseColor", fullFlowerColor);
    }

    private void Awake()
    {
        MeshRenderer meshRenderer = GetComponent<MeshRenderer>();
        flowerMaterial = meshRenderer.material;
        flowerCollider = transform.Find("TorusSegmentCollider").GetComponent<Collider>();
        // ResetFlower();
    }
}
