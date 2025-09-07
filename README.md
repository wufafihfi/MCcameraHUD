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
    "radar":true,
    "showRadarData":true,
    "engineControl":true,
    "hologram_ID":11,
    "camera_ID":11,
    "Engine_ID":0,
    "showCameraTransformData":true,
    "Camera_Screen_Distance":0.5,
    "hologramScale":0.05,
    "hologramSize":{"w":500,"h":350},
    "HUDTranslation_unRotate_offset":{"x":0,"y":-1,"z":1}
}
```
