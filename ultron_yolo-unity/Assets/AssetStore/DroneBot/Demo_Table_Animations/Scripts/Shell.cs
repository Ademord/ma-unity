using System.Collections;
using System.Collections.Generic;
using UnityEngine;
//this script is for the  shell
public class Shell : MonoBehaviour {
	public float lifeTime = 2.0f;
	public int shellDamage = 10;
	public ParticleSystem m_ExplosionParticles;         // Reference to the particles that will play on explosion.
	public AudioSource m_ExplosionAudio;             
	void OnTriggerEnter(Collider col){
 
		// Play the particle system.
		if(m_ExplosionParticles)m_ExplosionParticles.Play();
		// Play the explosion sound effect.
		if(m_ExplosionAudio)m_ExplosionAudio.Play();
		GetComponent<Rigidbody> ().velocity =Vector3.zero;
		GetComponent<Collider> ().enabled = false;
		GetComponent<Renderer> ().enabled = false;
	 	Destroy (gameObject, 2);	 

 
 
	}
	private IEnumerator Start()
	{
		yield return new WaitForSeconds(0.03f);
		GetComponent<Collider> ().enabled = true;
		yield return new WaitForSeconds(lifeTime);
		Destroy(gameObject);
 
	}
}
