using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IUserInput : MonoBehaviour
{
    public float DUp;     //0 - 1
    public float DRight;  //0 - 1
    public float DSpeed;
    public Vector3 Ddir;

    public bool inputEnabled = true;

    protected float targetDup;
    protected float targetDright;
    protected float velocityDup;
    protected float velocityDright;

    protected Vector2 SquareToCircle(Vector2 input)
    {
        Vector2 output;
        output.x = input.x * Mathf.Sqrt(1 - (input.y * input.y) / 2);
        output.y = input.y * Mathf.Sqrt(1 - (input.x * input.x) / 2);
        return output;
    }
}
