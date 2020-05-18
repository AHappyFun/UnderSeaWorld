using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class FogEffect : MonoBehaviour
{
    public Material mat;
    public Color fogColor;
    public float DepthStart;
    public float DepthDistance;

    private void Start()
    {
        GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
    }
    private void Update()
    {
        mat.SetColor("_FogColor", fogColor);
        mat.SetFloat("_DepthStart", DepthStart);
        mat.SetFloat("_DepthDistance", DepthDistance);
    }
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, mat);
    }
}
