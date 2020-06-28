# -*- coding: utf-8 -*-
=begin
  Copyright (C) 2020 Takashi SUGA

  You may use and/or modify this file according to the license
  described in the LICENSE.txt file included in https://github.com/suchowan/when_exe.
=end

require 'pp'
require 'when_exe'
include When

Encoding.default_external = 'UTF-8'
Encoding.default_internal = 'UTF-8'

class Manifest

  NDL_BASE = 'https://www.dl.ndl.go.jp/api/iiif/'
  OUR_BASE = 'http://hosi.org:8080/z/honkoku/converted_manifest/'

  def initialize(year, id, from, to)
    @year   = year.to_i
    @from   = from.to_i
    @to     = to.to_i
    @id     = id.strip
    @source = "#{NDL_BASE}#{@id}/manifest.json"
    @fname  = "#{@year}_#{@id}_#{@from}_#{@to}.json"
    @date   = (tm_pos(@year,1, 1, :frame=>'Japanese') ^ CalendarEra('Japanese')).first
    @era    = @date.calendar_era_name.to_s
    pp [@year, @id, @from, @to, @era, @date.year]
  end

  def modified_title(original)
    "#{@era}#{@date.year}年暦 (国会図書館所蔵の#{original}より)"
  end

  def convert
    open(@source, 'r', {:ssl_verify_mode=>OpenSSL::SSL::VERIFY_NONE}) do |json|
      manifest = JSON.parse(json.read)
      manifest['@id']   = OUR_BASE + @fname
      manifest['label'] = modified_title(manifest['label'])
      manifest['metadata'].each do |data|
        case data['label']
        when 'Title';                             data['value'] = modified_title(data['value'])
        when 'Publication Date';                  data['value'] = "#{@era}#{@date.year-1} [#{@year-1}]"
        when 'Publication Date (W3CDTF fortmat)'; data['value'] = (@year-1).to_s
        end
      end
      manifest['sequences'][0]['canvases'] = manifest['sequences'][0]['canvases'][(@from-1)..(@to-1)]
      manifest['sequences'][0]['thumbnail']['@id'] =  manifest['sequences'][0]['canvases'][0]['thumbnail']['@id']
      open('manifest/' + @fname, 'w') do |modified|
        modified.write(JSON.generate(manifest))
      end
    end
  end
end

OpenURI
path = "https://github.com/suchowan/when_exe/raw/master/test/events/ndl_koyomi.csv"
open(path, 'r', {:ssl_verify_mode=>OpenSSL::SSL::VERIFY_NONE}) do |csv|
  csv.read.each_line do |line|
    year, range, comment = line.chomp.split(',', 3)
    range =~ /^(.+)\/(\d+)\.\.(\d+)$/
    Manifest.new(year, $1, $2, $3).convert if (1685..1872).include?(year.to_i)
  end
end
