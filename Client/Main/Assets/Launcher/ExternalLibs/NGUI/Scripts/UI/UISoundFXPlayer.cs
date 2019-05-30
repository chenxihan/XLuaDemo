using System;
using System.Collections.Generic;

using System.Text;
using UnityEngine;

public enum UISoundType
{
    UICustom,
    UIAdd,
    UIBuy,
    UIHit,
    UIError,
    UIOpenBag,
    UIOpen,
    UIColse,
    UIYes,
    UINo,
}

public class UISoundFXPlayer : MonoBehaviour
{
    private static Action<String> _soundPlayer = null;
    public static Action<String> SoundPlayer
    {
        get { return _soundPlayer; }
        set { _soundPlayer = value; }
    }

    [SerializeField]
    private String _soundName = "snd_ui_hit";
    [SerializeField]
    private UISoundType _soundType = UISoundType.UIHit;
    private EventDelegate _delegate = null;

    public UISoundType SoundType
    {
        get { return _soundType; }
        set
        {
            if (_soundType != value)
            {
                _soundType = value;
                _soundName = GetTypeSound(_soundType);
            }
        }
    }

    public String SoundName
    {
        get { return _soundName; }
        set
        {
            if (_soundName != value)
            {
                _soundName = value;
                _soundType = UISoundType.UICustom;
            }
        }
    }

    protected void OnClick()
    {
        if (String.IsNullOrEmpty(_soundName) || _soundPlayer == null)
            return;
        _soundPlayer(_soundName);
    }

    private String GetTypeSound(UISoundType type)
    {
        switch (type)
        {
            case UISoundType.UIAdd:
                return "snd_ui_add";
            case UISoundType.UIBuy:
                return "snd_ui_buy";
            case UISoundType.UIHit:
                return "snd_ui_hit";
            case UISoundType.UIError:
                return "snd_ui_error";
            case UISoundType.UIOpenBag:
                return "snd_ui_openbag";
            case UISoundType.UIOpen:
                return "snd_ui_open";
            case UISoundType.UIColse:
                return "snd_ui_close";
            case UISoundType.UIYes:
                return "snd_ui_yes";
            case UISoundType.UINo:
                return "snd_ui_no";
        }
        return "";
    }
}
