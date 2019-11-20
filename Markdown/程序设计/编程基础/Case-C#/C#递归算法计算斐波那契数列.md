> ---
>
> - Title:《递归算法计算斐波那契数列》
> - Author:Pleione_Plus
> - Started Date:August 20th.2019.
> - Finished Date:August 20th.2019.
>
> ------

# 背景

## 兔子数列

斐波那契(Fibonacci)在《计算之术》中提出一个问题：

&emsp;&emsp;在第一个月有一对刚出生的小兔子，在第二个月小兔子变成大兔子并开始怀孕，第三个月大兔子会生下一对小兔子，并且以后每个月都会生下一对小兔子。 如果每对兔子都经历这样的出生、成熟、生育的过程，并且兔子永远不死，那么兔子的总数是如何变化的？

**关键点**：

- 兔子成对出生
- 兔子的成长周期和生育周期都为1个月
- 所有的兔子都不会死亡，并且可以一直保持生育

**问题解析**：

第一个月只有一对兔宝宝，1对兔子

第二个月兔宝宝变成大兔子，1对兔子

第三个月大兔子生了一对兔宝宝，2对兔子

第四个月大兔子继续生一对兔宝宝，小兔子变成大兔子，3对兔子

......

![数列列表](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\递归算法计算斐波那契数列\数列列表.jpg)

**发现规律**：

- 前一个月的大兔子对数就是下一个月的小兔子对数
- 前一个月的大兔子和小兔子对数的和就是下个月大兔子的对数

$$
f(n)=
\begin{cases}
1 & n=1\\
1 & n=2\\
f(n-1) + f(n-2) &n>2
\end{cases}
$$

此为兔子数列（斐波那契数列）

<font color="red">**使用程序怎样来实现斐波那契数列呐？**</font>

# 操作环境

**编程环境**：

- VS2017
- .Net Framework 4.5

**运行环境**：

- Win10

# 设计实现

**界面设计**：

![界面设计](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\递归算法计算斐波那契数列/界面设计.png)

**代码设计**：

```C#
using System;
using System.Windows.Forms;

namespace Arithmetic
{
    public partial class Frm_Main : Form
    {
        public Frm_Main()
        {
            InitializeComponent();
        }

        #region 计算按钮的Click事件
        //计算按钮的Click事件
        private void btn_Get_Click(object sender, EventArgs e)
        {
            int P_int_temp;                                         //定义一个用于存储的整型变量
            if (int.TryParse(txt_value.Text, out P_int_temp))       //为变量赋值
            {
                lb_result.Text = "计算结果为：" + Get(P_int_temp).ToString();     //输出计算结果
            }
            else                                    //当数据转化失败时
            {
                MessageBox.Show("请输入正确的数值！", "提示！");                      //提示输入正确数值
            }
        }
        #endregion

        #region 斐波那契数列的计算
        /// <summary>
        /// 递归算法                //斐波那契数列的计算问题
        /// </summary>
        /// <param name="i">参与计算的数值</param>
        /// <returns>计算结果</returns>
        int Get(int i)
        {
            if (i <= 0)							//判断数值是否小于0
                return 0;						//返回数值0
            else if (i >= 0 && i <= 2)			//判断数值是否大于等于0并且小于等于2
                return 1;						//返回数值1
            else								//如果不满足上述条件执行下面语句
                return Get(i - 1) + Get(i - 2);	//返回指定位数前两位数的和
        }
        #endregion

    }
}
```

**注**：

- 程序以int类型存储结果，当计算的数值超出int时，程序将会报错。

# 实现结果

![实现结果](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\递归算法计算斐波那契数列/实现结果.png)

# 附录

**参考链接**：

[什么叫斐波那契数列](https://baijiahao.baidu.com/s?id=1606651492697783298&wfr=spider&for=pc)

《C#开发实例1200例》