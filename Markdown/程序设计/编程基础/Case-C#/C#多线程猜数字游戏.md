> ---
>
> - Title:《多线程猜测数字游戏》
> - Author:Pleione_Plus
> - Started Date:August 20th.2019.
> - Finished Date:August 20th.2019.
>
> ------

# 背景

## 程序、进程、线程

**程序**：

- 程序是**指令**和**数据**的**有序集合**。
- 程序是静态的。

**进程**：

- 进程是一段程序的执行过程。
- 进程是动态的，具有生命周期。
- 进程是一个活动实体。
- 进程有三种基本状态（就绪态、运行态、阻塞态）。
- 进程是资源分配的基本单位。

**线程**：

- 线程作为独立运行和独立调度的基本单位。
- 一个进程中可以包含若干个线程。

**多线程**：

&emsp;&emsp;在一个程序中，这些独立运行的程序片段叫作“线程”（Thread），利用它编程的概念就叫作“多线程处理”。多线程是为了同步完成多项任务，不是为了提高运行效率，而是为了提高资源使用效率来提高系统的效率。线程是在同一时间需要完成多项任务的时候实现的。

> 最简单的比喻多线程就像火车的每一节车厢，而进程则是火车。车厢离开火车是无法跑动的，同理火车也不可能只有一节车厢。多线程的出现就是为了提高效率。[“外引”](https://www.cnblogs.com/fuchongjundream/p/3829508.html)
>

# 操作环境

**编程环境**：

- VS2017
- .Net Framework 4.5

**运行环境**：

- Win10

# 设计实现

**界面设计**:

![设计界面](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\多线程猜测数字游戏/设计界面.png)

**代码设计**:

```C#
using System;
using System.Drawing;
using System.Windows.Forms;

namespace NumGame
{
    public partial class Frm_Main : Form
    {
        public Frm_Main()
        {
            InitializeComponent();
        }

        #region 声明全局变量
        /// <summary>
        /// 定义一个计时器线程
        /// </summary>
        System.Threading.Thread G_th;

        /// <summary>
        /// 定义一个随机数对象
        /// </summary>
        Random G_random = new Random();

        /// <summary>
        /// 定义一个int型全局变量，用于存放产生的随机变量
        /// </summary>
        int G_int_num;
        #endregion

        #region 开始按钮的Click事件
        /// <summary>
        /// 开始按钮的Click事件
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btn_begin_Click(object sender, EventArgs e)
        {
            RemoveControl();                                        //调用自定义的RemoveControl()方法清空自定义的按钮
            int p_int_x = 10;                                       //X坐标初始值为10
            int p_int_y = 60;                                       //Y坐标初始值为60

            //向窗体添加按钮
            for (int i = 0; i < 100; i++)                           //添加100个按钮
            {
                Button bt = new Button();                           //创建button按钮
                bt.Text = (i + 1).ToString();                       //设置button按钮的文本值
                bt.Name = (i + 1).ToString();                       //设置button按钮的Name属性
                bt.Width = 35;                                      //设置button按钮的宽
                bt.Height = 35;                                     //设置button按钮的高
                bt.Location = new Point(p_int_x, p_int_y);          //设置button按钮的位置
                bt.Click += new EventHandler(bt_Click);             //定义button按钮的Click事件

                p_int_x += 36;                                      //设置下一个按钮的位置
                if ((i + 1) % 10 == 0)                            //设定每行有10个按钮
                {
                    p_int_x = 10;                                   //换行后重新设置X坐标  --X坐标不变
                    p_int_y += 36;                                  //换行后重新设置Y坐标  --Y坐标将变化为原来的+距离
                }

                Controls.Add(bt);                                   //使用Controls.Add()方法将button按钮放入窗体控件集合中
            }

            //创建线程
            //跨线程调用控件
            G_th = new System.Threading.Thread(                 //新建一条线程
                delegate ()                              //使用匿名方法创建一个委托
                {
                    int P_int_count = 0;                            //初始化计数器
                    while (true)                                //开始无限循环
                    {
                        P_int_count = ++P_int_count > 100000000 ? 0 : P_int_count;      //计数器累加

                        this.Invoke(                            //将代码交给主线程执行
                            (MethodInvoker)delegate         //使用匿名方法
                            {
                                lb_time.Text = P_int_count.ToString();          //窗体中显示计数
                            });
                        System.Threading.Thread.Sleep(1000);                    //线程睡眠1秒
                    }
                });

            G_th.IsBackground = true;                                   //设置线程为后台线程
            G_th.Start();                                           //开始执行线程

            //生成一个随机数
            G_int_num = G_random.Next(1, 100);                          //生成一个1-100之间的随机数
            btn_begin.Enabled = false;                              //停用开始按钮
        }
        #endregion

        #region 注册生成按钮的Click事件的方法
        //注册按钮的Click事件的方法
        void bt_Click(object sender, EventArgs e)
        {
            Control P_control = sender as Control;                          //将sender转换为control类型对象
            if (int.Parse(P_control.Name) > G_int_num)                  //强制转化并判断猜测数值与随机产生的数值之间的差距
            {
                P_control.BackColor = Color.Red;                        //设置按钮背景为红色
                P_control.Enabled = false;                              //设置按钮停用
                P_control.Text = "大";                                   //更改按钮文本--猜测数值偏大
                return;
            }
            if (int.Parse(P_control.Name) < G_int_num)
            {
                P_control.BackColor = Color.Red;                        //设置按钮背景为红色
                P_control.Enabled = false;                              //设置按钮停用
                P_control.Text = "小";                                       //更改按钮文本--猜测数偏小
                return;
            }
            if (int.Parse(P_control.Name) == G_int_num)                 //当猜测数值与随机产生的数值相等时
            {
                G_th.Abort();                                                   //终止计数线程
                //显示游戏信息
                MessageBox.Show(string.Format("恭喜你猜对了！共猜了{0}次 用时{1}秒", GetCount(), lb_time.Text), "恭喜！");
                btn_begin.Enabled = true;                           //启用开始按钮
                return;
            }
        }
        #endregion

        #region 计数方法
        /// <summary>
        /// 用于查找窗体中Enable属性为False控件的数量    --遍历窗体中的控件
        /// 用于计算玩家有多少次没有猜中
        /// </summary>
        /// <returns>返回没有猜中数量</returns>
        string GetCount()
        {
            int P_int_temp = 0;                                             //初始化计数器
            foreach (Control c in Controls)                                     //遍历控件集合
            {
                if (!c.Enabled) P_int_temp++;                               //计数器累加
            }
            return P_int_temp.ToString();                               //返回计数器信息
        }
        #endregion

        #region 清除控件方法
        /// <summary>
        /// 用于清空窗体中动态生成的按钮
        /// </summary>
        void RemoveControl()                                            //自定义的清除方法
        {
            for (int i = 0; i < 100; i++)                               //开始遍历100个按钮
            {
                if (Controls.ContainsKey((i + 1).ToString()))             //窗体中是否有此按钮
                {
                    for (int j = 0; j < Controls.Count; j++)                //遍历窗体控件集合
                    {
                        if (Controls[j].Name == (i + 1).ToString())         //是否查找到按钮
                        {
                            Controls.RemoveAt(j);                           //删除指定按钮
                            break;
                        }
                    }
                }
            }
        }
        #endregion

        #region 窗体的FormClosing事件
        //窗体的FormClosing事件
        private void Frm_Main_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (G_th != null)
            {
                G_th.Abort();
            }

            Environment.Exit(0);                                //强行关闭窗体
        }
        #endregion
    }
}
```



# 实现结果

![测试结果](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\多线程猜测数字游戏/测试结果.png)

# 附录

**程序流程分析**:

![NumGame](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\多线程猜测数字游戏/NumGame.png)

**参考资料**：

[进程、线程、多线程相关总结](https://www.cnblogs.com/fuchongjundream/p/3829508.html)

《C#开发实战1200例》