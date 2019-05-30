// Community contribution: http://www.tasharen.com/forum/index.php?topic=9268.0
Shader "Hidden/Unlit/Transparent Colored_RGB (TextureClip)"
{
	Properties
	{
		_MainTex ("Base (RGB), Alpha (A)", 2D) = "black" {}
		_AlphaTex ("Alpha (R)", 2D) = "white" {}	
	}

	SubShader
	{
		LOD 200

		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}

		UsePass "Ares/Base/NGUIPassHelper/NGUI&TRANSPARENT&T&ALPHATEX"
	}
	Fallback "Unlit/Transparent Colored"
}
