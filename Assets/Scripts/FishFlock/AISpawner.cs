using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class AISpawner : MonoBehaviour
{

    public List<Transform> Waypoints = new List<Transform>();

    public float SpawnerTimer { get { return m_spawnerTimer; } }
    public Vector3 SpawnArea { get { return m_spawnerArea; } }

    [Header("Global Stats")]
    [Range(0, 600)]
    [SerializeField]
    private float m_spawnerTimer;
    [SerializeField]
    private Color m_spawnerColor = new Color(1f, 0f, 0f, 0.3f);
    [SerializeField]
    private Vector3 m_spawnerArea = new Vector3(20, 10, 20);

    [Header("AI Group Setting")]
    public AIObjects[] AIObject = new AIObjects[1];

    private void Start()
    {
        GetWayPoints();
        RandomiseGroups();
        CreateAIGroups();
        InvokeRepeating("SpawnNPC", 0.5f, SpawnerTimer);
    }

    void SpawnNPC()
    {
        for (int i = 0; i < AIObject.Count(); i++)
        {
            if(AIObject[i].EnableSpawner && AIObject[i].ObjectPrefab != null)
            {
                GameObject tempGroup = GameObject.Find(AIObject[i].AIGroupName);
                if(tempGroup.GetComponentInChildren<Transform>().childCount < AIObject[i].MaxAI)
                {
                    for (int y = 0; y < Random.Range(0, AIObject[i].SpawnAmount); y++)
                    {
                        Quaternion randomRotation = Quaternion.Euler(Random.Range(-20,20), Random.Range(0,360),0);
                        GameObject tempSpawn;
                        tempSpawn = Instantiate(AIObject[i].ObjectPrefab, RandomPosition() ,randomRotation);
                        tempSpawn.transform.parent = tempGroup.transform;
                        tempSpawn.AddComponent<AIMove>();
                    }
                }
            }
        }
    }

    public Vector3 RandomPosition()
    {
        Vector3 randomPos = new Vector3(
            Random.Range(-SpawnArea.x, SpawnArea.x),
            Random.Range(-SpawnArea.y, SpawnArea.y),
            Random.Range(-SpawnArea.z, SpawnArea.z)
            );
        randomPos = transform.TransformPoint(randomPos * 0.5f);
        return randomPos;
    }

    public Vector3 RandomWayPoint()
    {
        int randomWP = Random.Range(0, (Waypoints.Count - 1));
        Vector3 randomWaypoint = Waypoints[randomWP].transform.position;
        return randomWaypoint; 
    }

    void GetWayPoints()
    {
        Transform[] wpList = transform.GetComponentsInChildren<Transform>();
        for (int i = 0; i < wpList.Length; i++)
        {
            if(wpList[i].tag == "WayPoint")
            {
                Waypoints.Add(wpList[i]);
            }
        }
    }

    void RandomiseGroups()
    {
        for (int i = 0; i < AIObject.Count(); i++)
        {
            if (AIObject[i].RandomizeStats)
            {
                AIObject[i].SetValue(Random.Range(1, 30), Random.Range(1, 20), Random.Range(1, 10));
            }
        }
    }

    void CreateAIGroups()
    {
        for (int i = 0; i < AIObject.Count(); i++)
        {
            GameObject m_AIGroupSpawn;
            m_AIGroupSpawn = new GameObject(AIObject[i].AIGroupName);
            m_AIGroupSpawn.transform.parent = this.gameObject.transform;
        }
    }

    private void OnDrawGizmosSelected()
    {
        Gizmos.color = m_spawnerColor;
        Gizmos.DrawCube(transform.position, SpawnArea);
    }
}

[System.Serializable]
public class AIObjects
{
    public string AIGroupName { get { return m_aiGroupName; } }
    public GameObject ObjectPrefab { get { return m_prefab; } }
    public int MaxAI { get { return m_maxAI; } }
    public int SpawnRate { get { return m_spawnRate; } }
    public int SpawnAmount { get { return m_maxSpawnAmount; } }
    public bool RandomizeStats { get { return m_randomizeStats; } }
    public bool EnableSpawner { get { return m_enableSpawner; } }

    [Header("AI Group Stats")]
    [SerializeField]
    private string m_aiGroupName;
    [SerializeField]
    private GameObject m_prefab;
    [SerializeField]
    [Range(0f, 30f)]
    private int m_maxAI;
    [SerializeField]
    [Range(0f, 20f)]
    private int m_spawnRate;
    [SerializeField]
    [Range(0f ,10f)]
    private int m_maxSpawnAmount;

    [Header("Main Setting")]
    [SerializeField]
    private bool m_randomizeStats;
    [SerializeField]
    private bool m_enableSpawner;

    public AIObjects(string name, GameObject pre, int maxAI, int rate, int amount, bool stats)
    {
        this.m_aiGroupName = name;
        this.m_prefab = pre;
        this.m_maxAI = maxAI;
        this.m_spawnRate = rate;
        this.m_maxSpawnAmount = amount;
        this.m_randomizeStats = stats;
    }
    public void SetValue(int maxAI, int rate, int amount)
    {
        this.m_maxAI = maxAI;
        this.m_spawnRate = rate;
        this.m_maxSpawnAmount = amount;
    }
}
