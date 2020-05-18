using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Mover : MonoBehaviour
{
    public float moveSpeed = 1.8f;
    public Transform model;

    private IUserInput userInput;
    private Rigidbody rigid;

    private Vector3 movingVec;
    private void Awake()
    {
        userInput = GetComponent<IUserInput>();
        rigid = GetComponent<Rigidbody>();
    }

    private void Update()
    {
        if (userInput.Ddir != Vector3.zero)
        {
            Vector3 Ddir = (userInput.DRight * model.transform.right + model.transform.forward + model.transform.up * -userInput.DUp).normalized;
            model.transform.forward = Vector3.Slerp(model.transform.forward, Ddir, 0.01f);
        }
        else
        {

        }

        float d = (userInput.DSpeed > 0.1f) ? 1f : 0;
        movingVec = model.transform.forward * moveSpeed * d;
    }

    private void FixedUpdate()
    {
        rigid.velocity = movingVec;
        //transform.position 
    }

}
