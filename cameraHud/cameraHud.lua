--模块
local MyMath = require("computational")
local DkJson = require("dkjson")

--配置文件操作--后期集成,现在将就用
-- 读取JSON配置文件
function load_config(filename)
    local file = io.open(filename, "r")
    if not file then return nil end
    
    local content = file:read("*a")
    file:close()
    
    return DkJson.decode(content)
end

-- 保存配置到JSON文件
function save_config(filename, config)
    local json_str = DkJson.encode(config, {indent = true})
    local file = io.open(filename, "w")
    file:write(json_str)
    file:close()
end

--启动
local laounch_Data= load_config("cameraHud\\launchData.json")
if(not laounch_Data)then
    term.setTextColour(0x4000)
    print("\"launchData.json\" load failure!")
    term.setTextColour(0x1)
end

--外设
local NamesTable = peripheral.getNames()
local peripherals = {}
term.setTextColour(0x20)
for k,v in ipairs(NamesTable) do
    local peripheralName = peripheral.getType(v)
    print(k,"|",v,"-->",peripheralName)

    peripherals[v] = peripheral.wrap(v)
end

local peripheralID = {}
local dd244883_textformat = string.format("%s_%d","hologram",laounch_Data.hologram_ID)
peripheralID["hologram"] = dd244883_textformat
dd244883_textformat = string.format("%s_%d","camera",laounch_Data.camera_ID)
peripheralID["camera"] = dd244883_textformat
dd244883_textformat = string.format("%s_%d","EngineController",laounch_Data.Engine_ID)
peripheralID["Engine"] = dd244883_textformat

local hologram = peripherals[peripheralID["hologram"]]
local camera = peripherals[peripheralID["camera"]]
local Engine
if(laounch_Data.engineControl)then
    Engine = peripherals[peripheralID["Engine"]]
end
term.setTextColour(0x1)

--初始化外设
local HologramScale = {x = laounch_Data.hologramScale,y = laounch_Data.hologramScale}--1/20
local HologramSize = {x = laounch_Data.hologramSize.w,y = laounch_Data.hologramSize.h}-- 500 350
local HWsize = 1/16*laounch_Data.hologramScale --缩放比例
local HologramWorldWH = {x = HWsize*HologramSize.x,y = HWsize*HologramSize.y}
local HUDRotation = {yaw = 0,pitch = 0,roll = 0}
local HUDTranslation = {x = 0,y = 0,z = 0}
local _x,_y,_z = hologram.GetBlockPos()
local HUDblockPs = MyMath.Vector3:new(_x,_y,_z)
hologram.Resize(HologramSize.x,HologramSize.y)
hologram.SetScale(HologramScale.x,HologramScale.y)
hologram.SetRotation(HUDRotation.yaw,HUDRotation.pitch,HUDRotation.roll)
hologram.SetTranslation(HUDTranslation.z,HUDTranslation.y,HUDTranslation.x)
hologram.SetClearColor(0x1)

local HudWindow = MyMath.Rect:new(0,0,HologramSize.x,HologramSize.y)
local signcolor = 0x00FF00FF

--绘图
local TEXT_Table = {}
TEXT_Table["0"] = {--0
1,1,1,
1,0,1,
1,0,1,
1,0,1,
1,1,1
}
TEXT_Table["1"] = {--1
0,1,0,
0,1,0,
0,1,0,
0,1,0,
0,1,0
}
TEXT_Table["2"] = {--2
1,1,1,
0,0,1,
1,1,1,
1,0,0,
1,1,1
}
TEXT_Table["3"] = {--3
1,1,1,
0,0,1,
1,1,1,
0,0,1,
1,1,1
}
TEXT_Table["4"] = {--4
1,0,1,
1,0,1,
1,1,1,
0,0,1,
0,0,1
}
TEXT_Table["5"] = {--5
1,1,1,
1,0,0,
1,1,1,
0,0,1,
1,1,1
}
TEXT_Table["6"] = {--6
1,1,1,
1,0,0,
1,1,1,
1,0,1,
1,1,1
}
TEXT_Table["7"] = {--7
1,1,1,
0,0,1,
0,0,1,
0,0,1,
0,0,1
}
TEXT_Table["8"] = {--8
1,1,1,
1,0,1,
1,1,1,
1,0,1,
1,1,1
}
TEXT_Table["9"] = {--9
1,1,1,
1,0,1,
1,1,1,
0,0,1,
1,1,1
}
TEXT_Table["."] = {--.
0,0,0,
0,0,0,
0,0,0,
0,0,0,
0,1,0
}
TEXT_Table["-"] = {-- -
0,0,0,
0,0,0,
1,1,1,
0,0,0,
0,0,0
}
TEXT_Table[" "] = {--  
0,0,0,
0,0,0,
0,0,0,
0,0,0,
0,0,0
}
TEXT_Table[":"] = {--:
0,0,0,
0,1,0,
0,0,0,
0,0,0,
0,1,0
}
TEXT_Table["A"] = {--  
0,1,0,
1,0,1,
1,1,1,
1,0,1,
1,0,1
}
TEXT_Table["B"] = {--  
1,1,0,
1,0,1,
1,1,0,
1,0,1,
1,1,1
}
TEXT_Table["C"] = {--  
0,1,1,
1,0,0,
1,0,0,
1,0,0,
0,1,1
}
TEXT_Table["D"] = {--  
1,1,0,
1,0,1,
1,0,1,
1,0,1,
1,1,0
}
TEXT_Table["E"] = {--  
1,1,1,
1,0,0,
1,1,1,
1,0,0,
1,1,1
}
TEXT_Table["F"] = {--  
1,1,1,
1,0,0,
1,1,1,
1,0,0,
1,0,0
}
TEXT_Table["G"] = {--  
0,1,0,
1,0,1,
1,0,0,
1,0,1,
0,1,1
}
TEXT_Table["H"] = {--  
1,0,1,
1,0,1,
1,1,1,
1,0,1,
1,0,1
}
TEXT_Table["I"] = {--  
1,1,1,
0,1,0,
0,1,0,
0,1,0,
1,1,1
}
TEXT_Table["J"] = {--  
1,1,1,
0,0,1,
0,0,1,
1,0,1,
0,1,1
}
TEXT_Table["K"] = {--  
1,0,1,
1,1,0,
1,1,0,
1,0,1,
1,0,1
}
TEXT_Table["L"] = {--  
1,0,0,
1,0,0,
1,0,0,
1,0,0,
1,1,1
}
TEXT_Table["M"] = {--  
1,0,1,
1,1,1,
1,0,1,
1,0,1,
1,0,1
}
TEXT_Table["N"] = {--  
0,0,0,
0,0,0,
1,1,0,
1,0,1,
1,0,1
}
TEXT_Table["O"] = {--  
0,1,0,
1,0,1,
1,0,1,
1,0,1,
0,1,0
}
TEXT_Table["P"] = {--  
1,1,0,
1,0,1,
1,1,0,
1,0,0,
1,0,0
}
TEXT_Table["Q"] = {--  
0,1,0,
1,0,1,
1,0,1,
1,1,1,
0,1,1
}
TEXT_Table["R"] = {--  
1,1,0,
1,0,1,
1,1,0,
1,0,1,
1,0,1
}
TEXT_Table["S"] = {--  
0,1,1,
1,0,0,
1,1,0,
0,0,1,
1,1,0
}
TEXT_Table["T"] = {--  
1,1,1,
0,1,0,
0,1,0,
0,1,0,
0,1,0
}
TEXT_Table["U"] = {--  
1,0,1,
1,0,1,
1,0,1,
1,0,1,
0,1,0
}
TEXT_Table["V"] = {--  
1,0,1,
1,0,1,
1,0,1,
0,1,0,
0,1,0
}
TEXT_Table["W"] = {--  
1,0,1,
1,0,1,
1,0,1,
1,1,1,
1,0,1
}
TEXT_Table["X"] = {--  
0,0,0,
0,0,0,
1,0,1,
0,1,0,
1,0,1
}
TEXT_Table["Y"] = {--  
1,0,1,
1,0,1,
0,1,0,
0,1,0,
0,1,0
}
TEXT_Table["Z"] = {--  
1,1,1,
0,0,1,
0,1,0,
1,0,0,
1,1,1
}

function BakeBitMap(buf, color)
    local b = {}
    i = 0
    for _, v in ipairs(buf) do
        if v == 1 then
            b[i] = color
        else
            b[i] = 0x00000000
        end
        i = i + 1
    end
    return b
end

function MdrawText(x,y,text,color)
    for i = 1,#text,1 do
        hologram.Blit(x + i * 4 - 4,y,3,5,BakeBitMap(TEXT_Table[string.sub(text,i,i)],color),2)
    end
end

function WMdrawText(x,y,text,color,WINTABLE)
    for i = 1,#text,1 do
        if(x >= WINTABLE.left and y >= WINTABLE.top and x <= WINTABLE.right and y <= WINTABLE.bottom)then
            hologram.Blit(x + i * 4 - 4,y,3,5,BakeBitMap(TEXT_Table[string.sub(text,i,i)],color),2)
        end
    end
end

function getCoordinates(angle, radius)--已知角和半径求坐标
    local radians = angle * math.pi / 180

    local x = radius * math.cos(radians)
    local y = radius * math.sin(radians)

    return x, y
end

function W_MdrawLine(x, y, x_, y_, color, windowTable)
    local dx = x_ - x
    local dy = y_ - y
    local k = dy / dx

    local e = 0
    if math.abs(k) > 1 then
        e = math.abs(dy)
    else
        e = math.abs(dx)
    end
    
    local xadd = dx / e
    local yadd = dy / e
    
    -- 分段绘制，每次最多绘制1000个点
    local MAX_SEGMENT = 500
    local segments = math.ceil(e / MAX_SEGMENT)
    
    for seg = 1, segments do
        local segmentLength = math.min(MAX_SEGMENT, e - (seg-1)*MAX_SEGMENT)
        
        for i = 0, segmentLength do
            local currentX = x + xadd * ((seg-1)*MAX_SEGMENT + i)
            local currentY = y + yadd * ((seg-1)*MAX_SEGMENT + i)
            
            if not (currentX + 0.5 < windowTable.left or currentY + 0.5 < windowTable.top 
                    or currentX + 0.5 > windowTable.right or currentY + 0.5 > windowTable.bottom) then
                hologram.Fill(currentX - 0.5, currentY - 0.5, 1, 1, color, 0)
            end
        end
    end
end

function drawCircleLine(centerX, centerY, radius, segments,colors,windowTable)
    local angleIncrement = 2 * math.pi / segments  -- 每一段的角度增加
    local lastX = centerX + radius  -- 起始点的 x 坐标
    local lastY = centerY           -- 起始点的 y 坐标

    for i = 1, segments + 1 do
        local angle = i * angleIncrement
        local x = centerX + radius * math.cos(angle)
        local y = centerY + radius * math.sin(angle)

        -- 画线段从 lastX，lastY 到 x，y
        W_MdrawLine(lastX, lastY,x, y,colors,windowTable)

        lastX = x
        lastY = y
    end
end

function drawPolygon(Points,PointNum_2,linecolor,WINTABLE)
    for i = 1,PointNum_2,1 do
        if(i == PointNum_2 - 1)then
            W_MdrawLine(Points[i] + 1,Points[i + 1] + 1,Points[1] + 1,Points[2] + 1,linecolor,WINTABLE)
            break
        elseif((i + 1) % 2 == 0)then
            W_MdrawLine(Points[i] + 1,Points[i + 1] + 1,Points[i + 2] + 1,Points[i + 3] + 1,linecolor,WINTABLE)
        end
    end
end

--功能实现
local CtoS = laounch_Data.Camera_Screen_Distance;--0.4

local HUDTranslation_unRotate = MyMath.Vector3:new(-CtoS,0,0)
local HUDTranslation_unRotate_offset = laounch_Data.HUDTranslation_unRotate_offset--MyMath.Vector3:new(0,-1,1)
local HUDTranslation_total = MyMath.Vector3:new(0,0,0)
local cameraPs = MyMath.Vector3:new(0,0,0)
local cameraQuat = MyMath.Quat:new(0,0,0,0)
local cameraQuat_World = MyMath.Quat:new(0,0,0,0)
local cameraEuler = MyMath.Euler:new(0,0,0)
local cameraEuler_World = MyMath.Euler:new(0,0,0)

local shipQuat = MyMath.Quat:new(0,0,0,0)
local shipEuler = MyMath.Euler:new(0,0,0)
local Ship_Omega = MyMath.Vector3:new(0,0,0)

local HUDradarPoint = {}
local HUDradarRect = {}

local JiZhunXian_PointTable = {
    1,1,0,1,0,1,1,0,
    0,0,1,0,1,0,0,0
}
function Pitch()
    local halfScreenXY = MyMath.Vector2:new(HologramSize.x/2,HologramSize.y/2)

    local Pitch_Screen = (halfScreenXY.y*2.2)/90

    local Dxy = MyMath.Vector2:new(halfScreenXY.x-20,-cameraEuler_World.pitch*Pitch_Screen)

    W_MdrawLine(20+halfScreenXY.x,Dxy.y+halfScreenXY.y,Dxy.x+halfScreenXY.x,Dxy.y+halfScreenXY.y,signcolor,HudWindow)
    W_MdrawLine(-20+halfScreenXY.x,Dxy.y+halfScreenXY.y,-Dxy.x+halfScreenXY.x,Dxy.y+halfScreenXY.y,signcolor,HudWindow)
    for i=0,90,1 do
        if(i % 15 == 0)then
            Dxy = MyMath.Vector2:new(40,(-cameraEuler_World.pitch+i)*Pitch_Screen)
            W_MdrawLine(20+halfScreenXY.x,Dxy.y+halfScreenXY.y,Dxy.x+halfScreenXY.x,Dxy.y+halfScreenXY.y,signcolor,HudWindow)
            W_MdrawLine(-Dxy.x+halfScreenXY.x,Dxy.y+halfScreenXY.y,-20+halfScreenXY.x,Dxy.y+halfScreenXY.y,signcolor,HudWindow)
        end
    end
    for i=0,-90,-1 do
        if(i % 15 == 0)then
            Dxy = MyMath.Vector2:new(40,(-cameraEuler_World.pitch+i)*Pitch_Screen)
            W_MdrawLine(20+halfScreenXY.x,Dxy.y+halfScreenXY.y,Dxy.x+halfScreenXY.x,Dxy.y+halfScreenXY.y,signcolor,HudWindow)
            W_MdrawLine(-Dxy.x+halfScreenXY.x,Dxy.y+halfScreenXY.y,-20+halfScreenXY.x,Dxy.y+halfScreenXY.y,signcolor,HudWindow)
        end
    end

    hologram.Blit(halfScreenXY.x-4,halfScreenXY.y-1,8,2,BakeBitMap(JiZhunXian_PointTable,signcolor),2)

    W_MdrawLine(100,halfScreenXY.y,110,halfScreenXY.y,signcolor,HudWindow)
    W_MdrawLine(HologramSize.x-100,halfScreenXY.y,HologramSize.x-110,halfScreenXY.y,signcolor,HudWindow)
    --W_MdrawLine(HologramSize.x,0,0,HologramSize.y,signcolor,HudWindow)
    --W_MdrawLine(0,0,HologramSize.x,HologramSize.y,signcolor,HudWindow)
end

function yaw()
    local XY = MyMath.Vector2:new(HologramSize.x/2,30)

    local Yaw_Screen = (XY.x*3.5)/180
    
    local Dxy = MyMath.Vector2:new(cameraEuler_World.yaw*Yaw_Screen,5)
    W_MdrawLine(Dxy.x+XY.x,-Dxy.y+XY.y,Dxy.x+XY.x,Dxy.y+XY.y,signcolor,HudWindow)

    for i=0,230,1 do
        if(i % 15 == 0)then
            Dxy = MyMath.Vector2:new((cameraEuler_World.yaw+i)*Yaw_Screen,2)
            W_MdrawLine(Dxy.x+XY.x,-Dxy.y+XY.y,Dxy.x+XY.x,Dxy.y+XY.y,signcolor,HudWindow)
        end
    end
    for i=0,-230,-1 do
        if(i % 15 == 0)then
            Dxy = MyMath.Vector2:new((cameraEuler_World.yaw+i)*Yaw_Screen,2)
            W_MdrawLine(Dxy.x+XY.x,-Dxy.y+XY.y,Dxy.x+XY.x,Dxy.y+XY.y,signcolor,HudWindow)
        end
    end

    W_MdrawLine(XY.x,XY.y - 15,XY.x,Dxy.y - 5,signcolor,HudWindow)
end

function MidSign(mode)
    local XY = MyMath.Vector2:new(HologramSize.x/2,HologramSize.y/2)

    if(mode == 1)then
        local singWh_2 = 10
        W_MdrawLine(XY.x-singWh_2,XY.y,XY.x + singWh_2,XY.y,signcolor,HudWindow)
        W_MdrawLine(XY.x,XY.y-singWh_2,XY.x,XY.y+singWh_2,signcolor,HudWindow)
    elseif(mode == 2)then
        local XYoffset = 7
        local lineD = 3
        --1
        W_MdrawLine(XY.x - XYoffset,XY.y - XYoffset,XY.x - XYoffset + lineD,XY.y - XYoffset,signcolor,HudWindow)
        W_MdrawLine(XY.x - XYoffset,XY.y - XYoffset,XY.x - XYoffset,XY.y - XYoffset + lineD,signcolor,HudWindow)
        --2
        W_MdrawLine(XY.x + XYoffset,XY.y - XYoffset,XY.x + XYoffset - lineD,XY.y - XYoffset,signcolor,HudWindow)
        W_MdrawLine(XY.x + XYoffset,XY.y - XYoffset,XY.x + XYoffset,XY.y - XYoffset + lineD,signcolor,HudWindow)
        --3
        W_MdrawLine(XY.x - XYoffset,XY.y + XYoffset,XY.x - XYoffset + lineD,XY.y + XYoffset,signcolor,HudWindow)
        W_MdrawLine(XY.x - XYoffset,XY.y + XYoffset,XY.x - XYoffset,XY.y + XYoffset - lineD,signcolor,HudWindow)
        --4
        W_MdrawLine(XY.x + XYoffset,XY.y + XYoffset,XY.x + XYoffset - lineD,XY.y + XYoffset,signcolor,HudWindow)
        W_MdrawLine(XY.x + XYoffset,XY.y + XYoffset,XY.x + XYoffset,XY.y + XYoffset - lineD,signcolor,HudWindow)
    end
end

local HUDworldPs = MyMath.Vector3:new(0,0,0)
local HUDScreenWorldPs = MyMath.Vector3:new(0,0,0)
local shipworldV3 = ship.getWorldspacePosition()
local shipyardV3 = ship.getShipyardPosition()
function getHUDPs()
    local N_q = {}
    N_q.x = -shipQuat.x
    N_q.y = -shipQuat.y
    N_q.z = -shipQuat.z
    N_q.w = -shipQuat.w

    shipworldV3 = ship.getWorldspacePosition()
    shipyardV3 = ship.getShipyardPosition()
    _x,_y,_z = hologram.GetBlockPos()
    HUDblockPs = MyMath.Vector3:new(_x,_y,_z)
    local HUDpyarPsOffset = MyMath.V3sub(HUDblockPs,shipyardV3)
    local HUDworldPsOffset = MyMath.RotateVectorByQuat(N_q,HUDpyarPsOffset)
    HUDworldPs = MyMath.V3add(HUDworldPsOffset,shipworldV3)
end

function _3dShow(pV3,SCdistance,cameraV3,cameraQ)
    local XY = MyMath.Vector2:new(HologramSize.x/2,HologramSize.y/2)

    local N_q = {}
    N_q.x = -cameraQ.x
    N_q.y = -cameraQ.y
    N_q.z = -cameraQ.z
    N_q.w = cameraQ.w

    local localPV3 = MyMath.RotateVectorByQuat(N_q,MyMath.V3sub(pV3,cameraV3))-- 目标

    local PCoffset = MyMath.Vector2:new(localPV3.x ,localPV3.y)
    local PCdistance = localPV3.z
    local BiLi = SCdistance/PCdistance
    local P_SWorldpos = MyMath.Vector2:new(PCoffset.x * BiLi,PCoffset.y * BiLi)
    local P_Spos = MyMath.Vector2:new(-P_SWorldpos.x/HWsize,-P_SWorldpos.y/HWsize)

    if(PCdistance > 0)then
        return MyMath.Vector2:new(XY.x + P_Spos.x,XY.y + P_Spos.y)
        --W_MdrawLine(XY.x + P_Spos.x,XY.y + P_Spos.y,XY.x + P_Spos.x,XY.y + P_Spos.y,signcolor,HudWindow)
    else
        return MyMath.Vector2:new(-114,-514)
    end
end

function _3dShow_DF(pV3,SCdistance,cameraV3,cameraQ,far,near)
    local XY = MyMath.Vector2:new(HologramSize.x/2,HologramSize.y/2)

    local N_q = {}
    N_q.x = -cameraQ.x
    N_q.y = -cameraQ.y
    N_q.z = -cameraQ.z
    N_q.w = cameraQ.w

    local localPV3 = MyMath.RotateVectorByQuat(N_q,MyMath.V3sub(pV3,cameraV3))-- 目标

    if(localPV3.z <= far and localPV3.z >= near)then
        local PCoffset = MyMath.Vector2:new(localPV3.x ,localPV3.y)
        local PCdistance = localPV3.z
        local BiLi = SCdistance/PCdistance
        local P_SWorldpos = MyMath.Vector2:new(PCoffset.x * BiLi,PCoffset.y * BiLi)
        local P_Spos = MyMath.Vector2:new(-P_SWorldpos.x/HWsize,-P_SWorldpos.y/HWsize)

        if(PCdistance > 0)then
            return MyMath.Vector2:new(XY.x + P_Spos.x,XY.y + P_Spos.y)
            --W_MdrawLine(XY.x + P_Spos.x,XY.y + P_Spos.y,XY.x + P_Spos.x,XY.y + P_Spos.y,signcolor,HudWindow)
        else
            return MyMath.Vector2:new(-114,-514)
        end
    else
        return MyMath.Vector2:new(-114,-514)
    end
end

function draw3dlines(Points,SCdistance,cameraV3,cameraQ,color,wintable,DFmode,far,near)
    local screenPoints = {}
    for k,v in pairs(Points) do
        if(DFmode)then
            screenPoints[#screenPoints + 1] = _3dShow_DF (v,SCdistance,cameraV3,cameraQ,far,near)
        else
            screenPoints[#screenPoints + 1] = _3dShow (v,SCdistance,cameraV3,cameraQ)
        end
    end
    local Psave
    local i = 1
    for k,v in pairs(screenPoints) do
        if(v.x ~= -114 and v.y ~= -514)then
            if(i > 1)then
                W_MdrawLine(v.x,v.y,Psave.x,Psave.y,color,HudWindow)
            end
            Psave = v
            i = i + 1
        end
    end
end
function draw3dline(Point_1,Point_2,SCdistance,cameraV3,cameraQ,color,wintable,DFmode,far,near)
    local screenPoints = {}
    if(DFmode)then
         screenPoints[#screenPoints + 1] = _3dShow_DF (Point_1,SCdistance,cameraV3,cameraQ,far,near)
        screenPoints[#screenPoints + 1] = _3dShow_DF (Point_2,SCdistance,cameraV3,cameraQ,far,near)
    else
        screenPoints[#screenPoints + 1] = _3dShow (Point_1,SCdistance,cameraV3,cameraQ)
        screenPoints[#screenPoints + 1] = _3dShow (Point_2,SCdistance,cameraV3,cameraQ)
    end
    local Psave
    local i = 1
    for k,v in pairs(screenPoints) do
        if(v.x ~= -114 and v.y ~= -514)then
            if(i > 1)then
                W_MdrawLine(v.x,v.y,Psave.x,Psave.y,color,HudWindow)
            end
            Psave = v
            i = i + 1
        end
    end
end

function radar()
    local shipData = coordinate.getShips(2500)
    local entitiesData = coordinate.getEntities(50)

    local i = 0
    local txtOffset = MyMath.Vector2:new(0,6)
    for k,v in pairs(shipData) do
        i = i + 1
        
        local shipPs = MyMath.Vector3:new(v["x"],v["y"],v["z"])
        local shipRectMin = MyMath.Vector3:new(v["min_x"],v["min_y"],v["min_z"])
        local shipRectMax = MyMath.Vector3:new(v["max_x"],v["max_y"],v["max_z"])

        local sRminV2 = _3dShow(shipRectMin,CtoS,cameraPs,cameraQuat_World)
        local sRmaxV2 = _3dShow(shipRectMax,CtoS,cameraPs,cameraQuat_World)
        local sRp1 = _3dShow(MyMath.Vector3:new(shipRectMax.x,shipRectMin.y,shipRectMin.z),CtoS,cameraPs,cameraQuat_World)
        local sRp2 = _3dShow(MyMath.Vector3:new(shipRectMax.x,shipRectMax.y,shipRectMin.z),CtoS,cameraPs,cameraQuat_World)
        local sRp3 = _3dShow(MyMath.Vector3:new(shipRectMin.x,shipRectMax.y,shipRectMax.z),CtoS,cameraPs,cameraQuat_World)
        local sRp4 = _3dShow(MyMath.Vector3:new(shipRectMin.x,shipRectMin.y,shipRectMax.z),CtoS,cameraPs,cameraQuat_World)
        local sRp5 = _3dShow(MyMath.Vector3:new(shipRectMax.x,shipRectMin.y,shipRectMax.z),CtoS,cameraPs,cameraQuat_World)
        local sRp6 = _3dShow(MyMath.Vector3:new(shipRectMin.x,shipRectMax.y,shipRectMin.z),CtoS,cameraPs,cameraQuat_World)

        if(not(shipworldV3.x >= shipRectMin.x-2 and shipworldV3.x <= shipRectMax.x+2 and shipworldV3.y >= shipRectMin.y-2 and shipworldV3.y <= shipRectMax.y+2 and shipworldV3.z >= shipRectMin.z-2 and shipworldV3.z <= shipRectMax.z+2))then
            local _rect = MyMath.Rect:new(math.min(sRminV2.x,sRmaxV2.x,sRp1.x,sRp2.x,sRp3.x,sRp4.x,sRp5.x,sRp6.x),math.min(sRminV2.y,sRmaxV2.y,sRp1.y,sRp2.y,sRp3.y,sRp4.y,sRp5.y,sRp6.y),math.max(sRminV2.x,sRmaxV2.x,sRp1.x,sRp2.x,sRp3.x,sRp4.x,sRp5.x,sRp6.x),math.max(sRminV2.y,sRmaxV2.y,sRp1.y,sRp2.y,sRp3.y,sRp4.y,sRp5.y,sRp6.y))
            if((_rect.right - _rect.left) * (_rect.bottom - _rect.top) > 36 and (_rect.right - _rect.left) * (_rect.bottom - _rect.top) < HologramSize.x * HologramSize.x)then
                HUDradarRect[#HUDradarRect + 1] = _rect
            end
        end

        --MdrawText(HologramSize.x - 100,50 + i*txtOffset.y,string.format("SHIP%d X%0.1f Y%0.1f Z%0.1f",i,shipPs.x,shipPs.y,shipPs.z),signcolor)
        HUDradarPoint[#HUDradarPoint + 1] = _3dShow(shipPs,CtoS,shipworldV3,cameraQuat_World)
    end

    --HUDradarPoint[#HUDradarPoint + 1] = _3dShow(MyMath.Vector3:new(0,-60,0),CtoS,cameraPs,cameraQuat_World)--世界坐标系原点Y = -60

    for k,v in pairs(entitiesData) do
        local entitiePs = MyMath.Vector3:new(v["x"],v["y"],v["z"])

        local ePV2 = _3dShow(entitiePs,CtoS,cameraPs,cameraQuat_World)

        local Wh_2 = 2
        W_MdrawLine(ePV2.x-Wh_2,ePV2.y,ePV2.x + Wh_2,ePV2.y,signcolor,HudWindow)
        W_MdrawLine(ePV2.x,ePV2.y-Wh_2,ePV2.x,ePV2.y+Wh_2,signcolor,HudWindow)
    end

    if(laounch_Data.showRadarData)then
        MdrawText(0,100,"RADAR:",signcolor)
        MdrawText(0,110,string.format("SHIP %d",i),signcolor)
    end
end

function rotateVshow(rotateQ,centerP)
    local Vdistance = MyMath.Vector3:new(0,0,1000)

    local N_q = {}
    N_q.x = -rotateQ.x
    N_q.y = -rotateQ.y
    N_q.z = -rotateQ.z
    N_q.w = -rotateQ.w

    local R_Vd = MyMath.RotateVectorByQuat(N_q,Vdistance)

    local V_Wolrd = MyMath.V3add(centerP,R_Vd)

    local Vw_V2 = _3dShow(V_Wolrd,CtoS,shipworldV3,cameraQuat_World)

    return Vw_V2
end

function velosityShow()
    local V = ship.getVelocity()
    local V_w = MyMath.V3add(MyMath.Vector3:new(-V.x * 10,-V.y * 10,-V.z * 10),shipworldV3)
    local V_w2 = MyMath.V3add(MyMath.Vector3:new(V.x * 10,V.y * 10,V.z * 10),shipworldV3)

    local v_XY = _3dShow(V_w,CtoS,shipworldV3,cameraQuat_World)
    local v_XY2 = _3dShow(V_w2,CtoS,shipworldV3,cameraQuat_World)

    if(v_XY.x == -114 and v_XY.y == -514)then
        v_XY = v_XY2
    end

    local Wh_2 = 1
    local line_D = 3
    W_MdrawLine(v_XY.x-Wh_2,v_XY.y-Wh_2,v_XY.x - Wh_2,v_XY.y+Wh_2,signcolor,HudWindow)
    W_MdrawLine(v_XY.x+Wh_2,v_XY.y-Wh_2,v_XY.x + Wh_2,v_XY.y+Wh_2,signcolor,HudWindow)
    W_MdrawLine(v_XY.x+Wh_2,v_XY.y+Wh_2,v_XY.x - Wh_2,v_XY.y+Wh_2,signcolor,HudWindow)
    W_MdrawLine(v_XY.x+Wh_2,v_XY.y-Wh_2,v_XY.x - Wh_2,v_XY.y-Wh_2,signcolor,HudWindow)

    W_MdrawLine(v_XY.x,v_XY.y - Wh_2,v_XY.x,v_XY.y - line_D,signcolor,HudWindow)
    W_MdrawLine(v_XY.x + Wh_2,v_XY.y,v_XY.x + line_D,v_XY.y,signcolor,HudWindow)
    W_MdrawLine(v_XY.x - Wh_2,v_XY.y,v_XY.x - line_D,v_XY.y,signcolor,HudWindow)
end

local yawPID = MyMath.PIDController:new(13,0,13,20000,-20000)
yawPID:setAngleWrap(true)
local pitchPID = MyMath.PIDController:new(13,0,13,20000,-20000)
pitchPID:setAngleWrap(true)
local rollPID = MyMath.PIDController:new(12,0,10,20000,-20000)
rollPID:setAngleWrap(true)

local screenXpid = MyMath.PIDController:new(10,0,6,20000,-20000)
screenXpid:setAngleWrap(false)
local screenYpid = MyMath.PIDController:new(10,0,6,20000,-20000)
screenYpid:setAngleWrap(false)

local yawPid_pu = 0;
local pitchPid_pu = 0;
local rollPid_pu = 0;
local S_Vw_V2
function ShipVshow()
    S_Vw_V2 = rotateVshow(shipQuat,shipworldV3)

    local lineV = 5
    local lineV_1 = 3
    --1
    W_MdrawLine(S_Vw_V2.x - lineV,S_Vw_V2.y - lineV,S_Vw_V2.x - lineV_1,S_Vw_V2.y - lineV_1,signcolor,HudWindow)
    W_MdrawLine(S_Vw_V2.x + lineV,S_Vw_V2.y - lineV,S_Vw_V2.x + lineV_1,S_Vw_V2.y - lineV_1,signcolor,HudWindow)
    --2
    W_MdrawLine(S_Vw_V2.x - lineV,S_Vw_V2.y + lineV,S_Vw_V2.x - lineV_1,S_Vw_V2.y + lineV_1,signcolor,HudWindow)
    W_MdrawLine(S_Vw_V2.x + lineV,S_Vw_V2.y + lineV,S_Vw_V2.x + lineV_1,S_Vw_V2.y + lineV_1,signcolor,HudWindow)

    --[[
    local lineD = 3
    --1
    W_MdrawLine(S_Vw_V2.x - lineD,S_Vw_V2.y,S_Vw_V2.x + lineD,S_Vw_V2.y,signcolor,HudWindow)
    W_MdrawLine(S_Vw_V2.x,S_Vw_V2.y - lineD,S_Vw_V2.x,S_Vw_V2.y + lineD,signcolor,HudWindow)]]
end
local targetQ
function Tatgeyselect()
    if(redstone.getInput("left"))then
        targetQ = cameraQuat_World
    end
    if(redstone.getInput("back"))then
        targetQ = nil
        yawPid_pu = 0;
        pitchPid_pu = 0;
        rollPid_pu = 0;
    end
    if(targetQ)then
        T_Vw_V2 = rotateVshow(targetQ,shipworldV3)

        local singWh_2 = 5
        W_MdrawLine(T_Vw_V2.x-singWh_2,T_Vw_V2.y,T_Vw_V2.x + singWh_2,T_Vw_V2.y,signcolor,HudWindow)
        W_MdrawLine(T_Vw_V2.x,T_Vw_V2.y-singWh_2,T_Vw_V2.x,T_Vw_V2.y+singWh_2,signcolor,HudWindow)
    end
    if(targetQ and shipQuat)then
        local V = ship.getVelocity()
        local Te = MyMath.ctEuler(targetQ)
        local Se = MyMath.ctEuler(shipQuat)

        --print(string.format("x%0.1f y%0.1f z%0.1f w%0.1f",targetQ.x,targetQ.y,targetQ.z,targetQ.w))
        local maxPitch = 70
        local screenMode = false
        if(Te.pitch >= maxPitch)then
            screenMode = true
            Se.roll = 0
            Te.pitch = maxPitch
        end 
        if(Te.pitch <= -maxPitch)then
            screenMode = true
            Se.roll = 0
            Te.pitch = -maxPitch
        end 
        if(Se.pitch >= maxPitch)then
            Se.roll = 0
            screenMode = true
        end
        if(Se.pitch <= -maxPitch)then
            Se.roll = 0
            screenMode = true
        end 

        if(screenMode and T_Vw_V2.x ~= -114 and T_Vw_V2.y ~= -514)then
            yawPID:reset()
            pitchPID:reset()
            yawPid_pu = -screenXpid:update(T_Vw_V2.x,S_Vw_V2.x,1)*200
            pitchPid_pu = screenYpid:update(T_Vw_V2.y,S_Vw_V2.y,1)*200
            rollPid_pu = rollPID:update(0,MyMath.convertAngle180To360(Se.roll),1)*300
        elseif(screenMode)then
            yawPID:reset()
            pitchPID:reset()
            screenXpid:reset()
            screenYpid:reset()
            targetQ = cameraQuat_World
        else
            screenXpid:reset()
            screenYpid:reset()
            yawPid_pu = yawPID:update(MyMath.convertAngle180To360(Te.yaw),MyMath.convertAngle180To360(Se.yaw),1)*200
            pitchPid_pu = pitchPID:update(Te.pitch-Te.pitch,Se.pitch-Te.pitch,1)*200
            rollPid_pu = rollPID:update(0,MyMath.convertAngle180To360(Se.roll),1)*200
        end
    end
end

local config = load_config("cameraHud\\3dLineData.json")
function draw_File_3dLines()
    if(config)then
        if(config.data.individual_Points)then
            for k,v in pairs(config.data.individual_Points) do 
                local _V2
                if(v.DistanceFilteringMode)then
                    _V2 = _3dShow_DF(v.position,CtoS,cameraPs,cameraQuat_World,v.far,v.near)
                else
                    _V2 = _3dShow(v.position,CtoS,cameraPs,cameraQuat_World)
                end
                HUDradarPoint[#HUDradarPoint + 1] = _V2
            end  
        end
        if(config.data.individual_lines)then
            for k,v in pairs(config.data.individual_lines) do 
                if(v.DistanceFilteringMode)then
                    if(v.color)then
                        draw3dline(v.startPosition,v.endPosition,CtoS,cameraPs,cameraQuat_World,MyMath.hex2num(v.color,signcolor),HudWindow,true,v.far,v.near)
                    else
                        draw3dline(v.startPosition,v.endPosition,CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,true,v.far,v.near)
                    end
                else
                    if(v.color)then
                        draw3dline(v.startPosition,v.endPosition,CtoS,cameraPs,cameraQuat_World,MyMath.hex2num(v.color,signcolor),HudWindow,false,v.far,v.near)
                    else
                        draw3dline(v.startPosition,v.endPosition,CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,false,v.far,v.near)
                    end
                end
            end  
        end
        if(config.data.point_groups)then
            for k,v in pairs(config.data.point_groups) do 
                local groupPosition = v.position
                for t,i in pairs(v.points) do 
                    local pointPosition = MyMath.V3add(i.position,v.position)
                    local _V2
                    if(v.DistanceFilteringMode)then
                        _V2 = _3dShow_DF(pointPosition,CtoS,cameraPs,cameraQuat_World,v.far,v.near)
                    else
                        _V2 = _3dShow(pointPosition,CtoS,cameraPs,cameraQuat_World)
                    end
                    HUDradarPoint[#HUDradarPoint + 1] = _V2
                end
            end
        end
        if(config.data.line_groups)then
            for k,v in pairs(config.data.line_groups) do 
                local groupPosition = v.position
                local _color = MyMath.hex2num(v.color,signcolor)
                for t,i in pairs(v.lines) do
                    if(v.DistanceFilteringMode)then
                        if(i.color)then
                            draw3dline(MyMath.V3add(i.startPosition,groupPosition),MyMath.V3add(i.endPosition,groupPosition),CtoS,cameraPs,cameraQuat_World,MyMath.hex2num(i.color,_color),HudWindow,true,v.far,v.near)
                        else
                            draw3dline(MyMath.V3add(i.startPosition,groupPosition),MyMath.V3add(i.endPosition,groupPosition),CtoS,cameraPs,cameraQuat_World,_color,HudWindow,true,v.far,v.near)
                        end
                    else
                        if(i.color)then
                            draw3dline(MyMath.V3add(i.startPosition,groupPosition),MyMath.V3add(i.endPosition,groupPosition),CtoS,cameraPs,cameraQuat_World,MyMath.hex2num(i.color,_color),HudWindow,false,v.far,v.near)
                        else
                            draw3dline(MyMath.V3add(i.startPosition,groupPosition),MyMath.V3add(i.endPosition,groupPosition),CtoS,cameraPs,cameraQuat_World,_color,HudWindow,false,v.far,v.near)
                        end
                    end
                end
            end
        end 
    end
end

function drawRadarPoint()
    local rectangleHwh = 3
    local rectangle = {}
    for k,v in pairs(HUDradarPoint) do
        if(v.x ~= -114 and v.y ~= -514)then
            local _rectangle = MyMath.Rect:new(v.x - rectangleHwh,v.y - rectangleHwh,v.x + rectangleHwh,v.y + rectangleHwh)
            rectangle[#rectangle + 1] = _rectangle
        end
    end
    -- 合并相交的矩形
    local mergedRects = BZD_ct.Rect.MergeRects(rectangle)
    for k,v in pairs(mergedRects) do    
        drawPolygon({v.left,v.top,v.right,v.top,v.right,v.bottom,v.left,v.bottom},8,signcolor,HudWindow)
    end
    local Drectangle = BZD_ct.Rect.MergeRects(HUDradarRect)
    for k,v in pairs(Drectangle) do    
        drawPolygon({v.left,v.top,v.right,v.top,v.right,v.bottom,v.left,v.bottom},8,signcolor,HudWindow)
    end
end

function cameraHud()
    HUDradarPoint = {}
    HUDradarRect = {}
    shipQuat = ship.getQuaternion()
    shipEuler =  MyMath.ctEuler(shipQuat)
    local Ss_q = {}
    Ss_q.x = -shipQuat.x
    Ss_q.y = -shipQuat.y
    Ss_q.z = -shipQuat.z
    Ss_q.w = shipQuat.w
    Ship_Omega = MyMath.RotateVectorByQuat(Ss_q,ship.getOmega())
    getHUDPs()

    cameraQuat_World = camera.getAbsViewTransform()
    cameraQuat = camera.getLocViewTransform()
    cameraEuler_World = MyMath.ctEuler(cameraQuat_World)
    cameraEuler = MyMath.ctEuler(cameraQuat)

    local cQ = MyMath.EulerToQuat(cameraEuler.yaw - 180,-cameraEuler.pitch,-cameraEuler.roll)

    local N_q = {}
    N_q.x = -cQ.x
    N_q.y = -cQ.y
    N_q.z = -cQ.z
    N_q.w = -cQ.w

    HUDTranslation = MyMath.RotateVectorByQuat(N_q,HUDTranslation_unRotate)
    --HUDTranslation = MyMath.rotateVector(cameraEuler.pitch,cameraEuler.yaw + 90,HUDTranslation_unRotate)

    hologram.SetRotation(cameraEuler.yaw - 180,-cameraEuler.pitch,-cameraEuler.roll)
    HUDTranslation_total = MyMath.Vector3:new(HUDTranslation.y+HUDTranslation_unRotate_offset.x,
    HUDTranslation.z+HUDTranslation_unRotate_offset.y,
    HUDTranslation.x+HUDTranslation_unRotate_offset.z)
    hologram.SetTranslation(HUDTranslation_total.x,HUDTranslation_total.y,HUDTranslation_total.z)
    --hologram.SetTranslation(HUDTranslation.x,HUDTranslation.y,HUDTranslation.z)
    
    local S_q = {}
    S_q.x = -shipQuat.x
    S_q.y = -shipQuat.y
    S_q.z = -shipQuat.z
    S_q.w = -shipQuat.w

    cameraPs = camera.getCameraPosition()

    --drawText(100,100,string.format("%0.1f %0.1f  %0.1f",cameraPs.x,cameraPs.y,cameraPs.z),signcolor)
    if(laounch_Data.showCameraTransformData)then
        if(string.format("%0.1f",cameraEuler_World.pitch) ~= "nan")then
            MdrawText(0,60,string.format("PITCH %0.1f",cameraEuler_World.pitch),signcolor)
        else
            MdrawText(0,60,"PITCH NIL",signcolor)
        end
        MdrawText(0,70,string.format("ROLL %0.1f",cameraEuler_World.roll),signcolor)
        MdrawText(0,80,string.format("YAW %0.1f",cameraEuler_World.yaw),signcolor)
        MdrawText(0,40,"CAMERA:",signcolor)
        MdrawText(0,50,string.format("X:%0.1f Y:%0.1f Z:%0.1f",cameraPs.x,cameraPs.y,cameraPs.z),signcolor)
    end

    --print(string.format("%0.1f %0.1f",HUDworldPs.x,HUDworldPs.z))
    --[[
    local SPyard = MyMath.V3add(MyMath.Vector3:new(HUDTranslation_total.z,HUDTranslation_total.y,HUDTranslation_total.x),HUDblockPs)
    local SPyard_offset = MyMath.V3sub(SPyard,shipyardV3)
    local SPworld_offset = MyMath.RotateVectorByQuat(S_q,SPyard_offset)
    HUDScreenWorldPs = MyMath.V3add(SPworld_offset,shipworldV3)
    MdrawText(100,100,string.format("%f %f",HUDScreenWorldPs.x ,HUDScreenWorldPs.z),signcolor)
    ]]

    --导弹模式
    MidSign(laounch_Data.cameraCrosshairSignStyle)
    if(laounch_Data.showShipDirection)then
        ShipVshow()
    end
    if(laounch_Data.engineControl)then
        Tatgeyselect()
    end
    if(laounch_Data.showVelosity)then
        velosityShow()
    end

    local _far = 500
    local _near = 0
    --3维形状绘制
    if(laounch_Data.draw3DLines)then
        draw_File_3dLines()
    end
    --[[
    --出生点矩形
    local points = {}
    points[#points + 1] = MyMath.Vector3:new(-10,-60,-10)
    points[#points + 1] = MyMath.Vector3:new(-10,-60,10)
    points[#points + 1] = MyMath.Vector3:new(10,-60,10)
    points[#points + 1] = MyMath.Vector3:new(10,-60,-10)
    draw3dlines(points,CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,true,_far,_near)
    local points2 = {}
    points2[#points2 + 1] = MyMath.Vector3:new(10,-50,-10)
    points2[#points2 + 1] = MyMath.Vector3:new(10,-50,10)
    points2[#points2 + 1] = MyMath.Vector3:new(-10,-50,10)
    points2[#points2 + 1] = MyMath.Vector3:new(-10,-50,-10)
    draw3dlines(points2,CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,true,_far,_near)
    --立柱
    draw3dline(MyMath.Vector3:new(-10,-60,-10),MyMath.Vector3:new(-10,-50,-10),CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,true,_far,_near)
    draw3dline(MyMath.Vector3:new(10,-60,10),MyMath.Vector3:new(10,-50,10),CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,true,_far,_near)
    draw3dline(MyMath.Vector3:new(10,-60,-10),MyMath.Vector3:new(10,-50,-10),CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,true,_far,_near)
    draw3dline(MyMath.Vector3:new(-10,-60,10),MyMath.Vector3:new(-10,-50,10),CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,true,_far,_near)
    --第6面横梁
    draw3dline(MyMath.Vector3:new(10,-60,-10),MyMath.Vector3:new(-10,-60,-10),CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,true,_far,_near)
    draw3dline(MyMath.Vector3:new(10,-50,-10),MyMath.Vector3:new(-10,-50,-10),CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,true,_far,_near)

    --机场
    --跑道线
    draw3dline(MyMath.Vector3:new(34,-53,-10),MyMath.Vector3:new(34,-53,2),CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,true,_far,_near)
    draw3dline(MyMath.Vector3:new(35,-53,-10),MyMath.Vector3:new(35,-53,2),CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,true,_far,_near)
    --速度矢量靶
    draw3dline(MyMath.Vector3:new(34.5,-53,-7),MyMath.Vector3:new(39.5,-48,-7),CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,true,_far,_near)
    draw3dline(MyMath.Vector3:new(39.5,-48,-7),MyMath.Vector3:new(29.5,-48,-7),CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,true,_far,_near)
    draw3dline(MyMath.Vector3:new(29.5,-48,-7),MyMath.Vector3:new(34.5,-53,-7),CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,true,_far,_near)
    --头标识
    draw3dline(MyMath.Vector3:new(32,-53,-20),MyMath.Vector3:new(37,-53,-20),CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,true,_far,_near)
    draw3dline(MyMath.Vector3:new(29,-53,-50),MyMath.Vector3:new(40,-53,-50),CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,true,_far,_near)
    draw3dline(MyMath.Vector3:new(19,-53,-80),MyMath.Vector3:new(50,-53,-80),CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,true,_far,_near)
    --尾标识
    draw3dline(MyMath.Vector3:new(29.5,-55,20),MyMath.Vector3:new(34,-55,24),CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,true,_far,_near)
    draw3dline(MyMath.Vector3:new(38.5,-55,20),MyMath.Vector3:new(34,-55,24),CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,true,_far,_near)
    draw3dline(MyMath.Vector3:new(29.5,-55,24),MyMath.Vector3:new(34,-55,28),CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,true,_far,_near)
    draw3dline(MyMath.Vector3:new(38.5,-55,24),MyMath.Vector3:new(34,-55,28),CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,true,_far,_near)

    --冰滑轨
    draw3dline(MyMath.Vector3:new(-47,-37,8),MyMath.Vector3:new(-47,-37,124),CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,true,_far,_near)
    draw3dline(MyMath.Vector3:new(-47,-37,124),MyMath.Vector3:new(-47,-37,302),CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,true,_far,_near)

    --赛博的赛博准心
    local V3save
    local _Rcenter = cameraPs
    local points3 = {}
    local _lineNumS8277 = 15
    local _rVr3392 = 0.3
    local _rVrD326 = 1
    for i = 1,_lineNumS8277 + 1,1 do 
        local _rV2iod332
         _rV2iod332 = MyMath.getCoordinates(i*(360/_lineNumS8277),_rVr3392)
        local _Viopa335 = MyMath.Vector3:new(_rV2iod332.x,_rV2iod332.y,_rVrD326)
        local _rViopa335 = MyMath.RotateVectorByQuat(S_q,_Viopa335)
        points3[#points3 + 1] = MyMath.V3add(_rViopa335,_Rcenter)
    end
    draw3dlines(points3,CtoS,cameraPs,cameraQuat_World,signcolor,HudWindow,false,_far,_near)
    ]]

    --一般
    if(laounch_Data.radar)then
        radar()
        drawRadarPoint()
    end
    if(laounch_Data.showPitch)then
        Pitch()
    end
    if(laounch_Data.showYaw)then
        yaw()
    end
end

function flush()
    hologram.Clear()
    hologram.Flush()
end

--角速度阻尼系数 if(laounch_Data.engineControl)then
--[[
local pitchOf_k
local yawOf_k
local rollOf_k
pitchOf_k = -Engine.getMass() * 2
yawOf_k = -Engine.getMass() * 2
rollOf_k = -Engine.getMass() * 2

local pitchOf = 0
local yawOf = 0
local rollOf = 0

local pitchOf_Max_m = 4
local pitchOf_Max = Engine.getMass() * pitchOf_Max_m
local yawOf_Max_m = 4
local yawOf_Max = Engine.getMass() * yawOf_Max_m
local rollOf_Max_m = 4
local rollOf_Max = Engine.getMass() * rollOf_Max_m

local m = Engine.getMass()
]]
local g = 10
local idle = false
function F_control()
    if(laounch_Data.engineControl)then
        Engine.setIdle(idle)

        --[[
        --角速度阻尼
        pitchOf = Ship_Omega.x * pitchOf_k
        yawOf = Ship_Omega.y * yawOf_k
        rollOf = Ship_Omega.z * rollOf_k

        --限制防止超调
        if yawOf > yawOf_Max then
            yawOf = yawOf_Max
        end
        if yawOf < -yawOf_Max then
            yawOf = -yawOf_Max
        end
        
        if pitchOf > pitchOf_Max then
            pitchOf = pitchOf_Max
        end
        if pitchOf < -pitchOf_Max then
            pitchOf = -pitchOf_Max
        end
        
        if rollOf > rollOf_Max then
            rollOf = rollOf_Max
        end
        if rollOf < -rollOf_Max then
            rollOf = -rollOf_Max
        end
        ]]

        if(not idle)then
            --Engine.applyRotDependentTorque(0,yawOf,0)
            --Engine.applyRotDependentTorque(0,0,rollOf)
            --Engine.applyRotDependentTorque(pitchOf,0,0)
        end

        --Engine.applyInvariantForce(0,m*g,0)

        --Engine.applyRotDependentForce(0,0,100)

        Engine.applyRotDependentTorque(0,yawPid_pu,0)
        Engine.applyRotDependentTorque(0,0,rollPid_pu)
        Engine.applyRotDependentTorque(pitchPid_pu,0,0)
    end
end

--主函数
--命令行
local command_Stop = false
local thread_Stop = false
function CHcommand()
    term.setTextColour(0x800)
    print("If you don't know how to do it, type help")
    term.setTextColour(0x1)
    while(1)do
        --命令
        UserCommand = ""
        local UserCommand = io.read()
        if(UserCommand == "help")then
            term.setTextColour(0x20)
            print("\"P -r\" reload peripherals")
            print("\"P list\" to show peripherals list")
            print("\"E set idle\" to set idle mode")
            print("\"config -r\" to reload 3dLines config")
            term.setTextColour(0x1)
        end
        if(UserCommand == "P -r")then
            term.setTextColour(0x800)
            print("reloading")
            term.setTextColour(0x20)
            command_Stop = true
            while(1)do
                if(thread_Stop)then
                    NamesTable = peripheral.getNames()
                    peripherals = {}
                    for k,v in ipairs(NamesTable) do
                        local peripheralName = peripheral.getType(v)
                        peripherals[peripheralName] = peripheral.wrap(v)
                    end
                    break
                end
                sleep(0)
            end
            command_Stop = false
            term.setTextColour(0x800)
            print("\"P list\" to show peripherals list")
            print("end")
            term.setTextColour(0x1)
        end
        if(UserCommand == "P list")then
            term.setTextColour(0x20)
            NamesTable = peripheral.getNames()
            for k,v in ipairs(NamesTable) do
                 local peripheralName = peripheral.getType(v)
                 print(k,"|",v,"-->",peripheralName)
            end
            term.setTextColour(0x1)
        end
        if(UserCommand == "E set idle")then
            term.setTextColour(0x800)
            print("idle Mode type T or F")
            term.setTextColour(0x1)
            local UserCommand_local = io.read()
            if(UserCommand_local == 'T')then
                idle = true
                term.setTextColour(0x800)
                print("idle mode is True now!")
            elseif(UserCommand_local == 'F')then
                idle = false
                term.setTextColour(0x800)
                print("idle mode is False now!")
            else
                term.setTextColour(0x4000)
                print("command.erro:unknow command")
            end
            term.setTextColour(0x1)
        end
        if(UserCommand == "config -r")then
            config = load_config("cameraHud\\3dLineData.json")
            if(config)then
                term.setTextColour(0x20)
                print("reload successfuly!")
            else
                term.setTextColour(0x4000)
                print("reload failed!")
            end
            term.setTextColour(0x1)
        end
        sleep(0)
    end
end
--引擎
function engine()
    while true do
        local evendata = {os.pullEvent()}
        if(evendata[1] == "phys_tick")then
            F_control()
        end
    end
end
--主循环
function main()
    while(1)do
        if(command_Stop)then
            thread_Stop = true
        else
            thread_Stop = false
        end
        if(thread_Stop == false)then
            cameraHud()
        end
        sleep(0)
        flush()
    end
end

parallel.waitForAll(main,CHcommand,engine)