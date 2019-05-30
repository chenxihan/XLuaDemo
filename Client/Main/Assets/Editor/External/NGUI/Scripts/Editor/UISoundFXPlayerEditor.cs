using System;
using System.Collections.Generic;

using System.Text;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(UISoundFXPlayer))]
public class UISoundFXPlayerInspector : Editor
{
    UISoundFXPlayer _player = null;

    public override void OnInspectorGUI()
    {
        if (_player == null)
            _player = target as UISoundFXPlayer;
        UISoundType type = (UISoundType)EditorGUILayout.EnumPopup("Clipping", _player.SoundType);
        if (_player.SoundType != type)
        {
            _player.SoundType = type;
        }

        String name = EditorGUILayout.TextField("SoundName", _player.SoundName);
        if (_player.SoundName != name)
        {
            _player.SoundName = name;
        }
    }
}

