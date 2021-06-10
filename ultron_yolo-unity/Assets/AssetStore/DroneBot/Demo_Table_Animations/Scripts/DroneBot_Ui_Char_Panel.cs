using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
//creates the buttons on panel of animations
public class DroneBot_Ui_Char_Panel : MonoBehaviour {

	public GameObject character;
	public Transform acts_table;
	public Transform weap_table;
    public Button buttonPrefab;

    Button sel_btm;

	DroneBot_Actions actions;


	void Start () {
 
		actions = character.GetComponent<DroneBot_Actions> ();
 


		CreateActionButton("Idle1");
		CreateActionButton("Idle2");
		CreateActionButton("MoveForward");
		CreateActionButton("StrafeLeft");
		CreateActionButton("StrafeRight");


		CreateActionButton("Hit1");
		CreateActionButton("Hit2");
		CreateActionButton("Hit3");
		CreateActionButton("Hit4");
		CreateActionButton("Dead1");
		CreateActionButton("Dead2");
		CreateActionButton("Dead3");
		CreateActionButton("Repair");
		CreateActionButton("Fire");

  
 
    }

 

    void CreateActionButton(string name) {
		CreateActionButton(name, name);
	}

 
	void CreateActionButton(string name, string message) {

		Button button = CreateButton (name, acts_table);

		if (name == "Idle1")
		{
			sel_btm = button;
			button.GetComponentInChildren<Image>().color = new Color(.5f, .5f, .5f);
		}
		button.GetComponentInChildren<Text>().fontSize = 12;
		button.onClick.AddListener(()  => actions.SendMessage(message, SendMessageOptions.DontRequireReceiver));
		button.onClick.AddListener(() => select_btm(button)  );


	}
    void select_btm(Button btm)
    {
		sel_btm.GetComponentInChildren<Image>().color = new Color(.345f, .345f, .345f);
		btm.GetComponentInChildren<Image>().color = new Color(.5f, .5f, .5f);
        sel_btm = btm;
    }

 
    Button CreateButton(string name, Transform group) {
		GameObject obj = (GameObject) Instantiate (buttonPrefab.gameObject);
		obj.name = name;
		obj.transform.SetParent(group);
		obj.transform.localScale = Vector3.one;
		Text text = obj.transform.GetChild (0).GetComponent<Text> ();
		text.text = name;
		return obj.GetComponent<Button> ();
	}




	public void OpenPublisherPageyoutu() {
		Application.OpenURL ("https://youtu.be/gFDg7KeBveo");
	}
	public void OpenPublisherPage() {
		Application.OpenURL ("https://www.artstation.com/sintetus");
	}
 
 
}
