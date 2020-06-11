# UnderSeaWorld

海底世界场景练习

## 使用软件

unity

## 版本

2019.3.11

## 简介
项目用于学习Unity中的渲染合批策略。

#### 1.地形边界

静态合批，勾选Static，Unity运行时将几个Mesh合并为CombineMesh，最开始渲染静态合批对象。

#### 2.鱼群和海草

GPU实例化合批，使用支持GPUInstancing的Shader，在渲染大量同Mesh，同Material的对象时，使用GPU实例化合批。(GPU实例化不支持蒙皮渲染的物体，鱼的游动动画需要Shader模拟)

#### 3.UI合批

待制作。

![image](https://github.com/AHappyFun/UnderSeaWorld/blob/master/Show.gif)
