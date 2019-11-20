> ---
>
> - Title:《C# 使用线程对系统当前时间进行操作》
> - Author: Pleione_Plus
> - Started Date: September. 7th. 2019.
> - Finished Date:
>



# 背景

​		在编写程序时，经常会对系统时间进行一些相关操作，如：动态获取当前系统的日期与时间、显示系统已经运行的时间、设置当前系统日期与时间等。

# 操作环境

**编程环境**：

- VS2017
- .Net Framework 4.6.1

**运行环境**：

- Win10

# 设计实现

## 1.动态获取系统当前日期与时间

**界面设计**：

![动态获取系统当前日期与时间](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\C# 使用线程对系统当前时间进行操作/动态获取系统当前日期与时间.png)

**代码设计**：

```C#
using System;
using System.Drawing;
using System.Windows.Forms;
using System.Threading;

namespace GetTime
{
    public partial class Frm_Main : Form
    {
        public Frm_Main()
        {
            InitializeComponent();
        }

        private void Frm_Main_Load(object sender, EventArgs e)
        {
            //创建线程
            Thread P_thread = new Thread(
                () =>//使用lambda表达式
                {
                    while (true)//无限循环
                    {
                        this.Invoke(//操作窗体线程
                              (MethodInvoker)delegate()//使用匿名方法
                                     {
                                         //刷新窗体
                                         this.Refresh();
                                         //创建绘图对象
                                         Graphics P_Graphics = this.CreateGraphics();
                                         //在窗体中绘出系统时间
                                         P_Graphics.DrawString("系统时间：" +
                                             DateTime.Now.ToString("yyyy年MM月dd日 HH时mm分ss秒"),
                                             new Font("宋体", 15),
                                             Brushes.Blue,
                                             new Point(10, 10));
                                     });
                        Thread.Sleep(1000);//线程挂起1秒钟
                    }
                });
            P_thread.IsBackground = true;//将线程设置为后台线程
            P_thread.Start();//线程开始执行
        }
    }
}

```

**运行结果**：

![动态获取系统当前日期与时间-Show](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\C# 使用线程对系统当前时间进行操作/动态获取系统当前日期与时间-Show.png)



## 2.手动设置系统日期与时间

**界面设计**：

![设置系统日期与时间](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\C# 使用线程对系统当前时间进行操作/设置系统日期与时间.png)

**代码设计**：

```C#
using System;
using System.Windows.Forms;
using System.Runtime.InteropServices;

namespace SetDate
{
    public partial class Frm_Main : Form
    {
        public Frm_Main()
        {
            InitializeComponent();
        }

        public class SetSystemDateTime//设置系统日期类
        {
            [DllImportAttribute("Kernel32.dll")]
            public static extern void GetLocalTime(SystemTime st);
            [DllImportAttribute("Kernel32.dll")]
            public static extern void SetLocalTime(SystemTime st);
        }

        [StructLayoutAttribute(LayoutKind.Sequential)]
        public class SystemTime//系统时间类
        {
            public ushort vYear;//年
            public ushort vMonth;//月
            public ushort vDayOfWeek;//星期
            public ushort vDay;//日
            public ushort vHour;//小时
            public ushort vMinute;//分
            public ushort vSecond;//秒
        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.textBox1.Text = DateTime.Now.ToString("F") +//得到系统时间
                "  " + DateTime.Now.ToString("dddd");
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("您真的确定更改系统当前日期吗？",//设置系统当前日期时间
                "信息提示", MessageBoxButtons.OK) == DialogResult.OK)
            {
                DateTime Year = this.dateTimePicker1.Value;//得到时间信息
                SystemTime MySystemTime = new SystemTime();//创建系统时间类的对象
                SetSystemDateTime.GetLocalTime(MySystemTime);//得到系统时间
                MySystemTime.vYear = (ushort)this.dateTimePicker1.Value.Year;//设置年
                MySystemTime.vMonth = (ushort)this.dateTimePicker1.Value.Month;//设置月
                MySystemTime.vDay = (ushort)this.dateTimePicker1.Value.Day;//设置日
                MySystemTime.vHour = (ushort)this.dateTimePicker2.Value.Hour;//设置小时
                MySystemTime.vMinute = (ushort)this.dateTimePicker2.Value.Minute;//设置分
                MySystemTime.vSecond = (ushort)this.dateTimePicker2.Value.Second;//设置秒
                SetSystemDateTime.SetLocalTime(MySystemTime);//设置系统时间
                button1_Click(null, null);//执行按钮点击事件
            }
        }
    }
}
```

**运行结果**：（需要管理员权限才能执行成功）

![设置系统日期与时间-Show](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\C# 使用线程对系统当前时间进行操作/设置系统日期与时间-Show.png)

## 3.确定系统运行的时间

**界面设计**：

![显示系统运行的时间](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\C# 使用线程对系统当前时间进行操作/显示系统运行的时间.png)

**代码设计**：

```C#
using System;
using System.Windows.Forms;
using System.Threading;

namespace DisplayRunTime
{
    public partial class Frm_Main : Form
    {
        public Frm_Main()
        {
            InitializeComponent();
        }

        //声明时间字段
        private DateTime G_DateTime;

        // 系统开始运行之后一直在计数
        private void Frm_Main_Load(object sender, EventArgs e)
        {
            //得到系统当前时间
            G_DateTime = DateTime.Now;
            //创建线程
            Thread P_th = new Thread(
                () =>//使用Lambda表达式
                {
                    while (true)//无限循环
                    {
                        //得到时间差
                        TimeSpan P_TimeSpan = DateTime.Now - G_DateTime;
                        //调用窗体线程
                        Invoke(
                            (MethodInvoker)(() =>//使用Lambda表达式
                            {
                                //显示程序启动时间
                                tssLabel_Time.Text = string.Format(
                                    "系统已经运行： {0}天{1}小时{2}分{3}秒",
                                    P_TimeSpan.Days, P_TimeSpan.Hours, 
                                    P_TimeSpan.Minutes, P_TimeSpan.Seconds);
                            }));
                        //线程挂起1秒钟
                        Thread.Sleep(1000);
                    }
                });
            //设置为后台线程
            P_th.IsBackground = true;
            //开始执行线程
            P_th.Start();
        }
    }
}

```

**运行结果**：

![显示系统运行的时间-Show](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\C# 使用线程对系统当前时间进行操作/显示系统运行的时间-Show.png)



# 附录

