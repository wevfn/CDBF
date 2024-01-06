CDBF.ini		需要备份的文件或目录，一行一项。文件需包含扩展名

C:\aaa
C:\aaa\file.obj

CDBF_NO.ini 	排除包含指定名称的文件或文件夹，一行一项。可自由组合

aaa\obj\		排除所有备份目录中目录格式带aaa\obj\的obj文件夹 
.obj		排除所有备份目录中扩展名为.obj的文件
file.obj		排除所有备份目录中名为file.obj的文件
file.*		忽略扩展名排除所有备份目录中名为file的文件
C:\aaa		排除指定文件夹
C:\aaa\file.*	忽略扩展名排除指定文件夹中名为file的文件

START.vbs	手动创建备份

CDBFT.cmd	创建/设置默认自动备份计划，可在任务计划程序中自定义备份计划CDBFTasks。默认A为备份到本地，B为本机手动唤醒SMB主机时备份到指定SMB主机

编辑CDBFT.cmd可设置备份保存路径、备份保留份数、UserData最
