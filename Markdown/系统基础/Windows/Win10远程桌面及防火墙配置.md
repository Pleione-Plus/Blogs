> +++++++++++++++++++++++++++++++++++++++++++++++++
>
> +Title:《Win10远程桌面及防火墙配置》
>
> +Author:Pleione_Plus
>
> +Finished Date：August 10th. 2019.
>
> +Reference Linking：https://www.htcp.net/4730.html
>
> +++++++++++++++++++++++++++++++++++++++++++++++++

# 远程桌面

&emsp;&emsp;当计算机开启了**远程桌面**连接后，可以通过另一台计算机中的**远程桌面客户端程序**连接到该计算机，在计算机上进行实时操作，如：安装程序、执行程序等。远程桌面抛开了地域的限制，使用户操作远端计算机犹如操作当前计算机一般。

# 操作环境

- Windows 10专业版
- 系统自带的**远程桌面**

ps:

- Windows 10操作系统中家庭版仅能作**客户端**，而专业版和企业版**既可以作客户端又可以作服务端**。
- 不使用**TeamViewer**的原因是：TeamViewer需要两台计算机都连接到Internet上，而我现在要实现的是，内网中的两台计算机可以实现远程桌面访问。

# 操作目的

&emsp;&emsp;实现内网中的两台计算机可以通过远程桌面访问。

# 操作步骤

&emsp;&emsp;Windows 10专业版默认是禁掉远程桌面服务端的功能，使用远程桌面时，需要先开启。远程桌面默认使用的是**3389**端口，但开启远程桌面时，不建议采用此端口，应修改成另一个不常用的端口，此时也要在Windows Defender 防火墙中对新设置的端口进行**规则设置**（*有的教程中，在开启远程桌面时，为了连接顺畅直接把防火墙给关了......建议还是不要采取这样的操作*）。下面将从**开启远程桌面**、**修改远程桌面端口**、**修改防火墙配置**、**远程桌面连接**这四个方面来叙述。

## 开启远程桌面

&emsp;&emsp;Win10中有两种常用方式可以开启远程桌面。

### 方式一：通用型

&emsp;&emsp;此方式适用于绝大多数Windows版本系统。

1. 右键【**此电脑**】选择【**属性**】，在**系统**界面中**点击**【**远程设置**】，如图1所示。

   ![图1](../../../MarkdownImgs\系统基础\Windows/Win10远程桌面及防火墙配置/图1.png)

   <center>图 1</center>

2. 在**远程属性界面**中的**远程桌面**中，**选中**【允许远程连接到计算机】选项，然后**点击**【**应用**】按钮，如图2所示。

   ![图2](../../../MarkdownImgs\系统基础\Windows/Win10远程桌面及防火墙配置/图2.png)

   <center>图 2</center>

3. **点击**【**选择用户**】按钮，进入**远程桌面用户**界面（系统默认仅当前管理员有远程访问权限，如需添加其他用户需继续执行下一步操作），如图3所示。

   ![图3](../../../MarkdownImgs\系统基础\Windows/Win10远程桌面及防火墙配置/图3.png)

   <center>图 3</center>

4. **点击**【**添加**】按钮，进入**选择用户界面**，在输入框中键入用户名后，**点击**【**确认**】按钮即可，如图4所示。

   ![图4](../../../MarkdownImgs\系统基础\Windows/Win10远程桌面及防火墙配置/图4.png)

   <center>图 4</center>

### 方式二：Modern界面

&emsp;&emsp;Win10采用Modern设置风格，并且将一些常用的设置选项都集成到了【**设置界面**】。

1. 【Win+I】打开【**设置界面**】，点击【**系统**】 -> 【**远程桌面**】，如图5所示。

   ![图5](../../../MarkdownImgs\系统基础\Windows/Win10远程桌面及防火墙配置/图5.png)

   <center>图 5</center>

2. 将**启用远程桌面**设置为**开**，如图6所示。

   ![图6](../../../MarkdownImgs\系统基础\Windows/Win10远程桌面及防火墙配置/图6.png)

   <center>图 6</center>

ps：

- 上述操作与***方式一***中的前两步操作达到相同的效果。
- 该方式仅允许当前管理员进行远程访问操作。
- 设置接通电源时计算机从不睡眠，否则只会在某段时间内才能正常连接。

## 修改远程桌面默认端口

1. 【Win+R】打开【运行】，键入**regedit**，打开**注册表编辑器界面**，如图7所示。

   ![图7](../../../MarkdownImgs\系统基础\Windows/Win10远程桌面及防火墙配置/图7.png)

   <center>图 7</center>

2. 修改**PortNumber**参数

   - 找到如下位置：<span style="color:red;">HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\Wds\rdpwd\Tds\tcp</span>

     在右侧找到**PortNumber**并将其修改为**6700**，如图8所示。

     ![图8](../../../MarkdownImgs\系统基础\Windows/Win10远程桌面及防火墙配置/图8.png)

     <center>图 8</center>

   - 找到如下位置：

     <span style="color:red">HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp</span>

     在右侧找到**PortNumber**并将其修改为**6700**，如图9所示。

     ![图9](../../../MarkdownImgs\系统基础\Windows/Win10远程桌面及防火墙配置/图9.png)

     <center>图 9</center>

3. 关闭注册表。

## 修改防火墙配置

1. 【Win+R】打开【运行】，键入**control**,打开**控制面板**。找到**Windows Defender 防火墙**并打开，如图10所示。

   ![图10](../../../MarkdownImgs\系统基础\Windows/Win10远程桌面及防火墙配置/图10.png)

   <center>图 10</center>

2. **点击**【**高级设置**】，打开**高级安全Windows Defender 防火墙界面**，如图11所示。

   ![图11](../../../MarkdownImgs\系统基础\Windows/Win10远程桌面及防火墙配置/图11.png)

   <center>图 11</center>

3. **点击**左侧【**入站规则**】后，点击【**新建规则**】，如图12所示。

   ![图12](../../../MarkdownImgs\系统基础\Windows/Win10远程桌面及防火墙配置/图12.png)

   <center>图 12</center>

4. 在**新建入站规则向导界面**的规则类型中选择**端口**选项，并单击【**下一步**】按钮，如图13所示。

   ![图13](../../../MarkdownImgs\系统基础\Windows/Win10远程桌面及防火墙配置/图13.png)

   <center>图 13</center>

5. 在**协议和端口界面**选择**TCP**选项（入栈需要创建两条规则一个是TCP一个是UDP，所以还需要按此例创建一个UDP的），选中**特定本地端口**，并键入端口值：**6700**，并**单击**【**下一步**】按钮，如图14所示。

   ![图14](../../../MarkdownImgs\系统基础\Windows/Win10远程桌面及防火墙配置/图14.png)

   <center>图 14</center>

6. 在**操作界面**中选择**允许连接**选项，如图15所示。

   ![图15](../../../MarkdownImgs\系统基础\Windows/Win10远程桌面及防火墙配置/图15.png)

   <center>图 15</center>

7. **配置文件界面**规则采用默认即可，**单击**【**下一步**】，如图16所示。

   ![图16](../../../MarkdownImgs\系统基础\Windows/Win10远程桌面及防火墙配置/图16.png)

   <center>图 16</center>

8. 在**名称界面**键入名称值，可随意设置只要自己懂什么意思就OK，如图17所示。

   ![图17](../../../MarkdownImgs\系统基础\Windows/Win10远程桌面及防火墙配置/图17.png)

   <center>图 17</center>

9. 按上述相同步骤再新增一条**UDP规则**。

10. 设置完毕后，关闭**高级安全Windows Defender 防火墙界面**。

11. <span style="color:red">所有设置完成之后需要重启电脑</span>

## 远程桌面连接

1. 【Win+R】打开【运行】，键入**mstsc**，打开**远程桌面界面客户端**，如图18所示。

   ![图18](../../../MarkdownImgs\系统基础\Windows/Win10远程桌面及防火墙配置/图18.png)

   <center>图 18</center>

2. 键入计算机IP地址，记得要加上端口号(如：<span style="color:red">192.168.11.111:6700</span>，不加的话，默认是使用**3389**进行连接)，如图19所示。

   ![图19](../../../MarkdownImgs\系统基础\Windows/Win10远程桌面及防火墙配置/图19.png)

   <center>图 19</center>

3. 成功后会要求用户键入**密码**，确认**连接凭证**即可登录。