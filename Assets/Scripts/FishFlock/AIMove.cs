using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AIMove : MonoBehaviour {

    AISpawner m_AIManager;

    bool m_HasTarget = false;
    bool m_IsTurning;

    Vector3 m_WayPoint;
    Vector3 m_LastWayPoint = new Vector3(0f, 0f, 0f);

    //Animator m_Animator;
    float m_Speed;

    private void Start()
    {
        m_AIManager = transform.parent.GetComponentInParent<AISpawner>();
        //m_Animator = GetComponent<Animator>();
        SetUpNPC();
    }
    void SetUpNPC()
    {
        float scale = Random.Range(0, 4);
        transform.localScale += new Vector3(scale * 1.5f, scale, scale);
    }
    private void Update()
    {
        if (!m_HasTarget)
        {
            m_HasTarget = CanFindTarget();
        }
        else
        {
            RotateNPC(m_WayPoint, m_Speed);
            transform.position = Vector3.MoveTowards(transform.position, m_WayPoint, m_Speed * Time.deltaTime);
        }
        if(transform.position == m_WayPoint)
        {
            m_HasTarget = false;
        }
    }

    bool CanFindTarget(float start = 1f, float end = 7f)
    {
        m_WayPoint = m_AIManager.RandomWayPoint();
        if(m_LastWayPoint == m_WayPoint)
        {
            m_WayPoint = m_AIManager.RandomWayPoint();
            return false;
        }
        else
        {
            m_LastWayPoint = m_WayPoint;
            m_Speed = Random.Range(start,end);
            //m_Animator.speed = m_Speed;
            return true;
        }
    }

    void RotateNPC(Vector3 waypoint, float curSpeed)
    {
        float turnSpeed = curSpeed * Random.Range(1f, 3f);

        Vector3 lookAt = waypoint - this.transform.position;
        transform.rotation = Quaternion.Slerp(transform.rotation, Quaternion.LookRotation(lookAt), turnSpeed * Time.deltaTime);
    }
}
