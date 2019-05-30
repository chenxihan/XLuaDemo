//----------------------------------------------
//            NGUI: Next-Gen UI kit
// Copyright © 2011-2015 Tasharen Entertainment
//----------------------------------------------

using UnityEngine;
using System.Collections.Generic;

/// <summary>
/// Generated geometry class. All widgets have one.
/// This class separates the geometry creation into several steps, making it possible to perform
/// actions selectively depending on what has changed. For example, the widget doesn't need to be
/// rebuilt unless something actually changes, so its geometry can be cached. Likewise, the widget's
/// transformed coordinates only change if the widget's transform moves relative to the panel,
/// so that can be cached as well. In the end, using this class means using more memory, but at
/// the same time it allows for significant performance gains, especially when using widgets that
/// spit out a lot of vertices, such as UILabels.
/// </summary>

public class UIGeometry
{
	/// <summary>
	/// Widget's vertices (before they get transformed).
	/// </summary>

	public BetterList<Vector3> verts = new BetterList<Vector3>();

	/// <summary>
	/// Widget's texture coordinates for the geometry's vertices.
	/// </summary>

	public BetterList<Vector2> uvs = new BetterList<Vector2>();

	/// <summary>
	/// Array of colors for the geometry's vertices.
	/// </summary>

	public BetterList<Color32> cols = new BetterList<Color32>();

	// Relative-to-panel vertices, normal, and tangent
	BetterList<Vector3> mRtpVerts = new BetterList<Vector3>();
    BetterList<Vector2> uv2s = new BetterList<Vector2>();

    Vector3 mRtpNormal;
	Vector4 mRtpTan;

	/// <summary>
	/// Whether the geometry contains usable vertices.
	/// </summary>

	public bool hasVertices { get { return (verts.size > 0); } }

	/// <summary>
	/// Whether the geometry has usable transformed vertex data.
	/// </summary>

	public bool hasTransformed { get { return (mRtpVerts != null) && (mRtpVerts.size > 0) && (mRtpVerts.size == verts.size); } }

	/// <summary>
	/// Step 1: Prepare to fill the buffers -- make them clean and valid.
	/// </summary>

	public void Clear ()
	{
		verts.Clear();
		uvs.Clear();
		cols.Clear();
		mRtpVerts.Clear();
        uv2s.Clear();

    }

	/// <summary>
	/// Step 2: Transform the vertices by the provided matrix.
	/// </summary>

	public void ApplyTransform (Matrix4x4 widgetToPanel, bool generateNormals,float height, float width,bool isOverall)
	{
        if (verts.size > 0)
        {
            mRtpVerts.Clear();
            uv2s.Clear();
            
            if (isOverall) 
            { //如果处理进行整体处理,
                float wh = Mathf.Min(3f, Mathf.Max(1, width / height));                
                //记录x,y的最大和最小
                Vector4 b = new Vector4(verts[0].x, verts[0].y, verts[0].x, verts[0].y);
                //临时变量
                Vector3 v;
                for (int i = 1, imax = verts.size; i < imax; ++i)
                {
                    v = verts[i];
                    b.x = Mathf.Min(b.x, v.x);
                    b.y = Mathf.Min(b.y, v.y);
                    b.z = Mathf.Max(b.z, v.x);
                    b.w = Mathf.Max(b.w, v.y);
                }
                //记录大小
                Vector2 sz = new Vector2(b.z - b.x, b.w - b.y);

                for (int i = 0, imax = verts.size; i < imax; ++i)
                {
                    v = verts[i];

                    mRtpVerts.Add(widgetToPanel.MultiplyPoint3x4(v));

                    uv2s.Add(new Vector2((v.x - b.x) / sz.x * wh, (v.y - b.y) / sz.y));
                }
            }
            else
            {//如果不是整体处理                
                for (int i = 0, imax = verts.size; i < imax; ++i)
                {
                    mRtpVerts.Add(widgetToPanel.MultiplyPoint3x4(verts[i]));

                    int st = i % 4;
                    if (st == 0) uv2s.Add(new Vector2(0, 0));
                    if (st == 1) uv2s.Add(new Vector2(0, 1));
                    if (st == 2) uv2s.Add(new Vector2(1, 1));
                    if (st == 3) uv2s.Add(new Vector2(1, 0));
                    
                }
            }


            // Calculate the widget's normal and tangent
            if (generateNormals)
            {
                mRtpNormal = widgetToPanel.MultiplyVector(Vector3.back).normalized;
                Vector3 tangent = widgetToPanel.MultiplyVector(Vector3.right).normalized;
                mRtpTan = new Vector4(tangent.x, tangent.y, tangent.z, -1f);
            }
        }
        else
        {
            mRtpVerts.Clear();
            uv2s.Clear();
        }
	}

	/// <summary>
	/// Step 3: Fill the specified buffer using the transformed values.
	/// </summary>

	public void WriteToBuffers (BetterList<Vector3> v, BetterList<Vector2> u, BetterList<Color32> c, BetterList<Vector3> n, BetterList<Vector4> t, BetterList<Vector2> u2)
	{
		if (mRtpVerts != null && mRtpVerts.size > 0)
		{
			if (n == null)
			{
				for (int i = 0; i < mRtpVerts.size; ++i)
				{
					v.Add(mRtpVerts.buffer[i]);
					u.Add(uvs.buffer[i]);
					c.Add(cols.buffer[i]);
                    u2.Add(uv2s.buffer[i]);

                }
			}
			else
			{
				for (int i = 0; i < mRtpVerts.size; ++i)
				{
					v.Add(mRtpVerts.buffer[i]);
					u.Add(uvs.buffer[i]);                    
                    c.Add(cols.buffer[i]);
					n.Add(mRtpNormal);
					t.Add(mRtpTan);
                    u2.Add(uv2s.buffer[i]);
                }
			}
		}
	}
}
