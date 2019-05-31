------------------------------------------------
--作者：xihan
--日期：2019-04-4
--文件：Enum.lua
--模块：无
--描述：全局枚举，用Enum作为后缀
------------------------------------------------

--地图逻辑类型定义
MapLogicTypeDefine = {
    None = 0,           --无类型
    WanYaoTa = 1,       --万妖塔
    DaNengYiFu = 2,     --大能遗府
    XianJieZhiMen = 3,  --仙界之门
    PlaneCopy = 4,      --位面副本
    YZZDCopy = 5,       --勇者之巅副本
    SZZQCopy = 6,       --圣战之启副本（三界战场）
    FuDiCopy = 7,       --宗派福地副本
    FuDiDuoBaoCopy = 8, --宗派福地夺宝
    ArenaShouXi = 9,    --首席竞技场
    MySelfBossCopy = 10,--个人BOSS副本
    WorldBossCopy = 11, --世界BOSS副本
}

--副本类型定义(临时定义，以后修改)
CopyMapTypeEnum = {
    PlaneCopy = 32,  --位面副本
    TowerCopy = 3,  --爬塔副本
    StarCopy = 35,   --星级副本，打满多少星给奖励
}

--副本开启状态定义
CopyMapStateEnum = {
    NotOpen = 0,    --未开启
    WaitFight = 1,  --开启 等待进入
    Fighting = 2,   --开启正在战斗 
}

--副本主分页定义
UICopyMainPanelEnum = {
    SinglePanel = 0,    --单人副本
    TeamPanel = 1,      --组队副本
}

--单人副本分页定义
UISingleCopyPanelEnum = {
    TowerPanel = 0,     --爬塔副本
    StarPanel = 1,      --星级副本
}

--用于造化面板的分页类型区分，红点也用他
NatureEnum = {
    Begin = 1,
    Mount = 1, --坐骑
    Wing = 2, --翅膀
    Talisman = 3, --法宝
    Magic = 4, --阵法
    Weapon = 5, --神兵
    Count = 5
}
--用于造化面板分页里面的子类型区分，红点也用他
NatureSubEnum = {
    Begin = 1,
    BaseUpLevel = 1, --基础升级界面
    Drug = 2,    --第二分页吃丹或者突破
    Fashionable = 3, --时装
    MountEatEquip = 4, --坐骑吃装备
    Count = 4
}

--用于坐骑面板分页里面的子类型区分，红点也用他
MountEnum = {
    Begin = 1,
    BaseGrowUp = 1, --基础升级界面
    HighGrowUp = 2, -- 高级成长目前还没有
    Count = 2
}

--背包子功能枚举
BagFormSubEnum = {
    Bag = 0,    ----背包
    Store = 1,  ----仓库
    Synth = 2,      ----合成
    EquipSyn = 3    --合装
}

-- 日常活动类型
ActivityTypeEnum = {
    None = 0,
    Daily = 1,              -- 日常
    Limit = 2,              -- 限时
    CrossServer = 3,        -- 跨服
}

-- 日常面板分页
ActivityPanelTypeEnum = {
    Daily = 1,                  -- 日常
    Limit = 2,                  -- 限时
    CrossServer = 3,            -- 跨服
    Week = 4,                   -- 周历
    Push = 5,                   -- 推送
    Active = 6,                 -- 活跃度
}

--炼器一级分页
LianQiSubEnum = {
    Begin = 1,
    Forge = 1,              --锻造
    Gem = 2,                --宝石
    Count = 2,
}

--炼器，锻造的分页
LianQiForgeSubEnum = {
    Begin = 1,
    Strength = 1,           --装备强化
    Count = 1,
}

--炼器，宝石分页
LianQiGemSubEnum = {
    Begin = 1,
    Inlay = 1,              --宝石镶嵌
    Refine = 2,             --宝石精炼
    Jade = 3,               --仙玉镶嵌
    Count = 3,
}

-- 符咒任务状态
AmuletTaskStatusEnum = {
    Available = 1,           -- 可领取
    UnFinished = 2,          -- 不可领取
    RECEIVED =3,             -- 已领取
}

-- 符咒  值和Amulet表的id对应
AmuletEnum = {
    LuoFan = 101,           -- 落幡咒
    JiuXing = 201,          -- 九星神咒
    TuDi = 301,             -- 土地神咒
    PoDi = 401,             -- 破地狱咒
    JingXin = 50,           -- 净心神咒
}

-- 符咒 需要特殊处理的条件类型
AmuletConditionEnum = {
    None = 0,
    KillMonster = 1,               --  击杀Boss, 怪物
}

--宗派建筑枚举
GuildBuildEnum = {
    GuildShop = 1,      --商店
    GuildBase = 2,      --基地/大厅
    GuildDivine = 3,    --占卜
    GuildTask = 4,      --任务
    GuildShrine = 5,    --祭祠
    GuildScience = 6,   --科技
}

--BOSS界面枚举，用于BOSS界面分页标志
BossEnum = {
    WorldBoss = 1, --世界BOSS
    MySelfBoss = 2, --个人BOSS
}

--婚姻子功能枚举
MarriageSubEnum = {
    Main = 0,    --背包
    House = 1,  --仙居
    Child = 2,      --仙娃
    Box = 3,    --宝匣
    Bless = 4,    --祈福
    Process = 5    --流程
}

-- --公会界面大分类
GuildSubEnum =
{
    TYPE_BUILD = 0,       --建筑
    TYPE_INFO = 1,        --信息
    TYPE_REPERTORY = 2,   --仓库
    TYPE_LIST = 3,        --技能
    TYPE_ACTION = 4,      --活动
}

-- 境界礼包购买类型  对应state_package表的type
PurchaseTypeEnum = {
    Money = 1,              -- 直购
    YuanBao = 2,            -- 元宝
    BangYuan = 3,           -- 绑元
}

--宗派职位枚举
GuildOfficalEnum =
{
    Student = -1,     --学员，以前用的，暂时保留
    Member = 0,       --成员
    Elder = 1,        --长老
    Guardian = 2,     --护法
    ViceChairman = 3, --副宗主
    Chairman = 4,     --宗主
}
--成就领取状态
AchievementState = {
    Finish = 1, --已完成
    None = 2, --未达成
    CanGet = 3, --可领取
}