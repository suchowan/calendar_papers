# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2023 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in https://github.com/suchowan/when_exe.
=end

if self.class.const_defined?(:Encoding)
  Encoding.default_external = 'UTF-8'
  Encoding.default_internal = 'UTF-8'
end

require 'pp'
require 'when_exe'
require 'when_exe/core/extension'
include When
=begin

紀元節および歴代天皇崩御日の太陽暦日、六十干支、ユリウス通日の確認

解説:
　2023-04-01 「市川斎宮の改暦案の紹介」(スクリプト)
　https://suchowan.seesaa.net/article/202304article_1.html

典拠:
　明治6年太政官布告第258号「御祭日及御祝日等日付」
　　http://dl.ndl.go.jp/info:ndljp/pid/787953/265
　明治6年太政官布告第344号「年中祭日祝日等ノ休暇日左ノ通候條此旨布告候事」
　　http://dl.ndl.go.jp/info:ndljp/pid/787953/335

=end

era = CalendarEra('Japanese')
eto = Residue('干支')

list = %w(
  1867-01-30_孝明   -659-02-11_紀元節 -584-04-03_神武     1324-07-24_後宇多 
  0070-07-26_垂仁   1156-07-27_鳥羽   0190-07-29_成務     1011-07-31_一条   
  1129-07-31_白河   1380-08-03_光明   0824-08-09_平城     1424-08-11_後亀山 
  1364-08-13_光厳   1107-08-16_堀河   0672-08-24_弘文     1304-08-25_後深草 
  0661-08-27_斉明   0842-08-28_嵯峨   1155-08-29_近衛     1176-08-30_六条   
  -392-08-31_孝昭   1762-08-31_桃園   0770-09-01_孝謙     1234-09-07_後堀河 
  0931-09-08_宇多   1428-09-09_称光   0479-09-09_雄略     0498-09-10_仁賢   
  0952-09-11_朱雀   1680-09-11_後水尾 1165-09-12_二条     0585-09-16_敏達   
  1308-09-18_後二条 0887-09-21_光孝   1164-09-21_崇徳     1732-09-24_霊元   
  0456-09-25_安康   1617-09-25_後陽成 1339-09-27_後醍醐   -476-10-01_懿徳   
  0686-10-04_天武   1557-10-07_後奈良 -157-10-11_孝元     0858-10-11_文徳   
  1305-10-12_亀山   1242-10-14_順徳   1317-10-16_伏見     0930-10-21_醍醐   
  0949-10-28_陽成   1654-10-30_後光明 1500-10-31_後土御門 1852-11-03_天長節 
  1231-11-13_土御門 0765-11-14_淳仁   0641-11-20_舒明     0654-11-27_孝徳   
  1011-11-27_冷泉   1696-12-04_明正   1779-12-06_後桃園   1348-12-10_花園   
  1433-12-10_後小松 1840-12-12_光格   0592-12-14_崇峻     0130-12-23_景行   
  1813-12-24_後桜町
).map {|item|
  date, name = item.split('_')
  name += '天皇祭' unless name =~ /節/
  gdate = when?(date)
  [gdate, Julian ^ gdate, eto[(gdate.to_i-11) % 60].to_s, gdate.to_i, name]
}

pp list.sort_by {|name, date| date} #=>
# [[-00659-02-11, -00659-02-18, "庚辰(16)", 1480407, "紀元節"],
#  [-00584-04-03, -00584-04-09, "甲辰(40)", 1507851, "神武天皇祭"],
# …
#  [1500-10-31, 1500-10-21, "庚辰(16)", 2269227, "後土御門天皇祭"],
# …
#  [1696-12-04, 1696-11-24, "癸亥(59)", 2340850, "明正天皇祭"],

puts
[0, 660].each do |shift|
  centuries = Hash.new {|h,k| h[k]=[]}
  list.each do |date|
    gdate = date.first
    year = gdate.year + shift
    year -= 1 if gdate.month <= 2
    century = year.divmod(100).first
    centuries[century+1] << date
  end
  centuries.keys.sort.each do |century|
    pp [shift, century, centuries[century].size] #=>
# [0, 5, 3]
#…
#[0, 19, 4]
#…
#…
#[660, 12, 3]
#…
#[660, 26, 3]
  end
end
