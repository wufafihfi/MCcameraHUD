# MCcameraHUD
## 这是引擎控制模式下的无线红石放置示例
![放置位置示例](https://raw.githubusercontent.com/wufafihfi/MCcameraHUD/refs/heads/main/image/ab2dc6a6-e064-4301-b1e9-7742f9a5e4b1.png "放置位置示例")
- 箭头朝向为CC电脑的正面朝向
- 其背面为"取消锁定"功能，激活可关闭船的方向控制
- 右侧的为"锁定"功能，一直激活可一直锁定你相机所朝方向，如果只激活一次则会锁定你此次激活所朝方向，此时相机可自由移动而船不跟随其朝向
- 正面的没有任何实际作用，我只是忘记把它打掉了
## 启动配置介绍
![启动配置示例](https://raw.githubusercontent.com/wufafihfi/MCcameraHUD/refs/heads/main/image/94feea1a-2e2d-4a0e-b410-0ea227a90d29.png "启动配置示例")
```json
// 实际上JSON不支持这么注释...
// 本人玩C++习惯了...
{
    "showYaw":true,// 显示偏航标尺
    "showPitch":true,// 显示俯仰梯
    "showVelosity":true,// 显示速度矢量
    "showShipDirection":true,// 显示船的朝向
    "cameraCrosshairSignStyle":2,// 准心样式 1为十字 2为方框 其他数字则没有准心
    "draw3DLines":true,// 绘制配置文件里读取的的3维空间线段
    "radar":true,// 开启雷达并绘制矩形框住船
    "showRadarData":true,// 显示雷达所扫描到的船的数量
    "engineControl":true,// 开启飞控，关闭时可以不需要装引擎外设
    "hologram_ID":11,// 全息屏外设的编号，具体看下一部分
    "camera_ID":11,// 相机外设的编号，具体看下一部分
    "Engine_ID":0,// 引擎外设的编号，具体看下一部分
    "showCameraTransformData":true,// 显示相机位置和旋转数据
    "Camera_Screen_Distance":0.5,// 相机到全息屏的距离
    "hologramScale":0.05,// 全息屏的像素缩放，1为1格方块的1/16，0.05则是1/16/20
    "hologramSize":{"w":500,"h":350},// 屏幕像素宽高
    "HUDTranslation_unRotate_offset":{"x":0,"y":-1,"z":1}//全息屏幕在船坐标系内相对于屏幕方块的位置偏移
}
```
## 外设编号
### 
![外设编号示例](https://raw.githubusercontent.com/wufafihfi/MCcameraHUD/refs/heads/main/image/015f393b-4a92-46ad-88f0-37e93d16e6cd.png "外设编号示例")
- 在运行程序后会显示的字，其中有扫描到的外设信息
### 
![无线外设方块](https://raw.githubusercontent.com/wufafihfi/MCcameraHUD/refs/heads/main/image/0ab6ed67-0d3a-4824-ab87-3db29d513718.png "无线外设方块")
- 因为此MOD的无线外设连接器在每次连接会给所连接的外设编号，所以在连接过后需要重新配置外设编号使程序能够成功连接
