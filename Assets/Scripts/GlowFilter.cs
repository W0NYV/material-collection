using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

[ExecuteAlways]
[ImageEffectAllowedInSceneView]
public class GlowFilter : MonoBehaviour
{
	[SerializeField] private Material _material;

	private void OnRenderImage(RenderTexture src, RenderTexture dest)
	{
		
		//1 Blit 1 Pass
		
		RenderTexture brightnessTex = RenderTexture.GetTemporary(src.descriptor);
		
		Graphics.Blit(src, brightnessTex, _material, 1);
		
		Graphics.Blit(brightnessTex, brightnessTex, _material, 2);
		
		_material.SetTexture("_BrightnessTex", brightnessTex);
		
		Graphics.Blit(src, dest, _material, 3);
		
		RenderTexture.ReleaseTemporary(brightnessTex);
		
	}
}
