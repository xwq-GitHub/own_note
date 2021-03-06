## python调用shell脚本

python调用Shell脚本，有两种方法：os.system(cmd)或os.popen(cmd),前者返回值是脚本的退出状态码，后者的返回值是脚本执行过程中的输出内容。实际使用时视需求情况而选择。 

现假定有一个shell脚本test.sh 

```shell

  #!/bin/bash
  echo "hello world!" 
  exit 3
```
> os.system(cmd):

该方法在调用完shell脚本后，返回一个16位的二进制数，低位为杀死所调用脚本的信号号码，高位为脚本的退出状态码，即脚本中“exit 1”的代码执行后，os.system函数返回值的高位数则是1，如果低位数是0的情况下，则函数的返回值是0×100,换算为10进制得到256。

如果我们需要获得os.system的正确返回值，那使用位移运算可以还原返回值
```python
>>> n = os.system(test.sh) 
>>> n >> 8 
>>> 3
```
> os.popen(cmd):

这种调用方式是通过管道的方式来实现，函数返回一个file-like的对象，里面的内容是脚本输出的内容（可简单理解为echo输出的内容）。使用os.popen调用test.sh的情况 
```python
>>> file = os.popen(test.sh) 
>>> file.read() 
>>> ‘hello world!\n’
```

明显地，像调用"ls"这样的shell命令，应该使用popen的方法来获得内容。