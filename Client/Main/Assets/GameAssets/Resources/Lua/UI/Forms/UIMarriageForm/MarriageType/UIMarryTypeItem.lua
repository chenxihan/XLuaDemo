------------------------------------------------
--作者： dhq
--日期： 2019-05-18
--文件： UIMarryTypeItem.lua
--模块： UIMarryTypeItem
--描述： 婚姻求婚的类型Item
------------------------------------------------

local UIMarryTypeItem = {
    --root
    RootGo = nil,
    Trans = nil,
    Parent = nil,
    Info = nil,
    -- 类型名字
    TypeTitleLabel = nil,
    -- 图片
    HouseTex = nil,
    -- 称号图片
    AppellationTex = nil,
    -- 夫妻称号
    UpLabel = nil,
    DownLabel = nil,
    -- 求婚价格
    PriceLabel = nil,
    RewardList = nil,
}

function UIMarryTypeItem:New(go, parent)
    local _result = Utils.DeepCopy(self);
    _result.RootGo = go;
    _result.Trans = go.transform;
    _result.Parent = parent;
    _result:OnFirstShow();
    return _result
end

function UIMarryTypeItem:OnFirstShow()
    self.TypeTitleLabel = UIUtils.FindLabel(self.Trans, "TypeTitle/Label");
    self.HouseTex = UIUtils.FindTex(self.Trans, "HouseTex");

    self.RewardList = List:New()
    for _index = 1, 2 do
        local _reward = UIUtils.FindTrans(self.Trans, string.format( "Reward/%s", _index ));
        local _rewardUIItem = UIUtils.RequireUIItem(_reward)
        self.RewardList:Add(_rewardUIItem)
    end

    self.AppellationTex = UIUtils.FindTex(self.Trans, "AppellationLabel/Tex");

    self.UpLabel = UIUtils.FindLabel(self.Trans, "SpecialName/Up/Label");
    self.DownLabel = UIUtils.FindLabel(self.Trans, "SpecialName/Down/Label");
    self.PriceLabel = UIUtils.FindLabel(self.Trans, "Price/Label/PriceLabel");
end

--刷新
function UIMarryTypeItem:Refresh(info)
    self.Info = info;
    if self.Info ~= nil then
        -- 豪华婚礼
        self.TypeTitleLabel.text = self.Info.TypeName
        -- 获取到父节点的的CSForm
        local _parentCSForm = self.Parent.Parent.Parent.CSForm;
        -- 加载图片
        _parentCSForm:LoadTexture(self.HouseTex, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, self.Info.HouseTexName))
        _parentCSForm:LoadTexture(self.AppellationTex, AssetUtils.GetImageAssetPath(ImageTypeCode.UI, self.Info.AppellationName))
        local _itemArr = Utils.SplitStr(self.Info.Award, ';')
        for i = 1, #_itemArr do
            if #self.RewardList >= i then
                local _strs = Utils.SplitStr(_itemArr[i], '_')
                if #_strs >= 3 then
                    local _id = tonumber(_strs[1]) and tonumber(_strs[1]) or -1
                    local _num = tonumber(_strs[2]) and tonumber(_strs[2]) or -1
                    local _bind = tonumber(_strs[3]) and tonumber(_strs[3]) or -1
                    self.RewardList[i]:InitializationWithIdAndNum(_id, _num, _bind == 1, false)
                end
            end
        end
        self.UpLabel.text = string.format( "%s的夫君", self.Info.WifeName )
        self.DownLabel.text = string.format( "%s的妻子", self.Info.HusbandName )
        self.PriceLabel.text = self.Info.Price
    end
end

function UIMarryTypeItem:LoadTexFinish(tex)
    if tex.Texture == nil then
        return
    end
    self.HouseTex.mainTexture = tex
end

function UIMarryTypeItem:LoadAppellationTexFinish(tex)
    if tex.Texture == nil then
        return
    end
    self.AppellationTex.mainTexture = tex
end

return UIMarryTypeItem