> ---
>
> - Title:《巧用移位运算符获取汉字编码值》
> - Author:Pleione_Plus
> - Started Date:August 12th.2019.
> - Finished Date:August 13th.2019.
> - Recommend link：[千千秀字](https://www.qqxiuzi.cn/daohang.htm)
>
> ---

# 背景

## 移位运算符

- 移位运算符在程序设计中，是**位操作运算符**的一种

- 移位运算符分为**左移位运算符**"<<"和**右移位运算符**">>"，形如：**X << N** 或 **X >> N**

- 在C#中**X**可以是：int、uint、long、ulong、byte、sbyte、short、ushort，其中**byte、sbyte、short、ushort**类型的值在进行移位操作后的类型将**自动转换成int类型**

- 其他类型数据的移位运算其本质还是对**二进制的移位运算**

- <span style="color:red">二进制每次向左移1位就相当于乘以2，每次向右移1位就相当于除以2</span>

- 举例如下：

  > 问题：
  >
  > - 3(O) << 2
  >
  > 计算过程：
  >
  > 1. 3(O)转换为二进制为:**0011**
  > 2. 二进制数值各个位整体左移两位（<span style="color:red">左端溢出丢弃，右端补"0"</span>）后得到：**1100**
  > 3. 再将移位后的二进制数值转换为十进制数值为：12(O)
  > 4. 也即：<span style="color:red">3 << 2 = 12</span>

## 汉字编码

​		汉字编码(Chinese character encoding)是为汉字设计的一种便于输入计算机的代码。

### 编码分类

​		计算机中汉字的表示也是用二进制，根据**应用目的**的不同，汉字编码分为**外码**、**交换码**、**机内码**和**字形码**。

#### 外码(输入码)

​		外码也叫输入码，是用来将汉字输入到计算机中的一组键盘符号。常用的输入码有拼音码、五笔字型码、区位码、电报码等

**特点**：

- 编码规则简单
- 易学好记
- 操作方便
- 重码率低
- 输入速度快

#### 交换码(国际码)

​		计算机内部处理的信息都是**二进制代码**表示的，汉字也不例外。而二进制代码使用起来很不方便，于是需要采用**信息交换码**。GB2312即为国际码。

- **GB2312编码**：1981年5月1日发布的简体中文汉字编码国家标准。GB2312对汉字采用双字节编码，收录7445个图形字符，其中包括6763个汉字。
- **BIG5编码**：台湾地区繁体中文标准字符集，采用双字节编码，共收录13053个中文字，1984年实施。
- **GBK编码**：1995年12月发布的汉字编码国家标准，是对GB2312编码的扩充，对汉字采用双字节编码。GBK字符集共收录21003个汉字，包含国家标准GB13000-1中的全部中日韩汉字，和BIG5编码中的所有汉字。
- **GB18030编码**：2000年3月17日发布的汉字编码国家标准，是对GBK编码的扩充，覆盖中文、日文、朝鲜语和中国少数民族文字，其中收录27484个汉字。GB18030字符集采用单字节、双字节和四字节三种方式对字符编码。兼容GBK和GB2312字符集。
- **Unicode编码**：国际标准字符集，它将世界各种语言的每个字符定义一个唯一的编码，以满足跨语言、跨平台的文本信息转换。

#### 机内码

​		根据国际码的规定，每个汉字都有确定的**二进制代码**，在微机内部汉字代码都用机内码，在键盘上记录汉字代码也使用机内码。

#### 字形码

​		字形码是汉字的**输出码**，输出汉字时都采用**图形方式**，无论汉字的笔画多少，每个汉字都可以卸载同样大小的**方块**中。通常用16×16点阵来显示汉字。

#### 地址码

​		汉字地址码是指汉字库中存**储汉字字形信息的逻辑地址码**。它与汉字机内码有着简单的对应关系，以简单内码到地址码的转换。

### 汉字编码之间的关系

![汉字编码之间的关系](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\巧用移位运算符获取汉字编码值/汉字编码之间的关系.png)

# 操作环境

**编程环境**：

- VS2017
- .Net Framework 4.5

**运行环境**：

- Win10

# 设计实现

**界面设计**:

![界面](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\巧用移位运算符获取汉字编码值/界面.png)

**代码设计**:

```c#
using System;
using System.Text;
using System.Windows.Forms;

namespace GetCode
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void btn_Get_Click(object sender, EventArgs e)
        {
            try
            {
                //获得一个汉字字符
                char ch = txt_ch.Text[0];
                //使用gb2312编码方式获得字节序列
                byte[] gb2312_bt = Encoding.GetEncoding("gb2312").GetBytes(new Char[] { ch });
                //将字节序列的第一个字节向左移8位
                int n = (int)gb2312_bt[0] << 8;
                
                //第一个字节移8位后与第二个字节相加得到汉字编码
                n += (int)gb2312_bt[1];
                //显示汉字编码(十六进制)
                txt_Num.Text = Convert.ToString(n, 16);
            }
            catch (Exception)
            {
                //异常提示信息
                MessageBox.Show("请输入汉字字符！", "出现错误！");
            }
        }
    }
}

```



# 实现结果

![结果](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\巧用移位运算符获取汉字编码值/结果.png)

## 原理解析

- char ch = txt_ch.Text[0];<font color="blue">//ch变量存储“位”的Unicode编码</font>>
- byte[] gb2312_bt = Encoding.GetEncoding("gb2312").GetBytes(new Char[] { ch });<font color="blue">//gb2312_bt变量数组中存储由ch编码得到的GB2312字节</font>
- int n = (int)gb2312_bt[0] << 8;<font color="blue"> //将字节左移八位(一个字节)</font>
- n += (int)gb2312_bt[1];<font color="blue">//两个数值相加得到“位”的GB2312编码(十进制)</font>
- txt_Num.Text = Convert.ToString(n, 16);<font color="blue">//编码转十六进制并显示</font>

# 附录

**参考链接**：

- [汉字编码(百度百科)](https://baike.baidu.com/item/汉字编码/7123465?fr=aladdin)
- [千千秀字(汉字字符集编码查询)](https://www.qqxiuzi.cn/bianma/zifuji.php)

**有关字体编码/查询/加解密网站推荐**：

[千千秀字](https://www.qqxiuzi.cn/daohang.htm)