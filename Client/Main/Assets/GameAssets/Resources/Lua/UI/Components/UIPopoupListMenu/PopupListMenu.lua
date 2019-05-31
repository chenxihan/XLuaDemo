
------------------------------------------------
--作者： 王圣
--日期： 2019-04-22
--文件： PopoupListMenu.lua
--模块： PopoupListMenu
--描述： 下拉列菜单组件
------------------------------------------------

-- c#类
local PopupMenu = require "UI.Components.UIPopoupListMenu.PopupMenu"
local PopupListMenu = {
    WaiteIndex = -1,
    IsWaitReset = false,
    MenuList = List:New(),
    Speed = 600,
}

--创建下拉列表菜单
function PopupListMenu:CreateMenu()
    local _m = Utils.DeepCopy(self)
    _m.MenuList:Clear()
    return _m
end

--添加菜单
function PopupListMenu:AddMenu(root, type, name, childDataList, childMenuCall)
    local count = -1
    local heigh = -1
    local dis = -1
    local preMenu = nil
    local Menu = PopupMenu:New(root,type, name,childDataList,self,childMenuCall)
    self.MenuList:Add(Menu)
    if self.MenuList:Count() ~= 1 then
        preMenu = self.MenuList[self.MenuList:Count()]
    end
    count = self:GetBrotherChildCount(self.MenuList:Count())
    heigh = self:GetBrotherChildPicH(self.MenuList:Count())
    dis = self:GetBrotherChildDis(self.MenuList:Count())
    if preMenu == nil then
        Menu:InitMenuPos(count,heigh,dis,false)
    else
        preMenu:InitMenuPos(count,heigh,dis,true)
    end
end

--获取哥哥节点的子节点个数
function PopupListMenu:GetBrotherChildCount(index)
    if index <= self.MenuList:Count() and index>1 then
        local menu = self.MenuList[index-1]
        if menu ~= nil then
            local count = menu:GetChildMenuCount()
            return count
        end
    end
    return -1
end

--获取哥哥节点的子节点图片高度
function PopupListMenu:GetBrotherChildPicH(index)
    if index <= self.MenuList:Count() and index>1 then
        local menu = self.MenuList[index-1]
        if menu ~= nil then
            local heigh = menu:GetChildPicH()
            return heigh
        end
    end
    return -1
end

--获取哥哥节点的子节点之间的间距
function PopupListMenu:GetBrotherChildDis(index)
    if index <= self.MenuList:Count()and index>1 then
        local menu = self.MenuList[index-1]
        if menu ~= nil then
            local dis = menu:GetChildDis()
            return dis
        end
    end
    return -1
end

--获取Menu
function PopupListMenu:GetMenuById(childId)
    for i = 1, #self.MenuList do
        local menu = self.MenuList[i]
        local childMenu = menu:GetChildMenu(childId)
        if childMenu.FuncStartId == childId then
            return menu, childMenu
        end
    end
end

--更新ChildMenu
function PopupListMenu:UpdateChildMenu(id)
    local menu = nil
    local clickChild = nil
    for i = 1,#self.MenuList do
        if self.MenuList[i] then
            for m = 1, #self.MenuList[i].Childs do
                local childMenu = self.MenuList[i].Childs[m]
                if childMenu.FuncStartId == id then
                    menu = self.MenuList[i]
                    menu.CurClickChildId = childMenu.FuncStartId
                    clickChild = childMenu
                    break
                end
                --childMenu.SetUnSelected()
            end
        end
    end
    if menu ~= nil then
        for n = 1,#menu.Childs do
            local childMenu = menu.Childs[n]
            childMenu:SetUnSelected()
        end
        if clickChild ~= nil then
            clickChild:OpenFunction(true)
        end
    end
end

--更新MenuList
function PopupListMenu:UpdateMenuList(index)
    --先关闭所有打开的Menu
    for i = 1, #self.MenuList do
        if self.MenuList[i].IsOpen == true then
            --如果是打开的，关闭当前按钮
            self.MenuList[i]:CloseChildList(index)
            if index == -1 then
                self.MenuList[i].IsOpen = false
            end
        else
            self.MenuList[i]:ResetSelect()
        end
        if index ~= -1 and i ~= index then
            self.MenuList[i].CurClickChildId = 0
        end
        --重置按钮位置
        self.MenuList[i]:ResetPos()
        self.IsWaitReset = true
        self.WaiteIndex = index
    end
end

--打开菜单分页
function PopupListMenu:OpenMenuList(id)
    if id == -1 then
        if GameCenter.RankSystem.CurFunctionId == -1 then
            --默认打开第一个菜单的第一个分页
            if self.MenuList:Count() >=1 then
                local menu = self.MenuList[1]
                self:UpdateMenuList(menu.MenuType)
                local childMenu = menu:GetFristChild()
                menu:UpdateChildMenu(childMenu.FuncStartId)
            end
        else
            --打开CurFunctionId对应的菜单分页
            local menu,childMenu = self:GetMenuById(GameCenter.RankSystem.CurFunctionId)
            self:UpdateMenuList(menu.MenuType)
            menu:UpdateChildMenu(childMenu.FuncStartId)
        end
    else
        --打开Id对应的菜单分页
        local menu,childMenu = self:GetMenuById(id)
        self:UpdateMenuList(menu.MenuType)
        menu:UpdateChildMenu(childMenu.FuncStartId)
    end
end

--关闭所有Menu
function PopupListMenu:CloseAll()
    for i = 1, #self.MenuList do
        self.MenuList[i]:HideMenu()
        self.MenuList[i]:ResetSelect()
    end
    self.WaiteIndex = -1
    self.IsWaitReset = false
end

--判断是否可以点击菜单
function PopupListMenu:CanClickMenu()
    local canClick = true
    for i = 1,#self.MenuList do
        if self.MenuList[i]:HaveChildMove() then
            canClick = false
        end
    end
    return canClick
end

--获取Menu
function PopupListMenu:GetMenuIndexByType(type)
    
    for i = 1,#self.MenuList do
        if type == self.MenuList[i].MenuType then
            return i
        end
    end
    return -1
end

--update
function PopupListMenu:Update(dt)
    if self.MenuList then
        for i = 1, #self.MenuList do
            self.MenuList[i]:UpdatePos(dt)
        end
    end
    if self.IsWaitReset then
        local isOpen = true
        for i = 1, #self.MenuList do
            local isStartPos = self.MenuList[i]:IsOnStartPos()
            if not isStartPos or not self.MenuList[i]:IsChildShrink() then
                isOpen = false
            else
                self.MenuList[i].IsMoveToStart = false
            end
        end
        if isOpen then
            if self.WaiteIndex == -1 then
                self.IsWaitReset = false
                return
            end
            --打开index对应的Menu
            local moveY = 0
            if self.WaiteIndex+1 <= #self.MenuList then
                moveY = self.MenuList[self.WaiteIndex+1]:GetMoveDisY()
            end
            for i = self.WaiteIndex+1, #self.MenuList do
                self.MenuList[i]:SetMenuMovePos(moveY)
            end
            if self.WaiteIndex<=#self.MenuList then
                self.MenuList[self.WaiteIndex].IsOpen =true
                self.MenuList[self.WaiteIndex]:OpenChildList()
            end
            self.WaiteIndex = -1
            self.IsWaitReset = false
        end
    end
end
return PopupListMenu