using UnityEngine;
using System.Collections;
//This script executes commands to change character animations
[RequireComponent (typeof (Animator))]
public class DroneBot_Actions : MonoBehaviour {

 
	private Animator animator,animatorWeap;
 
	void Awake () {
		animator = GetComponent<Animator> ();

 
 

 
    }
 

	public void Repair()
	{
		animator.SetBool ("Repair", true);
	}
	public void Fire()
	{
		animator.SetBool ("Fire", true);
	}
	public void Hit1()
	{
		animator.SetBool ("Hit1", true);
	}
	public void Hit2()
	{
		animator.SetBool ("Hit2", true);
	}
	public void Hit3()
	{
		animator.SetBool ("Hit3", true);
	}
	public void Hit4()
	{
		animator.SetBool ("Hit4", true);
	}
	public void Dead1()
	{
		animator.SetBool ("Dead1", true);
	}
	public void Dead2()
	{
		animator.SetBool ("Dead2", true);
	}
	public void Dead3()
	{
		animator.SetBool ("Dead3", true);
	}


	public void MoveForward()
	{
		animator.SetBool ("MoveForward", true);
	}

	public void StrafeLeft()
	{
		animator.SetBool ("StrafeLeft", true);
	}
	public void StrafeRight()
	{
		animator.SetBool ("StrafeRight", true);
	}
	public void Idle1()
	{
		animator.SetBool ("Idle1", true);
	}
	public void Idle2()
	{
		animator.SetBool ("Idle2", true);
	}
 

}
