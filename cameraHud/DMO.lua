DMO = {}

DMO.hologram = {}

--图形+方法--
function DMO.getCoordinates(angle, radius)--已知角和半径求坐标
    local radians = angle * math.pi / 180

    local x = radius * math.cos(radians)
    local y = radius * math.sin(radians)

    return x, y
end

function DMO.drawCirclePoint(WaiShe,x,y,radius,colors)
    for i = 0,360 do --360度环绕画点
        local X_ , Y_ = getCoordinates(i,radius)
        WaiShe.line(x + X_,y + Y_,x + X_,y + Y_,colors)
    end
end

function DMO.drawFillCirclePoint(WaiShe,x,y,radius,colors,fillcolors)--SB玩意
    for i = 0,360 do --360度环绕画点
        local X_ , Y_ = getCoordinates(i,radius)
        WaiShe.line(x,y,x + X_,y + Y_,fillcolors)
        WaiShe.line(x + X_,y + Y_,x + X_,y + Y_,colors)
    end
end

function DMO.drawFillPie(WaiShe,x,y,radius,firstAngle,endAngle,colors,fillcolors)
    for i = firstAngle,endAngle do --360度环绕画点
        local X_ , Y_ = getCoordinates(i,radius)
        WaiShe.line(x,y,x + X_,y + Y_,fillcolors)
        WaiShe.line(x + X_,y + Y_,x + X_,y + Y_,colors)
    end
end

function DMO.MWindowdrawLine(x,y,x_,y_,color,windowTable,Ws)

    local dx = x_ - x
    local dy = y_ - y
    local k = dy / dx

    local e = 0
    if(math.abs(k) > 1)then
        e = math.abs(dy)
    else
        e = math.abs(dx)
    end
    local xadd = dx / e
    local yadd = dy / e

    for i = 0,e,1 do
        if not(x < windowTable.left or y < windowTable.top or x > windowTable.right or y > windowTable.bottom)then
            hologram.DrawLine(x + 0.5,y + 0.5,x + 0.5,y + 0.5,color)
        end
        x = x + xadd
        y = y + yadd
    end
end

function DMO.drawCircleLine(centerX, centerY, radius, segments,colors,windowTable)
    local angleIncrement = 2 * math.pi / segments  -- 每一段的角度增加
    local lastX = centerX + radius  -- 起始点的 x 坐标
    local lastY = centerY           -- 起始点的 y 坐标

    for i = 1, segments + 1 do
        local angle = i * angleIncrement
        local x = centerX + radius * math.cos(angle)
        local y = centerY + radius * math.sin(angle)

        -- 画线段从 lastX，lastY 到 x，y
        DMO.MWindowdrawLine(lastX, lastY,x, y,colors,windowTable)

        lastX = x
        lastY = y
    end
end

function DMO.drawPolygon(Points,lineNum,linecolor)
    for i = 1,lineNum,1 do
        if(i == lineNum - 1)then
            hologram.line(Points[i],Points[i + 1],Points[1],Points[2],linecolor)
            break
        elseif((i + 1) % 2 == 0)then
            hologram.line(Points[i],Points[i + 1],Points[i + 2],Points[i + 3],linecolor)
        end
    end
end

function DMO.calculateAngles(x1, y1, z1, x2, y2, z2)
    local deltaX = x2 - x1
    local deltaY = y2 - y1
    local deltaZ = z2 - z1

    local yaw = math.atan2(deltaX, deltaZ)
    local pitch = math.atan2(deltaY, math.sqrt(deltaX^2 + deltaZ^2))
    
    yaw = yaw * (180 / math.pi)
    pitch = pitch * (180 / math.pi)

    local AllAngle = {yaw = yaw,pitch = pitch}
    
    return AllAngle  -- 返回角度
end

function DMO.GetEuler()  --获取欧拉角
    local quat={w=0,x=0,y=0,z=0}
    local Ag={yaw=0,pitch=0,roll=0}
    quat.w=ship.getQuaternion().w
    quat.x=ship.getQuaternion().y
    quat.y=ship.getQuaternion().x
    quat.z=ship.getQuaternion().z
    Ag.yaw=math.deg(math.atan2(quat.y*quat.z+quat.w*quat.x,1/2-(quat.x*quat.x+quat.y*quat.y)))
    Ag.roll=math.deg(math.atan2(quat.x*quat.y+quat.w*quat.z,1/2-(quat.y*quat.y+quat.z*quat.z)))
    Ag.pitch=math.deg(math.asin(-2*(quat.x*quat.z-quat.w*quat.y)))

    return Ag
end

function DMO.checkPosition(angleA, angleB)
    -- 将 angleB 转换到正值
    local angleB_converted
    if angleB < 0 then
        angleB_converted = angleB + 360
    else
        angleB_converted = angleB
    end

    -- 计算角度差
    local angleDifference = (angleB_converted - angleA + 360) % 360

    -- 判断方向
    if angleDifference > 0 and angleDifference < 180 then
        return "R"
    elseif angleDifference > 180 and angleDifference < 360 then
        return "L"
    elseif(angleDifference == angleDifference)then
        return "ON"
    else
        return "BACK"
    end
end

function DMO.MWindowdrawPolygon(Points,lineNum,linecolor,windowTable)
    for i = 1,lineNum,1 do
        if(i == lineNum - 1)then
            DMO.MWindowdrawLine(Points[i],Points[i + 1],Points[1],Points[2],linecolor,windowTable)
            break
        elseif((i + 1) % 2 == 0)then
            DMO.MWindowdrawLine(Points[i],Points[i + 1],Points[i + 2],Points[i + 3],linecolor,windowTable)
        end
    end
end

return DMO
