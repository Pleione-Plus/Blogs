---
H3C-Telnet
---

# 原理概述

​		Telnet（Telecommunication Network Protocol）起源于ARPANET，是最早的Internet应用之一。

​		Telnet通常用在远程登录应用中，以便对本地或远端运行的网络设备进行配置、监控和维护。如网络中有多台设备需要配置和管理，用户无需为每一台设备都连接一个用户终端进行配置，可以通过Telnet方式在一台设备上对多台设备及逆行管理或配置。如果网络中需要管理或配置的设备不在本地时，也可以通过Telnet方式实现对网络中设备的远程维护，极大地提高了用户操作的灵活性。

# 实验目的

- 掌握基本系统操作命令的使用
- 使用Telnet终端登录设备

# 实验内容

​		RTB路由器模拟员工主机，去TelnetRTA路由器。

# 实验拓扑

![H3C_Telnet_topology](../../../MarkdownImgs/网络配置/H3C\H3C-Telnet\H3C-Telnet-topology.png)

# 实验编址

| 设备 | 接口 |   IP地址    |   子网掩码    |  默认网关   |
| :--: | :--: | :---------: | :-----------: | :---------: |
| RTA  | g0/0 | 192.168.0.1 | 255.255.255.0 | 192.168.0.2 |
| RTB  | g0/0 | 192.168.0.2 | 255.255.255.0 | 192.168.0.1 |

# 实验步骤

## 基本配置 ##

### 配置RTA路由器的IP地址

![H3C-Telnet-TRA-IP](../../../MarkdownImgs/网络配置/H3C\H3C-Telnet\H3C-Telnet-TRA-IP.PNG)

命令脚本：

```sql
system-view
int g0/0
ip add 192.168.0.1 24
quit
sysname RTA
```

### 配置RTB路由器的IP地址

![H3C-Telnet-TRB-IP](../../../MarkdownImgs/网络配置/H3C\H3C-Telnet\H3C-Telnet-TRB-IP.PNG)

命令脚本：

```sql
system-view
sysname RTB
int g0/0
ip add 192.168.0.2 24
```

### 测试RTA与RTB的连通性

![H3C-Telnet-RTA-ping-RTB](../../../MarkdownImgs/网络配置/H3C\H3C-Telnet\H3C-Telnet-RTA-ping-RTB.PNG)

## 配置Telnet

![H3C-Telnet-Tel配置命令](../../../MarkdownImgs/网络配置/H3C\H3C-Telnet\H3C-Telnet-Tel配置命令.PNG)

命令脚本：

```sql
telnet server enable
local-user demo class manage
password simple demo
service-type telnet
authorization-attribute user-role network-admin
quit
line vty 0 4
authentication-mode scheme
quit
```

## 结果测试

![H3C-Telnet-RTB-Telnet-RTA](../../../MarkdownImgs/网络配置/H3C\H3C-Telnet\H3C-Telnet-RTB-Telnet-RTA.PNG)

# 附录

## 完整命令脚本(带注释版)：

RTA命令脚本：

```sql
--从用户视图进入系统视图
system-view
--从系统视图进入接口视图
int g0/0
--为g0/0端口配置IP地址
ip add 192.168.0.1 24
--从接口视图返回到系统视图
quit
--将路由器的名称修改为RTA
sysname RTA
--开启路由器的telnet服务
telnet server enable
--添加一个本地用户，并指定该用户所属类
local-user demo class manage
--设置用户的密码(明文显示)
password simple demo
--设置所属用户的服务类型
service-type telnet
--将该用户设置为网络的超级管理员
authorization-attribute user-role network-admin
--退出到系统视图
quit
--设置vty端口
line vty 0 4
--设置认证模式为组合模式(用户名+密码)
authentication-mode scheme
--退出到系统视图
quit
```

RTB命令脚本：

```sql
--从用户视图进入系统视图
system-view
--将路由的名称修改为RTB
sysname RTB
--从系统视图进入接口视图
int g0/0
--设置端口的IP地址
ip add 192.168.0.2 24
--直接退到用户模式
end

--Telnet测试
telnet 192.168.0.1
```



## 完整命令脚本(无注释，可直接粘贴)：

RTA命令脚本：

```sql
system-view
int g0/0
ip add 192.168.0.1 24
quit
sysname RTA
telnet server enable
local-user demo class manage
password simple demo
service-type telnet
authorization-attribute user-role network-admin
quit
line vty 0 4
authentication-mode scheme
quit
```

RTB命令脚本：

```sql
system-view
sysname RTB
int g0/0
ip add 192.168.0.2 24
end

telnet 192.168.0.1
```