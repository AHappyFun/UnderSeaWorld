using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 跟随目标的Camera
/// </summary>
public class MyFollowCamera : MonoBehaviour
{
    public static MyFollowCamera Instance;
    public Transform Target;    //目标

    [SerializeField]private float m_CamMoveSpeed = 1f;
    [Range(0f, 10f)][SerializeField]private float m_TurnSpeed = 1.5f;

    private Transform m_CamTrans;
    private Transform m_PivotTrans;

    private float m_LookAngle;  //左右角  沿Y轴
    private float m_TiltAngle;  //上下角  沿X轴

    private Vector3 m_PivotEulers;
    private Quaternion m_PivotRotation;
    private Quaternion m_TransformRotation;

    [SerializeField]private float m_XRotateMax = 30f;   //沿X轴最大角度
    [SerializeField]private float m_XRotateMin = -60f;   //沿X周最小角度
    [SerializeField]private bool m_LockCursor = false;   //锁定鼠标

    [HideInInspector]
    public GameObject LockTarget;

    private void Awake()
    {       
        Instance = this;
    }

    public void Init()
    {
        RefreshCursor();
        m_CamTrans = GetComponentInChildren<Camera>().transform;
        m_PivotTrans = m_CamTrans.parent;

        m_PivotEulers = m_PivotTrans.rotation.eulerAngles;
        m_PivotRotation = m_PivotTrans.transform.localRotation;
        m_TransformRotation = transform.localRotation;
    }

    public void Tick()
    {
        if (!LockTarget)
        {
            HandleRotationMovement();
        }
      
        RefreshCursor();  
    }

    public void LateTick()
    { 
        FollowTarget();
        if (LockTarget)
        {      
            //m_CamTrans.LookAt(LockTarget.transform, Vector3.up);
            Vector3 dir = LockTarget.transform.position - (Target.transform.position + new Vector3(0, 1, 0));
            //Vector3 dir = LockTarget.transform.position - (transform.position);     
            dir.y = 0;
            transform.forward = dir.normalized;
        }
    }

    void FollowTarget()
    {
        if (Target == null)
        {
            return;
        }
        transform.position = Vector3.Lerp(transform.position, Target.position, Time.deltaTime * m_CamMoveSpeed);
    }

    void HandleRotationMovement()
    {
        float x = Input.GetAxis("Mouse X");
        float y = Input.GetAxis("Mouse Y");

        m_LookAngle += x * m_TurnSpeed;
        m_TransformRotation = Quaternion.Euler(0f, m_LookAngle, 0f);

        m_TiltAngle -= y * m_TurnSpeed;   //这里用减
        //沿X旋转角度进行Clamp限制
        m_TiltAngle = Mathf.Clamp(m_TiltAngle, m_XRotateMin, m_XRotateMax);
        m_PivotRotation = Quaternion.Euler(m_TiltAngle, m_PivotEulers.y, m_PivotEulers.z);

        m_PivotTrans.localRotation = m_PivotRotation;
        transform.localRotation = m_TransformRotation;
    }

    void RefreshCursor()
    {
        Cursor.lockState = m_LockCursor ? CursorLockMode.Locked : CursorLockMode.None;
        Cursor.visible = !m_LockCursor;
    }

    public void SetLockTarget(GameObject lockGo)
    {
        LockTarget = lockGo;
    }
}
