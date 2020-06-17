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

formats = Hash.new {|h,k| h[k]=[]}

Dir.glob("#{When::Parts::Resource.root_dir}/data/kanagoyomi/null/*") do |path|
  open(path, 'r') do |null|
    open(path.sub('null','csv')+'.csv', 'w') do |csv|
      csv.puts "# カンマ区切りテキスト形式です。"
      csv.puts "# ・先頭カラム(“暦首,”など)は表成型に用いますので削除しないでください。"
      csv.puts "# ・表の区画内での改行は“/”で表記します。"
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
