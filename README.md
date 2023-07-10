# 介绍

[文档](https://juejin.cn/post/7250299528925003835)

# 集成
```
pod 'MonitorKit'
```
# 使用
```
// 启动 UI 卡顿监听
CatonMonitor.shared.startMonitor()

// 关闭 UI 卡顿监听
CatonMonitor.shared.stopMonitor()

// 卡顿监听回调
CatonMonitor.shared.catonStackCallback = { res in
  print(res)
}

// 修改卡顿阈值，单位是 s，一般不宜过短，因为获取调用栈也是一个耗时的过程
CatonMonitor.shared.changeObserverTime(20)
```



