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

urls = {}

OpenURI
path = "https://github.com/suchowan/when_exe/raw/master/test/events/ndl_koyomi.csv"
open(path, 'r', {:ssl_verify_mode=>OpenSSL::SSL::VERIFY_NONE}) do |csv|
  csv.read.each_line do |line|
    year, url, comment = line.chomp.split(',', 3)
    urls[year] = url.strip.sub('..', ' ～ ')
  end
end

formats = Hash.new {|h,k| h[k]=[]}

Dir.glob("#{When::Parts::Resource.root_dir}/data/kanagoyomi/null/*") do |path|
  open(path, 'r') do |null|
    open(path.sub('null','csv')+'.csv', 'w') do |csv|
      path =~ /(\d+)$/
      STDERR.puts "“#{$1}” undefined" unless urls[$1]
      csv.puts "# カンマ区切りテキスト形式です。"
      csv.puts "# ・表の区画内での改行は“/”で表記します。"
      csv.puts "# ・先頭カラム(“暦首,”など)は表成型に用いますので削除しないでください。"
      csv.puts "# ・カンマ“,”を追加・削除すると、その行が表成型できない場合があります。"
      csv.puts "# 外部リンク"
      csv.puts "# ・国会図書館 : https://dl.ndl.go.jp/info:ndljp/pid/#{urls[$1]}"
      csv.puts "# ・hosi.org　 : http://hosi.org:3000/Note/#{$1}g"
      while (line=null.gets)
        line.gsub!(/FULL_MONTH|HALF_MONTH|DIRECTION_MAP|BLANK_FIELD/,'')
        line.gsub!(/<\/?small>/,'')
        line.gsub!(/<br\/>/,';')
        line.gsub!(/&nbsp;/,'　')
        next unless line =~ /^<(...?)\/>(.+)$/
        type = $1
        body = $2.gsub!(/<.+?>/) do |tag|
          tag.gsub(' ', '_')
        end
        parts = []
        format = body.gsub(/(?:\p{Hiragana}|\p{Katakana}|[ー－●○□]|[一-龠々〱]|[　 ;\|\(\)\[\]])+/) do |part|
          parts << part
          '%s'
        end
        formats[[type, parts.size]] << format
        formats[[type, parts.size]].uniq!
        STDERR.puts body unless body == format % parts
        parts.each do |part|
          part.gsub!(/\|[^<]*\z/) {|note|
            case note
            when /\A\|[ \|]*\z/      ; ''
            when /\A\|(.+?)[ \|]*\z/ ; $1.gsub('|','') + 'よし'
            else                     ; note
            end
          }
        end
        csv.puts ([type] + parts).join(',').gsub(';','/')
      end
    end
  end
end

formats.each_pair do |k,v|
  pp [k,v] unless v.size == 1
end

pp formats
