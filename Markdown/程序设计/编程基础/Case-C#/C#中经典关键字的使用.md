> ---
>
> - Title:《C#中经典关键字的使用》
> - Author:Pleione_Plus
> - Started Date:August 20th.2019.
> - Finished Date:August 21th.2019.ss
>
> ------

[TOC]

# 背景

**checked**:

​		检查计算结果**是否**发生**溢出**，常常需要与**try...catch**异常处理连用。

**typeof**:

​		用于获取类型的**System.Type对象**。通过调用System.Type对象相应的方法可以得到类型中**定义的成员**。

**using**:

- 可以用来**引用命名空间**
- 有效地的**回收对象资源**（**对象必须实现IDisposable接口**）

**is:**

​		用于检查**对象**是否与**给定类型**兼容，返回bool值

**as**:

​		用于**引用类型**之间执行**弹性转换**，返回转换后的对象或NULL，不会抛出异常

**goto:**

​		跳转到指定**标签**[^1]处，常常判断语句搭配来实现循环的效果

# 操作环境

**编程环境**：

- VS2017
- .Net Framework 4.6.1

**运行环境**：

- Win10

# 设计实现

## checked关键字处理溢出错误

**界面设计**：

![checked界面设计](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\C#中经典关键字的使用/checked界面设计.png)

**代码设计**：

```C#
/*
 * 程序功能：检查计算结果是否发生溢出，（checked）--《需要和try...catch异常处理》
 * 
 * 注：C#默认不处理溢出问题，使用checked之后检查溢出后抛出错误
 */ 


using System;
using System.Windows.Forms;

namespace Checked
{
    public partial class Form1 : Form
    {
        //窗体的无参构造函数
        public Form1()
        {
            InitializeComponent();
        }

        //按钮的CLick事件
        private void btn_Get_Click(object sender, EventArgs e)
        {
            //定义两个byte类型变量
            byte bt_One, bt_Two;                                                                                              
            
            //对两个byte类型变量赋值
            if (byte.TryParse(txt_Add_One.Text.Trim(), out bt_One) && byte.TryParse(txt_Add_Two.Text.Trim(), out bt_Two))     
            {
                try
                {
                    //使用checked关键字判断计算结果是否有溢出
                    checked { bt_One += bt_Two; }

                    //输出相加后的结果
                    txt_Result.Text = bt_One.ToString();                   
                }
                catch (OverflowException ex)
                {
                    //输出异常信息
                    MessageBox.Show(ex.Message,"出错！");                                                                     
                }
            }
            else
            {
                //输出错误信息
                MessageBox.Show("请输入255以内的数字!");                      
            }
        }
    }
}
```

**技术分析**：

- C#默认不检查数值溢出问题
- 程序执行时，checked包裹的语句会检查是否存在数值溢出问题，有则抛出异常
- checked通常和try...catch异常处理一起使用，以处理溢出异常

**实现结果**：

![checked结果](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\C#中经典关键字的使用/checked结果.png)

## typeof关键字获取类的内部结构

**界面设计**：

![typeof界面设计](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\C#中经典关键字的使用/typeof界面设计.png)

**代码设计**：

```C#
using System;
using System.Windows.Forms;
using System.Reflection;

namespace TypeOf
{
    public partial class Frm_Main : Form
    {
        public Frm_Main()
        {
            InitializeComponent();
        }

        private void btn_Get_Click(object sender, EventArgs e)
        {
            Type type = typeof(System.Int32);                                                       //获得int类型的Type对象
            //int i = 1;
            //Type type1 = i.GetType();                                             //使用GetType()方法获取类型的Type对象
            foreach (MethodInfo method in type.GetMethods())                                        //遍历int类中定义的所有公共方法
            {
                rtbox_text.AppendText("方法名称：" + method.Name + Environment.NewLine);            //输出方法名称

                foreach (ParameterInfo parameter in method.GetParameters())                         //遍历公共方法中所有参数
                {
                    rtbox_text.AppendText( "  参数：" + parameter.Name + Environment.NewLine);       //输出参数名称
                }
            }
        }
    }
}

```

**技术分析**：

- System.Type对象可以通过typeof()来获取，也可以通过GetType()方法来获取
- 使用type对象的```GetMethods()```、```GetProperties()```等方法可获得对象的内部构造
- ```Environment.NewLine```相当于换行符

**实现结果**：

![typeof实现结果](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\C#中经典关键字的使用/typeof实现结果.png)

## using关键字有效回收资源

**界面设计**：

![using设计界面](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\C#中经典关键字的使用/using设计界面.png)

**代码设计**：

```C#
/*
 *注意事项：
 *using()内的对象资源必须继承于IDisposable接口或其基类继承于IDisposable接口，否则程序会报错
 */

using System;
using System.Windows.Forms;

namespace Using
{
    public partial class Frm_Main : Form
    {
        public Frm_Main()
        {
            InitializeComponent();
        }

        //btn_true按钮的Click事件
        private void btn_true_Click(object sender, EventArgs e)
        {
            using (new test())         //在using语句中创建test对象
            {
            }//using语句块执行完成后会自动调用test对象的Dispose方法
        }
        class test : IDisposable//定义test类实现IDisposable接口
        {
            public void Dispose()//实现接口方法
            {
                MessageBox.Show(//弹出消息对话框
                    "已经执行test对象的Dispose方法","提示");
            }
        }
        
    }
/*
 * ----------------------------------------
 * 多个using的使用方法
 * using(new test1()) using(new test2())
 * {
 * 
 * }
 * ---------------------------------------
 */
}

```

**技术分析**：

- using释放对象的本质是隐式调用对象的```Dispose()```方法，所以资源对象必须实现IDospose接口
- 使用using同时回收多个对象资源时需要使用多个using

**实现结果**：

![using实现结果](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\C#中经典关键字的使用/using实现结果.png)

## is关键字检查对象是否与给定类型兼容

**界面设计**：

![is设计界面](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\C#中经典关键字的使用/is设计界面.png)

**代码设计**：

```C#
/*
 * is关键字的使用：
 * 该关键字用于判断对象与类型之间的是否兼容，可以是值类型也可以是引用类型，
 * 但是is是只做判断不做任何的类型之间的转化，因此不会产生调试异常，且其返回值是一个bool类型的值
 */


using System;
using System.Windows.Forms;

namespace Equal
{
    public partial class Frm_Main : Form
    {
        public Frm_Main()
        {
            InitializeComponent();
        }
        //按钮的Click事件
        private void btn_Get_Click(object sender, EventArgs e)
        {
            //使用条件运算符获取选择的对象--若为true则为字符串类型，否则为文件类型
            object P_obj = rbtn_target1.Checked ? (object)"C# 编程词典" : new System.IO.FileInfo(@"d:\");
            if (rbtn_class1.Checked)                //当选择的类型为string类型时
            {
                if (P_obj is System.String)                             //使用is关键字判断对象是否为字符串类型
                    MessageBox.Show("对象与指定类型兼容", "提示！");       //提示兼容信息
                else
                    MessageBox.Show("对象与指定类型不兼容", "提示！");     //提示不兼容信息
            }
            else                                    //当选择的类型为文件类型时
            {
                if (P_obj is System.IO.FileInfo)                      //使用is关键字判断对象是否为文件类型
                    MessageBox.Show("对象与指定类型兼容", "提示！");     //提示兼容信息
                else
                    MessageBox.Show("对象与指定类型不兼容", "提示！");    //提示不兼容信息
            }
        }
    }
}

```

**技术分析**：

- is关键字用于判断对象与类型之间的是否兼容，可以是值类型也可以是引用类型
- is是只做判断不做任何的类型之间的转化，因此不会产生调试异常，且其返回值是一个bool类型的值

**实现结果**：

![is实现结果1](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\C#中经典关键字的使用/is实现结果1.png)

![is实现结果2](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\C#中经典关键字的使用/is实现结果2.png)

## as关键字将对象转化为指定类型

**界面设计**：

![as设计界面](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\C#中经典关键字的使用/as设计界面.png)

**代码设计**：

```C#
/*
 * as关键字的使用：
 * 做对象与类型间的转化，若可以转化则将转化后的值赋给定义的变量；否则将变量赋值为null---此处常用做来判断是否转化成功
 */


using System;
using System.IO;
using System.Windows.Forms;

namespace Transform
{
    public partial class Frm_Main : Form
    {
        public Frm_Main()
        {
            InitializeComponent();
        }
        //按钮的Click事件
        private void btn_Get_Click(object sender, EventArgs e)
        {
            if (rbtn_object.Checked)                                                    //当想要将对象转化为object类型时
            {
                using (FileStream P_filestream = new FileStream(@"d:\log.txt", System.IO.FileMode.Create))     //创建文件流对象
                {
                    object P_object = P_filestream as object;                           //使用as关键字做转换类型
                    if (P_object != null)                                            //判断转换是否成功
                    {
                        MessageBox.Show("转换为Object成功！", "提示！");          //不为null则转化成功
                    }
                    else
                    {
                        MessageBox.Show("转换为Object不成功！", "提示！");
                    }
                }

            }
            if (rbtn_stream.Checked)                                               //当想要将对象转化为stream类型时
            {
                using (FileStream P_filestream = new FileStream(@"d:\log.txt", System.IO.FileMode.Create)) //创建文件流对象
                {
                    object P_obj = P_filestream;
                    Stream P_stream = P_obj as Stream;                              //使用as关键字转换类型
                    if (P_stream != null)                                           //判断转换是否成功
                    {
                        MessageBox.Show("转换为Stream成功！", "提示！");
                    }
                    else
                    {
                        MessageBox.Show("转换为Stream不成功！", "提示！");
                    }
                }
            }
            if (rbtn_string.Checked)                                            //当想要将对象转化为string类型时
            {
                using (FileStream P_filestream = new FileStream(@"d:\log.txt", System.IO.FileMode.Create))           //创建文件流对象
                {
                    object P_obj = P_filestream;
                    string P_str = P_obj as string;                                 //使用as关键字转换类型
                    if (P_str != null)                                              //判断转换是否成功
                    {
                        MessageBox.Show("转换为string成功！", "提示！");
                    }
                    else
                    {
                        MessageBox.Show("转换为string不成功！", "提示！");
                    }
                }
            }
        }
    }
}
```

**技术分析**：

- using回收创建的资源对象
- as作弹性转换，返回值为转换后对象或null

**实现结果**：

![as实现结果1](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\C#中经典关键字的使用/as实现结果1.png)

![as实现结果2](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\C#中经典关键字的使用/as实现结果2.png)

## goto语句在数组中检索指定字符串

**界面设计**：

![goto设计界面](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\C#中经典关键字的使用/goto设计界面.png)

**代码设计**：

```C#
using System;
using System.Windows.Forms;

/*
 * 使用goto替代循环完成预期效果
 */ 
namespace Goto
{
    public partial class Frm_Main : Form
    {
        public Frm_Main()
        {
            InitializeComponent();
        }

        string[] G_str_array = new string[]                 //定义数组并初始化         --书库中的书
        { 
        "C#范例宝典",
        "C#编程宝典",
        "C#视频学",
        "C#项目开发全程实录",
        "C#项目开发实例自学手册",
        "C#编程词典",
        "C#实战宝典",
        "C#经验技巧宝典",
        "C#入门模式",
        };

        //窗体的Load事件
        private void Frm_Main_Load(object sender, EventArgs e)
        {
            lbox_str.Items.AddRange(G_str_array);                           //将赋值之后的string型数组添加到ListBox控件中
        }

        //搜索按钮的Click事件
        private void btn_query_Click(object sender, EventArgs e)
        {
            int i = 0;                                                      //定义计数器

        label1:                 //定义GOTO标签--用于跳转之用
            if (G_str_array[i].Contains(txt_query.Text))                //判断是否找到图书
            {
                lbox_str.SelectedIndex = i;                 //选中查找到的结果
                MessageBox.Show(txt_query.Text + " 已经找到！", "提示！");          //提示找到信息
                return;
            }
            
            i++;
            
            if (i < G_str_array.Length) 
                goto label1;                        //条件满足则跳转到标签
            MessageBox.Show(txt_query.Text + " 没有找到！", "提示！");              //提示未找到信息
        }
    }
}

```

**技术分析**：

- 向ListBox控件中批量添加元素：```lbox_str.Items.AddRange(G_str_array);```
- 判断元素是否在数组中存在：```G_str_array[i].Contains(txt_query.Text)```
- goto借助判断语句可实现循环效果

**实现结果**：

![goto实现结果](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\C#中经典关键字的使用/goto实现结果.png)



# 附录

**参考资料**：

《C#开发实战1200例》



--------------

[^1]: 定义形式："labelname:"

