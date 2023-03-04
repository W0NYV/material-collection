using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteAlways]
[ImageEffectAllowedInSceneView]
public class CameraFilter : MonoBehaviour
{
    [SerializeField] private Material _material;

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, dest, _material);
    }
}
