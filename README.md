### 开发

克隆代码
```
git clone https://github.com/ruchee/t309.git
```

切换到工程目录
```
cd t309
```

安装依赖
```
bundle install
```

创建数据库
```
bundle exec rake db:create
```

初始化数据表
```
bundle exec rake db:migrate
```

运行测试
```
bundle exec rake test
```

启动服务器
```
bundle exec puma -C config/puma.rb
```

数据库配置文件地址：`config/database.yml`

为缩减服务器部署的耗时，项目用到的全部 `gem` 包都保存在 `vendor/cache` 目录下，可通过命令 `bundle package --all` 来更新

----

### 部署

切换到工程目录
```
cd t309
```

构建镜像
```
docker-compose build
```

启动服务
```
docker-compose up -d
```

创建数据库（可能会提示 `postgres already exists`，忽视即可）
```
docker-compose run web rake db:create
```

初始化数据表
```
docker-compose run web rake db:migrate
```

测试接口访问是否正常（如果是用的 `boot2docker`，则使用 `boot2docker ip` 输出的 `IP` 地址替换 `localhost`）
```
curl http://localhost:3000/categories
```
显示 `{"code":0,"msg":"ok","data":[]}` 为正常

如需修改数据库密码，请编辑 `docker-compose.yml` 和 `config/database.yml` 两文件

----

### 说明

出于开发惯例和开发的便利性，接口并未和 `api.raml` 设计稿完全一致，具体可查看 `test/integration` 下的测试用例
