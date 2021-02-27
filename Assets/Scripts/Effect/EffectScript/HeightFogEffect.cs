using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class HeightFogEffect : MonoBehaviour
{
    public Material mat;

    public Color fogColor;
    public float FogStart;
    public float FogEnd;
    [Range(0, 3.0f)]
    public float FogDensity = 1.0f;
    private Camera cam;

    private void Start()
    {
        GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
        cam = Camera.main;
    }
    private void Update()
    {
        
    }
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Matrix4x4 frustumCorners = Matrix4x4.identity;
        float fov = cam.fieldOfView;
        float near = cam.nearClipPlane;
        float far = cam.farClipPlane;
        float aspect = cam.aspect;

        float halfHeight = near * Mathf.Tan(fov * 0.5f * Mathf.Deg2Rad);
        Vector3 toRight = cam.transform.right * halfHeight * aspect;
        Vector3 toTop = cam.transform.up * halfHeight;

        Vector3 topLeft = cam.transform.forward * near - toRight + toTop;
        float scale = topLeft.magnitude / near;
        topLeft.Normalize();
        topLeft *= scale;

        Vector3 topRight = cam.transform.forward * near + toRight + toTop;
        topRight.Normalize();
        topRight *= scale;

        Vector3 bottomLeft = cam.transform.forward * near - toRight - toTop;
        topRight.Normalize();
        topRight *= scale;

        Vector3 bottomRight = cam.transform.forward * near + toRight - toTop;
        topRight.Normalize();
        topRight *= scale;

        frustumCorners.SetRow(0, bottomLeft);
        frustumCorners.SetRow(1, bottomRight);
        frustumCorners.SetRow(3, topLeft);
        frustumCorners.SetRow(2, topRight);

        mat.SetMatrix("_FrustumCornersRay", frustumCorners);

        mat.SetColor("_FogColor", fogColor);
        mat.SetFloat("_FogStart", FogStart);
        mat.SetFloat("_FogEnd", FogEnd);
        mat.SetFloat("_FogStrength", FogDensity);
        Graphics.Blit(source, destination, mat);
    }
}
