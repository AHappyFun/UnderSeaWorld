//创建一个文件夹（右键单击Assets目录，然后单击Create> New Folder），然后将其命名为“ Editor”（如果尚不存在）。
//将此脚本放在该文件夹中

//此脚本在“编辑器”窗口中创建一个新菜单和一个新菜单项
//使用新的菜单项在给定的路径上创建一个Prefab。 如果预制件已经存在，它会询问您是否要更换它
//在层次结构中单击一个GameObject，然后转到“示例”>“创建预制件”以查看其运行情况。

using UnityEngine;
using UnityEditor;

public class Example : EditorWindow
{
    //使用菜单项（Create Prefab）创建一个新菜单
    [MenuItem("Tools/Create Prefab")]
    static void CreatePrefab()
    {
        //跟踪当前选定的GameObject
        GameObject[] objectArray = Selection.gameObjects;

        //遍历上面数组中的每个GameObject
        foreach (GameObject gameObject in objectArray)
        {
            //将路径设置为Assets文件夹中的路径，并将其命名为.prefab格式的GameObject名称。
            string localPath = "Assets/Arts/Prefab/" + gameObject.name + ".prefab";

            //检查路径中是否已经存在相同Prefab名称
            if (AssetDatabase.LoadAssetAtPath(localPath, typeof(GameObject)))
            {
                //创建对话框，询问用户是否确定要覆盖现有的预制件
                if (EditorUtility.DisplayDialog("Are you sure?",
                    "The Prefab already exists. Do you want to overwrite it?",
                    "Yes",
                    "No"))
                //如果用户按下是按钮，则创建预制件
                {
                    CreateNew(gameObject, localPath);
                }
            }
            //如果名称不存在，请创建新的Prefab
            else
            {
                Debug.Log(gameObject.name + " is not a Prefab, will convert");
                CreateNew(gameObject, localPath);
            }
        }
    }

    //如果没有选择，则禁用菜单项
    [MenuItem("Examples/Create Prefab", true)]
    static bool ValidateCreatePrefab()
    {
        return Selection.activeGameObject != null;
    }

    static void CreateNew(GameObject obj, string localPath)
    {
        //在给定的路径上创建一个新的Prefab
        Object prefab = PrefabUtility.CreatePrefab(localPath, obj);
        PrefabUtility.ReplacePrefab(obj, prefab, ReplacePrefabOptions.ConnectToPrefab);
    }
}