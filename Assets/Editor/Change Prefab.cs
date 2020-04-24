using UnityEngine;
using System.Collections;
using UnityEditor;
using System.Collections.Generic;
/// <summary>
/// 改变Prefab
/// 注：通过选中匹配搜索被替换目标
/// （被选中物体的所有物体则替换）
/// </summary>
public class Change_Prefab : EditorWindow 
{
 
    [MenuItem("Tools/Change Prefab")]
    public static void Open()
    {
        EditorWindow.GetWindow(typeof(Change_Prefab));
    }
 
    public GameObject newPrefab;
    static GameObject tonewPrefab;
 
    void OnGUI()
    {
 
        newPrefab = (GameObject)EditorGUILayout.ObjectField(newPrefab, typeof(GameObject),true, GUILayout.MinWidth(100f));
        tonewPrefab = newPrefab;
        if (isChange)
        {
            GUILayout.Button("正在替换...");
        }
        else
        {
            if (GUILayout.Button("替换"))
                Change();
        }
    }
 
    static bool isChange = false;
 
    public static void Change()
    {
        if (tonewPrefab == null)
            return;
 
        isChange = true;
        List<GameObject> destroy = new List<GameObject>();
        Object[] labels = Selection.gameObjects;
        foreach (Object item in labels)
        {
            GameObject tempGO = (GameObject)item; // (GameObject)item;
            //只要搜到的物体包含新Prefab的名字，就会被替换
                GameObject newGO = PrefabUtility.InstantiatePrefab(tonewPrefab) as GameObject;
                newGO.transform.SetParent(tempGO.transform.parent);
                newGO.name = newGO.name;
                newGO.transform.localPosition = tempGO.transform.localPosition;
                newGO.transform.localRotation = tempGO.transform.localRotation;
                newGO.transform.localScale = tempGO.transform.localScale;
 
                destroy.Add(tempGO);
        }
        foreach (GameObject item in destroy)
        {
            DestroyImmediate(item.gameObject);
        }
        isChange = false;
    }
}