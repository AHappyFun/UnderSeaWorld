using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class KeyboardInput : IUserInput
{
    [Header("=== Key Setting ==")]
    public string KeyUp = "w";
    public string KeyDown = "s";
    public string KeyLeft = "a";
    public string KeyRight = "d";

    public string KeySpeed = "space";

    private void Update()
    {
        targetDup = (Input.GetKey(KeyUp) ? 1.0f : 0) - (Input.GetKey(KeyDown) ? 1.0f : 0);
        targetDright = (Input.GetKey(KeyRight) ? 1.0f : 0) - (Input.GetKey(KeyLeft) ? 1.0f : 0);

        //平滑输入信号
        DUp = Mathf.SmoothDamp(DUp, targetDup, ref velocityDup, 0.1f);
        DRight = Mathf.SmoothDamp(DRight, targetDright, ref velocityDright, 0.1f);

        if (inputEnabled == false)
        {
            DUp = 0;
            DRight = 0;
        }

        DUp *= 0.7f;
        DRight *= 0.7f;

        Vector2 tempUV = SquareToCircle(new Vector2(DRight, DUp));
        float DUp2 = tempUV.y;
        float DRight2 = tempUV.x ;

        Ddir = (DRight2 * transform.right + DUp2 * transform.forward).normalized;

        DSpeed = (Input.GetKey(KeySpeed) ? 1 : 0);
    }
}
