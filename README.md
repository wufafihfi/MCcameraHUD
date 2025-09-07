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
### 启动配置里所有项目全开后的样子
![全开示例](https://raw.githubusercontent.com/wufafihfi/MCcameraHUD/refs/heads/main/image/60298d5c-d34d-41ea-a35c-8d4afd4dfe03.png "全开示例")
## 外设编号
### 
![外设编号示例](https://raw.githubusercontent.com/wufafihfi/MCcameraHUD/refs/heads/main/image/015f393b-4a92-46ad-88f0-37e93d16e6cd.png "外设编号示例")
- 在运行程序后会显示的字，其中有扫描到的外设信息
### 
![无线外设方块](https://raw.githubusercontent.com/wufafihfi/MCcameraHUD/refs/heads/main/image/0ab6ed67-0d3a-4824-ab87-3db29d513718.png "无线外设方块")
- 因为此MOD的无线外设连接器在每次连接会给所连接的外设编号，所以在连接过后需要重新配置外设编号使程序能够成功连接
### 配置编号
- 放置无线外设方块并紧贴CC电脑
- 使用其MOD的法杖连接（具体过程不过多赘述）
- 所有外设连接完毕后运行一次程序，使之打印外设信息
- 记下对应外设的编号（"外设名"_外设编号->"外设原名"）
- 将启动配置中对应外设的编号（此内容在上一部分）改成之前所记下的对应外设的编号
- 再次运行程序即可成功连接
## 创建自己的3维空间线段 或 导航点
### 示例
```json
{
  "name":"BZD_Pack",// 包名
  "metadata": {
    "version": 1.0,// 包版本
    "description": "example lines pack"// 包描述
  },
  "data":{// 点/线的数据
    "individual_Points":[// 单个点
      {
        "name":"point 1",// 点的名称
        "position":{"x":0,"y":-60,"z":0},// 点的坐标
        "DistanceFilteringMode":false// 不被被远裁剪或近裁剪
      },
      {
        "name":"point 2",// 点的名称
        "position":{"x":20,"y":-60,"z":0},// 点的坐标
        "DistanceFilteringMode":true,// 被远裁剪或近裁剪
        "far":50,// 远裁剪距离
        "near":10// 近裁剪距离
      }
    ],
    "individual_lines":[// 单个线
      {
        "name":"line 1",// 线的名称
        "color":"0xBBFFFFFF",// 线的颜色（0xRRGGBBAA格式）
        "startPosition":{"x":0,"y":-40,"z":0},// 线的头坐标
        "endPosition":{"x":0,"y":-60,"z":0},// 线的尾坐标
        "DistanceFilteringMode":true,// 被远裁剪或近裁剪
        "far":50,// 远裁剪距离
        "near":10// 近裁剪距离
      },
      {
        "name":"line 2",// 线的名称
        // 线如果不定义颜色则使用系统默认颜色，即绿色
        "startPosition":{"x":0,"y":-20,"z":0},// 线的头坐标
        "endPosition":{"x":0,"y":-30,"z":0},// 线的尾坐标
        "DistanceFilteringMode":false// 不被被远裁剪或近裁剪
      }
    ],
    "_注释":"线组内的每一个线的坐标是相对线组坐标的偏移量,点组也一样",
    "point_groups":[ // 点集
      {
        "name":"Point Group 1",// 点集的名称
        "position":{"x":30,"y":-50,"z":30},// 点集的世界坐标
        "DistanceFilteringMode":true,// 远近裁剪设置
        "far":50,
        "near":10,
        "points":[// 点集里的点在这里定义
          {
            "position":{"x":10,"y":10,"z":10}// 点集内的一个点
          },
          {
            "position":{"x":-20,"y":-10,"z":5}// 点集内的一个点
          }
        ]
      },
      {
        "name":"Point Group 2",
        "position":{"x":50,"y":-60,"z":-30},
        "DistanceFilteringMode":false,// 远近裁剪设置
        "points":[
          {
            "position":{"x":10,"y":10,"z":10}
          },
          {
            "position":{"x":-20,"y":-10,"z":5}
          }
        ]
      }
    ],
    "line_groups":[// 线集
      {
        "name":"Line Group 1",// 线集的名称
        "color":"0xFFFFFFFF",// 线集的颜色，如果未定义则跟随系统颜色，即绿色
        "position":{"x":20,"y":-60,"z":20},// 线集的世界坐标
        "DistanceFilteringMode":true,// 远近裁剪设置
        "far":50,
        "near":10,
        "lines":[// 线集里的线在这里定义
          { 
            "color":"0x00FF00FF",// 线集里的一条线的的颜色（它是有个性的，并不想随波逐流）
            "startPosition":{"x":0,"y":10,"z":0},
            "endPosition":{"x":-5,"y":0,"z":20}
          },
          {
            // 这条线没有定义颜色则跟随线集颜色
            "startPosition":{"x":-5,"y":0,"z":20},
            "endPosition":{"x":10,"y":20,"z":20}
          }
        ]
      },
      {
        "name":"Line Group 2",
        "color":"0x00FF00FF",
        "position":{"x":-30,"y":-20,"z":20},
        "DistanceFilteringMode":false,// 远近裁剪设置
        "lines":[
          { 
            "startPosition":{"x":0,"y":10,"z":0},
            "endPosition":{"x":-5,"y":0,"z":20}
          },
          { 
            "startPosition":{"x":-5,"y":0,"z":20},
            "endPosition":{"x":10,"y":20,"z":20}
          }
        ]
      }
    ]
  }
}
```
