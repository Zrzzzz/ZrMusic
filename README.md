# ZrMusic

一些技术相关：https://zrzzzz.github.io/

<div align="center">
  <img src="https://tva1.sinaimg.cn/large/0082zybpgy1gbuqfw9m8xj30ne1e6492.jpg" width=200/><img src="https://tva1.sinaimg.cn/large/0082zybpgy1gbuqh8v1m3j30nk1een7r.jpg" width=200/>
  <img src="https://tva1.sinaimg.cn/large/0082zybpgy1gbuqly3vu1j30n61e6qbx.jpg" width=200/><img src="https://tva1.sinaimg.cn/large/0082zybpgy1gbuqj83bbbj30nu1e4gws.jpg" width=200/>
</div>



## ZrExtension

`UIView.superView()`

``` swift
func superView<T: UIView>(of: T.Type) -> T? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let father = view as? T {
                return father
            }
        }
        return nil
    }
```

用于寻找父View, 不过只能寻找到第一个就是了

`UILabel.fontSuitToFrame()`

```swift
func fontSuitToFrame() {
        let aView = self.sizeThatFits(CGRect.zero.size)
        guard aView.width * aView.height != 0 else { return }
        let rate1 = self.frame.width / aView.width
        let rate2 = self.frame.height / aView.height
        let rate = rate1 > rate2 ? rate2 : rate1
        self.font = .systemFont(ofSize: self.font.pointSize * rate)
    }

```

宽高哪个窄就铺满哪一个

`DyColor(light: UIColor, dark: UIColor) -> UIColor`

``` swift
func DyColor(light: UIColor, dark: UIColor) -> UIColor {
    return UIColor(dynamicProvider: { (trait) -> UIColor in
        return trait.userInterfaceStyle != .dark ? light : dark
    })
}
```



## Login

<img src="https://tva1.sinaimg.cn/large/0082zybpgy1gbuqnj1srmj30cm0d0t95.jpg" alt="image-20200213140522029" style="zoom:50%;" /> <img src="https://tva1.sinaimg.cn/large/0082zybpgy1gbuqq1f0buj30gk0ecq5f.jpg" alt="image-20200213140748891" style="zoom: 33%;" />

两种登录方式，输入不对或者密码错误时会弹窗

## Mine

<img src="https://tva1.sinaimg.cn/large/0082zybpgy1gbuqr53xivj30n019c7gh.jpg" alt="image-20200213140849662" style="zoom: 33%;" align="left"/>成功登录后会跳转到歌单页面，点击箭头实现收缩展开，点击添加图标添加新歌单。