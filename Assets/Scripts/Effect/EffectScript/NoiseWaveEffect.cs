using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class NoiseWaveEffect : MonoBehaviour {

    public Material mat;
    public float DepthStart;
    public float DepthDistance;

    private void Update()
    {
        mat.SetFloat("_DepthStart", DepthStart);
        mat.SetFloat("_DepthDistance", DepthDistance);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, mat);
    }
}
