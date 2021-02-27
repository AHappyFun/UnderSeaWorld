using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 后处理基础类
/// </summary>
[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class PostProcessBase : MonoBehaviour
{

    private void Start()
    {
        CheckResources();
    }

    protected void CheckResources()
    {
        bool isSupport = CheckSupport();
        if(isSupport == false)
        {
            NotSupported();
        }
    }

    protected bool CheckSupport()
    {
        return SystemInfo.supportsImageEffects;
    }

    protected void NotSupported()
    {
        this.enabled = false;
    }

    protected Material CheckShaderAndCreateMaterial(Shader shader, Material material)
    {
        if (shader == null) { return null; }
        if (shader.isSupported && material && material.shader == shader) { return material; }
        if (!shader.isSupported) { return null; }
        else
        {
            material = new Material(shader);
            material.hideFlags = HideFlags.DontSave;
            if (material)
                return material;
            else
                return null;
        }
    }
}
