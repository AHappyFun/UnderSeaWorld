using UnityEngine;
using System.Collections;
using UnityEditor;
using System.Collections.Generic;
/// <summary>
/// 改变Prefab
/// 注：通过选中匹配搜索被替换目标
/// （被选中物体的所有物体则替换）
/// </summary>
public class ChangePrefab : EditorWindow
{

    [MenuItem("Tools/Change Prefab")]
    public static void Open()
    {
        //GetWindow(typeof(Change_Prefab));
        GetWindow<ChangePrefab>("ChangePrefab工具");
    }

    public GameObject newPrefab;
    GameObject tonewPrefab;
    bool isChange = false;

    void OnGUI()
    {

        newPrefab = EditorGUILayout.ObjectField(newPrefab, typeof(Object), true, GUILayout.MinWidth(100f)) as GameObject;
        if (newPrefab != null)
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



    public void Change()
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