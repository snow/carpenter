Carpenter
=========
抓取国家统计局网站[最新县及县以上行政区划代码]然后转换成yaml

Usage
------
```shell
git clone https://github.com/snow/carpenter.git
cd carpenter
bundle install
bundle exec ./fetch_from_stats_gov_cn.rb
cat cache.yaml
```

Legacy
=======
已经不工作了! 个别地区增加了复杂的嵌套结构，因为懒，放弃这个数据源了。

从中文维基的 [中华人民共和国县级以上行政区列表](http://zh.wikipedia.org/wiki/%E4%B8%AD%E5%8D%8E%E4%BA%BA%E6%B0%91%E5%85%B1%E5%92%8C%E5%9B%BD%E5%8E%BF%E7%BA%A7%E4%BB%A5%E4%B8%8A%E8%A1%8C%E6%94%BF%E5%8C%BA%E5%88%97%E8%A1%A8) 词条抓取全国省市清单，并生成yaml

Usage
-----
```shell
git clone https://github.com/snow/carpenter.git
cd carpenter
bundle install
bundel exec ruby app.rb
```

然后访问 [http://localhost:4567](http://localhost:4567)，并设法确保你的机器能访问中文维基。
