BZD_ct = {}

--类--
BZD_ct.Rect = {left=0,top=0,right=0,bottom=0}
BZD_ct.Rect.__index = BZD_ct.Rect
function BZD_ct.Rect:new(_left,_top,_right,_bottom)
    local rect = {}
    setmetatable(rect, BZD_ct.Rect)

    rect.left = _left
    rect.top = _top
    rect.right = _right
    rect.bottom = _bottom

    return rect
end
function BZD_ct.Rect:Intersects(otherRect)
    -- 检查参数是否为Rect类型
    if getmetatable(otherRect) ~= BZD_ct.Rect then
        return false
    end
    
    -- 检查矩形是否有重叠
    -- 如果一个矩形在另一个矩形的左侧、右侧、上方或下方，则不相交
    if self.right < otherRect.left or 
       self.left > otherRect.right or 
       self.bottom < otherRect.top or 
       self.top > otherRect.bottom then
        return false
    end
    
    -- 否则相交
    return true
end
-- 合并当前矩形与另一个矩形(返回新的合并后的矩形)
function BZD_ct.Rect:Merge(otherRect)
    if not self:Intersects(otherRect) then
        return {self, otherRect} -- 不相交则返回两个矩形
    end
    
    local left = math.min(self.left, otherRect.left)
    local top = math.min(self.top, otherRect.top)
    local right = math.max(self.right, otherRect.right)
    local bottom = math.max(self.bottom, otherRect.bottom)
    
    return BZD_ct.Rect:new(left, top, right, bottom)
end
-- 静态方法: 合并一组相交的矩形
function BZD_ct.Rect.MergeRects(rects)
    if #rects == 0 then return {} end
    if #rects == 1 then return {rects[1]} end
    
    local merged = false
    local result = {}
    local mergedRects = {}
    
    for i = 1, #rects do
        if not mergedRects[i] then
            local current = rects[i]
            for j = i+1, #rects do
                if not mergedRects[j] and current:Intersects(rects[j]) then
                    current = current:Merge(rects[j])
                    merged = true
                    mergedRects[j] = true
                end
            end
            table.insert(result, current)
        end
    end
    
    -- 如果发生了合并，可能需要递归处理(因为合并后的新矩形可能与其它矩形相交)
    if merged then
        return BZD_ct.Rect.MergeRects(result)
    else
        return result
    end
end
-- 获取矩形面积
function BZD_ct.Rect:Area()
    return (self.right - self.left) * (self.bottom - self.top)
end
-- 判断矩形是否包含另一个矩形
function BZD_ct.Rect:Contains(otherRect)
    return self.left <= otherRect.left and
           self.right >= otherRect.right and
           self.top <= otherRect.top and
           self.bottom >= otherRect.bottom
end

--V3
BZD_ct.Vector3 = {x = 0, y = 0, z = 0}
BZD_ct.Vector3.__index = BZD_ct.Vector3
function BZD_ct.Vector3:new(x, y, z)
    local vector3 = {}
    setmetatable(vector3, BZD_ct.Vector3)

    vector3.x = x
    vector3.y = y
    vector3.z = z

    return vector3
end
-- 向量方法扩展
function BZD_ct.Vector3:dot(other)
    return self.x * other.x + self.y * other.y + self.z * other.z
end
function BZD_ct.Vector3:cross(other)
    return BZD_ct.Vector3:new(
        self.y * other.z - self.z * other.y,
        self.z * other.x - self.x * other.z,
        self.x * other.y - self.y * other.x
    )
end
function BZD_ct.Vector3:length()
    return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
end
function BZD_ct.Vector3:normalize()
    local len = self:length()
    if len > 1e-12 then
        return BZD_ct.Vector3:new(self.x / len, self.y / len, self.z / len)
    end
    return BZD_ct.Vector3:new(0, 0, 0)
end
function BZD_ct.Vector3:__tostring()
    return string.format("x:%.3f y:%.3f z:%.3f", self.x, self.y, self.z)
end
--V2
BZD_ct.Vector2 = {x = 0, y = 0}
BZD_ct.Vector2.__index = BZD_ct.Vector2
function BZD_ct.Vector2:new(x, y)
    local vector2 = {}
    setmetatable(vector2, BZD_ct.Vector2)

    vector2.x = x
    vector2.y = y

    return vector2
end
--欧拉
BZD_ct.Euler = {yaw = 0, pitch = 0, roll = 0}
BZD_ct.Euler.__index = BZD_ct.Euler
function BZD_ct.Euler:new(yaw, pitch, roll)
    local euler = {}
    setmetatable(euler, BZD_ct.Euler)

    euler.yaw = yaw
    euler.pitch = pitch
    euler.roll = roll

    return euler
end
--四元数
BZD_ct.Quat = {w = 0, x = 0, y = 0, z = 0}
BZD_ct.Quat.__index = BZD_ct.Quat
function BZD_ct.Quat:new(w, x, y, z)
    local quat = {}
    setmetatable(quat, BZD_ct.Quat)

    quat.w = w
    quat.x = x
    quat.y = y
    quat.z = z

    return quat
end
function BZD_ct.Quat:length()
    return math.sqrt(self.w * self.w + self.x * self.x + self.y * self.y + self.z * self.z)
end
function BZD_ct.Quat:normalize()
    local len = self:length()
    if len > 1e-12 then
        return BZD_ct.Quat:new(self.w / len, self.x / len, self.y / len, self.z / len)
    end
    return BZD_ct.Quat:new(1, 0, 0, 0)
end
function BZD_ct.Quat:__tostring()
    return string.format("w=%.3f x=%.3f y=%.3f z=%.3f", self.w, self.x, self.y, self.z)
end
-- 从向量u旋转到向量v的四元数计算
function BZD_ct.Quat.fromVectors(u, v)
    local u_norm = u:normalize()
    local v_norm = v:normalize()
    
    local dot_product = u_norm:dot(v_norm)
    
    -- 处理方向相同的情况
    if dot_product > 0.999999 then
        return BZD_ct.Quat:new(1.0, 0.0, 0.0, 0.0)
    end
    
    -- 处理方向相反的情况
    if dot_product < -0.999999 then
        -- 选择与u正交的轴
        local axis
        if math.abs(u_norm.x) < 0.9 then
            axis = u_norm:cross(BZD_ct.Vector3:new(1.0, 0.0, 0.0))
        else
            axis = u_norm:cross(BZD_ct.Vector3:new(0.0, 1.0, 0.0))
        end
        axis = axis:normalize()
        return BZD_ct.Quat:new(0.0, axis.x, axis.y, axis.z)
    end
    
    -- 正常情况：计算旋转轴和四元数
    local axis = u_norm:cross(v_norm)
    axis = axis:normalize()
    
    local s = math.sqrt(2 * (1 + dot_product))
    local inv_s = 1.0 / s
    
    local w = s * 0.5
    local x = axis.x * inv_s
    local y = axis.y * inv_s
    local z = axis.z * inv_s
    
    return BZD_ct.Quat:new(w, x, y, z):normalize()
end
-- 优化的版本（避免创建临时对象）
function BZD_ct.Quat.fromVectorsOptimized(u, v)
    -- 归一化u
    local u_len = math.sqrt(u.x*u.x + u.y*u.y + u.z*u.z)
    if u_len < 1e-12 then
        return BZD_ct.Quat:new(1.0, 0.0, 0.0, 0.0)
    end
    local ux, uy, uz = u.x/u_len, u.y/u_len, u.z/u_len
    
    -- 归一化v
    local v_len = math.sqrt(v.x*v.x + v.y*v.y + v.z*v.z)
    if v_len < 1e-12 then
        return BZD_ct.Quat:new(1.0, 0.0, 0.0, 0.0)
    end
    local vx, vy, vz = v.x/v_len, v.y/v_len, v.z/v_len
    
    -- 计算点积
    local dot_product = ux*vx + uy*vy + uz*vz
    
    -- 处理特殊情况
    if dot_product > 0.999999 then
        return BZD_ct.Quat:new(1.0, 0.0, 0.0, 0.0)
    elseif dot_product < -0.999999 then
        -- 选择正交轴
        local ax, ay, az
        if math.abs(ux) < 0.9 then
            -- cross(u, [1,0,0])
            ax, ay, az = 0.0, uz, -uy
        else
            -- cross(u, [0,1,0])
            ax, ay, az = -uz, 0.0, ux
        end
        
        local axis_len = math.sqrt(ax*ax + ay*ay + az*az)
        if axis_len > 1e-12 then
            ax, ay, az = ax/axis_len, ay/axis_len, az/axis_len
        else
            ax, ay, az = 1.0, 0.0, 0.0
        end
        return BZD_ct.Quat:new(0.0, ax, ay, az)
    end
    
    -- 计算叉积
    local cx = uy*vz - uz*vy
    local cy = uz*vx - ux*vz
    local cz = ux*vy - uy*vx
    
    local axis_len = math.sqrt(cx*cx + cy*cy + cz*cz)
    if axis_len < 1e-12 then
        return BZD_ct.Quat:new(1.0, 0.0, 0.0, 0.0)
    end
    
    cx, cy, cz = cx/axis_len, cy/axis_len, cz/axis_len
    
    -- 直接构造四元数
    local s = math.sqrt(2 * (1 + dot_product))
    local inv_s = 1.0 / s
    
    local w = s * 0.5
    local x = cx * inv_s
    local y = cy * inv_s
    local z = cz * inv_s
    
    -- 归一化四元数
    local q_len = math.sqrt(w*w + x*x + y*y + z*z)
    return BZD_ct.Quat:new(w/q_len, x/q_len, y/q_len, z/q_len)
end
-- 四元数旋转向量
function BZD_ct.Quat:rotateVector(vector)
    -- q * v * q⁻¹
    local vx, vy, vz = vector.x, vector.y, vector.z
    local qw, qx, qy, qz = self.w, self.x, self.y, self.z
    
    -- 提取四元数的虚部
    local ux, uy, uz = qx, qy, qz
    
    -- 计算交叉项
    local cross_uv_x = uy * vz - uz * vy
    local cross_uv_y = uz * vx - ux * vz
    local cross_uv_z = ux * vy - uy * vx
    
    local dot_uv = ux * vx + uy * vy + uz * vz
    
    -- 旋转后的向量
    local result_x = vx + 2 * (qw * cross_uv_x + uy * cross_uv_z - uz * cross_uv_y)
    local result_y = vy + 2 * (qw * cross_uv_y + uz * cross_uv_x - ux * cross_uv_z)
    local result_z = vz + 2 * (qw * cross_uv_z + ux * cross_uv_y - uy * cross_uv_x)
    
    return BZD_ct.Vector3:new(result_x, result_y, result_z)
end
--[[ 共轭运算
function BZD_ct.normalize(q)
    local len = math.sqrt(q.w^2 + q.x^2 + q.y^2 + q.z^2)
    if len > 0 then
        q.w = q.w / len
        q.x = q.x / len
        q.y = q.y / len
        q.z = q.z / len
    end
    return q
end
-- 乘法运算
function BZD_ct.multiply(q1,q2)
    return BZD_ct.Quat:new(
        q1.w*q2.w - q1.x*q2.x - q1.y*q2.y - q1.z*q2.z,
        q1.w*q2.x + q1.x*q2.w + q1.y*q2.z - q1.z*q2.y,
        q1.w*q2.y - q1.x*q2.z + q1.y*q2.w + q1.z*q2.x,
        q1.w*q2.z + q1.x*q2.y - q1.y*q2.x + q1.z*q2.w
    )
end]]

BZD_ct.PIDController = {}
BZD_ct.PIDController.__index = BZD_ct.PIDController
-- 构造函数
function BZD_ct.PIDController:new(Kp, Ki, Kd, max_output, min_output)
    local pid = {}
    setmetatable(pid, BZD_ct.PIDController)
    
    pid.Kp = Kp or 1.0       -- 比例增益
    pid.Ki = Ki or 0.0       -- 积分增益
    pid.Kd = Kd or 0.0       -- 微分增益
    pid.max_output = max_output or math.huge  -- 输出上限
    pid.min_output = min_output or -math.huge -- 输出下限
    pid.previous_error = 0    -- 上一次的误差
    pid.integral = 0          -- 误差积分
    pid.wrap_angle = true     -- 是否启用角度环绕处理
    
    return pid
end
-- 更新PID控制器（支持360°角度处理）
function BZD_ct.PIDController:update(setpoint, measured_value, dt,errMOD,err)
    -- 角度归一化处理
    local error = 0
    if(errMOD)then
        error = err
    else
        if self.wrap_angle then
            setpoint = setpoint % 360
            measured_value = measured_value % 360
            
            -- 计算最短路径误差
            error = setpoint - measured_value
            error = error % 360
            if error > 180 then
                error = error - 360
            elseif error < -180 then
                error = error + 360
            end
        else
            -- 普通线性误差计算
            error = setpoint - measured_value
        end
    end
    
    -- 计算积分项（带抗饱和）
    self.integral = self.integral + error * dt
    
    -- 积分限幅
    local max_integral = self.max_output / (self.Ki + 1e-6)  -- 防止除零
    local min_integral = self.min_output / (self.Ki + 1e-6)
    self.integral = math.min(math.max(self.integral, min_integral), max_integral)
    
    -- 计算微分项
    local derivative = (error - self.previous_error) / dt
    
    -- 计算PID输出
    local output = self.Kp * error + self.Ki * self.integral + self.Kd * derivative
    
    -- 输出限幅
    output = math.min(math.max(output, self.min_output), self.max_output)
    
    -- 保存当前误差
    self.previous_error = error
    
    return output
end

-- 重置PID控制器
function BZD_ct.PIDController:reset()
    self.previous_error = 0
    self.integral = 0
end

-- 设置角度环绕模式
function BZD_ct.PIDController:setAngleWrap(enabled)
    self.wrap_angle = enabled
end

--变量
BZD_ct.Ps = BZD_ct.Vector3:new(0,0,0)
BZD_ct.q = BZD_ct.Quat:new(0,0,0,0)
BZD_ct.Ag = BZD_ct.Euler:new(0,0,0)
BZD_ct.velocity = BZD_ct.Vector3:new(0,0,0)

--方法
--计算
function BZD_ct.V3sub(V3_1,V3_2)
    local V3result = {}
    V3result.x = V3_1.x - V3_2.x
    V3result.y = V3_1.y - V3_2.y
    V3result.z = V3_1.z - V3_2.z
    return V3result
end

function BZD_ct.V3add(V3_1,V3_2)
    local V3result = {}
    V3result.x = V3_1.x + V3_2.x
    V3result.y = V3_1.y + V3_2.y
    V3result.z = V3_1.z + V3_2.z
    return V3result
end

function BZD_ct.RotateVectorByQuat(quat, v)
    local x = quat.x * 2
    local y = quat.y * 2
    local z = quat.z * 2
    local xx = quat.x * x
    local yy = quat.y * y
    local zz = quat.z * z
    local xy = quat.x * y
    local xz = quat.x * z
    local yz = quat.y * z
    local wx = quat.w * x
    local wy = quat.w * y
    local wz = quat.w * z
    local res = {}
    res.x = (1.0 - (yy + zz)) * v.x + (xy - wz) * v.y + (xz + wy) * v.z
    res.y = (xy + wz) * v.x + (1.0 - (xx + zz)) * v.y + (yz - wx) * v.z
    res.z = (xz - wy) * v.x + (yz + wx) * v.y + (1.0 - (xx + yy)) * v.z
    return res
end

function BZD_ct.radianToDegree(angle)-- 弧-角
	return angle * (180.0 / math.pi)
end

function BZD_ct.degreeToRadian(degree)-- 角-弧
	return degree * (math.pi / 180.0)
end

function BZD_ct.getCoordinates(angle, radius)--已知角和半径求坐标2D
    local radians = angle * math.pi / 180

    local x = radius * math.cos(radians)
    local y = radius * math.sin(radians)

    return BZD_ct.Vector2:new(x, y)
end

function BZD_ct.pitchTo360(pitch)
    -- 确保 Pitch 在 ±90° 范围内
    if pitch < -90 or pitch > 90 then
        print("Pitch must be between -90 and 90 degrees")
        return nil
    end

    -- 转换逻辑
    if pitch >= 0 then
        return pitch  -- 0°~90° 保持不变
    else
        return 360 + pitch  -- -90°~0° → 270°~360°
    end
end

function BZD_ct.normalizeAngle(angle)
    angle = angle % 360
    if angle > 180 then
        angle = angle - 360
    elseif angle <= -180 then
        angle = angle + 360
    end
    return angle
end

function BZD_ct.convertAngle180To360(angle)
    angle = BZD_ct.normalizeAngle(angle)  -- 先归一化到 ±180°
    if angle < 0 then
        return angle + 360
    else
        return angle
    end
end

function BZD_ct.normalizeAngleTo90(angle)
    angle = angle % 360  -- 先归一化到 0~360
    if angle > 180 then
        angle = angle - 360  -- 转换到 -180~180
    end
    -- 限制在 ±90°
    if angle > 90 then
        angle = 90
    elseif angle < -90 then
        angle = -90
    end
    return angle
end

function BZD_ct.convertAngle90To360(angle)
    angle = BZD_ct.normalizeAngleTo90(angle)  -- 先归一化到 ±90°
    if angle < 0 then
        return angle + 360
    else
        return angle
    end
end

function BZD_ct.calculate_point(r, pitch, yaw)--已知欧拉角和半径求坐标3D
    -- 将角度转换为弧度
    local pitch_rad = degreeToRadian(pitch)  -- 俯仰角 (PITCH)
    local yaw_rad = degreeToRadian(yaw)      -- 偏航角 (YAW)

    -- 计算直角坐标系下的坐标
    local x = r * math.cos(pitch_rad) * math.sin(yaw_rad)
    local y = r * math.sin(pitch_rad)
    local z = r * math.cos(pitch_rad) * math.cos(yaw_rad)

    return BZD_ct.Vector3:new(x, y, z)
end

-- 将旋转矩阵转换为四元数
function BZD_ct.matrixToQuaternion(matrix)
    local m11, m12, m13 = matrix[1][1], matrix[1][2], matrix[1][3]
    local m21, m22, m23 = matrix[2][1], matrix[2][2], matrix[2][3]
    local m31, m32, m33 = matrix[3][1], matrix[3][2], matrix[3][3]

    -- 计算四元数的实部 w
    local trace = m11 + m22 + m33
    local w, x, y, z

    if trace > 0 then
        local s = 0.5 / math.sqrt(trace + 1.0)
        w = 0.25 / s
        x = (m32 - m23) * s
        y = (m13 - m31) * s
        z = (m21 - m12) * s
    elseif (m11 > m22) and (m11 > m33) then
        local s = 2.0 * math.sqrt(1.0 + m11 - m22 - m33)
        w = (m32 - m23) / s
        x = 0.25 * s
        y = (m12 + m21) / s
        z = (m13 + m31) / s
    elseif m22 > m33 then
        local s = 2.0 * math.sqrt(1.0 + m22 - m11 - m33)
        w = (m13 - m31) / s
        x = (m12 + m21) / s
        y = 0.25 * s
        z = (m23 + m32) / s
    else
        local s = 2.0 * math.sqrt(1.0 + m33 - m11 - m22)
        w = (m21 - m12) / s
        x = (m13 + m31) / s
        y = (m23 + m32) / s
        z = 0.25 * s
    end

    -- 归一化四元数
    local length = math.sqrt(w * w + x * x + y * y + z * z)
    w = w / length
    x = x / length
    y = y / length
    z = z / length

    return BZD_ct.Quat:new(w, x, y, z)
end

function BZD_ct.ctEuler(quat)  --四元数解算欧拉角
    local _quat={w=0,x=0,y=0,z=0}
    _quat.w=quat.w
    _quat.x=quat.y
    _quat.y=quat.x
    _quat.z=quat.z
    local Ag = {}
    Ag.yaw=math.deg(math.atan2(_quat.y*_quat.z+_quat.w*_quat.x,1/2-(_quat.x*_quat.x+_quat.y*_quat.y)))
    Ag.roll=math.deg(math.atan2(_quat.x*_quat.y+_quat.w*_quat.z,1/2-(_quat.y*_quat.y+_quat.z*_quat.z)))
    --Ag.pitch=math.deg(math.asin(-2*(_quat.x*_quat.z-_quat.w*_quat.y)))
    local sin_pitch = -2*(_quat.x*_quat.z-_quat.w*_quat.y)
    sin_pitch = math.max(-1, math.min(1, sin_pitch))  -- 防止浮点误差导致 NaN
    Ag.pitch = math.deg(math.asin(sin_pitch))
    return Ag
end

function BZD_ct.EulerToQuat(yaw_deg, pitch_deg, roll_deg)
    -- 角度转弧度
    local yaw = math.rad(yaw_deg)
    local pitch = math.rad(pitch_deg)
    local roll = math.rad(roll_deg)

    -- 计算半角的正弦和余弦
    local cy = math.cos(yaw * 0.5)
    local sy = math.sin(yaw * 0.5)
    local cp = math.cos(pitch * 0.5)
    local sp = math.sin(pitch * 0.5)
    local cr = math.cos(roll * 0.5)
    local sr = math.sin(roll * 0.5)

    -- 计算四元数分量
    local q = {}
    q.w = cr * cp * cy + sr * sp * sy
    q.x = sr * cp * cy - cr * sp * sy
    q.y = cr * sp * cy + sr * cp * sy
    q.z = cr * cp * sy - sr * sp * cy

    return q
end

function BZD_ct.round(num, decimalPlaces)
    local mult = 10^(decimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function BZD_ct.rotateVector(pitch, yaw, v)
    -- 使用 math.rad 将角度转换为弧度
    local pitchRad = math.rad(pitch)
    local yawRad = math.rad(yaw)
    
    local x, y, z = v.x, v.y, v.z
    
    -- 首先绕Y轴旋转（yaw）
    local cosYaw = math.cos(yawRad)
    local sinYaw = math.sin(yawRad)
    local x1 = x * cosYaw + z * sinYaw
    local z1 = -x * sinYaw + z * cosYaw
    
    -- 然后绕X轴旋转（pitch）
    local cosPitch = math.cos(pitchRad)
    local sinPitch = math.sin(pitchRad)
    local y1 = y * cosPitch - z1 * sinPitch
    local z2 = y * sinPitch + z1 * cosPitch
    
    return BZD_ct.Vector3:new(x1, y1, z2)
end

--参数获取
function BZD_ct.GetShipTransform()
    BZD_ct.Ps = ship.getWorldspacePosition()
    BZD_ct.q = ship.getQuaternion()
    BZD_ct.Ag = BZD_ct.ctEuler(BZD_ct.q)
    BZD_ct.velocity = ship.getVelocity()
end

-- 从四元数误差中提取欧拉角误差（简化的轴-角转换）
function BZD_ct.quatErrorToEulerAngles(q_error)
    -- 四元数转轴-角表示
    local angle = 2 * math.acos(q_error.w)
    local axis_x, axis_y, axis_z
    if angle < 1e-6 then -- 无旋转
        return 0, 0, 0
    else
        local sin_theta_half = math.sqrt(1 - q_error.w * q_error.w)
        axis_x = q_error.x / sin_theta_half
        axis_y = q_error.y / sin_theta_half
        axis_z = q_error.z / sin_theta_half
    end
    
    -- 将轴-角映射到欧拉角误差（简化近似）
    return axis_x * angle, axis_y * angle, axis_z * angle
end

-- 高级PID计算函数
function BZD_ct.computePID(pid, error, dt)
    pid.integral = pid.integral + error * dt
    local derivative = (error - pid.last_error) / dt
    pid.last_error = error
    return pid.kp * error + pid.ki * pid.integral + pid.kd * derivative
end

-- 16进制字符串转数字
function BZD_ct.hex2num(hex, default)
    if type(hex) ~= "string" then
        return default or nil
    end
    
    local clean_hex = hex:gsub("^0[xX]", "")
    
    if clean_hex == "" then
        return default or 0
    end
    
    local num = tonumber(clean_hex, 16)
    return num or default or nil
end

return BZD_ct