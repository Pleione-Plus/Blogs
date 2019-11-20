> +++++++++++++++++++++++++++++++++++++++++
>
> +Title：【AssemblyInfo.cs】为程序设置版本和帮助信息
>
> +Author：Pleione_Plus
>
> +Finished Date：August 9th. 2019
>
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# 引入

&emsp;&emsp;当我们准备在**Windows系统**中安装一个软件时，会双击该软件的安装包，而我们把鼠标放在该安装包上时，通常会显示一个信息提示框，其中显示了一些该软件的**版本等信息**（如图1-1所示）。

![1](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\【AssemblyInfo.cs】为程序设置版本和帮助信息\1.png)

<center>图 1-1</center>
&emsp;&emsp;在我们编写自己软件时，通过怎样的操作也会实现相同的效果呐？下面通过对AssemblyInfo.cs文件的分析将给大家提供一种实现方式。

# 简介

&emsp;&emsp;当我们使用VS创建一个工程时，在【**Properties**】文件夹下会自动创建一个名为【**AssemblyInfo.cs**】的配置文件(如图 2-1所示)，不懂其原理的还是建议使用VS自动生成该文件，然后再在生成文件的基础上就行适当的修改。

![图 2-1](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\【AssemblyInfo.cs】为程序设置版本和帮助信息\2-1.png)

<p style="text-align:center">图 2-1</p>
# 作用

&emsp;&emsp;AssemblyInfo.cs配置文件主要是通过**特性**来设置生成的有关程序集的常规信息参数，如：程序集名称、描述、所属公司等。

# 解析

&emsp;&emsp;使用.Net Framework 4.6.1框架创建一个工程，生成的**AssemblyInfo.cs**文件如图4-1所示。

![图4-1](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\【AssemblyInfo.cs】为程序设置版本和帮助信息\4-1.png)

<p style="text-align:center">图 4-1</p>
&emsp;&emsp;下面来详细解释各个特性的意义：

```csharp
//设置程序集标题
[assembly: AssemblyTitle(".NET Pet Shop Model")]
//设置程序集描述信息
[assembly: AssemblyDescription(".NET Pet Shop Middle-Tier Components")]
//设置配置文件，如零售、发布、调试等信息。程序集在运行时不会使用该信息
[assembly: AssemblyConfiguration("")]
//设置公司名称信息
[assembly: AssemblyCompany("Microsoft Corporation")]
//设置软件名称
[assembly: AssemblyProduct(".NET Pet Shop 4.0")]
//设置版权信息
[assembly: AssemblyCopyright("Copyright ©2005 Microsoft Corporation")]
//设置合法商标信息
[assembly: AssemblyTrademark("")]
//指定程序集支持的区域性
[assembly: AssemblyCulture("")]

// 将 ComVisible 设置为 false 使此程序集中的类型
// 对 COM 组件不可见。如果需要从 COM 访问此程序集中的类型，
// 则将该类型上的 ComVisible 属性设置为 true。
[assembly: ComVisible(false)]

// 如果此项目向 COM 公开，则下列 GUID 用于类型库的 ID
[assembly: Guid("df3527a1-e499-48f6-ad7e-d95aaa3d4a9f")]

// 程序集的版本信息由下面四个值组成:
//
//      主版本
//      次版本 
//      内部版本号
//      修订号
//
// 可以指定所有这些值，也可以使用“内部版本号”和“修订号”的默认值，
// 方法是按如下所示使用“*”:
// [assembly: AssemblyVersion("1.0.*")]
[assembly: AssemblyVersion("4.0.0.0")]
[assembly: AssemblyFileVersion("4.0.0.0")]
```

&emsp;&emsp;显示效果如图4-2所示。

![图4-2](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\【AssemblyInfo.cs】为程序设置版本和帮助信息\4-2.png)

<p style="text-align:center">图 4-2</p>
&emsp;&emsp;此外，在VS中除了直接修改**AssemblyInfo.cs**文件来实现之外，还可以使用图形操作界面的形式来设置程序集的常规信息。

1. **右击**项目，选择**属性**，进入【**应用程序**】界面，如图4-3所示。

   ![应用程序界面](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\【AssemblyInfo.cs】为程序设置版本和帮助信息\4-3.png)

2. **点击**【程序集信息(I)】按钮，进入【**程序集信息**】界面，如图4-4所示。

   ![程序集信息界面](../../../../MarkdownImgs\程序设计\编程基础\Case-C#\【AssemblyInfo.cs】为程序设置版本和帮助信息\4-4.png)