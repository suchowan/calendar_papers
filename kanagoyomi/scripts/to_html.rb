# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2014-2020 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in https://github.com/suchowan/when_exe.
=end

require 'pp'
require 'when_exe'

Encoding.default_external = 'UTF-8'
Encoding.default_internal = 'UTF-8'

HEADER =<<HEADER
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8" />
<title>仮名暦</title>
<style type="text/css">
<!--
.vertical {
  writing-mode: tb-rl;
  direction: ltr;
}
-->
</style>
</head>
<body>
<div class="vertical">
<table border=1>
HEADER

FOOTER =<<FOOTER
</table>
</div>
</body>
</html>
FOOTER

Formats = 
{["版元", 3]=>
  ["<tr><td_colspan=2_align=center><big><b>%s</b></big></td><td_colspan=4><big><b>%s</b></big></td><td_colspan=2>%s</td></tr>"],
 ["前書", 1]=>["<tr><td_colspan=8><big><b>%s</b></big></td></tr>"],
 ["暦首", 1]=>["<tr><td_colspan=8><big><b>%s</b></big></td></tr>"],
 ["大歳", 2]=>
  ["<tr><td_colspan=3><big><b>%s</b></big></td><td_colspan=2>%s</td></tr>"],
 ["大將軍", 2]=>
  ["<tr><td_colspan=3><big><b>%s</b></big></td><td_colspan=2>%s</td></tr>"],
 ["大陰", 2]=>
  ["<tr><td_colspan=3><big><b>%s</b></big></td><td_colspan=2>%s</td></tr>"],
 ["歳徳", 5]=>
  ["<tr><td>%s</td><td_colspan=3><big><b>%s</b></big></td><td>%s<big><b>%s</b></big>%s</td></tr>"],
 ["歳刑", 5]=>
  ["<tr><td_colspan=3><big><b>%s</b></big></td><td_colspan=2>%s</td><td><big><b>%s</b></big></td><td>%s</td><td>%s</td></tr>"],
 ["歳破", 5]=>
  ["<tr><td_colspan=3><big><b>%s</b></big></td><td_colspan=2>%s</td><td><big><b>%s</b></big></td><td><big><b>%s</b></big></td><td><big><b>%s</b></big></td></tr>"],
 ["歳煞", 5]=>
  ["<tr><td_colspan=3><big><b>%s</b></big></td><td_colspan=2>%s</td><td><big><b>%s</b></big></td><td><big><b>%s</b></big></td><td><big><b>%s</b></big></td></tr>"],
 ["黄幡", 5]=>
  ["<tr><td_colspan=3><big><b>%s</b></big></td><td_colspan=2>%s</td><td><big><b>%s</b></big></td><td><big><b>%s</b></big></td><td><big><b>%s</b></big></td></tr>"],
 ["豹尾", 5]=>
  ["<tr><td_colspan=3><big><b>%s</b></big></td><td_colspan=2>%s</td><td><big><b>%s</b></big></td><td><big><b>%s</b></big></td><td><big><b>%s</b></big></td></tr>"],
 ["月序", 5]=>
  ["<tr><td_align=center><big><b>%s</b></big></td><td_align=center><big><b>%s</b></big></td><td_align=right><big><b>%s</b></big></td><td_colspan=2_align=center><big><b>%s</b></big></td><td_colspan=3><big><b>%s</b></big></td></tr>"],
 ["正月", 6]=>
  ["<tr><td><big><b>%s</b></big></td><td><big><b>%s</b></big></td><td><big><b>%s</b></big></td><td><big><b>%s</b></big></td><td>%s</td><td_colspan=3>%s</td></tr>"],
 ["暦日1", 6]=>
  ["<tr><td>%s／</td><td>%s</td><td>%s</td><td><big><b>%s</b></big></td><td>%s</td><td_colspan=3>%s</td></tr>"],
 ["暦日2", 6]=>
  ["<tr><td>%s／</td><td>%s</td><td>%s</td><td_valign='center'_rowspan=2><big><b>%s</b></big></td><td>%s</td><td_colspan=3>%s</td></tr>"],
 ["暦日0", 5]=>
  ["<tr><td>%s／</td><td>%s</td><td>%s</td><td>%s</td><td_colspan=3>%s</td></tr>"],
 ["暦日1", 5]=>
  ["<tr><td>%s／</td><td>%s</td><td>%s</td><td><big><b>%s</b></big></td><td>%s</td><td_colspan=3></td></tr>"],
 ["食記", 1]=>
  ["<tr><td_colspan=4_align='center'><big><b>%s</b></big></td><td_colspan=4></td></tr>"],
 ["暦日0", 4]=>
  ["<tr><td>%s／</td><td>%s</td><td>%s</td><td>%s</td><td_colspan=3></td></tr>"],
 ["暦日2", 5]=>
  ["<tr><td>%s／</td><td>%s</td><td>%s</td><td_valign='center'_rowspan=2><big><b>%s</b></big></td><td>%s</td><td_colspan=3></td></tr>"],
 ["暦末", 2]=>
  ["<tr><td_colspan=4_align=center><big><b>%s</b></big></td><td_colspan=4_align=center><big><b>%s</b></big></td></tr>"],
 ["三日", 6]=>
  ["<tr><td><big><b>%s</b></big></td><td><big><b>%s</b></big></td><td><big><b>%s</b></big></td><td><big><b>%s</b></big></td><td>%s</td><td_colspan=3><big><b>%s</b></big></td></tr>"],
 ["月序", 3]=>
  ["<tr><td_align=center><big><b>%s</b></big></td><td_align=center><big><b>%s</b></big></td><td_colspan=4_align=center><big><b></b></big></td><td_colspan=2><big><b>%s</b></big></td></tr>"],
 ["暦首", 3]=>
  ["<tr><td_colspan=5><big><b>%s</b></big></td><td>%s</td><td_colspan=2><big><b>%s</b></big></td></tr>"],
 ["月序", 4]=>
  ["<tr><td_align=center><big><b>%s</b></big></td><td_align=center><big><b>%s</b></big></td><td_colspan=4_align=center><big><b>%s</b></big></td><td_colspan=2><big><b>%s</b></big></td></tr>"],
 ["三日", 5]=>
  ["<tr><td><big><b>%s</b></big></td><td><big><b>%s</b></big></td><td><big><b>%s</b></big></td><td><big><b>%s</b></big></td><td>%s</td><td_colspan=3><big><b></b></big></td></tr>"],
 ["前書", 17]=>
  ["<tr><td_colspan=8><big><b><ul><li>%s、%s、%s、%s、%s、%s、%s、%s、%s、%s。%s、%s、%s</li></ul>%s<ruby><rb>%s</rb><rt>（%s）</rt></ruby><div_align='right'>%s</div></b></big></td></tr>"],
 ["節中", 4]=>
  ["<tr><td_colspan=5_align=right><big><b>%s</b></big></td><td>%s</td><td><big><b>%s</b></big></td><td>%s</td></tr>"],
 ["食記", 2]=>
  ["<tr><td_colspan=4_align='center'><big><b>%s</b></big></td><td_colspan=4>%s</td></tr>"],
 ["前書", 4]=>
  ["<tr><td_colspan=8><big><b>%s、%s、%s<div_align='right'>%s</div></b></big></td></tr>"],
 ["前書", 7]=>
  ["<tr><td_colspan=8><big><b>%s<ul><li>%s</li><li>%s</li><li>%s</li></ul><div_align='right'>%s<ruby><rb>%s</rb><rt>%s</rt></ruby></div></b></big></td></tr>"],
 ["前書", 2]=>
  ["<tr><td_colspan=8><big><b>%s<div_align='right'>%s</div></b></big></td></tr>"],
 ["豹尾", 4]=>
  ["<tr><td_colspan=3><big><b>%s</b></big></td><td_colspan=2>%s</td><td><big><b>%s</b></big></td><td><big><b>%s</b></big></td><td><big><b></b></big></td></tr>"]}

Dir.glob("#{When::Parts::Resource.root_dir}/data/kanagoyomi/csv/*") do |path|
  open(path, 'r') do |csv|
    open(path.gsub('csv','html'), 'w') do |html|
      html.puts HEADER
      while (line=csv.gets)
        type, *parts = line.chomp.split(',')
        format = Formats[[type, parts.size]]
        if format
          html.puts format.first.gsub('_',' ') % (parts.map {|part| part.gsub('/','<br/>')})
        elsif line !~ /^#/
          STDERR.puts "#{path} : #{line.chomp}"
        end
      end
      html.puts FOOTER
    end
  end
end
