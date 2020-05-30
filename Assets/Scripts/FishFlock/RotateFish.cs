using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateFish : MonoBehaviour {

    public float BigSpeed;
    public string Dir;
    public Transform Center;

	
	// Update is called once per frame
	void Update () {
        if (Dir == "Y")
            transform.RotateAround(Center.position, new Vector3(0, 1, 0), BigSpeed);
        if (Dir == "X")
            transform.RotateAround(Center.position, new Vector3(1, 0, 0), BigSpeed);
        if (Dir == "Z")
            transform.RotateAround(Center.position, new Vector3(0, 0, 1), BigSpeed);

    }
}
